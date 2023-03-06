global with sharing class CreateInvoiceExternalAPI {
    public CreateInvoiceExternalAPI() {

    }

    public static void CreateInvoice(List<QB_Line_Item__c> invoiceData){

     String JSONBody='{'+
       ' "Line": ['+
       '  {'+           
       '   "DetailType": "SalesItemLineDetail", '+
       '   "Amount"    : '+''+invoiceData[0].Amount__c+', '+
       '   "LineNum"   : '+''+invoiceData[0].Line_Number__c+', '+    
       '   "SalesItemLineDetail": {'+
       '     "ItemRef"  : {'+
       '        "name"  : "Services", '+
       '        "value" : "1"'+
       '      }'+
       '    }'+
       '   }'+
       '], '+
       '  "TotalTax": '+''+invoiceData[0].Invoice__r.Total_Tax__c+', '+
       '  "DueDate": '+'"'+invoiceData[0].Invoice__r.Due_Date__c+'",\n'+
       '  "CustomerRef": {'+
       '  "value": "1"'+
       '  "BillEmail": {'+
       '  "Address": '+' "'+invoiceData[0].Invoice__r.Email_Status__c+'"'+
       '}, '+
       '   "ShipAddr": {'+
       ' "City": "Middlefield",'+ 
       '  "Line1": "5647 Cypress Hill Ave.", '+
       '  "PostalCode": "94303", '+
       '  "Lat": "37.4238562", '+
       '  "Long": "-122.1141681", '+
       '  "CountrySubDivisionCode": "CA", '+
       '  "Id": "25"'+
       '},'+ 
      '  "EmailStatus":'+' "'+invoiceData[0].Invoice__r.Email_Status__c+'", '+
      '  "BillAddr": {'+
      '  "Line4": "Middlefield, CA  94303", '+
      '  "Line3": "5647 Cypress Hill Ave.", '+
      '  "Line2": "Sonnenschein Family Store", '+
      '  "Line1": "Russ Sonnenschein", '+
      '  "Long": "-122.1141681", '+
      '  "Lat": "37.4238562", '+
      '  "Id": "95"'+
      '},'+
       ' }'+
       ' }"';
       System.debug('JSON BODY :: ' +JSONBody);
       createInvoiceAPI(JSONBody);

    }
    @future(callout = true)
    public static void createInvoiceAPI(String JSBODY){
        String endpoint; 
        String result;
        String JsonBody=JSBODY;         
            System.debug('JSON Body:-'+JsonBody);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            endpoint = 'callout:QuickBookCredendial'+'/v3/company/4620816365236175040/invoice?minorversion=65';
            //req.setHeader('Authorization', header);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setBody(JsonBody);
            res = http.send(req);
            System.debug(req.getEndpoint());
            system.debug(res.getBody());
            System.debug('Status @@ '+res.getStatusCode());
            if(res.getStatusCode() == 200)
            {
                
                Map<String,Object> QueryResponseMap =(Map<String,Object>) JSON.deserializeUntyped(res.getBody());   
                // Map<String,Object> Customers =(Map<String,Object>) QueryResponseMap.get('Customer');  
                // System.debug('Customer Data @@ '+Customers); 
                // comObj.QB_Customer_ID__c = (String)Customers.get('Id');
                // comObj.QB_Sync_Token__c  = '0';
                // update comObj;
                // QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Customer created Successfully');
                result = 'error';
            } else {
                 result = 'success';
            }

 
    }


}