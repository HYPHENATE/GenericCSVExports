/**
 * @description     test class for CSVExport app
 * @author          daniel@hyphen8.com
 * @date            18/04/2020
 * @group           Test
*/
@isTest
public with sharing class CSVExport_Test {
    
    /**
     * @description testing a basic opportunity mapping
    */
    static testMethod void testbasicoppmapping(){
        Account acc = new Account(Name='TestAccount1');
        insert acc;

        Opportunity opp = new Opportunity(Name='DEMO', StageName='Prospecting',CloseDate=system.today(), Amount=10000.00,AccountId=acc.Id);
        insert opp;

        CSV_Export__c csvexport = new CSV_Export__c();
        insert csvexport;

        List<CSVExport_ImportInvocable.ExportRecord> listofexports = new List<CSVExport_ImportInvocable.ExportRecord>();
        CSVExport_ImportInvocable.ExportRecord ceii = new CSVExport_ImportInvocable.ExportRecord();
        ceii.recordId = csvexport.Id;
        ceii.developerName = 'Example';
        listofexports.add(ceii);

        CSVExport_ImportInvocable.importRecordsForExport(listofexports);
        
        //Should return first and second messages
        System.assertEquals(1, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }
}