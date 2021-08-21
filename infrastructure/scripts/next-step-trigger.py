import boto3
import json
import logging
import os
from urllib.parse import unquote_plus


# Process an uploaded file as a response to AWS Step Function, sending a status to that service
#
# S3 Lambda Reference:
# https://docs.aws.amazon.com/lambda/latest/dg/with-s3.html
# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/stepfunctions.html#SFN.Client.send_task_success
def execute(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    for record in event['Records']:
        nextStepInput = record["body"]
        # TODO: get the ProcessId to identify the next step function
        logger.info("Next Step Input: {}", nextStepInput)
        # TODO: validate that it exists, instead (I presume) blowing up
        processId = nextStepInput["messageAttributes"]["ProcessID"]
        logger.info("ProcessID: {}", processId)

        # file names are the ETL batch ID - created per run of pentaho and logged in the database
        # sfn = boto3.client('stepfunctions')
        #
        # try:
        #     s3 = boto3.resource('s3')
        #
        #     state_machine_arn = ""  # TODO:
        #     executions = sfn.list_executions(
        #         stateMachineArn=state_machine_arn,
        #         statusFilter='RUNNING',
        #         maxResults=1
        #     )
        #     num_executions = len(executions["executions"])
        #     if num_executions == 0:
        #         pass
        #     else:
        #         logger.info("Num running executions is {}, sleeping message.", num_executions)
        #
        #     # read the file and parse it
        #     # body = obj.get()['Body'].read().decode('utf-8')
        #     # content_json = json.loads(body)
        # except:
        #     logger.error("Task Failure for ETL Batch ID {}".format(etl_batch_id))
        #     raise
        # finally:
        #     # move to the archive
        #     pass
