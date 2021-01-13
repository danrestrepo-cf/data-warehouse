# Enterprise Data Warehouse (EDW) for BI

This repository contains all code related to EDW, including SQL migrations and Pentaho ETLs.

# AWS SSO 

## Login

Once AWS SSO is set up (below) you can retrieve a new session by invoking the `aws-sso-login.sh` script.

## One time setup

AWS SSO generates temporary credentials for access to the data warehouse.

To configure AWS SSO, run `scripts/aws-sso-configure.sh` from the command line.

## FAQs
> **Q: What does SP stand for in the acronyms SP1, SP2, SP999, etc?**
>
> **A:** Server Process. They are process names given to each process we run. With each process having a defined name we can all refer to a specific process and know what each other is talking about. 

> **Q: How do I reserve a process name?**
>
> **A:** Open the [production job matrix](https://docs.google.com/spreadsheets/d/1njphL7PpykrfqUUY8kxImsQBhrrwPz9ICqW727QnAA0/) and add a row to the bottom of the sheet. NOTE: This name reservation should occur at the beginning of the development process (if there isn't one already) so the name can be referenced throughout the lifecycle of the project.
