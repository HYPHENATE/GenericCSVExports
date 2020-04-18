/**
 * @description     helper class for the CSVExport_ImportInvocable class
 * @author          daniel@hyphen8.com
 * @date            18/04/2020
 * @group           Helper
*/
public with sharing class CSVExport_ImportHelper {

    /**
     * @description     method to return the CSV Import Mapping and their child filters
     * @param           string developerName - this is the recordType of the CSV Export
     * @return          List<CSV_Import_Mapping__mdt> mapping for query
     */
    public static List<CSV_Import_Mapping__mdt> getMappings(string developerName){
        return [SELECT Allow_re_imports__c, CSV_Import_RecordType__c, Filter_Type__c, Import_Object__c, Mapping_Field__r.QualifiedApiName, (SELECT Field_API_Name__c, Filter_type__c, Value__c FROM CSV_Import_Mapping_Filters__r) FROM CSV_Import_Mapping__mdt WHERE CSV_Import_RecordType__c=:developerName];
    }

    /**
     * @description     method to generate our soql query for pulling in records
     * @param           string recordId - export recordId
     * @param           CSV_Import_Mapping__mdt importMappingRecord
    */
    public static void processLinking(string recordId, CSV_Import_Mapping__mdt importMappingRecord){

        // list of filters
        List<CSV_Import_Mapping_Filter__mdt> listOfFilters = importMappingRecord.CSV_Import_Mapping_Filters__r;
        
        // start generating our soql query
        string query = 'SELECT ID, ';

        SObjectType objectType = Schema.getGlobalDescribe().get(importMappingRecord.Import_Object__c);

        // list for storing the where queries in to reduce the need for another loop later on
        List<String> whereQueryList = new List<String>();

        // simple loop count to ensure we put our and or in the right place
        integer loopcount = 1;

        // loop through the mappings
        for(CSV_Import_Mapping_Filter__mdt cimf:listOfFilters){

            // add field api name to the query
            query = query + ' ' + cimf.Field_API_Name__c + ',';

            // get the filter type for the check
            string filterType = filterTypeHandling(cimf.Filter_type__c);

            // get the display type for the field we are processing
            DisplayType fieldType = getSObjectFieldType(objectType, cimf.Field_API_Name__c);
            
            // generate our where clause for this filter
            string whereQueryFilter = cimf.Field_API_Name__c + ' ' + filterType;

            // list of field types that should not have quotes put around them
            List<String> listOfFieldTypes = new List<String>{'Double', 'Boolean', 'Date', 'Integer','CURRENCY', 'DateTime', 'Percent'};

            // check to see if fieldtype is in the list of field types
            if(listOfFieldTypes.contains(string.valueOf(fieldType))){
                whereQueryFilter = whereQueryFilter + cimf.Value__c;
            } else {
                whereQueryFilter = whereQueryFilter + ' \'' + cimf.Value__c + '\'';
            } 

            // confirm if this is the last record or not and ensure we don't add the soqlFilterType incorrectly
            if(loopcount < listOfFilters.size()){
                whereQueryFilter = whereQueryFilter + ' ' + importMappingRecord.Filter_Type__c + ' ';
            }

            // increment our loop count
            loopcount = loopcount + 1;

            // add the clause to our list for use later
            whereQueryList.add(whereQueryFilter);
        }

        // extend our query to include the export mapping field and the object we are going to query against
        query = query + ' ' + importMappingRecord.Mapping_Field__r.QualifiedApiName + ' FROM ' + importMappingRecord.Import_Object__c + ' WHERE ';
        
        // set string for the where query
        string whereQuery = '';

        // loop through our where query list and append to the query
        for(string whereClause:whereQueryList){
            whereQuery = whereQuery + whereClause;
        }

        // add where query to overall query
        query = query + whereQuery;

        List<SObject> recordsProcessList = Database.query(query);

        List<SObject> updateList = new List<SObject>();

        for(SObject record:recordsProcessList){
            string mappingfield = importMappingRecord.Mapping_Field__r.QualifiedApiName;
            record.put(mappingfield, recordId);
            updateList.add(record);
        }

        Database.update(updateList);
    }


    /**
     * @description     filter type handling
     * @param           string filterType
     * @return          string filterSQOL
    */
    public static string filterTypeHandling(string filterType){
        if(filterType==CSVExport_Constants.FIELD_OPERATOR_EQUALS){
            return '=';
        } else if(filterType==CSVExport_Constants.FIELD_OPERATOR_NOT_EQUALS){
            return '!=';
        } else if(filterType==CSVExport_Constants.FIELD_OPERATOR_GREATER_THAN){
            return '>';
        } else if(filterType==CSVExport_Constants.FIELD_OPERATOR_GREATER_THAN_EQUALS){
            return '>=';
        } else if(filterType==CSVExport_Constants.FIELD_OPERATOR_LESS_THAN){
            return '<';
        } else if(filterType==CSVExport_Constants.FIELD_OPERATOR_LESS_THAN_EQUALS){
            return '<=';
        } else {
            return null;
        }
    }

    /**
    * @description  getSObjectFieldType - Will take in a field name and confirm what type of field it is
    * @param        string SOQLField - confirms the SOQL API Name of the field
    * @param        SObjectType objectType - confirms what objecttype we are working with
    * @return       DisplayType - confirmed what or how we are going to display the field
    */
    public static DisplayType getSObjectFieldType(SObjectType objectType, string sOQLField) {        
        
        // set the display type
        DisplayType fieldType = null;
        
        // check to see if the field exists and if it does return the type
        if(objectType.getDescribe().fields.getMap().containsKey(sOQLField)) {
            fieldType = objectType.getDescribe().fields.getMap().get(sOQLField).getDescribe().getType();    
        }

        // return our fieldtype
        return fieldType;
    }
}