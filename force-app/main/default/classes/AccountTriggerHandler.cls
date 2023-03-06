public class AccountTriggerHandler {
    
    
    Public Static void UpdateAccountRecords(Map<Id,Account>OldMap, Map<Id,Account>NewMap)
    {
        String JsonBody;
        Id Insured = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        
        Map<Id,Account>MapOfAccount = new Map<Id, Account>();        
        
        for(Account acc : NewMap.values()){
            
            if(OldMap.containsKey(acc.id))
            {
                
                Account OldData   =  OldMap.get(acc.Id); 
                
              //  System.debug(OldMap.containsKey(acc.id));
                System.debug('Inside ForLoop');
              
                if(NewMap.values() != OldMap.Values() && acc.RecordTypeId == Insured && acc.Number_of_Units__c > 1 && acc.QB_External_Id__c !=null){
                    
                     if(acc.QB_External_Id__c !=null || OldData.QB_External_Id__c!=null){ 
                        JsonBody = '{'+
                        '      "Id": '+'"'+acc.QB_External_Id__c+'", \n';
                     }
                    
                    if(acc.Name != OldData.Name){
                        JsonBody+=
                            '      "DisplayName": '+'"'+acc.Name+'", \n'+
                            '      "CompanyName": '+'"'+acc.Name+'", ';
                    } 
                    
                    if(acc.Email__c != OldData.Email__c){ 
                        JsonBody+='   "PrimaryEmailAddr": {'+
                            '          "Address": '+'"'+acc.Email__c+'"'+ 
                            '      }, ';
                    }
                    if(acc.Phone != OldData.Phone){
                        JsonBody+='  "PrimaryPhone": {'+
                            '    "FreeFormNumber": '+'"'+acc.Phone+'"'+ 
                            '  }, ';
                    }
                    if((acc.BillingState != OldData.BillingState) || (acc.BillingCountry != OldData.BillingCountry) ||  (acc.BillingCity != OldData.BillingCity) || (acc.BillingPostalCode != OldData.BillingPostalCode)||(acc.BillingStreet != OldData.BillingStreet))
                       {
                        JsonBody+='  "BillAddr": {'+
                          '    "CountrySubDivisionCode": '+'"'+acc.BillingState+'",\n'+
                          '    "City": '+'"'+acc.BillingCity+'",\n'+
                          '    "PostalCode": '+'"'+acc.BillingPostalCode+'",\n'+
                          '    "Line1": '+'"'+acc.BillingStreet+'",\n'+
                          '    "Country": '+'"'+acc.BillingCountry+'"\n '+
                             '  }, ';
                    }
                    JsonBody+=
                        '	   "Active": true,\n'+
                        '      "SyncToken": '+'"'+acc.QB_Sync_Token__c+'",\n '+
                        '      "sparse": true'+
                        '    } ';      
                }
                System.debug('JsonBody:-'+JsonBody);
                // here
             if(!Test.isRunningTest()){QB_External_API.updateCustomer(JsonBody,acc.Id);}
             
            }
        }
    }
}