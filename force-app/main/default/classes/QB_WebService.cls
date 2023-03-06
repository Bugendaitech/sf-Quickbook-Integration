@RestResource(urlMapping='/qbwebservice/*')
global without sharing class QB_WebService {
    @HttpPost
    global static void CreateRocord() {
        try{
             string ObjectName ='';
             string Objectid ='';
             string operation ='';
             string JSONBody='';
            System.debug('called web'); 
            RestRequest request = RestContext.request;         
            Blob body = request.requestBody;
            System.debug('Headers '+request.headers);
            String bodyString = body.toString();
            system.debug('====='+bodyString);
            
            String SIGNATURE = 'intuit-signature';
            String ALGORITHM = 'HmacSHA256';
            
            //return request.headers;
            String verifier_token = label.QB_WH_verifier_token;
            String hashedVal = request.headers.get(SIGNATURE);
            
            Blob bB = request.requestBody;
            Blob hmac = Crypto.generateMac(ALGORITHM, bB, Blob.valueOf(verifier_token));
            String hmacstring = EncodingUtil.convertToHex(hmac);
            if(hashedVal == hmacstring){
                system.debug('MATCHED!!! '+request.requestBody.toString());
                JSONBody=request.requestBody.toString();
            }
            if(bodyString != null){
            Map<String , object> JSONotifications = new Map<string , object>();
            JSONotifications = (Map<String , object>)JSON.deserializeUntyped(bodyString);
            System.debug('JSON Notification Parsed:'+JSONotifications);
            List<object> EventNotify = new List<Object>();
            EventNotify = (List<object>)JSONotifications.get('eventNotifications');
            System.debug('Event Notification:'+EventNotify);
            
            for (object Notification : EventNotify)
            {
                Map<string, object> NotificationMap = (Map<string,object>)Notification;
                system.debug('NotificationMap:'+NotificationMap);
                Map<string,object> DataChangeEvent = new Map<string,object>();
                DatachangeEvent = (Map<string,object>)NotificationMap.get('dataChangeEvent');
                List<object> Entities = new list<object>();
                Entities = (List<object>)DataChangeEvent.get('entities');
                for(object Entity : Entities)
                {
                    System.debug('Entitiy Local variable value:'+Entity);
                    Map<string,object> EntityMap = (Map<string,object>)Entity;
                    ObjectName = (string)EntityMap.get('name');
                  
                    Objectid = (string)EntityMap.get('id');
                    operation = (String)EntityMap.get('operation');
                      System.debug('Object Name:'+ObjectName);
                    System.debug('Object Id:'+Objectid);
                                                
                    //if(!Test.isRunningTest()){
                        if(objectName == 'customer' && operation == 'Create'){WebhookHelper.CreateAgency(Objectid);}
                    else if(objectName == 'Payment' && operation == 'Create'){WebhookHelper.CreatePayment(Objectid);}
                  //  }
                    
                    

                }
                
            }
        }
            
    
        }
        catch(Exception e ){
            system.debug('errr '+e.getMessage());
        }   
    }
}