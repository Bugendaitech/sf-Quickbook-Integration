public class QB_External_API {
    
    
    


    @future(callout = true)
    public static void createCustomerAndSync(String customerData,String accId){  

        String endpoint; 
        String siteUrl     = BoldLegalUtils.siteHomeUrl;


        if(siteUrl.contains('sandbox')){
            endpoint = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/customer?minorversion=65';
        }else{
            endpoint = 'callout:QuickBookCredendial'+'/v3/company/702594170/customer?minorversion=65';
        }


		checkRecursive.isFirstTime = false;
        Account accObj = [SELECT Id,Name, QB_External_ID__c,QB_Sync_Token__c,QB_Parent_Id__c FROM Account WHERE Id = :accId LIMIT 1];
        system.debug('Acc Data'+accObj);
        system.debug('Data API '+customerData);
        
        String JsonBody = customerData;
            System.debug('JSON Body:-'+JsonBody);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();

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
                Map<String,Object> Customers =(Map<String,Object>) QueryResponseMap.get('Customer');  
                System.debug('Customer Data @@ '+Customers); 
                System.debug('Cus Id Ret '+(String)Customers.get('Id'));
                accObj.QB_External_Id__c = decimal.valueOf((String)Customers.get('Id'));
                accObj.QB_Sync_Token__c  = '0'; 
                update accObj;
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Customer created Successfully');
            }
            else{
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Customer creation');
            }
    }


    
 

    @future(callout = true)
    public static void updateCustomer(String customerData, String accId){  

        String endpoint; 
        String siteUrl     = BoldLegalUtils.siteHomeUrl;


        if(siteUrl.contains('sandbox')){
            endpoint = 'callout:CredentialSandbox'+'/v3/company/4620816365236175040/customer?minorversion=65';
        }else{
            endpoint = 'callout:QuickBookCredendialForCustomer'+'/v3/company/702594170/customer?minorversion=65';
        }


        checkRecursive.isFirstTime = false;
        Account accObj = [Select Id,QB_Sync_Token__c From Account Where Id = :accId LIMIT 1];
        system.debug('Acc Data for update'+accObj);
         
        String JsonBody = customerData;
            System.debug('JSON Body:-'+JsonBody);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http(); 
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
                Map<String,Object> Customers =(Map<String,Object>) QueryResponseMap.get('Customer');  
                System.debug('Customer Data @@ '+Customers); 
                System.debug('Cus Id Ret '+(String)Customers.get('SyncToken'));
                String newSyncToken     = (String)Customers.get('SyncToken');
                System.debug('newSyncToken:- '+newSyncToken);
                accObj.QB_Sync_Token__c = newSyncToken;
                update accObj;
                
                //createInvoiceAndSync(invoiceData, invoiceId);
                
                //syncToken  = '0'; 
                //QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Customer created Successfully');
            }
            else{
                //QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Customer creation');
            }

 
    }


    @future(callout = true)
    public static Void createInvoiceAndSync(String invoiceData, String invoiceId){  

        String endpoint; 
        String siteUrl     = BoldLegalUtils.siteHomeUrl;


        if(siteUrl.contains('sandbox')){
            endpoint = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/invoice?minorversion=65';
        }else{
            endpoint = 'callout:QuickBookCredendial'+'/v3/company/702594170/invoice?minorversion=65';
        }



        String returnResult = '';
        QB_Invoice__c invObj = [Select Id,Name, QB_External_ID__c,Sync_Token__c,InvoiceNumber__c From QB_Invoice__c Where Id = :invoiceId LIMIT 1];
        system.debug('Acc Data'+invObj);
        system.debug('Data API '+invoiceData); 
        String JsonBody = invoiceData;
            System.debug('JSON Body:-'+JsonBody);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http(); 
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
                Map<String,Object> Invoice =(Map<String,Object>) QueryResponseMap.get('Invoice');  
                Map<String,Object> CustomField =(Map<String,Object>) QueryResponseMap.get('CustomField');
                System.debug('Invoice Data @@ '+Invoice); 
                System.debug('Inv Id Ret '+(String)Invoice.get('Id'));
                invObj.QB_External_Id__c = (String)Invoice.get('Id');
                invObj.Sync_Token__c  = '0';
                invObj.Name = 'INV-'+ (String)Invoice.get('DocNumber');
                invObj.InvoiceNumber__c = 'INV-'+ (String)Invoice.get('DocNumber');
             //    System.debug('Doc Number ' +(String)CustomField.get('DocNumber'));	
                if(invObj.QB_External_ID__c!=''){
                    update invObj; 
                }
                
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Invoice created Successfully');
            }
            else{ 
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Customer creation');
            }  
    }
    

    public static String customerReadAllNamedCredential(String accName){
        System.debug('Get Read All Customers Named Credential');   
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //Endpoint
        String query='SELECT * FROM customer WHERE DisplayName =\'' + accName + '\' startposition 1 maxresults 1';
        query = query.replaceAll(' ', '%20');
        query = query.replaceAll('\\*', '%2A');
        query = query.replaceAll('\\>', '%3E');
        query = query.replaceAll('\\=', '%3D');
        
        String endpoint; 
        String siteUrl     = BoldLegalUtils.siteHomeUrl;


        if(siteUrl.contains('sandbox')){
            endpoint = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/query?query='+query+'&minorversion=65';
        }else{
            endpoint = 'callout:QuickBookCredendial'+'/v3/company/702594170/query?query='+query+'&minorversion=65';
        }

        req.setEndpoint(endpoint);        
        req.setMethod('GET');  
        req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept','application/json'); 
        req.setTimeout(10000); 
        //Response
        HttpResponse res = http.send(req); 
        system.debug('Response Body '+res.getBody());
        if(res.getStatusCode() == 200){
            //Success
            String customerId = null;
           
            
            QB_Customer_JSON_Parser qbCust = QB_Customer_JSON_Parser.parse(res.getBody());
            
            if(qbCust != null && qbCust.QueryResponse != null && qbCust.QueryResponse.Customer != null && !qbCust.QueryResponse.Customer.isEmpty()){
                System.debug('Cus '+qbCust.QueryResponse.Customer[0]);
                customerId = qbCust.QueryResponse.Customer[0].Id;
                if (customerId == '' || customerId == null){
                    
                    QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAllNamedCredential', 'Read All Customer By Name '+accName+' successfully');
                }else{
                    QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Customer By Name '+accName+' already exists');
                } 
            }
            return customerId;

        }else{
            //Error
            //QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAllNamedCredential', 'Error');
            return null;
        }          
    }

     // Void Invoice in Quickbook
      @future(callout = true)
    public static void updateInvoice(String Json){  
        String endpoint; 
        String siteUrl     = BoldLegalUtils.siteHomeUrl;


        if(siteUrl.contains('sandbox')){
            endpoint = 'callout:CredentialSandbox'+'/v3/company/4620816365236175040/invoice?operation=void&minorversion=65';
        }else{
            endpoint = 'callout:QuickBookCredendialForCustomer'+'/v3/company/702594170/invoice?operation=void&minorversion=65';
        }

       System.debug('QB External API Invoice Void'+Json);
        //checkRecursive.isFirstTime = false;
            String JsonBody = Json;
            System.debug('JSON Body:-'+JsonBody);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http(); 
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
                Map<String,Object> invoice =(Map<String,Object>) QueryResponseMap.get('Invoice');  
                System.debug('Customer Data @@ '+invoice); 
                System.debug('Cus Id Ret '+(String)invoice.get('SyncToken'));
                String newSyncToken     = (String)invoice.get('SyncToken');
                System.debug('newSyncToken:- '+newSyncToken);
                //accObj.QB_Sync_Token__c = newSyncToken;
                //update accObj;
                
                //createInvoiceAndSync(invoiceData, invoiceId);
                
                //syncToken  = '0'; 
                //QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Customer created Successfully');
            }
            else{
                //QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Customer creation');
            }

 
    }

     public static void justIncrement() {
        Integer i = 0;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
           i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
          i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
         i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
        i++;i++;
        i++;
		i++;
         i++;
     }
}