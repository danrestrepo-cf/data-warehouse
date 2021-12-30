import boto3
import logging
import os
import datetime

"""
Read an SQS message that indicates which job should be triggered next

This script assumes the following to accomplish this:
   1. The ProcessID (ex, SP-100) is passed in as an SQS Message Attribute
   2. The Step Function ARN prefix is available as a environment variable, 'sfn_arn_prefix'
   3. The Step Function to call is the concatenation of ARN Prefix and ProcessID

   
This script performs a lookup on the step function included in the SQS message against EDW's step function inventory
to determine which action to take, using the following logic:

- If there is no step function with the base identifier:
    Output an error and drop the message
- If there is no step function with the full identifier:
    Output an error to the logger and drop the message
- If the most recent execution of the full identifier has a start date after the message submit date and completed successfully:
    Log a message indicating the duplicate was dropped and drop the message
- If any step function with the base identifier is currently RUNNING:
    Place it back on the queue
- Else:
    Execute the step function
"""


def execute(event, context):
    valid_etl_type_suffixes = ['', '-insert', '-insert-update', '-delete']

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    sfn_arn_prefix = os.environ['sfn_arn_prefix']
    logger.info("sfn_arn_prefix is {}".format(sfn_arn_prefix))

    process_id = "Not Yet Set"
    for record in event['Records']:
        message_sent_timestamp = datetime.datetime.fromtimestamp(record['attributes']['SentTimestamp'])
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

            any_step_function_with_base_exists = False
            any_step_function_with_base_has_running_execution = False
            exact_step_function_exists = False
            exact_step_function_latest_execution_was_successful = False
            latest_successful_execution_datetime = None

            for suffix in valid_etl_type_suffixes:
                step_function_exists, has_running_execution, latest_successful_execution_datetime = fetch_execution(state_machine_arn_base, suffix)
                any_step_function_with_base_has_running_execution = has_running_execution or any_step_function_with_base_has_running_execution
                any_step_function_with_base_exists = any_step_function_with_base_exists or step_function_exists
                if process_id_base + suffix == process_id:
                    exact_step_function_exists = step_function_exists
                    exact_step_function_latest_execution_was_successful = latest_successful_execution_datetime is not None

            if not any_step_function_with_base_exists:
                # Do not raise an exception because we do not want this message to go back onto the queue and cause
                # an infinite loop
                logger.error("No state machine with base process name {} exists".format(process_id_base))
            elif not exact_step_function_exists:
                logger.error("State machine not found: {}".format(state_machine_arn))
            elif exact_step_function_latest_execution_was_successful and latest_successful_execution_datetime > message_sent_timestamp:
                logger.info("Detected unneeded execution for state machine {}, dropping message.".format(state_machine_arn))
            elif any_step_function_with_base_has_running_execution:
                # Do raise an exception to send this message back to the queue, as the included step function could
                # result in changes to data within its target table when executed
                logger.info("Step function with base process_id {} is running, sleeping message.".format(process_id_base))
                raise Exception("At least one execution of step function with base {} is running".format(process_id_base))
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


def fetch_execution(state_machine_arn_base: str, etl_type_suffix: str = '') -> tuple:
    sfn = boto3.client('stepfunctions')
    try:
        response = sfn.list_executions(
            stateMachineArn=(state_machine_arn_base + etl_type_suffix),
            maxResults=1
        )
        step_function_exists = True
        latest_execution_status = response["executions"]["status"]
        has_running_execution = latest_execution_status == "RUNNING"
        latest_successful_execution_datetime = response["executions"]["startDate"] if latest_execution_status == "SUCCEEDED" else None
    except sfn.exceptions.StateMachineDoesNotExist:
        step_function_exists = False
        has_running_execution = False
        latest_successful_execution_datetime = None
    return step_function_exists, has_running_execution, latest_successful_execution_datetime
