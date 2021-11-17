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
            state_machine_found_flag = False

            # Count running step functions named under the *OLD* naming scheme, e.g. SP-100320
            try:
                executions_base = sfn.list_executions(
                    stateMachineArn=state_machine_arn_base,
                    statusFilter='RUNNING',
                    maxResults=1
                )
                num_executions_base = len(executions_base["executions"])
                if state_machine_arn == state_machine_arn_base:
                    state_machine_found_flag = True
            except sfn.client.exceptions.StateMachineDoesNotExist:
                num_executions_base = 0

            # Count running insert ETL step functions named under the *NEW* naming scheme, e.g. SP-200001-insert
            try:
                executions_insert = sfn.list_executions(
                    stateMachineArn=(state_machine_arn_base + '-insert'),
                    statusFilter='RUNNING',
                    maxResults=1
                )
                num_executions_insert = len(executions_insert["executions"])
                if state_machine_arn == (state_machine_arn_base + '-insert'):
                    state_machine_found_flag = True
            except sfn.client.exceptions.StateMachineDoesNotExist:
                num_executions_insert = 0

            # Count running insert-update ETL step functions named under the *NEW* naming scheme,
            # e.g. SP-300001-insert-update
            try:
                executions_insert_update = sfn.list_executions(
                    stateMachineArn=(state_machine_arn_base + '-insert-update'),
                    statusFilter='RUNNING',
                    maxResults=1
                )
                num_executions_insert_update = len(executions_insert_update["executions"])
                if state_machine_arn == (state_machine_arn_base + '-insert-update'):
                    state_machine_found_flag = True
            except sfn.client.exceptions.StateMachineDoesNotExist:
                num_executions_insert_update = 0

            # Count running delete ETL step functions named under the *NEW* naming scheme, e.g. SP-300001-delete
            try:
                executions_delete = sfn.list_executions(
                    stateMachineArn=(state_machine_arn_base + '-delete'),
                    statusFilter='RUNNING',
                    maxResults=1
                )
                num_executions_delete = len(executions_delete["executions"])
                if state_machine_arn == (state_machine_arn_base + '-delete'):
                    state_machine_found_flag = True
            except sfn.client.exceptions.StateMachineDoesNotExist:
                num_executions_delete = 0

            num_executions = num_executions_base + num_executions_insert + num_executions_insert_update + num_executions_delete

            if num_executions == 0:
                if state_machine_found_flag:
                    logger.info("Running {}".format(state_machine_arn))
                    sfn.start_execution(
                        stateMachineArn=state_machine_arn,
                        input=next_step_input
                    )
                else:
                    logger.info("ERROR: State machine not found: {}".format(state_machine_arn))
                    # Do not raise an exception because we do not want this message to go back onto the queue and
                    # cause an infinite loop
            else:
                logger.info("Num running executions is {} for step function {}, sleeping message."
                            .format(num_executions, process_id))
                raise Exception("At least one execution of step function {} is running".format(process_id))
        except:
            logger.error("Failed to trigger {}".format(process_id))
            raise
        finally:
            # move to the archive
            pass
