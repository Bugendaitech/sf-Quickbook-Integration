public class createInvoiceCtrl {    
    
    
    @AuraEnabled
    public static Quote__c getBillingAddress(string qouteid) {	
        
        Quote__c quoteObj         = new Quote__c();
        try {            
            quoteObj = [select Id,Applicant_Insured__c,Amount__c	,Applicant_Insured__r.Agent_to_Bill__r.Name,Applicant_Insured__r.Name,Applicant_Insured__r.Contact_Person_First_Name__c,Applicant_Insured__r.Contact_Person_Last_Name__c,Applicant_Insured__r.Total_Discount_Value__c, Applicant_Insured__r.BillingAddress,Applicant_Insured__r.Commission__c, Applicant_Insured__r.Indicated_Premium__c,Applicant_Insured__r.Discount_Amount__c,Desired_Attachment_Date__c from Quote__c where id=: qouteid with SECURITY_ENFORCED];
        } catch (Exception e) {
            quoteObj = null;
            //throw new AuraHandledException(e.getMessage());
        }
        return quoteObj;
    }
    
    @AuraEnabled
    public static String creatingInvoiceRecord(String invoiceData, String lineItemData) {
        
        //////System.debug('Called @@'); 
        String invoiceId = '';
        String accId     = '';
        String accQBId     = '';
        String syncToken = '';
        String parentId  = '';
        //System.debug('LineItem Data ==> '+lineItemData);
        QB_Invoice__c invoiceObj = (QB_Invoice__c)System.JSON.deserializeStrict(invoiceData, QB_Invoice__c.Class);
       
        List<QB_Line_Item__c> lineItemLisTToBeInserted = (List<QB_Line_Item__c>)System.JSON.deserializeStrict(lineItemData, List<QB_Line_Item__c>.Class);
        
        ////System.debug('Data 1 '+invoiceObj);
         //System.debug('Data 2 '+lineItemLisTToBeInserted);         
        
        QB_Invoice__c selQbForName = [SELECT Id,Name from Qb_Invoice__c Order By Name Desc LIMIT 1];
        //////System.debug('name '+selQbForName.Name.substring(4));
        String namePart = selQbForName.Name.substring(4);
        Integer nameForLineItem = Integer.ValueOf(namePart)+1;
        ////System.debug('Name '+nameForLineItem);
        insert invoiceObj;
        invoiceId = invoiceObj.Id;
        
        Integer i = 1;
        for(QB_Line_Item__c qbLineIte : lineItemLisTToBeInserted){ 
            
            Integer uiqNum = Math.round((Math.random() * (90000000) + 10000000));
            
            qbLineIte.Line_Number__c         = i;
            qbLineIte.Invoice__c             = invoiceObj.Id;
            qbLineIte.Name                   = 'INV-'+nameForLineItem+'-LienItem-'+i;
            qbLineIte.Line_Item_Id__c        = uiqNum+'-INV-'+nameForLineItem+'-'+i; 
            i++;
        } 
        
        if(!lineItemLisTToBeInserted.isEmpty()){
            //////System.debug('data');
            insert lineItemLisTToBeInserted;
            ////System.debug('Data of Invoice '+invoiceObj);
            //////System.debug('Data of Line Item '+lineItemLisTToBeInserted); 
            
            //QB_Company__c curCompany = [SELECT Id FROM QB_Company__c WHERE id =: ]
            
            
            QB_Invoice__c crInvoiceData = [SELECT Id,Billing_Street_Address__c,Billing_City__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Name,Terms__c,Account__c,Account__r.Name,Account__r.Agent_to_Bill__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,InceptionDate__c,Amount_Received__c,Amount_Credited__c,Policy__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Statement_Memo__c,Days_Overdue__c,Total__c,Message_Displayed__c,Sales_Rep__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE id =: invoiceId];
            
            System.debug('Invoice Full Data '+crInvoiceData);
            ////System.debug('Invoice Id '+crInvoiceData.Id);
            if(invoiceId!=''){

                Account curCompany = [SELECT QB_Sync_Token__c,QB_External_Id__c,Name,QB_Parent_Id__c FROM Account WHERE id =:invoiceObj.Account__c with SECURITY_ENFORCED];
                accId      = invoiceObj.Account__c;
                accQBId    = String.valueOf(curCompany.QB_External_Id__c);
                syncToken  = curCompany.QB_Sync_Token__c;
                parentId   = String.valueOf(curCompany.QB_Parent_Id__c);



                //////System.debug('Company Data '+curCompany);
                //////System.debug('Company External Id '+curCompany.QB_External_Id__c);
                //////System.debug('Company Display Name '+curCompany.QB_Display_Name__c);

                String JsonBodyForCustomer =    '{'+
                                    '  "Job": true, '+
                                    '  "ParentRef": {'+
                                    '    "value": '+'"'+parentId+'"\n'+
                                    '  },'+
                                    '  "SyncToken": '+'"'+syncToken+'",\n'+
                                    '  "Id": '+'"'+accQBId+'",\n'+
                                    '  "sparse": true'+
                                    '} ';

                
                Integer count;
                Integer iteration;
                String JsonBody='';
                string Temp1='';
                string Temp2='';
                string Temp3='';
                String endpoint='';                
                
                Temp1 = '{\n'+         
                    '  "Line": '+'[\n';
                       
                    Temp2='';
                    count = crInvoiceData.QB_Line_Items__r.size();
                    iteration = 0;

                    String siteUrl     = BoldLegalUtils.siteHomeUrl; 
                    String commisionId = null;
                    String grossId     = null;
                    String salesTermId = null;
                  //  String paymentMethodId   = null;


                    if(siteUrl.contains('sandbox')){
                        commisionId      = BoldLegalUtils.qbComissionRecIdSand;
                        grossId          = BoldLegalUtils.qbGrossRecIdSand;
                     salesTermId         = BoldLegalUtils.qbSalesTermSand;                  
                    }else{
                        commisionId      = BoldLegalUtils.qbComissionRecIdProd;
                        grossId          = BoldLegalUtils.qbGrossRecIdProd;
                        salesTermId      = BoldLegalUtils.qbSalesTermProd;
                    }

                    for(QB_Line_Item__c orderItemIterate : crInvoiceData.QB_Line_Items__r ){
                        iteration++;
                        decimal tempDecimal = 0;
                        String serviceName = null;
                        String serviceId   = null;

                        
                        if(orderItemIterate.Product_Service__c=='Commissions'){
                            tempDecimal = orderItemIterate.Quantity__c * orderItemIterate.Rate__c;
                            serviceName = 'Comission';
                            serviceId   = commisionId;
                        }else{
                            tempDecimal = orderItemIterate.Quantity__c * orderItemIterate.Rate__c;
                            serviceName = 'Gross Premium';
                            serviceId   = grossId;
                        }
                        Temp2 =  '    {\n'+
                            '      "DetailType": ' + '"'+'SalesItemLineDetail'+'", \n'+
                            '      "Amount": '+'"'+tempDecimal+'", \n';
                                    if(orderItemIterate.Description__c != null){
                                        Temp2+='      "Description" :'+'"'+orderItemIterate.Description__c+'", \n';
                                    }                            
                            Temp2+='      "SalesItemLineDetail": {\n'+
                            '        "ItemRef": {\n'+
                            //'          "name": '+'"'+serviceName+'", \n'+
                            '          "value": '+'"'+serviceId+'"\n'+
                            '        },\n'+
                            '        "Qty": '+'"'+orderItemIterate.Quantity__c+'",\n'+
                            '        "UnitPrice": '+'"'+orderItemIterate.Rate__c+'"\n'+
                            '      }\n'+
                            '    }\n';
                        
                        if(count == 1){   Temp2=Temp2;   }else{ if(count == iteration){  Temp2=Temp2;  }else{  Temp2=Temp2+',';  }  }

                        //////System.debug('Temp2##################'+Temp2);
                        Temp1+=Temp2 ;
                    }
                    
                    Temp3 = '  ], \n'+
                        '  "Deposit": '+'"'+crInvoiceData.Amount_Credited__c+'", \n'+   
                        '  "Balance": '+'"'+crInvoiceData.Total__c+'", \n'+
                        '  "SalesTermRef": { '+
                        '    "value": '+'"'+salesTermId+'" \n'+
                        '        },\n';                 

                        if(crInvoiceData.Statement_Memo__c!=null){
                            Temp3+='  "PrivateNote": '+'"'+crInvoiceData.Statement_Memo__c+'", \n';
                        }

                        //crInvoiceData.Message_Displayed__c!='' || crInvoiceData.Message_Displayed__c!=null
                      //  if(crInvoiceData.Message_Displayed__c!=null){
                         if(false){
                             
                            String messageText = crInvoiceData.Message_Displayed__c.replaceAll('\r\n|\n|\r',' ');
                            Temp3+='  "CustomerMemo": { '+
                                   '    "value": '+'"'+messageText+'"\n'+
                                   '        },\n';
                        }

                        if(crInvoiceData.Email__c!=null){
                            Temp3+='  "BillEmail": { '+
                                   '    "Address": '+'"'+crInvoiceData.Email__c+'"\n'+
                                   '        },\n';
                        }

                        Temp3+='  "TxnDate" : '+'"'+crInvoiceData.Invoice_Date__c+'", \n'+ 
                        '  "DueDate" : '+'"'+crInvoiceData.Due_Date__c+'", \n'+ 
                        '  "CustomerRef": {\n'+
                        '    "name": '+'"'+curCompany.Name+'", \n'+      
                        '    "value": '+'"'+curCompany.QB_External_Id__c+'"\n'+
                        '  },\n';
                       
                    
                        crInvoiceData.Sales_Rep__c = crInvoiceData.Sales_Rep__c != null ? crInvoiceData.Sales_Rep__c : '';
                        Temp3+= ' "CustomField": [ '+
                          '  {'+
                          '   "DefinitionId": "1",'+
                          '     "Name": "Policy#",'+
                          '    "Type": "StringType",'+
                          '    "StringValue": '+'"'+crInvoiceData.Policy__c+'" \n'+ 
                          '   },\n';
                          
                          if(crInvoiceData.Sales_Rep__c != null || crInvoiceData.Sales_Rep__c != '' )
                          {
                        Temp3+=  '   {'+
                          '    "DefinitionId": "2",'+
                          '    "Name": "Sales Rep",'+ 
                          '    "Type": "StringType",'+
                          '    "StringValue": '+'"'+ crInvoiceData.Sales_Rep__c +'" \n'+ 
                          '   },\n';
                          }
                          Temp3+=  '   {'+
                          '   "DefinitionId": "3",'+
                          '   "Name": "Inception Date",'+
                          '   "Type": "StringType",'+
                          '   "StringValue": '+'"'+ crInvoiceData.InceptionDate__c+'" \n'+ 
                          '  }'+
                          ' ]\n';

                      
                      Temp3+=      '}' ;
                 
                    
                    JsonBody +=Temp1+Temp3;
                    //System.debug('JsonBodyOfCustomer '+JsonBodyForCustomer);
                    //System.debug('JsonBody '+JsonBody);
 
                    
                    //QB_External_API.normalMethod(JsonBodyForCustomer, accId, JsonBody, invoiceId);
                     if(!Test.isRunningTest()){
                	 
                    	QB_External_API.updateCustomer(JsonBodyForCustomer, accId);
                    	QB_External_API.createInvoiceAndSync(JsonBody,invoiceId);         
                    }
                
            }
        }
        return invoiceId;
    }
    
    @AuraEnabled
    public static Quote__c getProducerDetails(string qouteid) {
        
        Quote__c quoteObj =new Quote__c();
        try {
            quoteObj = [select Id,Applicant_Insured__c,Amount__c	,Applicant_Insured__r.Agent_to_Bill__r.Name,Applicant_Insured__r.Name,Applicant_Insured__r.Contact_Person_First_Name__c,
            Applicant_Insured__r.Contact_Person_Last_Name__c,
             Applicant_Insured__r.BillingAddress,Producer_City__c,Producer_Country__c,Producer_State_Province__c,	
             Desired_Attachment_Date__c ,Applicant_Insured__r.Physical_Street_Address__c,Producer_Street__c	,
             Applicant_Insured__r.Physical_City__c ,Applicant_Insured__r.Physical_State__c,Producer_Zip_Postal_Code__c,	Producer__r.id,
             Applicant_Insured__r.Physical_Zip_Code__c,Applicant_Insured__r.Physical_Address_2__c,Producer__r.Name,Producer__r.Agency_Name__c,
             Applicant_Insured__r.Agency__c	 ,Applicant_Insured__r.Email__c	  ,Applicant_Insured__r.Agency_Phone__c	,Producer__r.Email,Producer__r.MobilePhone	
             from Quote__c where id=: qouteid with SECURITY_ENFORCED];

        } catch (Exception e) {
            quoteObj = null;
            //throw new AuraHandledException(e.getMessage());
        }
        return quoteObj;
    }
    @AuraEnabled
    public static Account getcondominiumdetails(String applicantId){
      
        Account accObj  = new Account();
        try{
           
          accObj =  [SELECT 
          Name,Physical_Street_Address__c,Physical_City__c,
          Physical_State__c,Physical_Zip_Code__c,Physical_Address_2__c,
          Agent_to_Bill__r.Name,Agent_to_Bill__r.Agency_Name__c,
          Agent_to_Bill__r.Email,Agent_to_Bill__r.MobilePhone	
          FROM Account where id=:applicantId with SECURITY_ENFORCED];
            return accObj;
    } catch (Exception e) {
		accObj = null;        
    }
        return accObj;
  }
  
}