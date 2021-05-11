/**
 * @description    Batch class to process funding payments and add them to finance batch
 * @author          philip@hyphen8.com
 * @date            12/02/2021
 * @group           Helper
*/
public  class CSVExport_ImportBatchable implements Database.Batchable<SObject> , Database.stateful {


    CSV_Import_Mapping__mdt  importMappingRecord;
    String soqlQuery;
    String recordId;

    public CSVExport_ImportBatchable(string rid,
                                     CSV_Import_Mapping__mdt cim,
                                     String soql) {

        this.recordId = rid;
        this.importMappingRecord = cim;
        this.soqlQuery = soql;

    }

    public Database.QueryLocator start(Database.BatchableContext BC){


        return Database.getQueryLocator(soqlQuery);
    }

    public void execute(Database.BatchableContext BC,List<SObject> listOfRecords){

        List<SObject> updateList = new List<SObject>();

        for(SObject record:listOfRecords){
            string mappingfield = importMappingRecord.Mapping_Field__r.QualifiedApiName;
            record.put(mappingfield, recordId);
            updateList.add(record);
        }

        // perform update
        Database.update(updateList);


    }

    public void finish(Database.BatchableContext BC){

    }

}