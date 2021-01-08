[![codecov](https://codecov.io/gh/HYPHENATE/GenericCSVExports/branch/master/graph/badge.svg)](https://codecov.io/gh/HYPHENATE/GenericCSVExports)
[![HYPHENATE](https://circleci.com/gh/HYPHENATE/GenericCSVExports.svg?style=svg&&circle-token=297c83f424a06b21dc3b4fa042318223464f67d7)](https://circleci.com/gh/HYPHENATE/GenericCSVExports)

# Generic CSV Exports
A simple solution for mass linking records to a single object and then exporting them into a predetermined CVS file.
Could be used for:
- Finance batch solution
- Income batch solutions
- GiftAid

Developed by Hyphen8 as a part of our 8% pledge and freely available.

## Verion Control

### Release
- Update to API version 50
- include unlocked package links

### Beta
- Initial BETA release

## Part 1: Installation

<a href="https://githubsfdeploy.herokuapp.com?owner=HYPHENATE&repo=GenericCSVExports">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Unlocked Package installation links:
- Production: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t67000000SaFFAA0
- Sandbox: https://test.salesforce.com/packaging/installPackage.apexp?p0=04t67000000SaFFAA0

## Part 2: Configuration

Out the box the configuration comes with some static configuration that you should leave in the system but hide from all none System Administrators. 

In order to configure the solution there are a couple of steps you need to take.

### New CSV Export Record Preperation
1. Go to the CSV Export Object in Setup
2. Add a new RecordType and Assign to the Appropriate users
3. Add a new PageLayout and Assign it to the RecordType
4. Add a new Lighting Page Layouts and assign it to the RecordType
5. Add a new Path for the recordtype

CSV Export as a name for the Object might not be appropriate for your client and so you can always go in an amend the Label for the Object - DO NOT CHANGE THE OBJECT API Name unless you are going to also refactor the code in the background.

### Configure first Import
1. Go to the Object that you want to import into the CSV Export
2. Create a Lookup to the CSV Export record and ensure the permissions are set for the appropriate users
3. Update your Page Layouts on the CSV Export to include this related list and exclude any you do not want
4. Update your Lighting Page Layout to include this single list
5. Go to Custom Meta Data in Setup
6. Press Manage Records on CSV Import Mapping
7. Press New
8. Give your Import Mapping a sensible label that helps you spot what it is doing
9. Enter the RecordType developer API Name that you created previous in CSV Import RecordType
10. Select the Object that you want to import record from in Import Object
11. Select the Mapping Field that you created in step 2
12. Set the Filter Type to AND or OR - If you set as AND any filters you add a record will need to pass them all, if you set to OR then if any 1 of those filters equals true the record will be pulled in.
13. If you want to allow records to be pulled in mulitple times then tick Allow re-imports
14. Press Save
15. Go to Custom Meta Data in Setup
16. Select Manage Records on CSV Import Mapping Filter
17. Press New
18. Give your meta data a logical label so you know what it is and what the filter is
19. Lookup your CSV Import Mapping you created above and link it to the record.
20. Specific the Field API Name on the Object your are importing records from that you want to use in the filter.
21. Specify the Filter type
22. Specify the filter value - if using boolean/checkboxes then you can add in true or false
23. Press Save
24. Repeat steps 16-23 until you are happy you have the correct filters in place.
25. Add some test data to your Salesforce
26. Go to the CSV Export Application
27. Go to the CSV Export tab
28. Press new and select your new recordtype
29. Move the status to Import
30. Verifiy the correct records were linked to the CSV Export record

### Create your First Export
1. Go to Custom Meta Data in Setup
2. Select Manage Records next to CSV Export File
3. Select New
4. Enter a Label and makes sense for the File you are going to Export
5. Enter your FileName you do not need to include .csv that is added automatically
6. Enter the RecordType Developer Name of the CSV Export record that you want setup the export from
7. Confirm if you would like to use versioning on the files created - this means if ticked you can generate the file numerous times and you will only see 1 file on the record but retain previous version. If left unticked each generation will create a new file.
8. Set the Export Object that you want to pull data into the CSV file from
9. Set the Export Related Field that confirms the relationship (lookup) with your CSV Export record
10. Enter comma seperate the CSV Header line
11. Press Save
12. Go to Custom Meta Data in Setup
13. Select Manage Records next to CSV Export File Lines
14. Press New
15. Set a Label that will help you understand what this is
16. Use the Lookup to link this export to the CSV Export File you created above
17. Specify the Line - default is 1 however there is capability for you to export the same record on multiple lines as an example a finance export might have a credit and a debit line created from a single Salesforce record
18. Specify the Order this is the column number that the value should be added to
19. Specify the API name of the field you want to export the value for you can specify a value on the record or traverse up to parent records i.e. Account.Name on opportunity or StageName on opportunity
20. Press Save
21. Repeat steps 12-20 until you have all the required fields in your meta data
22. Now go to your CSV Export record and move the status to Export
23. Refresh your page and then review the file created - the file is created using an @future method which means it doesn't happen immediately.

### Amend the Processes
This package is completely unmanaged and you can amend and change the processes how you like. Out the box there is a Process Builder enabled on the CSV Export record call CSV Export Processes. It has 2 decisions in it:

#### STATUSIMPORTCHANGE
- Status = Import
- Status = ISCHANGED()
- Fires the Invocable Method Import records for Export (CSVExport_ImportInvocable) and needs the following variables assigned:
- Record ID - The ID of the CSV Export Record
- DeveloperName - The RecordType Developer Name of the CSV Export Record

#### EXPORTCSV
- Status = Export
- Status = ISCHANGED()
- Fires the Invocable Method Generate export files (CSVExport_ExportInvocable) and needs the following variables assigned:
- Record ID - The ID of the CSV Export Record
- DeveloperName - The RecordType Developer Name of the CSV Export Record

Because you have complete access you could change these statuses to match your requirements, you could also create your own custom quick actions or embedded flows that trigger these processes or if you have custom you could just disable these processes and define your own.

## Part 3: Limitations

- Each export setup will go into it's only File
- Maximum records in a single export file is 10000 - for larger a custom implementation would be required
- No ability to generate 1 file from multiple different mapping objects

## Credits

@danielbprobert

