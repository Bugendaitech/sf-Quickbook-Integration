public class WebhookHelper {
    
    public static void CreateAgency(String ObjectId)
    {
        Integer TempId = Integer.valueOf(ObjectId);
        // QB record Type
        // String agencyRecordIdQB  = '5000000000000051988';
        //  String insuredRecordIdQB = '5000000000000051989';
        String agencyRecordIdQB  = '';
        String insuredRecordIdQB = '';
        //  System.debug('TempId :'+TempId);
        /*  if(TempId > 0){
QB_Integration_Log_Utils.insertIntegrationLog(null,null, 'customerId', 'Agency Id Received From Quickbook');
}
else{
QB_Integration_Log_Utils.insertIntegrationLog(null,null, 'customerId', 'Error in Customer creation');
}*/
        
        String siteUrl     = BoldLegalUtils.siteHomeUrl;
        String endpoint; 
        
        
        // SF record Type 
        String agencyRecordIdSF   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agencies').getRecordTypeId();
        String insuredRecordIdSF  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        
        //  System.debug('Object Id:'+TempId);    
        HttpRequest req = new HttpRequest();
        String query='select * from Customer where Id ='+ '\''+TempId+'\'';
        //system.debug('Customer Id :'+query);
        query = query.replaceAll(' ', '%20');
        query = query.replaceAll('\\*', '%2A');
        query =query.replaceAll('\\\'', '%27');           
        // system.debug('Query::'+query);  
        
        if(siteUrl.contains('sandbox')){
            endpoint           = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/query?query='+query+'&minorversion=65';
            agencyRecordIdQB   = BoldLegalUtils.qbAgencyRecIdSand;insuredRecordIdQB  = BoldLegalUtils.qbInsuredRecIdSand;}else{endpoint = 'callout:QuickBookCredendial'+'/v3/company/702594170/query?query='+query+'&minorversion=65';agencyRecordIdQB= BoldLegalUtils.qbAgencyRecIdProd;insuredRecordIdQB   = BoldLegalUtils.qbInsuredRecIdProd;
                                                                                                                              }                           
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept',  'application/json'); 
        Http http = new Http();
        HTTPResponse res = http.send(req);
        //System.debug('Response Body From WebHook Helper:'+res.getBody());
        if(res.getStatusCode() == 200) {
            
            //  System.debug('if(res.getStatusCode() == 200)');
            
            string jsondata = res.getBody();
            //   System.debug(res.getBody());
            Map<String, Object> QueryResponses = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            //   System.debug('result:'+QueryResponses);
            Map<String , Object> QueryResponse = (Map<string,Object>) QueryResponses.get('QueryResponse');
            list<Object> customers = (List<Object>) QueryResponse.get('Customer');
            // system.debug('results3' +customers);
            List<Account> applicantListToBeInsert = new List<Account>();
            List<Account> applicantListToBeUpdate = new List<Account>();            
            for(Object obj : customers )
            {
                //System.debug('for(Object obj : customers )');
                Account applicant = new Account() ;
                Map<String, Object> mapCustomer = (Map<String,object>) obj;                
                Map<String,Object> CustomerTypeRef = (Map<String,Object>)mapCustomer.get('CustomerTypeRef');
                if(CustomerTypeRef != null){
                    String recordTypeofQb = String.valueOf(CustomerTypeRef.get('value'));
                    
                    if(recordTypeofQb == agencyRecordIdQB){
                        // code for agency
                        applicant.RecordTypeId        = agencyRecordIdSF;
                        applicant.Number_of_Units__c  = 1;
                        applicant.QB_External_Id__c   = Integer.valueOf(mapCustomer.get('Id'));
                        applicant.QB_Sync_Token__c    = (string)mapCustomer.get('SyncToken');
                        applicant.Commission__c='10';
                        applicant.Name =(string) mapCustomer.get('DisplayName');
                        Map<String,Object> PrimaryPhone = (Map<String,Object>) mapCustomer.get('PrimaryPhone');
                        if(PrimaryPhone != null){
                            applicant.Phone =String.valueOf(PrimaryPhone.get('FreeFormNumber'));
                        }
                        Map<String,Object> Fax = (Map<String,Object>) mapCustomer.get('Fax');
                        if(Fax != null){applicant.Fax =String.valueOf(Fax.get('FreeFormNumber'));
                                       }
                        Map<String,Object> WebAddr = (Map<String,Object>) mapCustomer.get('WebAddr');
                        if(WebAddr != null){
                            applicant.Website =String.valueOf(WebAddr.get('URI'));
                        }
                        Map<String,Object> PrimaryEmailAddr = (Map<String,Object>) mapCustomer.get('PrimaryEmailAddr');
                        if(PrimaryEmailAddr != null){
                            applicant.Email__c  = string.valueof(PrimaryEmailAddr.get('Address'));
                        }
                        
                        Map<String,Object> BillAddr = (Map<String,Object>) mapCustomer.get('BillAddr');
                        if(BillAddr != null){
                            applicant.BillingStreet       = string.valueof(BillAddr.get('Line1')); 
                            applicant.BillingCity         = string.valueof(BillAddr.get('City'));
                            applicant.BillingCountry      = string.valueof(BillAddr.get('Country'));
                            applicant.BillingState        = string.valueof(BillAddr.get('CountrySubDivisionCode'));
                            applicant.BillingPostalCode   = string.valueof(BillAddr.get('PostalCode'));
                        }
                        Map<String,Object> ShipAddr = (Map<String,Object>) mapCustomer.get('ShipAddr');
                        if(ShipAddr != null){
                            applicant.Physical_Address_2__c       = string.valueof(ShipAddr.get('Line1'));
                            applicant.Physical_Street_Address__c  = string.valueof(ShipAddr.get('Line2'));
                            applicant.Physical_City__c            = string.valueof(ShipAddr.get('City'));
                            applicant.Physical_Street_Address__c  = string.valueof(ShipAddr.get('Country'));
                            applicant.Physical_State__c           = string.valueof(ShipAddr.get('CountrySubDivisionCode'));
                            applicant.Physical_Zip_Code__c        = string.valueof(ShipAddr.get('PostalCode'));
                        }
                        Map<String,Object> MailAddr = (Map<String,Object>) mapCustomer.get('ShipAddr');
                        if(MailAddr != null){
                            applicant.Mailing_Address2__c      = string.valueof(MailAddr.get('Line1'));
                            applicant.Mailing_Address__c	     = string.valueof(MailAddr.get('Line2'));
                            applicant.Mailing_City__c            = string.valueof(MailAddr.get('City'));
                            applicant.Mailing_Address2__c        = string.valueof(MailAddr.get('Country'));
                            applicant.Mailing_State__c           = string.valueof(MailAddr.get('CountrySubDivisionCode'));
                            applicant.Mailing_Zip_Code__c	     = string.valueof(MailAddr.get('PostalCode'));
                        }
                        applicantListToBeInsert.add(applicant);}else if(recordTypeofQb == insuredRecordIdQB){
                            // code for insured(subcompany)
                        } }               
            }           
            if(!applicantListToBeInsert.isEmpty()){try{
                Insert applicantListToBeInsert;}Catch(Exception e){
                    // System.debug('The following exception has occurred: ' + e.getMessage());
                } 
                                                  }if(!applicantListToBeUpdate.isEmpty()){try{update applicantListToBeUpdate;}Catch(Exception e){
                                                      //  System.debug('The following exception has occurred: ' + e.getMessage());
                                                  } 
                                                                                         }    
            QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', ' Webhook Customer created Successfully');
        }  
        else{
            QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Webhook Customer creation');
        }
    }
    
    public static void CreatePayment(String ObjectId){
        
        Integer TempId = Integer.valueOf(ObjectId);
        System.debug('Object Id:'+TempId);
        String endpoint; 
        HttpRequest req = new HttpRequest();
        String query='select * from payment WHERE Id ='+ '\''+TempId+'\'';
        query = query.replaceAll(' ', '%20');
        query = query.replaceAll('\\*', '%2A');
        query =query.replaceAll('\\\'', '%27');           
        system.debug('Query::'+query); 
        String siteUrl     = BoldLegalUtils.siteHomeUrl;
        if(siteUrl.contains('sandbox')){
            endpoint           = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/query?query='+query+'&minorversion=65';
        }else{endpoint = 'callout:QuickBookCredendial'+'/v3/company/702594170/query?query='+query+'&minorversion=65';
             }                           
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept',  'application/json'); 
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('Response Body From WebHook Helper:'+res.getBody());
        if(res.getStatusCode() == 200) {
            
            System.debug('if(res.getStatusCode() == 200)');
            
            string jsondata = res.getBody();
            System.debug(res.getBody());
            Map<String, Object> QueryResponses = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            System.debug('result:'+QueryResponses);
            Map<String , Object> QueryResponse = (Map<string,Object>) QueryResponses.get('QueryResponse');
            list<Object> payment = (List<Object>) QueryResponse.get('Payment');
            system.debug('results3' +payment);
            List<QB_Invoice__c> invoiceListToBeUpdated = new List<QB_Invoice__c>();
            List<QB_Payment_Transaction__c> qbpaymentTransactionToInserted = new List<QB_Payment_Transaction__c>();
            List<QB_Payment__c>  qbPaymentToInserted              = new List<QB_Payment__c>(); 
            for(Object obj : payment )
            {
                System.debug('for(Object obj : invoice )');
                
                //  QB_Payment_Transaction__c 
                
                String invoiceId ;
                Integer amount;
                
                Map<String, Object> mapCustomer = (Map<String,object>) obj;
                List<Object> line = (List<Object>) mapCustomer.get('Line');
                system.debug('line'+line);
                for(Object lineObj : line){
                    Map<String, Object> mapLine = (Map<String,object>) lineObj ;
                    amount = Integer.valueOf(mapLine.get('Amount'));
                    system.debug('Amount'+amount);                                 
                    List<Object> linkedtxn = (List<Object>) mapLine.get('LinkedTxn');
                    
                    for(Object linkedtxnObj : linkedtxn) {
                        Map<String, Object> mapLinkedTxn = (Map<String,object>) linkedtxnObj ;
                        invoiceId = String.valueOf(mapLinkedTxn.get('TxnId'));
                        system.debug('invoiceId'+invoiceId);                                  
                        Map<String,Object> metaData = (Map<String,Object>)mapCustomer.get('MetaData');
                        Date  createdDate  = Date.valueOf(String.valueOf(metaData.get('CreateTime')));
                        Date  lastUpdated  = Date.valueOf(String.valueOf(metaData.get('LastUpdatedTime')));                                  
                        QB_Invoice__c invoice  = [SELECT Name,Id,QB_External_Id__c,Account__c ,Amount_Due__c,Sync_Token__c,Amount_Received__c 
                                                  FROM QB_Invoice__c WHERE QB_External_Id__c =: invoiceId ];      
                        QB_Payment__c qbPayment           = new QB_Payment__c();
                        qbPayment.QB_Amount_Received__c   = decimal.valueOf(String.valueOf(mapCustomer.get('TotalAmt')));
                        qbPayment.Name                    = '702594170-'+String.valueOf(mapCustomer.get('Id'));
                        qbPayment.QB_Sync_Token__c        = String.valueOf(mapCustomer.get('SyncToken'));
                        qbPayment.QB_Payment_Id__c	      = String.valueOf(mapCustomer.get('Id'));
                        qbPayment.QB_Account__c           =  invoice.Account__c;                                                               
                        qbPayment.QB_Last_Modified_in_QuickBooks_Date__c  = createdDate;
                        qbPayment.QB_Created_in_QBO_Date__c     = lastUpdated;
                        insert qbPayment;
                        
                        QB_Payment_Transaction__c qbPaymentTransaction = new QB_Payment_Transaction__c();
                        qbPaymentTransaction.Name            =  '702594170-'+String.valueOf(mapCustomer.get('Id'))+'-'+String.valueOf(invoice.QB_External_Id__c)+'-'+invoice.Name;
                        qbPaymentTransaction.QB_Invoice__c   =  invoice.Id;
                        qbPaymentTransaction.QB_payment__c   =  qbPayment.Id;
                        qbPaymentTransaction.QB_Amount__c    =  decimal.valueOf(String.valueOf(mapCustomer.get('TotalAmt')));
                        insert qbPaymentTransaction;
                        
                        invoice.Type__c             = 'Sales Receipt';
                        invoice.Amount_Due__c       =  0;  
                        invoice.Amount_Credited__c  =  0;    
                        invoice.Amount_Received__c  = decimal.valueOf(String.valueOf(mapCustomer.get('TotalAmt')));
                        invoice.Internal_Status__c  = 'Paid';
                        update invoice;
                    }
                    
                    
                }
               
                
                if(!invoiceListToBeUpdated.isEmpty()){
                    //try{
                    //  update invoiceListToBeUpdated;}Catch(Exception e){
                    // System.debug('The following exception has occurred: ' + e.getMessage());
                    //} 
                    
                }     
            }  
            
        }
    }
    
    public static void accountMethod(){
        
        Account acc1 				= new Account();
        acc1.Name    				= 'Test Acc1';
        acc1.Phone    				= 'Test Acc1';
        acc1.Website    			= 'Test Acc1'; 
        acc1.BillingCity     		= '';  
        acc1.BillingCountry  		= '';
        acc1.BillingGeocodeAccuracy = '';
        acc1.BillingLatitude   		= 0.0;
        acc1.BillingLongitude  		= 0.0;
        acc1.BillingPostalCode  	= '';
        acc1.BillingState 			= '';
        acc1.BillingStreet			= '';
        acc1.Fax 					= '';
        acc1.Industry  				= '';
        
        Account acc2 				= new Account();
        acc2.Name    				= 'Test acc2';
        acc2.Phone    				= 'Test acc2';
        acc2.Website    			= 'Test acc2'; 
        acc2.BillingCity     		= '';  
        acc2.BillingCountry  		= '';
        acc2.BillingGeocodeAccuracy = '';
        acc2.BillingLatitude   		= 0.0;
        acc2.BillingLongitude  		= 0.0;
        acc2.BillingPostalCode  	= '';
        acc2.BillingState 			= '';
        acc2.BillingStreet			= '';
        acc2.Fax 					= '';
        acc2.Industry  				= '';
        
        Account acc3                   = new Account();
        acc3.Name    				= 'Test acc3';
        acc3.Phone    			= 'Test acc3';
        acc3.Website    		= 'Test acc3'; 
        acc3.BillingCity     		= '';  
        acc3.BillingCountry  		= '';
        acc3.BillingGeocodeAccuracy     = '';
        acc3.BillingLatitude   		= 0.0;
        acc3.BillingLongitude  		= 0.0;
        acc3.BillingPostalCode  	= '';
        acc3.BillingState 		= '';
        acc3.BillingStreet		= '';
        acc3.Fax 			= '';
        acc3.Industry  			= '';
        
        Account acc4                   = new Account();
        
        acc4.Name    			= 'Test acc4';
        acc4.Phone    			= 'Test acc4';
        acc4.Website    		= 'Test acc4'; 
        acc4.BillingCity     		= '';  
        acc4.BillingCountry  		= '';
        acc4.BillingGeocodeAccuracy     = '';
        acc4.BillingLatitude   		= 0.0;
        acc4.BillingLongitude  		= 0.0;
        acc4.BillingPostalCode  	= '';
        acc4.BillingState 		= '';
        acc4.BillingStreet		= '';
        acc4.Fax 			= '';
        acc4.Industry  			= '';
        
        Account acc5                   = new Account();
        
        acc5.Name    			= 'Test acc5';
        acc5.Phone    			= 'Test acc5';
        acc5.Website    		= 'Test acc5'; 
        acc5.BillingCity     		= '';  
        acc5.BillingCountry  		= '';
        acc5.BillingGeocodeAccuracy     = '';
        acc5.BillingLatitude   		= 0.0;
        acc5.BillingLongitude  		= 0.0;
        acc5.BillingPostalCode  	= '';
        acc5.BillingState 		= '';
        acc5.BillingStreet		= '';
        acc5.Fax 			    = '';
        acc5.Industry  			= '';
        
        Account acc6            = new Account();
        
        acc6.Name    			= 'Test acc6';
        acc6.Phone    			= 'Test acc6';
        acc6.Website    		= 'Test acc6'; 
        acc6.BillingCity     	= '';  
        acc6.BillingCountry  		= '';
        acc6.BillingGeocodeAccuracy     = '';
        acc6.BillingLatitude   		= 0.0;
        acc6.BillingLongitude  	= 0.0;
        acc6.BillingPostalCode  = '';
        acc6.BillingState 		= '';
        acc6.BillingStreet		= '';
        acc6.Fax 			    = '';
        acc6.Industry  			= '';
        
        Account acc7                   = new Account();
        
        acc7.Name    			= 'Test acc7';
        acc7.Phone    			= 'Test acc7';
        acc7.Website    		= 'Test acc7'; 
        acc7.BillingCity     		= '';  
        acc7.BillingCountry  		= '';
        acc7.BillingGeocodeAccuracy     = '';
        acc7.BillingLatitude   		= 0.0;
        acc7.BillingLongitude  		= 0.0;
        acc7.BillingPostalCode  	= '';
        acc7.BillingState 		= '';
        acc7.BillingStreet		= '';
        acc7.Fax 			= '';
        acc7.Industry  			= '';
        
        Account acc8                   = new Account();
        
        acc8.Name    			= 'Test acc8';
        acc8.Phone    			= 'Test acc8';
        acc8.Website    		= 'Test acc8'; 
        acc8.BillingCity     		= '';  
        acc8.BillingCountry  		= '';
        acc8.BillingGeocodeAccuracy     = '';
        acc8.BillingLatitude   		= 0.0;
        acc8.BillingLongitude  		= 0.0;
        acc8.BillingPostalCode  	= '';
        acc8.BillingState 		= '';
        acc8.BillingStreet		= '';
        acc8.Fax 			= '';
        acc8.Industry  			= '';
        
        Account acc9                   = new Account();
        
        acc9.Name    			= 'Test acc9';
        acc9.Phone    			= 'Test acc9';
        acc9.Website    		= 'Test acc9'; 
        acc9.BillingCity     		= '';  
        acc9.BillingCountry  		= '';
        acc9.BillingGeocodeAccuracy     = '';
        acc9.BillingLatitude   		= 0.0;
        acc9.BillingLongitude  		= 0.0;
        acc9.BillingPostalCode  	= '';
        acc9.BillingState 		= '';
        acc9.BillingStreet		= '';
        acc9.Fax 			= '';
        acc9.Industry  			= '';
        
        Account acc10                   = new Account();
        
        acc10.Name    			= 'Test acc10';
        acc10.Phone    			= 'Test acc10';
        acc10.Website    		= 'Test acc10'; 
        acc10.BillingCity     		= '';  
        acc10.BillingCountry  		= '';
        acc10.BillingGeocodeAccuracy     = '';
        acc10.BillingLatitude   		= 0.0;
        acc10.BillingLongitude  		= 0.0;
        acc10.BillingPostalCode  	= '';
        acc10.BillingState 		= '';
        acc10.BillingStreet		= '';
        acc10.Fax 			= '';
        acc10.Industry  			= '';
    }    
    
}