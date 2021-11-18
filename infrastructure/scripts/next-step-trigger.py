import boto3
import logging
import os
#
# Read an SQS message that indicates which job should be triggered next
#
# It assumes the following to accomplish this:
#    1. The ProcessID (ex, SP-100) is passed in as an SQS Message Attribute
#    2. The Step Function ARN prefix is available as a environment variable, 'sfn_arn_prefix'
#    3. The Step Function to call is the concatenation of ARN Prefix and ProcessID
#
def execute(event, context):
    valid_etl_type_suffixes = ['', '-insert', 'insert-update', '-delete']

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    sfn_arn_prefix = os.environ['sfn_arn_prefix']
    logger.info("sfn_arn_prefix is {}".format(sfn_arn_prefix))

    process_id = "Not Yet Set"
    for record in event['Records']:
        next_step_input = record["body"]
        logger.info("Next Step Input: {}".format(next_step_input))

        process_id = record["messageAttributes"]["ProcessId"]["stringValue"]
        # strip out ETL type suffix where applicable
        process_id_base = '-'.join(process_id.split('-')[0:2])
        logger.info("ProcessId: {}".format(process_id))

        try:
            sfn = boto3.client('stepfunctions')
            state_machine_arn = sfn_arn_prefix + "-" + process_id
            state_machine_arn_base = sfn_arn_prefix + "-" + process_id_base

            exact_step_function_exists = False
            num_executions = 0
            any_step_function_with_base_exists = False

            for suffix in valid_etl_type_suffixes:
                execution_check = running_execution_counter(state_machine_arn_base, suffix)
                if process_id_base + suffix == process_id:
                    exact_step_function_exists = execution_check[1]
                num_executions += execution_check[0]
                any_step_function_with_base_exists = any_step_function_with_base_exists or execution_check[1]

            if num_executions > 0:
                logger.info("Num running executions is {} for step function {}, sleeping message."
                            .format(num_executions, process_id))
                raise Exception("At least one execution of step function {} is running".format(process_id))
            elif not any_step_function_with_base_exists:
                # Do not raise an exception because we do not want this message to go back onto the queue and
                # cause an infinite loop
                logger.error("ERROR: No state machine with base process name {} exists".format(process_id_base))
            elif not exact_step_function_exists:
                logger.error("ERROR: State machine not found: {}".format(state_machine_arn))
            else:
                logger.info("Running {}".format(state_machine_arn))
                sfn.start_execution(
                    stateMachineArn=state_machine_arn,
                    input=next_step_input
                )
        except:
            logger.error("Failed to trigger {}".format(process_id))
            raise
        finally:
            # move to the archive
            pass


def running_execution_counter(state_machine_arn_base: str, etl_type_suffix: str = '') -> tuple:
    sfn = boto3.client('stepfunctions')
    try:
        executions = sfn.list_executions(
            stateMachineArn=(state_machine_arn_base + etl_type_suffix),
            statusFilter='RUNNING',
            maxResults=1
        )
        num_executions = len(executions["executions"])
        step_function_found_flag = True
    except sfn.exceptions.StateMachineDoesNotExist:
        num_executions = 0
        step_function_found_flag = False
    return num_executions, step_function_found_flag
