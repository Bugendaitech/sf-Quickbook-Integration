@isTest(SeeAllData=true)
public class WebhookHelper_Test{
    
    class createCustomer implements HttpCalloutMock {
        HttpResponse res1;
        createCustomer(HttpResponse r) {
            res1 = r;
            //system.debug('responce EchoHttpMock:-'+res1);
        }
        // This is the HttpCalloutMock interface method
        public HttpResponse respond(HttpRequest req) {
         String JSONResponse ='{"QueryResponse":{"Customer":[{"Taxable":true,"BillAddr":{"Id":"336","Line1":"Street Avenue","Line2":"Street Avenue","City":"City","Country":"US","CountrySubDivisionCode":"US","PostalCode":"41214"},"ShipAddr":{"Id":"336","Line1":"Street Avenue","Line2":"Street Avenue","City":"City","Country":"US","CountrySubDivisionCode":"US","PostalCode":"41214"},"Job":false,"BillWithParent":false,"CustomerTypeRef":{"value":"5000000000000051988"},"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"ClientEntityId":"0","domain":"QBO","sparse":false,"Id":"240","SyncToken":"0","MetaData":{"CreateTime":"2022-11-26T02:07:14-08:00","LastUpdatedTime":"2022-11-26T02:07:14-08:00"},"GivenName":"TestAgency","FamilyName":"26Nov","FullyQualifiedName":"TestAgency 26Nov","DisplayName":"TestAgency 26Nov","PrintOnCheckName":"TestAgency 26Nov","Active":true,"V4IDPseudonym":"002098819282fc2784404289fe817878b8b1d7","PrimaryPhone":{"FreeFormNumber":"14541754"},"Mobile":{"FreeFormNumber":"14541754"},"PrimaryEmailAddr":{"Address":"test@gmail.com"},"WebAddr":{"URI":"http://test.com"}}],"startPosition":1,"maxResults":1},"time":"2022-11-26T02:27:18.307-08:00"}';

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
    
    @isTest static void positiveTest() {       
      
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new createCustomer(res));        
        Test.startTest();
        WebhookHelper.CreateAgency('336');
        Test.stopTest();
        
    }
    
        
    class createPayment implements HttpCalloutMock {
        HttpResponse res1;
        createPayment(HttpResponse r) {
            res1 = r;
            //system.debug('responce EchoHttpMock:-'+res1);
        }
        // This is the HttpCalloutMock interface method
        public HttpResponse respond(HttpRequest req) {
         String JSONResponse ='{"QueryResponse":{"Payment":[{"CustomerRef":{"value":"1877","name":"Condominium BT"},"DepositToAccountRef":{"value":"4"},"PaymentMethodRef":{"value":"1"},"TotalAmt":2160.00,"UnappliedAmt":0,"ProcessPayment":false,"domain":"QBO","sparse":false,"Id":"278","SyncToken":"0","MetaData":{"CreateTime":"2023-02-19T02:55:37-08:00","LastUpdatedTime":"2023-02-19T02:55:37-08:00"},"TxnDate":"2023-02-19","CurrencyRef":{"value":"USD","name":"United States Dollar"},"Line":[{"Amount":2160.00,"LinkedTxn":[{"TxnId":"1445","TxnType":"Invoice"}],"LineEx":{"any":[{"name":"{http://schema.intuit.com/finance/v3}NameValue","declaredType":"com.intuit.schema.finance.v3.NameValue","scope":"javax.xml.bind.JAXBElement$GlobalScope","value":{"Name":"txnId","Value":"1445"},"nil":false,"globalScope":true,"typeSubstituted":false},{"name":"{http://schema.intuit.com/finance/v3}NameValue","declaredType":"com.intuit.schema.finance.v3.NameValue","scope":"javax.xml.bind.JAXBElement$GlobalScope","value":{"Name":"txnOpenBalance","Value":"2160.00"},"nil":false,"globalScope":true,"typeSubstituted":false},{"name":"{http://schema.intuit.com/finance/v3}NameValue","declaredType":"com.intuit.schema.finance.v3.NameValue","scope":"javax.xml.bind.JAXBElement$GlobalScope","value":{"Name":"txnReferenceNumber","Value":"1061"},"nil":false,"globalScope":true,"typeSubstituted":false}]}}]}],"startPosition":1,"maxResults":1},"time":"2023-02-19T02:55:38.641-08:00"}';            HTTPResponse res = new HttpResponse();
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
    
    @isTest static void positiveTestPayment() {       
              Id Insured = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 100;
        applicant.Name                ='Test';
        applicant.Physical_City__c    = 'City';
        applicant.recordTypeId        = Insured;
        applicant.QB_External_Id__c   = 1877;
        insert applicant;
         
         QB_Invoice__c invoiceObj = new QB_Invoice__c();
        invoiceObj.Total__c                 = 2160.00;
        invoiceObj.Total_Tax__c             = 0.00;
        invoiceObj.QBO_Org_Name__c          ='Sandbox Company'; 
        invoiceObj.Due_Date__c              = Date.newInstance(2022, 12, 9);
        invoiceObj.Terms__c                 = 'Due On Recipt';
        invoiceObj.Account__c               = applicant.Id;
        invoiceObj.Invoice_Date__c          = Date.newInstance(2022, 12, 9); 
        invoiceObj.Email__c                 = 'email@gmial.com';
        invoiceObj.Email_Status__c          = 'NeedToSend'; 
        invoiceObj.Billing_State__c          = 'State';
        invoiceObj.Billing_City__c           = 'City';
        invoiceObj.Billing_Country__c        = 'USA';
        invoiceObj.Billing_Postal_Code__c    = '12456';
        invoiceObj.Billing_Street_Address__c = 'Street Address';
        invoiceObj.Sales_Rep__c             = 'John Test';
        invoiceObj.Policy__c                = '20222611D';
        invoiceObj.Amount_Due__c            =  00.00;
        invoiceObj.Statement_Memo__c        = 'Statement Memo';
        invoiceObj.QB_External_Id__c        = '1445';
        invoiceObj.Name                     = 'INV-02';
        insert invoiceObj;
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new createPayment(res));     
        Test.startTest();  
        WebhookHelper.CreatePayment('275');
        Test.stopTest();        
    }

    @isTest static void negativeTest() {       
      
        HttpResponse res = new HttpResponse();
        res.setStatusCode(400);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new createCustomer(res));        
        Test.startTest();
        WebhookHelper.CreateAgency('2000');
        Test.stopTest();
        
    }
     @isTest static void positiveTest2() {       
    
        Test.startTest();
        WebhookHelper.accountMethod();
        Test.stopTest();
        
    }
 
}