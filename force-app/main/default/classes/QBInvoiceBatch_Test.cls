@isTest
public class QBInvoiceBatch_Test {
    class createInvoices implements HttpCalloutMock {
        HttpResponse res1;
        createInvoices(HttpResponse r) {
            res1 = r;
            //system.debug('responce EchoHttpMock:-'+res1);
        }
        // This is the HttpCalloutMock interface method
        public HttpResponse respond(HttpRequest req) {
            String JSONResponse ='{"QueryResponse":{"Invoice":[{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"255","SyncToken":"3","MetaData":{"CreateTime":"2023-01-25T11:12:43-08:00","LastModifiedByRef":{"value":"9130354503741216"},"LastUpdatedTime":"2023-01-27T10:08:51-08:00"},"CustomField":[{"DefinitionId":"1","Name":"Crew #","Type":"StringType","StringValue":"20230126J"},{"DefinitionId":"2","Type":"StringType","StringValue":"John Doe"},{"DefinitionId":"3","Type":"StringType","StringValue":"2023-01-26 00:00:00"}],"DocNumber":"1146","TxnDate":"2023-01-26","CurrencyRef":{"value":"USD","name":"United States Dollar"},"PrivateNote":"Statement Memo","LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Amount":74.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"23","name":"Gross Premium"},"UnitPrice":74,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Id":"2","LineNum":2,"Amount":-11.10,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"20","name":"Comission"},"UnitPrice":-11.1,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Amount":62.90,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"287","name":"BT Ans Condominium"},"CustomerMemo":{"value":"Message on Invoice"},"BillAddr":{"Id":"432","Line1":"Test Raja Ji Puramm","City":"Lucknow","Country":"USA","CountrySubDivisionCode":"In"},"FreeFormAddress":false,"ShipFromAddr":{"Id":"456","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999 US"},"SalesTermRef":{"value":"1","name":"Due on receipt"},"DueDate":"2023-01-26","TotalAmt":62.90,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","BillEmail":{"Address":"testing26@gmail.com"},"Balance":62.90},{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"189","SyncToken":"0","MetaData":{"CreateTime":"2022-11-21T01:15:55-08:00","LastModifiedByRef":{"value":"9130354503741216"},"LastUpdatedTime":"2022-11-21T01:15:55-08:00"},"CustomField": [{"DefinitionId": "1","Name": "Crew #", "Type": "StringType","StringValue": "20230126J"},{"DefinitionId": "2","Type": "StringType","StringValue": "John Doe"},{"DefinitionId": "3","Type": "StringType","StringValue": "2023-01-26 00:00:00"}],"DocNumber":"1080","TxnDate":"2022-11-21","CurrencyRef":{"value":"USD","name":"United States Dollar"},"PrivateNote":"Statement Memo","LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Description":"Desc Gross","Amount":599.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"23","name":"Gross Premium"},"UnitPrice":599,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Id":"2","LineNum":2,"Description":"Desc Com","Amount":-59.90,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"20","name":"Comission"},"UnitPrice":-59.9,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Amount":539.10,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"230","name":"Bt Condominium Test 21 NovUpdatedUpdated"},"CustomerMemo":{"value":"Customer Message Here"},"BillAddr":{"Id":"318","Line1":"Street test2 IN","City":"City","Country":"IN","CountrySubDivisionCode":"IN","PostalCode":"74547"},"FreeFormAddress":false,"ShipFromAddr":{"Id":"319","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999 US"},"SalesTermRef":{"value":"1","name":"Due on receipt"},"DueDate":"2022-11-23","TotalAmt":539.10,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","BillEmail":{"Address":"BtCondominium@gamil.com"},"Balance":539.10}],"startPosition":1,"maxResults":2,"totalCount":2},"time":"2023-01-27T11:34:36.175-08:00"}';
              //  '{"QueryResponse":{"Invoice":[{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"255","SyncToken":"3","MetaData":{"CreateTime":"2023-01-25T11:12:43-08:00","LastModifiedByRef":{"value":"9130354503741216"},"LastUpdatedTime":"2023-01-27T10:08:51-08:00"},"CustomField":[{"DefinitionId":"1","Name":"Crew #","Type":"StringType","StringValue":"20230126J"},{"DefinitionId":"2","Type":"StringType","StringValue":"John Doe"},{"DefinitionId":"3","Type":"StringType","StringValue":"2023-01-26 00:00:00"}],"DocNumber":"1146","TxnDate":"2023-01-26","CurrencyRef":{"value":"USD","name":"United States Dollar"},"PrivateNote":"Statement Memo","LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Amount":74.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"23","name":"Gross Premium"},"UnitPrice":74,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Id":"2","LineNum":2,"Amount":-11.10,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"20","name":"Comission"},"UnitPrice":-11.1,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Amount":62.90,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"287","name":"BT Ans Condominium"},"CustomerMemo":{"value":"Message on Invoice"},"BillAddr":{"Id":"432","Line1":"Test Raja Ji Puramm","City":"Lucknow","Country":"USA","CountrySubDivisionCode":"In"},"FreeFormAddress":false,"ShipFromAddr":{"Id":"456","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999 US"},"SalesTermRef":{"value":"1","name":"Due on receipt"},"DueDate":"2023-01-26","TotalAmt":62.90,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","BillEmail":{"Address":"testing26@gmail.com"},"Balance":62.90},{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"189","SyncToken":"0","MetaData":{"CreateTime":"2022-11-21T01:15:55-08:00","LastModifiedByRef":{"value":"9130354503741216"},"LastUpdatedTime":"2022-11-21T01:15:55-08:00"},"CustomField":[{"DefinitionId":"1","Name":"Crew #","Type":"StringType"}],"DocNumber":"1080","TxnDate":"2022-11-21","CurrencyRef":{"value":"USD","name":"United States Dollar"},"PrivateNote":"Statement Memo","LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Description":"Desc Gross","Amount":599.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"23","name":"Gross Premium"},"UnitPrice":599,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Id":"2","LineNum":2,"Description":"Desc Com","Amount":-59.90,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"20","name":"Comission"},"UnitPrice":-59.9,"Qty":1,"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Amount":539.10,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"230","name":"Bt Condominium Test 21 NovUpdatedUpdated"},"CustomerMemo":{"value":"Customer Message Here"},"BillAddr":{"Id":"318","Line1":"Street test2 IN","City":"City","Country":"IN","CountrySubDivisionCode":"IN","PostalCode":"74547"},"FreeFormAddress":false,"ShipFromAddr":{"Id":"319","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999 US"},"SalesTermRef":{"value":"1","name":"Due on receipt"},"DueDate":"2022-11-23","TotalAmt":539.10,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","BillEmail":{"Address":"BtCondominium@gamil.com"},"Balance":539.10}],"startPosition":1,"maxResults":2,"totalCount":2},"time":"2023-01-27T11:34:36.175-08:00"}';
            HttpResponse res = new HttpResponse();
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
            return res;
        }
    }
    @isTest static void testPositive() {
       Account newAcc = new Account();
        newAcc.Name = 'First Bugendaitech Test';
        newAcc.QB_External_Id__c = 230;
        String accIndRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        newAcc.RecordTypeId = accIndRecordTypeId;
        newAcc.Physical_City__c = 'Test';
        newAcc.Number_of_Units__c = 10;
        insert newAcc;
        system.debug('Inserted Acc '+newAcc);
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new createInvoices(res));        
        Test.startTest();
        List<Account>accList = new List<Account>();
        accList.add(newAcc);
        QBInvoiceBatch obj = new QBInvoiceBatch();
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,accList);
        obj.Finish(null);
        Id batchIds = Database.executebatch(obj);
        //Id db = Database.executeBatch(new QBInvoiceBatch(),5);

        Test.stopTest();
            }  
}