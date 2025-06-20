# Contents:
* ## Flow Cleaner:
    ### Summary:
    Powershell script to clean the LocationX & LocationY nodes within the Salesforce flow file in a dx project.

    ### Setup:
    * Within a powershell terminal, open your profile in vscode by runnning the below command in terminal

        `code $PROFILE -r`
    
    * In the profile file, copy paste the contents of the file **Flow Cleaner.ps1** and save.

    * Reload the profile file by running the below command in vscode terminal

        `. $PROFILE`

    Thats it! you are all set.

    ### Commands:
    * **sfpf** - pull the flow using salesforce cli & clean the flow location nodes

    * **sfcf** - clean an existing location nodes by giving the name of the flow within a dx project or giving the flow directory (flow directory need not be in a dx project).