global class CreateCustomerBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts , Database.Stateful {
    
    global Integer RecordsProcessed =0;
    //global String accname = 'Bay House Miami Condominium Association Inc';
    global String query ='select  Name, Phone, Email__c, Mailing_City__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account LIMIT 5';
    
    public  Database.QueryLocator  start(Database.BatchableContext BC) {
        
       
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {         
        String endpoint; 
        String JsonBody;        
        List<Account> AccountsToUpdate = new List<Account>();
        for(Account acc : scope)  
        {
            JsonBody    =		'{'+
                '  "FullyQualifiedName": '+'"'+acc.Name+'1", \n'+
                '  "PrimaryEmailAddr": '+'{\n' + 
                '    "Address": ' + '"'+acc.Email__c+'"\n'+
                '  }, \n'+
                '  "DisplayName": '+'"'+acc.Name+'", \n'+
                '  "Suffix": "Jr", \n'+
                '  "Title": "Mr", \n'+
                '  "MiddleName": "B", \n'+
                '  "Notes": "Here are other details.", \n'+
                '  "FamilyName": '+'"'+acc.Name+'", \n'+
                '  "PrimaryPhone": '+'{\n'+
                '    "FreeFormNumber": '+'"'+acc.Phone+'"\n'+
                '  }, \n'+
                '  "CompanyName": '+'"'+acc.Name+'", \n'+
                '  "BillAddr": {\n'+
                '    "CountrySubDivisionCode": '+'"'+acc.BillingState+'", \n'+
                '    "City": '+'"'+acc.BillingCity+'", \n'+
                '    "PostalCode": '+'"'+acc.BillingPostalCode+'", \n'+
                '    "Line1": '+'"'+acc.BillingStreet+'", \n'+
                '    "Country": '+'"'+acc.BillingCountry+'" \n'+
                '  }, \n'+
                '  "GivenName": '+'"'+acc.Name+'" \n'+
                '}';
            //System.debug('JSON Body:-'+JsonBody);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            endpoint = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/customer?minorversion=65';
            //req.setHeader('Authorization', header);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setBody(JsonBody);
            res = http.send(req);
            //System.debug(req.getEndpoint());
            //System.debug(res.getBody());
            //System.debug('Status @@ '+res.getStatusCode());
            
            if(res.getStatusCode() == 200)
            {
                
                Map<String,Object> QueryResponseMap =(Map<String,Object>) JSON.deserializeUntyped(res.getBody());   
                Map<String,Object> Customers =(Map<String,Object>) QueryResponseMap.get('Customer');  
                //System.debug('Customer Data @@ '+Customers); 
             /*   acc.QB_Customer_ID__c = (String)Customers.get('Id');
                acc.QB_Sync_Token__c  = '0';
                //update acc;*/
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Customer created Successfully');
              //  AccountsToUpdate.add(acc);
               // recordsProcessed++;
            }
            else{
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Customer creation');
            }
        }
        //if(!//System.Test.isRunningTest()) Update AccountsToUpdate;   
    }        
    public void finish(Database.BatchableContext BC){
        
        //System.debug('RecordsProcessed:::::'+ recordsProcessed);
        /* //System.debug(recordsProcessed + ' records processed.');
AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
JobItemsProcessed,
TotalJobItems
FROM AsyncApexJob
WHERE Id = :BC.getJobId()];*/
        
        
    }
}