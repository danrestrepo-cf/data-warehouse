import boto3
import logging
import os
from typing import Optional

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
            step_function_arn = sfn_arn_prefix + "-" + process_id
            step_function_arn_base = sfn_arn_prefix + "-" + process_id_base

            # Count running step functions named under the *OLD* naming scheme, e.g. SP-100320
            base_executions = running_execution_counter(step_function_arn_base)

            # Count running insert ETL step functions named under the *NEW* naming scheme, e.g. SP-200001-insert
            insert_executions = running_execution_counter(step_function_arn_base, '-insert')

            # Count running insert-update ETL step functions named under the *NEW* naming scheme, e.g. SP-300001-insert-update
            insert_update_executions = running_execution_counter(step_function_arn_base, '-insert-update')

            # Count running delete ETL step functions named under the *NEW* naming scheme, e.g. SP-300001-delete
            delete_executions = running_execution_counter(step_function_arn_base, '-delete')

            num_executions = base_executions[0] + insert_executions[0] + insert_update_executions[0] + delete_executions[0]
            step_function_found_flag = any([base_executions[1], insert_executions[1], insert_update_executions[1],
                                            delete_executions[1]])

            if num_executions == 0:
                if step_function_found_flag:
                    logger.info("Running {}".format(step_function_arn))
                    sfn.start_execution(
                        stateMachineArn=step_function_arn,
                        input=next_step_input
                    )
                else:
                    # Do not raise an exception because we do not want this message to go back onto the queue and
                    # cause an infinite loop
                    logger.error("ERROR: State machine not found: {}".format(step_function_arn))
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


def running_execution_counter(step_function_arn_base: str, etl_type_suffix: Optional[str]) -> tuple:
    sfn = boto3.client('stepfunctions')
    try:
        executions = sfn.list_executions(
            stateMachineArn=(step_function_arn_base + etl_type_suffix),
            statusFilter='RUNNING',
            maxResults=1
        )
        num_executions = len(executions["executions"])
        step_function_found_flag = True
    except sfn.exceptions.StateMachineDoesNotExist:
        num_executions = 0
        step_function_found_flag = False
    return num_executions, step_function_found_flag
