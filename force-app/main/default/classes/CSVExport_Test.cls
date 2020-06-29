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
        
        // create test data
        CSVExport_DataFactory.inmemory = false;
        Account account = CSVExport_DataFactory.createAccount('TestAccount1');
        Opportunity opportunity = CSVExport_DataFactory.createOpportunity(account.Id, 'Prospecting', system.today(), 10000.00, 'DEMO',null);
        CSV_Export__c csvExport = new CSV_Export__c();
        insert csvExport;
        List<CSVExport_Constants.ExportRecord> listOfExports = new List<CSVExport_Constants.ExportRecord>();
        CSVExport_Constants.ExportRecord ceii = new CSVExport_Constants.ExportRecord();
        ceii.recordId = csvExport.Id;
        ceii.developerName = 'Example';
        listOfExports.add(ceii);

        // perform test
        test.startTest();
            CSVExport_ImportInvocable.importRecordsForExport(listOfExports);
        test.stopTest();
        
        // verify process worked
        System.assertEquals(1, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }

    /**
     * @description testing a basic opportunity mapping bulk processing 500
    */
    static testMethod void testbasicoppmappingbulk500(){

        // create test data
        CSVExport_DataFactory.inmemory = false;
        Account account = CSVExport_DataFactory.createAccount('TestAccount1');
        List<Opportunity> listOfOpportunity = CSVExport_DataFactory.createOpportunityList(500,account.Id, 'Prospecting', system.today(), 10000.00, 'DEMO',null);
        CSV_Export__c csvExport = new CSV_Export__c();
        insert csvExport;
        List<CSVExport_Constants.ExportRecord> listOfExports = new List<CSVExport_Constants.ExportRecord>();
        CSVExport_Constants.ExportRecord ceii = new CSVExport_Constants.ExportRecord();
        ceii.recordId = csvExport.Id;
        ceii.developerName = 'Example';
        listOfExports.add(ceii);

        // perform test
        test.startTest();
            CSVExport_ImportInvocable.importRecordsForExport(listOfExports);
        test.stopTest();
        
        // confirm process completed
        System.assertEquals(500, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }

    /**
     * @description testing a basic opportunity mapping bulk processing 3000
    */
    static testMethod void testbasicoppmappingbulk3000(){

        // set up test data
        CSVExport_DataFactory.inmemory = false;
        Account account = CSVExport_DataFactory.createAccount('TestAccount1');
        List<Opportunity> listOfOpportunity = CSVExport_DataFactory.createOpportunityList(3000,account.Id, 'Prospecting', system.today(), 10000.00, 'DEMO',null);
        CSV_Export__c csvExport = new CSV_Export__c();
        insert csvExport;
        List<CSVExport_Constants.ExportRecord> listOfExports = new List<CSVExport_Constants.ExportRecord>();
        CSVExport_Constants.ExportRecord ceii = new CSVExport_Constants.ExportRecord();
        ceii.recordId = csvExport.Id;
        ceii.developerName = 'Example';
        listOfExports.add(ceii);

        // perform test
        test.startTest();
            CSVExport_ImportInvocable.importRecordsForExport(listOfExports);
        test.stopTest();
        
        // verify test worked
        System.assertEquals(4000, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }

    /**
     * @description testing a basic opportunity mapping
    */
    static testMethod void testbasicoppexport(){
        
        // create test data
        CSVExport_DataFactory.inmemory = false;
        Account account = CSVExport_DataFactory.createAccount('TestAccount1');
        CSV_Export__c csvExport = new CSV_Export__c();
        insert csvExport;
        Opportunity opportunity = CSVExport_DataFactory.createOpportunity(account.Id, 'Prospecting', system.today(), 10000.00, 'DEMO',csvExport.Id);
        List<CSVExport_Constants.ExportRecord> listOfExports = new List<CSVExport_Constants.ExportRecord>();
        CSVExport_Constants.ExportRecord ceii = new CSVExport_Constants.ExportRecord();
        ceii.recordId = csvExport.Id;
        ceii.developerName = 'Example';
        listOfExports.add(ceii);

        // perform test
        test.startTest();
            // first run
            CSVExport_ExportInvocable.generateExportFiles(listOfExports);
            // second run
            CSVExport_ExportInvocable.generateExportFiles(listOfExports);
        test.stopTest();
        
        // verify process worked
        System.assertEquals(1, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }

    /**
     * @description testing a basic opportunity export bulk processing 500
    */
    static testMethod void testbasicoppexportbulk500(){

        // create test data
        CSVExport_DataFactory.inmemory = false;
        Account account = CSVExport_DataFactory.createAccount('TestAccount1');
        CSV_Export__c csvExport = new CSV_Export__c();
        insert csvExport;
        List<Opportunity> listOfOpportunity = CSVExport_DataFactory.createOpportunityList(500,account.Id, 'Prospecting', system.today(), 10000.00, 'DEMO',csvExport.Id);
        List<CSVExport_Constants.ExportRecord> listOfExports = new List<CSVExport_Constants.ExportRecord>();
        CSVExport_Constants.ExportRecord ceii = new CSVExport_Constants.ExportRecord();
        ceii.recordId = csvExport.Id;
        ceii.developerName = 'Example';
        listOfExports.add(ceii);

        // perform test
        test.startTest();
            CSVExport_ExportInvocable.generateExportFiles(listOfExports);
        test.stopTest();
        
        // confirm process completed
        System.assertEquals(500, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }

    /**
     * @description testing a basic opportunity export bulk processing 4000
    */
    static testMethod void testbasicoppexportbulk3000(){

        // set up test data
        CSVExport_DataFactory.inmemory = false;
        Account account = CSVExport_DataFactory.createAccount('TestAccount1');
        CSV_Export__c csvExport = new CSV_Export__c();
        insert csvExport;
        List<Opportunity> listOfOpportunity = CSVExport_DataFactory.createOpportunityList(3000,account.Id, 'Prospecting', system.today(), 10000.00, 'DEMO',csvExport.Id);
        List<CSVExport_Constants.ExportRecord> listOfExports = new List<CSVExport_Constants.ExportRecord>();
        CSVExport_Constants.ExportRecord ceii = new CSVExport_Constants.ExportRecord();
        ceii.recordId = csvExport.Id;
        ceii.developerName = 'Example';
        listOfExports.add(ceii);

        // perform test
        test.startTest();
            CSVExport_ExportInvocable.generateExportFiles(listOfExports);
        test.stopTest();
        
        // verify test worked
        System.assertEquals(4000, [SELECT COUNT() FROM Opportunity WHERE CSV_Export__c=:csvexport.Id], 'Expected number of opportunities linked');

    }
}