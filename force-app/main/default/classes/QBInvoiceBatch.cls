public class QBInvoiceBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts , Database.Stateful {
    
    public  Database.QueryLocator  start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Name FROM Account LIMIT 1');
    }    
    
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        
        String siteUrl           = BoldLegalUtils.siteHomeUrl;
        String endpoint  ; 
        String InsertInvoice       = label.InsertInvoice;
        String InsertLineItem	   = label.InsertLineItem;     
        
        HttpRequest req     = new HttpRequest();
        
        String query        = label.batchInvoiceQuery;
        query = query.replaceAll(' ', '%20');
        query = query.replaceAll('\\*', '%2A');
        query = query.replaceAll('\\\'', '%27');        
        
        if(siteUrl.contains('sandbox')){
            // query = 'SELECT%20%2A%20FROM%20Invoice%20WHERE%20Id%20IN%20%28%27189%27%2C%27255%27%29';
            endpoint = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/query?query='+query+'&minorversion=65';
        }else{
            endpoint = 'callout:QuickBookCredendial'+'/v3/company/702594170/query?query='+query+'&minorversion=65';
        }   
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept',  'application/json'); 
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 200) {
            
            String jsondata = res.getBody();
            system.debug('Invoice JS'+jsondata);
            
            Map<String, Object> QueryResponses  = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> QueryResponse   = (Map<string,Object>) QueryResponses.get('QueryResponse');
            
            List<Object> invoices                                   = (List<Object>) QueryResponse.get('Invoice');           
            List<QB_Invoice__c> invoicesToInsert                    = new List<QB_Invoice__c> ();            
            List<QB_Line_Item__c> QbLineItemList                    = new List<QB_Line_Item__c>();
            Map<String,List<QB_Line_Item__c>>  mapInvAndLineItems   = new Map<String,List<QB_Line_Item__c>>();
            Map<Double,Id>    mapAccExIdAndId                       = new Map<Double,Id>();
            Map<String,Id>    mapInvoiceExIdAndId                   = new Map<String,Id>();
            
            //system.debug('Invoices'+invoices);

            
            
            //Map of Account
            List<Account> accList   = [Select Id, QB_External_Id__c FROM Account WHERE QB_External_Id__c != null AND Number_of_Units__c > 1];
            for(Account acc : accList){
                mapAccExIdAndId.put(acc.QB_External_Id__c,acc.Id);
            }
            
            
            //Map of Existing Invoices
            List<QB_Invoice__c> invoiceLists = [Select Id, QB_External_Id__c FROM QB_Invoice__c WHERE QB_External_Id__c != null];
            if(!invoiceLists.isEmpty()){
                for(QB_Invoice__c invIt : invoiceLists){
                    mapInvoiceExIdAndId.put(invIt.QB_External_Id__c,invIt.Id);
                }
            }            
            
            List<String> dateErrorInv = new List<String>();
            //System.debug('map '+mapInvoiceExIdAndId);
            //QB_Invoice__c selQbForName = [SELECT Id,Name from Qb_Invoice__c Order By Name Desc LIMIT 1];                
            //String namePart            = selQbForName.Name.substring(4);
            Integer nameForLineItem    =  null;
            
            //INV-0010
            
            Integer namePart = Database.countQuery('select count() from Qb_Invoice__c ');
            
            for(Object obj : invoices ){
                
                            
                String inceptionDate                = null;
                String policyName                   = null;
                String salesRep                     = null;
                Boolean   haveInvoice               = false;
                Boolean   haveAccount               = false;
                Boolean   otherLineItems            = false;
                QB_Invoice__c invoiceObj            = new QB_Invoice__c();
                Map<String, Object> invoiceMap      = (Map<String,object>) obj;  
                String invId                        = (String) invoiceMap.get('Id');
                invoiceObj.Sync_Token__c            = (String) invoiceMap.get('SyncToken');
                
                
                if(!mapInvoiceExIdAndId.containsKey(invId)){
                    haveInvoice  = false;
                    //invoiceObj.QB_External_Id__c        = (String) invoiceMap.get('Id');
                    System.debug('not exists for '+invId);
                    
                        invoiceObj.QB_External_Id__c        = (String) invoiceMap.get('Id');
                        Map<String, Object> customerRef     = (Map<String, Object>)invoiceMap .get('CustomerRef');
                        String cusId                        = (String) customerRef.get('value');
                        Integer custExternalId              = Integer.valueOf(cusId);                
                        invoiceObj.Account__c               = mapAccExIdAndId.get(custExternalId);//accObj.Id;
                        
                        if(mapAccExIdAndId.get(custExternalId)!=null){
                            
                            haveAccount  = true;
                            
                            invoiceObj.Amount_Due__c    = (Decimal) invoiceMap.get('TotalAmt'); 
                            invoiceObj.Total__c         = (Decimal) invoiceMap.get('TotalAmt');
                            
                               
                            
                            List<Object> customfields = (List<Object>) invoiceMap.get('CustomField');  
                            

                            // custom fields start here || Sales Rep, Policy, Inception Date
                            for(Object objCustomFields: customFields ){
                                
                                Map<String, Object> mapCustomFields = (Map<String,object>) objCustomFields;
                                String defId = (String) mapCustomFields.get('DefinitionId');
                                String policyNumber = (String) mapCustomFields.get('Name');
                                
                                if((String) mapCustomFields.get('StringValue')!=null){
                                    
                                    String entityName = (String) mapCustomFields.get('Name');
                                    String entityId   = (String) mapCustomFields.get('DefinitionId');
                                    if(entityId == '2'){                                                        // sales rep
                                        salesRep        = (String) mapCustomFields.get('StringValue'); 
                                    }else  if(entityName == 'Crew #' || entityName == 'Policy #'){              // Policy#  
                                        policyName      = (String) mapCustomFields.get('StringValue');
                                    }else  if(entityId == '3'){                                                 // inception date
                                        inceptionDate   =  (String) mapCustomFields.get('StringValue');
                                    }
                                }                                
                            }
                            // custom fields end here || Sales Rep, Policy, Inception Date

                            
                            /*if(policyName!= null){invoiceObj.Policy__c               = policyName;
                            }else{
                                invoiceObj.Policy__c               = 'N/A';
                            }*/
                            invoiceObj.Policy__c               = policyName != null ? policyName : 'N/A';
                            
                            invoiceObj.Sales_Rep__c        = salesRep; 
                            invoiceObj.Due_Date__c         = (String) invoiceMap.get('DueDate') != null ? Date.valueOf((String) invoiceMap.get('DueDate')) : null; 
                            //invoiceObj.InceptionDate__c    = inceptionDate != null ? Date.valueOf(inceptionDate) : null;
                            
                         /*   if(inceptionDate!=null){
                               
                                if(inceptionDate.contains('/')){
                                List<String> arrayDate = inceptionDate.split('/');
                                String inceptDate = arrayDate[2]+'-'+arrayDate[1]+'-'+arrayDate[0];
                                system.debug('arrayDate'+arrayDate);
                                invoiceObj.InceptionDate__c    =  Date.valueOf(inceptDate);
                                }else if(inceptionDate.contains('-')){
                                    invoiceObj.InceptionDate__c    =  Date.valueOf(inceptionDate);
                                }else{
                                    dateErrorInv.add(invId);
                                }
                            }*/
                        
                            //Policy__c policy             = [Select Name ,Id FROM Policy__c WHERE Name = : policyName LIMIT 1]
                            //invoiceObj.Policy__c         = policyName;
                            invoiceObj.Email_Status__c     = (String) invoiceMap.get('EmailStatus');
                            invoiceObj.InvoiceNumber__c    = 'INV -' + (String) invoiceMap.get('DocNumber'); 
                            String dateVal                 = (String) invoiceMap.get('TxnDate');
                            invoiceObj.Invoice_Date__c     = date.valueOf(dateVal);
                            
                            if((String)invoiceMap.get('PrivateNote') != null){
                                invoiceObj.Statement_Memo__c   = (String)invoiceMap.get('PrivateNote');
                            }
                            
                            invoiceObj.Invoice_Date__c    = date.valueOf(dateVal);
                            
                            Map<String, Object> emailMap  = (Map<String, Object>)invoiceMap .get('BillEmail'); 
                            if(emailMap != null){
                                invoiceObj.Email__c       = (String) emailMap.get('Address');
                            }
                            
                            Map<String, Object> salesTerm  = (Map<String, Object>)invoiceMap .get('SalesTermRef');
                            if(salesTerm!=null){
                                
                                invoiceObj.Terms__c        = (String) salesTerm.get('name'); 
                            }   
                            
                            Map<String, Object> customerMemo    = (Map<String, Object>)invoiceMap .get('CustomerMemo');                            
                            if(customerMemo   != null){ 
                                invoiceObj.Message_Displayed__c = (String) customerMemo.get('value');
                            }
                            
                            // billing Address start here
                            Map<String, Object> billAddr = (Map<String, Object>)invoiceMap .get('BillAddr');
                            if(billAddr!=null){ 
                                String Line1     = (String) billAddr.get('Line1');
                                String Line2     = (String) billAddr.get('Line2');
                                String Line3     = (String) billAddr.get('Line3');
                                String Line4     = (String) billAddr.get('Line4');
                                if(Line1 != null){
                                    invoiceObj.Billing_Street_Address__c  =  Line1;
                                }
                                if(Line2 != null){
                                    invoiceObj.Billing_Street_Address__c  += Line2 ;
                                }
                                if(Line3 != null){
                                    invoiceObj.Billing_Street_Address__c  += Line3;
                                }
                                if(Line4 != null){
                                    invoiceObj.Billing_Street_Address__c  += Line4 ;
                                }
                            
                                invoiceObj.Billing_City__c         = (String) billAddr.get('City');
                                invoiceObj.Billing_Country__c      = (String) billAddr.get('Country') != null ? (String) billAddr.get('Country') : 'USA';
                                invoiceObj.Billing_Postal_Code__c  = (String) billAddr.get('PostalCode');
                                invoiceObj.Billing_State__c        = (String) billAddr.get('CountrySubDivisionCode');                    
                                
                            }           
                            // billing Address end here

                            
                            // Line Items Start Here
                            
                            List<Object> lineItems              = (List<Object>) invoiceMap.get('Line');
                            List<QB_Line_Item__c> qbLineList    = new List<QB_Line_Item__c>();
                            
                            for(Object objLineItem : lineItems ){
                                
                                QB_Line_Item__c QbLineItem          = new QB_Line_Item__c();
                                
                                Map<String, Object> mapLineItem     = (Map<String,object>) objLineItem; 
                                Map<String, Object> saleslineItems  = (Map<String, Object>) mapLineItem.get('SalesItemLineDetail');
                                
                                if(saleslineItems!= null){

                                    Map<String, Object> items       = (Map<String, Object>) saleslineItems.get('ItemRef');  
                                    
                                    //String entityId = (String) mapLineItem.get('Id');
                                    String entityName = (String) items.get('name');
                                    if(entityName == 'Gross Premium' || entityName == 'Comission' ||entityName == 'Commissions'){   // check for line items
                                        
                                        QbLineItem.Product_Service__c = (String) items.get('name');
                                        QbLineItem.Amount__c          = (Decimal) mapLineItem.get('Amount');
                                        QbLineItem.Quantity__c        = (Decimal) saleslineItems.get('Qty');                                        
                                        QbLineItem.Rate__c            = (Decimal) saleslineItems.get('UnitPrice');
                                        qbLineList.add(QbLineItem); 
                                    
                                    }else{

                                        otherLineItems                = true;

                                    } 
                                    
                                    // invoiceObj.Total__c           	       = (Decimal) saleslineItems.get('Amount'); 
                                    // invoiceObj.Credit_Memo_Total_Amount__c  = (Decimal) saleslineItems.get('Amount');                                     
                                
                                }   
                                
                            }                    
                            
                            if(!qbLineList.isEmpty() && !otherLineItems){
                                mapInvAndLineItems.put((String) invoiceMap.get('Id'),qbLineList);
                            }
                               
                            // Line Items End Here
                        
                            if(haveAccount && !otherLineItems){
                                invoicesToInsert.add(invoiceObj);                        
                            }
                        }
                    }
                    
                }   
                
                
                
                
                
                
                
                
                //Policy__c policy     =  [Select Name ,Id FROM Policy__c WHERE Name = : policyName LIMIT 1];
                //System.debug('Map of LineItems AA '+mapInvAndLineItems);
                
                if(InsertInvoice == 'true'){
                    System.debug('invoicesToInsert Size'+invoicesToInsert.size());
                    
                    insert invoicesToInsert;                   // Invoice Inserted Here
                    System.debug('after invoicesToInsert :: '+invoicesToInsert);
                    
                }
                
                
                Integer i = 1;
                if(!invoicesToInsert.isEmpty()){
                    for(QB_Invoice__c inv  : invoicesToInsert){
                        
                        nameForLineItem = namePart+i;
                        
                     
                        List<QB_Line_Item__c> QbLineItemListNew = mapInvAndLineItems.get(inv.QB_External_Id__c);
                        if(QbLineItemListNew != null){
                            Integer j = 1;
                            for(QB_Line_Item__c qbLineIte :  QbLineItemListNew ){ 
                                
                                Integer uiqNum                   = Math.round((Math.random() * (90000000) + 10000000));                    
                                qbLineIte.Line_Number__c         = j;
                                if(InsertInvoice == 'true'){
                                    qbLineIte.Invoice__c             = inv.Id;
                                }
                                qbLineIte.Name                   = 'INV-'+nameForLineItem+'-LienItem-'+j;
                                qbLineIte.Line_Item_Id__c        = uiqNum+'-INV-'+nameForLineItem+'-'+j; 
                                QbLineItemList.add(qbLineIte);
                                j++;
                            } 
                        }     
                        i++;                      
                        
                    } 
                    
                    System.debug('QbLineItemList Size '+QbLineItemList.size());
                    if(!QbLineItemList.isEmpty()){                     
                        System.debug('QbLineItemList '+QbLineItemList);
                        if(InsertLineItem == 'true'){
                            insert QbLineItemList;
                        }
                        
                    }                    
                    
                }
        }

    }            
    
    public void finish(Database.BatchableContext BC){
        System.debug('Invoice Batch Successful for '+ label.batchInvoiceQuery);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
        String[] toAddresses=new String[] {'payal.kavitake@bugendaitech.com','anshul@bugendaitech.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Batch Completed For Invoice QuickBook to Salesforce');
        mail.setPlainTextBody('Batch completed successfully For '+label.batchInvoiceQuery);
		
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);



    }
    
}