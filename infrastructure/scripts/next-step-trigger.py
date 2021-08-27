import boto3
import logging
import os


#
# Read an SQS message that indicates which job should be triggered next
#
# It assumes the following to accomplish this:
#    1. The ProcessID (ex, SP-100) is pass in as an SQS Message Attribute
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
        logger.info("ProcessId: {}".format(process_id))

        try:
            sfn = boto3.client('stepfunctions')

            state_machine_arn = sfn_arn_prefix + "-" + process_id
            executions = sfn.list_executions(
                stateMachineArn=state_machine_arn,
                statusFilter='RUNNING',
                maxResults=1
            )
            num_executions = len(executions["executions"])
            if num_executions == 0:
                logger.info("Running {}".format(state_machine_arn))
                sfn.start_execution(
                    stateMachineArn=state_machine_arn,
                    input=next_step_input
                )
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
