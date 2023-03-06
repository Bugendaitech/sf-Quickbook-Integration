@isTest
public class CreateInvoiceBatch_Test {
    class EchoHttpMock implements HttpCalloutMock {
        HttpResponse res1;
        EchoHttpMock(HttpResponse r) {
            res1 = r;
            //system.debug('responce EchoHttpMock:-'+res1);
        }
        // This is the HttpCalloutMock interface method
        public HttpResponse respond(HttpRequest req) {
            String JSONResponse = '{"Invoice":{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"300","SyncToken":"0","MetaData":{"CreateTime":"2022-07-26T04:35:53-07:00","LastModifiedByRef":{"value":"9130353979255286"},"LastUpdatedTime":"2022-07-26T04:35:53-07:00"},"CustomField":[{"DefinitionId":"1","Name":"Crew #","Type":"StringType"}],"DocNumber":"1088","TxnDate":"2022-07-26","CurrencyRef":{"value":"USD","name":"United States Dollar"},"LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Amount":200.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"7","name":"Installation"},"UnitPrice":100,"Qty":2,"ItemAccountRef":{"value":"52","name":"Landscaping Services:Labor:Installation"},"TaxCodeRef":{"value":"NON"}}},{"Id":"2","LineNum":2,"Amount":49.95,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"7","name":"Installation"},"UnitPrice":49.95,"Qty":1,"ItemAccountRef":{"value":"52","name":"Landscaping Services:Labor:Installation"},"TaxCodeRef":{"value":"NON"}}},{"Id":"3","LineNum":3,"Amount":49.95,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"7","name":"Installation"},"UnitPrice":49.95,"Qty":1,"ItemAccountRef":{"value":"52","name":"Landscaping Services:Labor:Installation"},"TaxCodeRef":{"value":"NON"}}},{"Id":"4","LineNum":4,"Amount":149.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"7","name":"Installation"},"UnitPrice":149,"Qty":1,"ItemAccountRef":{"value":"52","name":"Landscaping Services:Labor:Installation"},"TaxCodeRef":{"value":"NON"}}},{"Id":"5","LineNum":5,"Amount":100.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"7","name":"Installation"},"UnitPrice":100,"Qty":1,"ItemAccountRef":{"value":"52","name":"Landscaping Services:Labor:Installation"},"TaxCodeRef":{"value":"NON"}}},{"Id":"6","LineNum":6,"Amount":150.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"7","name":"Installation"},"UnitPrice":75,"Qty":2,"ItemAccountRef":{"value":"52","name":"Landscaping Services:Labor:Installation"},"TaxCodeRef":{"value":"NON"}}},{"Amount":698.90,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"102","name":"First Bugendaitech Test"},"BillAddr":{"Id":"172","Line1":"Billing Street","City":"Billing City","Country":"Ciountry","CountrySubDivisionCode":"Billing State","PostalCode":"1424124"},"ShipFromAddr":{"Id":"177","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999 US"},"DueDate":"2022-08-25","TotalAmt":698.90,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","Balance":698.90},"time":"2022-07-26T04:35:53.622-07:00"}';
            HTTPResponse res = new HttpResponse();
            res.setHeader('Content-Type','application.json');
            res.setBody(JSONResponse);
            //system.debug('responce respond:-'+res);
            if(res1.getStatusCode() == 200)
            {
                res.setStatusCode(200);
            }
            else
            {
                res1.setStatusCode(400);
            }
            //res.setStatusCode(400);
            return res;
        }
    }
    @isTest static void testPositive() {   
        
        Account newAcc = new Account();
        newAcc.Name = 'First Bugendaitech Test';
        newAcc.QB_External_Id__c = 102;
        String accIndRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        newAcc.RecordTypeId = accIndRecordTypeId;
        newAcc.Physical_City__c = 'Test';
        newAcc.Number_of_Units__c = 10;
        insert newAcc;
        
        QB_Invoice__c InvoiceObj = new QB_Invoice__c();
        InvoiceObj.Policy__c = 'test';
        InvoiceObj.Amount_Credited__c = 50;
        InvoiceObj.Total__c = 100;
        InvoiceObj.Message_Displayed__c = 'testData';
        InvoiceObj.Email__c = 'test@email.com';
        InvoiceObj.Invoice_Date__c = System.today();
        InvoiceObj.Account__c =newAcc.id;
        InvoiceObj.Statement_Memo__c = 'test';
        InvoiceObj.Due_Date__c = System.today() +5;
        Insert InvoiceObj;
        
        QB_Line_Item__c LineItem = new QB_Line_Item__c();
        LineItem.Name = 'Test';
        LineItem.Quantity__c = 1;
        LineItem.Amount__c = 100;
        LineItem.Rate__c = 2;
        LineItem.Product_Service__c = 'Commissions';
        LineItem.Description__c = 'TestData';
        LineItem.Invoice__c = InvoiceObj.Id;
        
        Insert LineItem;
            
        List<QB_Invoice__c> ListOfInvoice = new List<QB_Invoice__c>();
        ListOfInvoice.add(InvoiceObj);
        // System.debug('Test Execute+++++++:'+ListOfInvoice);
        for(QB_Invoice__c ObjTemp : ListOfInvoice)
        {
            // System.debug(ObjTemp);
        }
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new EchoHttpMock(res));
        // Start the test
        
        test.startTest();
        List<QB_Invoice__c> ListInvoice = new List<QB_Invoice__c>();
        String TempID1 =InvoiceObj.Id;
        ListInvoice = [SELECT Id,Policy__c,Amount_Credited__c,Total__c,Email__c,Statement_Memo__c,Due_Date__c,Invoice_Date__c,Name,Message_Displayed__c,Account__c,Account__r.QB_External_Id__c,Account__r.Name,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c Where Id=: TempID1];
        CreateInvoiceBatch obj = new CreateInvoiceBatch();
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,ListInvoice);
        obj.Finish(null);
        Id batchIds = Database.executebatch(obj);
        test.stopTest();
    }
}