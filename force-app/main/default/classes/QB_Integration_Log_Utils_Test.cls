@isTest(SeeAllData=true)
public class QB_Integration_Log_Utils_Test {
    
    @isTest static void myTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(400);
        res.setBody('{"Fault":{"Error":[{"Message":"Invalid Number","Detail":"Invalid Number : null","code":"2090","element":"CustomerRef.value"}],"type":"ValidationFault"},"time":"2022-11-30T08:16:58.918-08:00"}');
        HttpRequest req  = new HttpRequest();
        req.setEndpoint('callout:QuickbooksCredentialsSandbox/v3/company/4620816365236175040/invoice?minorversion=65');
        req.setBody('{"Line":[{"DetailType": "SalesItemLineDetail","Amount": "3244.0000","Description" :"jhf","SalesItemLineDetail": {"ItemRef":{ "value": "23"},"Qty": "1.00","UnitPrice": "3244.00"}},{"DetailType": "SalesItemLineDetail","Amount": "-324.4000","Description" :"ujc","SalesItemLineDetail":{"ItemRef": {"value": "20"},"Qty": "1.00","UnitPrice": "-324.40"}}],"Deposit": "null","Balance": "2919.60","SalesTermRef": { "value": "1" },"PrivateNote": "dkj", "BillEmail": {"Address": "nicole@boldlegalplans.com"},"TxnDate" : "2022-11-30 00:00:00","DueDate" : "2022-11-30 00:00:00","CustomerRef": {"name": "Robert Condominium Association", "value": "null"}}');
        QB_Integration_Log_Utils.insertIntegrationLog( req,  res, 'customerReadAll', 'Invoice created Successfully');
        // QB_Integration_Log_Utils.insertNewLogs();
    }     
}