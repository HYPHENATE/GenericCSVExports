[![codecov](https://codecov.io/gh/HYPHENATE/GenericCSVExports/branch/master/graph/badge.svg)](https://codecov.io/gh/HYPHENATE/GenericCSVExports)
[![HYPHENATE](https://circleci.com/gh/HYPHENATE/GenericCSVExports.svg?style=svg&&circle-token=297c83f424a06b21dc3b4fa042318223464f67d7)](https://circleci.com/gh/HYPHENATE/GenericCSVExports)

# Generic CSV Exports
COMING SOON

## Verion Control

## Part 1: Installation

<a href="https://githubsfdeploy.herokuapp.com?owner=HYPHENATE&repo=GenericCSVExports">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Part 2: Configuration

Out the box the configuration comes with some static configuration that you should leave in the system but hide from all none System Administrators. 

In order to configure the solution there are a couple of steps you need to take.

### New CSV Export Record Preperation
1. Go to the CSV Export Object in Setup
2. Add a new RecordType and Assign to the Appropriate users
3. Add a new PageLayout and Assign it to the RecordType
4. Add a new Lighting Page Layouts and assign it to the RecordType
5. Add a new Path for the recordtype

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


## Part 3: Limitations

- Each export setup will go into it's only File
- Maximum records in a single export file is 10000 - for larger a custom implementation would be required


## Credits

