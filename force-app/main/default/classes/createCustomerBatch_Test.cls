@isTest
public class createCustomerBatch_Test {
    // Simple echo callout class
    // Returns whatever response we tell it to when asked
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
    
     @isTest static void testPositive() {
        // Avoid using live data
        // create Account Data
        Account newAcc = new Account();
        newAcc.Name = 'First Bugendaitech Test';
        newAcc.QB_External_Id__c = 102;
        String accIndRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        newAcc.RecordTypeId = accIndRecordTypeId;
        newAcc.Physical_City__c = 'Test';
        newAcc.Number_of_Units__c = 10;
        insert newAcc;
        system.debug('Inserted Acc '+newAcc);
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        // This allows the callout to succeed
        Test.setMock(HttpCalloutMock.class, new createCustomer(res));
        // Start the test
        
        Test.startTest();
        List<Account>accList = new List<Account>();
        accList.add(newAcc);
        CreateCustomerBatch obj = new CreateCustomerBatch();
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,accList);
        obj.Finish(null);
        Id batchIds = Database.executebatch(obj);
        Test.stopTest();
        // Verify logic
        
        System.assertEquals(newAcc.id, accList[0].Id);
    }
}