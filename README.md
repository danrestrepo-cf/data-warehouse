# Enterprise Data Warehouse (EDW) for BI

This repository contains all code related to EDW, including SQL migrations and Pentaho ETLs.

# AWS SSO 

## Login

Once AWS SSO is setup (below) you can retrieve a new session by invoking the `aws-sso-login.sh` script.

## One time setup

AWS SSO generates temporary credentials for access to the data warehouse.

To configure AWS SSO, use `scripts/aws-sso-configure.sh`.  It accepts a single argument, **environment**, which identifies the
database to connect to.

### Common parameters

**SSO start URL** - https://cardinalfinancial.awsapps.com/start
**Region** - us-east-1
**Account** See the environment specific sections below.
**CLI default client Region** - us-east-1
**Client default output format** - text

### QA

Select the `Cardinal Analysis` account (without UAT / Prod). This creates the `qa-data-warehouse-readonly` profile.

### UAT

There is not a UAT environment for EDW (yet).

### Prod

Select the `Cardinal Analysis (prod)` account.  This creates the `prod-data-warehouse-readonly` profile.


## FAQs
> **Q: What does SP stand for in the acronyms SP1, SP2, SP999, etc?**
>
> **A:** Server Process. They are process names given to each process we run. With each process having a defined name we can all refer to a specific process and know what each other is talking about. 

> **Q: How do I reserve a process name?**
>
> **A:** Open the [production job matrix](https://docs.google.com/spreadsheets/d/1njphL7PpykrfqUUY8kxImsQBhrrwPz9ICqW727QnAA0/) and add a row to the bottom of the sheet. NOTE: This name reservation should occur at the beginning of the development process (if there isn't one already) so the name can be referenced throughout the lifecycle of the project.
