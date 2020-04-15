# Extract, Transform, Load repository for BI (DL3/Data Lake 3)
This repository is used to version all code/files needed to perform ETLs into DL3.

## Folder Structure

The basic folder structure 

    .
    ├── ..
    ├── encompass/                                                  # Folders in the root directory are for each platform/system that we import/export data to/from
    │   ├── Transformations/                                        # Transformations run by Pan are kept in this folder
    |   │   ├── SP1_load_encompass_daily_extract_to_dl3.bat         # Batch script that has sample commands needed to execute the transform and a description of all parameters
    |   │   ├── SP1_load_encompass_daily_extract_to_dl3.ktr         # Pentaho transformation file
    |   │   ├── SP1_load_encompass_daily_extract_to_dl3.sh          # Bash script that has sample commands needed to execute the transform and a description of all parameters
    │   ├── encompass.kjb                                           # The job file that kicks off all of the transformations 
    │   ├── Jobs/                                                   # Jobs run by Kettle are kept in this folder
    |   │   ├── SP999_sample_job_name.bat                           # Batch script that has sample commands needed to execute the transform and a description of all parameters
    |   │   ├── SP999_sample_job_name.kjb                           # Pentaho job file
    |   │   ├── SP999_sample_job_name.sh                            # Bash script that has sample commands needed to execute the transform and a description of all parameters    
    └── servicing/                                                  # Folders in the root directory are for each platform/system that we import/export data to/from
    |
    ├ README.md                                                     # This readme file.
    └  ...    

## FAQs
> **Q: What does SP stand for in the acronyms SP1, SP2, SP999, etc?**
>
> **A:** Server Process. They are are process names given to each process we run. With each process having a defined name we can all refer to a specific process and know what each other is talking about. 

> **Q: How do I reserve a process name?**
>
> **A:** Open the [production job matrix](https://docs.google.com/spreadsheets/d/1njphL7PpykrfqUUY8kxImsQBhrrwPz9ICqW727QnAA0/) and add a row to the bottom of the sheet. 
