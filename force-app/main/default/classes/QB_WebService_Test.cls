@isTest 
public class QB_WebService_Test {

    @isTest
    public static void  CreateCustomerTest() {
      
      String JSONNotify = '{   "eventNotifications":[   {      "realmId":"1185883450",      "dataChangeEvent":      {         "entities":[         {            "name":"Customer",            "id":"1",            "operation":"Create",            "lastUpdated":"2015-10-05T14:42:19-0700"         },         {            "name":"Vendor",            "id":"1",            "operation":"Create",            "lastUpdated":"2015-10-05T14:42:19-0700"         }]      }   }]}';
      Blob JSONBLOB = Blob.valueOf(JSONNotify);
      RestRequest request = new RestRequest();
      RestResponse response = new RestResponse();
      request.requestBody =JSONBLOB;
      request.requestUri ='https://bold--bugendai.sandbox.my.salesforce-sites.com/qbsite/services/apexrest/QuickBookWebservice';
          
      request.httpMethod = 'POST';
      RestContext.request = request;
      RestContext.response  = response;

            test.startTest();
            QB_WebService.CreateRocord();
            test.stopTest();


    }

     

  


}