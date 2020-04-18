/**
 * @description     invocable method for importing records against a given export record
 * @author          daniel@hyphen8.com
 * @date            18/04/2020
 * @group           Invocables
*/
public with sharing class CSVExport_ImportInvocable {


    /**
     * @description invocable method that will review the export record and pull in the appropriate meta data to perform a query and pull in the link the appropriate records
     *              to the export csv record
     */
    @InvocableMethod(label='Import records for Export' description='Invocable method to support importing of records against the csv export record being processed')
    public static void importRecordsForExport(List<ExportRecord> exportrecords){

        for(ExportRecord exportrecord:exportrecords){
            List<CSV_Import_Mapping__mdt> mappings = CSVExport_ImportHelper.getMappings(exportrecord.developerName);
            system.debug('mappings > ' + mappings);
            for(CSV_Import_Mapping__mdt cim:mappings){
                CSVExport_ImportHelper.processLinking(exportrecord.recordId, cim);
            }
        }
    }

    /**
     * @description     invocable parameter record to make processing more efficient
     */
    public with sharing class ExportRecord {
        /**
         * @description this is the recordId for the csv export record
         */
        @InvocableVariable(label='Record ID' required=true)
        public Id recordId;

        /**
         * @description this is the recordtype developer name export
         */
        @InvocableVariable(label='DeveloperName' required=true)
        public string developerName;
    }
}