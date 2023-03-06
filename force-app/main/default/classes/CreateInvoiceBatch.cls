global class CreateInvoiceBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts , Database.Stateful {
    
    public  Database.QueryLocator  start(Database.BatchableContext BC) {
        
        //System.debug('QueryLocator');
        String Query = 'SELECT Id,QB_Company__c,Billing_Street_Address__c,Billing_City__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Policy__c,Name,Terms__c,Account__c,Account__r.QB_External_Id__c,Account__r.Name,Account__r.Agent_to_Bill__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Statement_Memo__c,Days_Overdue__c,Total__c,Message_Displayed__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c Where Account__r.QB_External_Id__c!= NULL  Limit 1 ';
        //if(System.Test.isRunningTest()) Query ='SELECT Account.Name,Sync_Token__c,Account.QBO_External_UID__c,Description,Name,ItemRef_Value__c,ItemtRef_Name__c, Balance_Due__c, OwnerId, TotalAmount, Deposit__c, OrderNumber,(SELECT Product2Id,Product2.Name,Product2.QB_External_Id__c,UnitPrice,Quantity FROM OrderItems ) FROM Order LIMIT 1'; 
        
        return Database.getQueryLocator(Query);
        
    }    
    
    public void execute(Database.BatchableContext BC, List<QB_Invoice__c> scope) { 
        Integer count;
        Integer iteration;
        String JsonBody='';
        string Temp1='';
        string Temp2='';
        string Temp3='';
        String endpoint;
        List<QB_Invoice__c> OrderToUpdate = new List<QB_Invoice__c>();
        for(QB_Invoice__c orderObj1 : scope)
        {        
            Temp1 = '{\n'+         
                '  "Line": '+'[\n';
        }
        for(QB_Invoice__c orderObj : scope)
        {
            Temp2='';
            count = orderObj.QB_Line_Items__r.size();
            iteration = 0;
            if(!orderObj.QB_Line_Items__r.isEmpty()){
                for(QB_Line_Item__c orderItemIterate : orderObj.QB_Line_Items__r ){
                    iteration++;
                    decimal tempDecimal;
                    String serviceName = null;
                    String serviceId   = null;
                    if(orderItemIterate.Product_Service__c=='Commissions'){
                        orderItemIterate.Amount__c = -orderItemIterate.Amount__c;
                        tempDecimal = orderItemIterate.Quantity__c * orderItemIterate.Amount__c;
                        serviceName = 'Comission';
                        serviceId   = '20';
                    }else{
                        tempDecimal = orderItemIterate.Quantity__c * orderItemIterate.Amount__c;
                        serviceName = 'Gross Premium';
                        serviceId   = '23';
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
                        '        "UnitPrice": '+'"'+orderItemIterate.Amount__c+'"\n'+
                        '      }\n'+
                        '    }\n';
                    //System.debug('Temp2##################'+Temp2);
                    if(count == 1){   Temp2=Temp2;   }else{ if(count == iteration){  Temp2=Temp2;  }else{  Temp2=Temp2+',';  }  }
                    //System.debug('Temp2##################'+Temp2);
                    Temp1+=Temp2 ;  
                }
                
                Temp3 = '  ], \n'+
                    '  "Deposit": '+'"'+orderObj.Amount_Credited__c+'", \n'+   
                    '  "Balance": '+'"'+orderObj.Total__c+'", \n'+ 
                    '  "SalesTermRef": { '+
                    '    "value": "1" '+
                    '        },\n';        
                if(orderObj.Statement_Memo__c!=null){
                            Temp3+='  "PrivateNote": '+'"'+orderObj.Statement_Memo__c+'", \n';
                        }
                //crInvoiceData.Message_Displayed__c!='' || crInvoiceData.Message_Displayed__c!=null
                        if(true){
                            orderObj.Message_Displayed__c = 'Customer Message Here';
                            Temp3+='  "CustomerMemo": { '+
                                   '    "value": '+'"'+orderObj.Message_Displayed__c+'"\n'+
                                   '        },\n';
                        }

                        if(orderObj.Email__c!=null){
                            Temp3+='  "BillEmail": { '+
                                   '    "Address": '+'"'+orderObj.Email__c+'"\n'+
                                   '        },\n';
                        }

                        Temp3+='  "TxnDate" : '+'"'+orderObj.Invoice_Date__c+'", \n'+ 
                        '  "DueDate" : '+'"'+orderObj.Due_Date__c+'", \n'+ 
                        '  "CustomerRef": {\n'+
                        '    "name": '+'"'+orderObj.Account__r.Name+'", \n'+      
                        '    "value": '+'"'+orderObj.Account__r.QB_External_Id__c+'"\n'+
                        '  }\n'+
                        '}' ;
                 JsonBody +=Temp1+Temp3;
              //System.debug('JsonBody'+JsonBody);
                
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
           		endpoint = 'callout:QuickbooksCredentialsSandbox'+'/v3/company/4620816365236175040/invoice?minorversion=65';
                // endpoint = 'callout:QuickBookCredendial'+'/company/4620816365230257050/invoice?minorversion=65';   
                //req.setHeader('Authorization', header);
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('accept', 'application/json');
                req.setBody(JsonBody);
                res = http.send(req); 
              //System.debug('Status Code @@ '+res.getStatusCode());
                
                if(res.getStatusCode() == 200)
            {
                
                Map<String,Object> QueryResponseMap =(Map<String,Object>) JSON.deserializeUntyped(res.getBody());   
                Map<String,Object> Invoice =(Map<String,Object>) QueryResponseMap.get('Invoice');  
              //System.debug('Invoice Data @@ '+Invoice); 
              //System.debug('Inv Id Ret '+(String)Invoice.get('Id'));
                orderObj.QB_External_Id__c = (String)Invoice.get('Id');
                orderObj.Sync_Token__c  = '0';
                if(orderObj.QB_External_ID__c!=''){
                    update orderObj; 
                }
                
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Invoice created Successfully');
            }
            else{ 
                QB_Integration_Log_Utils.insertIntegrationLog(req, res, 'customerReadAll', 'Error in Customer creation');
            }  
                
            }
            
        }
        //if(!System.Test.isRunningTest()) update OrderToUpdate;
        
    }
    
    
    
    public void finish(Database.BatchableContext BC){
        
      //System.debug('Finish called');
    }
}