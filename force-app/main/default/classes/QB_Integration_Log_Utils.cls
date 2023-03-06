public class QB_Integration_Log_Utils {
    private static List<QB_Integration_Log__c> qbLogsToInsert = new List<QB_Integration_Log__c>();
    public static void insertIntegrationLog(HttpRequest req, HttpResponse res, String apiFriendlyName, String result){
        System.debug('Entered Integration log Utils');
        QB_Integration_Log__c log = new QB_Integration_Log__c();
        log.QB_Consumed_API__c = apiFriendlyName;
        log.QB_Request_URL__c = req.getEndpoint();
        log.QB_Request_Body__c = req.getBody();
        log.QB_Status_Code__c = res.getStatusCode();
        log.QB_Response_Body__c = res.getBody();
        log.QB_Result__c = result;
        insert log;
        qbLogsToInsert.add(log);
    }
    
    public static void insertWebhookIntegrationLog(RestRequest req,String apiFriendlyName, String result){
        System.debug('Entered Integration log Utils');
        QB_Integration_Log__c log = new QB_Integration_Log__c();
        log.QB_Consumed_API__c = apiFriendlyName;
        //log.QB_Request_Body__c = req;
        //log.QB_Response_Body__c = res;
        log.QB_Result__c = result;
        insert log;
        qbLogsToInsert.add(log);
    }
    public static void insertNewLogs(){
        insert qbLogsToInsert;
        qbLogsToInsert.clear();
    }
}