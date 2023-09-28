# Security

## Tracking changes

Every change to the data is meticulously tracked and saved. These changes are recorded in two distinct locations:

1. Directly in the Database - Each record maintains its own history of changes:

~~~ TXT
{
  "ComesFrom": 1,
  "GoesTo": 0,
  "RecordId": null,
  "Changes": [
    {
      "DateTime": "2020-10-10T10:10:10.00",
      "UserName": "admin",
      "ValueTag": {
        "HumanReadable": "PneumaticManipulator.ProcessData.Shared.Set.ComesFrom",
        "Symbol": "Context.PneumaticManipulator.ProcessData.Shared.Set.ComesFrom"
      },
      "OldValue": 0,
      "NewValue": 1
    }
  ],
  "DataEntityId": "testRecord"
}
~~~

2. In Logs - All operations involving records are meticulously logged:

~~~ TXT
[10:10:10 INF] Create testRecord in examples.PneumaticManipulator.ProcessDataManger by user action. { UserName = admin }
[10:10:10 INF] Value change Context.PneumaticManipulator.ProcessData.Shared.Set.ComesFrom of testRecord from 0 to 1 changed by user action. { UserName = admin }
~~~

Every action as creation, update, deletion, or copying data is captured in the logs. Also every record has its own set of changes.  
Its important to note that modifications originating from the PLC are not logged, tracked, or saved.

## Locking

When a client is in the process of editing, copying, or attempting to delete a record, the entire repository becomes locked. While the repository is locked, no one can make edits to records, until the repository is unlocked.

> [!IMPORTANT]
> The repository is locked by clicking on the edit, copy, or delete buttons, and it can be unlocked by clicking the save or close button. If the modal is closed in an incorrect manner, such as clicking outside of it, the repository will remain locked.

## Hashing

Data are hashed each time they are created or updated.
To enable hash verification, you can add the attribute: `{#ix-attr:[AXOpen.Data.AxoDataVerifyHashAttribute]}` above the data manager. With this attribute in place, the hash will be checked whenever you interact with the data. In case the verification process fails, a log will be generated, and the user will be warned about external modifications to the record.
