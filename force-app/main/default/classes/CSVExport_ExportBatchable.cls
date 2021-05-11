/**
 * @description    Batch class to process finance batch and generate csv file
 * @author          philip@hyphen8.com
 * @date            12/02/2021
 * @group           Helper
*/
public  class CSVExport_ExportBatchable implements Database.Batchable<SObject> , Database.stateful {

    private List<SObject> exportRecords = new List<SObject>();
    private Map<String, List<String>> lineFieldMappings;
    private List<CSV_Export_File_Line__mdt> listOfLineMappings;
    private ID contentDocumentID;
    private CSV_Export_File__mdt exportMappingRecord;
    string recordId;
    private String csv;
    private string fieldSetQuery;
    private String soqlQuery;


    public CSVExport_ExportBatchable(string rid,
                                     CSV_Export_File__mdt emr) {

        this.recordId = rid;
        this.exportMappingRecord = emr;

    }

    public Database.QueryLocator start(Database.BatchableContext BC){


        listOfLineMappings = CSVExport_ExportHelper.getMappingsLines(exportMappingRecord.Id);
        lineFieldMappings = CSVExport_ExportHelper.getLineFieldMapping(listOfLineMappings);
        fieldSetQuery = CSVExport_ExportHelper.getSOQLFieldQuery(listOfLineMappings);
        soqlQuery = CSVExport_ExportHelper.getRecordsToProcess(exportMappingRecord, fieldSetQuery, recordId);
        csv = exportMappingRecord.CSV_Header__c + '\n';

        return Database.getQueryLocator(soqlQuery);
    }

    public void execute(Database.BatchableContext BC,List<SObject> listOfRecords){

        for(SObject record:listOfRecords){
            string recordlines = CSVExport_ExportHelper.getLineValues(record, lineFieldMappings);
            csv = csv + recordlines;
        }


    }

    public void finish(Database.BatchableContext BC){

        contentDocumentID = CSVExport_ExportHelper.getExistingContentDocumentID(recordId, exportMappingRecord.FileName__c);
        CSVExport_ExportHelper.generateContentFile(csv, recordId, contentDocumentID, exportMappingRecord.Use_Versioning__c, exportMappingRecord.FileName__c);

    }

}