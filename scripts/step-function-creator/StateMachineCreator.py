from json import dumps
import re


class StateMachineCreator:
    def __init__(self,
                 step_function_comment: str, # no default value, must be provided
                 state_machine_name: str = ""):

        self.reset(step_function_comment, state_machine_name)

    def __str__(self) -> str:
        # self.step_function["States"] is a list of dicts, this converts it to a "dict of dicts"
        state_machine_steps = dict()
        for index, step in enumerate(self.step_function["States"]):
            # state_machine["key"] = step["States"]
            for key in step.keys():
                state_machine_steps[key] = step[key]

        self.step_function["States"] = state_machine_steps
        return f"{dumps(self.step_function, indent=4)}\n\n".replace('"<<', '').replace('>>"', '')

    def reset(self, comment: str = "", name: str = ""):
        if len(name) > 0:
            comment = f"{name} - {comment}"
        self.state_list = []
        self.step_function = {
            "Comment": comment,
            "StartAt": "",
            "States": self.state_list
        }

    def add_state_to_state_machine_sequential(self, state_name: str):
        # create new task state and add it to the list of states
        new_task = self.create_state_task(state_name)
        self.state_list.append(new_task)

        # update all states in the list so their next/end/resource keys are valid
        self.remove_end_parameter_from_state_list()
        self.update_next_from_state_list()
        self.update_resource_suffix()
        self.update_startat_state_machine_key()

    def update_startat_state_machine_key(self):
        first_process_name = ""

        for index, state in enumerate(self.state_list):
            if len(list(state.keys())) > 1:
                raise ValueError(f"Only 1 value expected in the root node of each dict in state_list. {len(list(state.keys()))} nodes found. List of nodes found: {list(state.keys())}")

            # only save the first process name
            if index == 0:
                # parse the name of the process from the first key found on the list of states
                first_process_name = list(state.keys())[0]

        self.step_function['StartAt'] = first_process_name

    def update_resource_suffix(self):
        for index, state in enumerate(self.state_list):
            current_state_name = list(state.keys())[0]

            if len(list(state.keys())) > 1:
                raise ValueError(f"Only 1 value expected in the root node of each dict in state_list. {len(list(state.keys()))} nodes found. List of nodes found: {list(state.keys())}")

            if len(self.state_list) == 1:
                # if there is only one item in the list we know it needs a suffix of .sync
                suffix_to_append = ".sync"
            elif index + 1 == len(self.state_list):
                # if this is the last item in the list we know it needs to have suffix of ".sync"
                suffix_to_append = ".sync"
            else:
                # default to suffix ".waitForTaskToken" unless it is the last/only item in the list
                suffix_to_append = ".waitForTaskToken"

            self.state_list[index][current_state_name]["Resource"] = self.remove_resource_suffix_from_string(self.state_list[index][current_state_name]["Resource"]) + suffix_to_append

    def remove_resource_suffix_from_string(self, resource: str) -> str:
        return re.sub('\..*', '', resource)

    def update_next_from_state_list(self):
        for index, state in enumerate(self.state_list):
            next_state_index = index + 1

            if len(list(state.keys())) > 1:
                raise ValueError(f"Only 1 value expected in the root node of each dict in state_list. {len(list(state.keys()))} nodes found. List of nodes found: {list(state.keys())}")

            if next_state_index == len(self.state_list):
                # if this is the last item in the list we know it does not need a 'next' parameter (it needs End=True not handled by this function)
                return
            else:
                current_state_name = list(state.keys())[0]
                next_state_name = list(self.state_list[next_state_index].keys())[0]
                self.state_list[index][current_state_name]["Parameters"]["Next"] = next_state_name

    def remove_end_parameter_from_state_list(self):
        for index, state in enumerate(self.state_list):
            if len(list(state.keys())) > 1:
                raise ValueError(f"Only 1 value expected in the root node of each dict in state_list. {len(list(state.keys()))} nodes found. List of nodes found: {list(state.keys())}")

            # state is a dict so call keys to return a list of keys (only 1) and index that list to get the value
            process_name = list(state.keys())[0]

            try:
                del(self.state_list[index][process_name]["End"])
            except:
                # the dict may or may not have a key named 'End' so do nothing if the key wasn't found
                pass

            # this is the last item in the list so set end to true
            if (index + 1) == len(self.state_list):
                self.state_list[index][process_name]["End"] = True

    def create_state_task(self, state_name: str,
                          launch_type: str = "FARGATE",
                          resource_arn: str = "arn:aws:states:::ecs:runTask",
                          assign_public_ip: str = "DISABLED",
                          cluster_arn: str = "${ecsClusterARN}",
                          task_definition_arn: str = "${mdi_2_arn}",
                          security_groups: list = ["${securityGroupId}"],
                          subnets: str = "<<${subnetIDs}>>",
                          container_name: str = "${mdi_2_container}") -> dict:

        environment_variables = [
            {
                "Name":"PROCESS_NAME",
                "Value":state_name
            },
            {
                "Name":"INPUT_DATA",
                "Value.$":"States.Format('\\{\"token_id\":\"{}\",\"mdi_input_json\":{}\\}', $$.Task.Token, States.JsonToString($))"
            }
        ]

        state_definition = {
            state_name: {
                "Type": "Task",
                "Resource": resource_arn,
                "End":True,
                "Parameters": {
                    "LaunchType": launch_type,
                    "Cluster": cluster_arn,
                    "TaskDefinition": task_definition_arn,
                    "NetworkConfiguration": {
                        "AwsvpcConfiguration": {
                            "AssignPublicIp": assign_public_ip,
                            "SecurityGroups": security_groups,
                            "Subnets": subnets
                            }
                        },
                        "Overrides": {
                            "ContainerOverrides": [{
                                "Environment": environment_variables,
                                "Name": container_name
                            }]
                        }
                    }
                }
            }

        return state_definition
