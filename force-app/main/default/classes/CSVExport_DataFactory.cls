/**
 * @description     DataFactory class to support with shared creation of testing data across the application
 * @author          daniel@hyphen8.com
 * @date            19/04/2020
 * @group           DataFactory
*/
@isTest
public with sharing class CSVExport_DataFactory {
    
    /**
     * @description in memory is used to confirm if we should be creating the records or just returing them
    */
    public static boolean inmemory;

    /**
     * @description     create an account
     * @param           string name of the account
     * @return          Account
    */
    public static Account createAccount(string name){
        boolean inmemory = CSVExport_DataFactory.inmemory;
        Account account = new Account(Name=name);
        if(!inmemory){
            insert account;
        }
        return account;
    }

    /**
     * @description     create an opportunity
     * @param           string accountId is the Account we are going to link this opportunity to
     * @param           string stageName is the stage that the opportunity should be set to
     * @param           date closeDate is the date we should set the opportunity to
     * @param           decimal amount is the value of the opportunity
     * @param           string name is the name of the opportunity
     * @param           string exportRecordId the export record
     * @return          Opportunity
    */
    public static Opportunity createOpportunity(string accountId, string stageName, date closeDate, decimal amount, string name, string exportRecordId){
        boolean inmemory = CSVExport_DataFactory.inmemory;
        Opportunity opportunity = new Opportunity(Name=name, StageName=stageName,CloseDate=closeDate, Amount=amount,AccountId=accountId,CSV_Export__c=exportRecordId);
        if(!inmemory){
            insert opportunity;
        }
        return opportunity;
    }

    /**
     * @description     create lots of opportunities
     * @param           integer noOfOpportunities the number of opportunities you want to create
     * @param           string accountId is the Account we are going to link these opportunities to
     * @param           string stageName is the stage that the opportunity should be set to
     * @param           date closeDate is the date we should set the opportunities to
     * @param           decimal amount is the value of the opportunities
     * @param           string name is the name of the opportunities
     * @param           string exportRecordId the export record
     * @return          List<Opportunity>
    */
    public static List<Opportunity> createOpportunityList(integer noOfOpportunities, string accountId, string stageName, date closeDate, decimal amount, string name, string exportRecordId){
        boolean inmemory = CSVExport_DataFactory.inmemory;
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        for(Integer i=0;i<noOfOpportunities;i++) {
            Opportunity opportunity = new Opportunity(Name=name, StageName=stageName,CloseDate=closeDate, Amount=amount,AccountId=accountId,CSV_Export__c=exportRecordId);
            listOfOpportunities.add(opportunity);
        }
        if(!inmemory){
            insert listOfOpportunities;
        }
        return listOfOpportunities;
    }

}