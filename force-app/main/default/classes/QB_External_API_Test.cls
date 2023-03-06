@isTest
public class QB_External_API_Test{
    
    class createCustomer implements HttpCalloutMock {
        HttpResponse res1;
        createCustomer(HttpResponse r) {
            res1 = r;
            //system.debug('responce EchoHttpMock:-'+res1);
        }
        // This is the HttpCalloutMock interface method
        public HttpResponse respond(HttpRequest req) {
            String JSONResponse = '{ "Customer": { "domain": "QBO", "PrimaryEmailAddr": { "Address": "Surf@Intuit.com" }, "DisplayName": "Bill\'s Windsurf Shop",  "PreferredDeliveryMethod": "Print", "GivenName": "Bill", "FullyQualifiedName": "Bill\'s Windsurf Shop", "BillWithParent": false, "Job": false, "BalanceWithJobs": 85.0, "PrimaryPhone": {"FreeFormNumber": "(415) 444-6538"}, "Active": true, "MetaData": { "CreateTime": "2014-09-11T16:49:28-07:00", "LastUpdatedTime": "2015-07-23T11:07:55-07:00"}, "BillAddr": { "City": "Half Moon Bay", "Line1": "12 Ocean Dr.", "PostalCode": "94213", "Lat": "37.4307072", "Long": "-122.4295234", "CountrySubDivisionCode": "CA", "Id": "3"}, "MiddleName": "Mark", "Taxable": false, "Balance": 85.0, "SyncToken": "1", "CompanyName": "Bill\'s Windsurf Shop", "FamilyName": "Lucchini", "PrintOnCheckName": "Bill\'s Windsurf Shop", "sparse": false, "Id": "2"}, "time": "2015-07-23T11:07:55.772-07:00"}';
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
    
    @isTest static void myTest2() {
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 1;
        applicant.Name                = 'Test';
        applicant.Physical_City__c    = 'City';
        
        Account applicant1             = new Account() ;
        applicant1.Number_of_Units__c  = 1;
        applicant1.Name                = 'Test';
        applicant1.Physical_City__c    = 'City';
        insert applicant1;
        String applicantData          = String.valueOf(applicant);
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new createCustomer(res));
        
        Test.startTest();
        QB_External_API.createCustomerAndSync(applicantData,applicant1.id);
        //QB_External_API.updateCustomer(applicantData,applicant1.id);
        Test.stopTest();
        
    }    
    
    class createInvoice implements HttpCalloutMock {
        HttpResponse res1;
        createInvoice(HttpResponse r) {
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
    
    @isTest static void myTest3() {        
        QB_Invoice__c invoice          = new QB_Invoice__c();
        invoice.Policy__c              = '20222611D';
        invoice.Due_Date__c            = Date.newInstance(2022, 12, 9);
        invoice.Invoice_Date__c        = Date.newInstance(2022, 11, 9);
        invoice.Amount_Received__c     = 1000;
        invoice.Amount_Credited__c     = 1000;
        invoice.Discount_Amount__c     = 1000;
        invoice.Amount_Due__c          = 1000;
        invoice.Credit_Memo_Total_Amount__c     = 1000;
        invoice.Total__c     = 1000;        
        insert invoice;
        
        QB_Invoice__c invoice1          = new QB_Invoice__c();
        invoice1.Policy__c              = '20222611D';
        invoice1.Due_Date__c            = Date.newInstance(2022, 12, 9);
        invoice1.Invoice_Date__c        = Date.newInstance(2022, 11, 9);
        invoice1.Amount_Received__c     = 1000;
        invoice1.Amount_Credited__c     = 1000;
        invoice1.Discount_Amount__c     = 1000;
        invoice1.Amount_Due__c          = 1000;
        invoice1.Credit_Memo_Total_Amount__c     = 1000;
        invoice1.Total__c     = 1000;        
        String invoiceData          = String.valueOf(invoice1);
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new createInvoice(res));
        
        Test.startTest();
        QB_External_API.createInvoiceAndSync(invoiceData, invoice.id);
        Test.stopTest();
    }
    
    class UpdateCustomer implements HttpCalloutMock {
        HttpResponse res1;
        UpdateCustomer(HttpResponse r) {
            res1 = r;
            //system.debug('responce EchoHttpMock:-'+res1);
        }
        // This is the HttpCalloutMock interface method
        public HttpResponse respond(HttpRequest req) {
            String JSONResponse=  '{ "Customer": { "domain": "QBO", "PrimaryEmailAddr": {"Address": "Surf@Intuit.com"}, "DisplayName": "Bills Windsurf Shop", "PreferredDeliveryMethod": "Print", "GivenName": "Bill", "FullyQualifiedName": "Bills Windsurf Shop", "BillWithParent": false, "Job": false, "BalanceWithJobs": 85.0, "PrimaryPhone": {"FreeFormNumber": "(415) 444-6538"}, "Active": true, "MetaData": {"CreateTime": "2014-09-11T16:49:28-07:00", "LastUpdatedTime": "2015-07-23T11:18:37-07:00"}, "BillAddr": {"City": "Half Moon Bay", "Line1": "12 Ocean Dr.", "PostalCode": "94213", "Lat": "37.4307072", "Long": "-122.4295234", "CountrySubDivisionCode": "CA", "Id": "3"}, "MiddleName": "Mac", "Taxable": false, "Balance": 85.0, "SyncToken": "4", "CompanyName": "Bills Windsurf Shop", "FamilyName": "Lucchini", "PrintOnCheckName": "Bills Wind Surf Shop", "sparse": false, "Id": "2"}, "time": "2015-07-23T11:18:37.323-07:00"}';                HTTPResponse res = new HttpResponse();
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
    
    @isTest static void myTest4() {
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 1;
        applicant.Name                = 'Test';
        applicant.Physical_City__c    = 'City';
        applicant.QB_External_Id__c   = 2;
        applicant.QB_Sync_Token__c    = '1';
        
        Account applicant1             = new Account() ;
        applicant1.Number_of_Units__c  = 1;
        applicant1.Name                = 'Test';
        applicant1.Physical_City__c    = 'City';
        applicant.QB_External_Id__c   = 2;
        applicant.QB_Sync_Token__c    = '1';
        insert applicant1;
        String applicantData          = String.valueOf(applicant);
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new UpdateCustomer(res));
        
        Test.startTest();
        QB_External_API.updateCustomer(applicantData,applicant1.id);
        QB_External_API.customerReadAllNamedCredential(applicant1.Name);
        Test.stopTest();
        
        
        
    }
    
    @isTest static void myTest5() {
        QB_External_API.justIncrement();
    }
}