public class createCustomerCtrl {    

    private static String searchCustomerByNameReturningId(String accName){
        system.debug('Called Search Method'); 
        String qbId = '';
        if(!Test.isRunningTest()){
	        //qbId = QB_CustomerAPI.customerReadAll(accessToken, accName); 
            qbId = QB_External_API.customerReadAllNamedCredential(accName); 
            
        }
        return qbId;
    }


    @AuraEnabled
    public static String  getContacts(string accId) {
       //System.debug('accId :: '+accId);
        List<conwrapperClass> conwrapList=new List<conwrapperClass>();
        try { 
         List<Contact> conList=[SELECT  Name,Id
                                FROM Contact
                                WHERE AccountId=: accId
                                ];
            if(!conList.isEmpty()) {               
            for(Contact con:conList)   {
                conwrapperClass conwrap=new conwrapperClass(con.Name,con.Id);
                conwrapList.add(conwrap);  
            }     
        }              
         return JSON.serialize(conwrapList);} catch (Exception e) { throw new AuraHandledException(e.getMessage()); }
    }


    @AuraEnabled
    public static Quote__c getAllDetailsOfApplicant(string qouteid) {
        try { 
        return[SELECT Id,Applicant_Insured__c,Applicant_Insured__r.Name,Applicant_Insured__r.Total_Discount_Value__c, Applicant_Insured__r.QB_External_Id__c,Applicant_Insured__r.BillingAddress,Applicant_Insured__r.Commission__c, Applicant_Insured__r.Indicated_Premium__c,Applicant_Insured__r.Discount_Amount__c,Applicant_Insured__r.Producer_First_Name__c,Applicant_Insured__r.Producer_Last_Name__c,Applicant_Insured__r.Agent_Email_Application__c,Applicant_Insured__r.Agent_Phone_Application__c,
        Applicant_Insured__r.Agent_to_Bill__c,Applicant_Insured__r.Agent_to_Bill__r.id from Quote__c WHERE id=: qouteid]; } catch (Exception e) {      throw new AuraHandledException(e.getMessage()); }
    }

    
    @AuraEnabled
    public static String creatingCustomer(String customerData, String accId, String accName){
            
        try {
               
                
                String result  = null;
                String qbId    = null;
                 
                            
                    if(accId!=''){   
                        
                        if(accName!='' && accName!=null){

                            qbId = searchCustomerByNameReturningId(accName);                            
                            System.debug('Response '+qbId);
                            
                            if(qbId == '' || qbId == null){
                                System.debug('No customer find'); 
                                if(Test.isRunningTest()){
                                    qbId = '123';
                                }else{
                                    QB_External_API.createCustomerAndSync(customerData, accId); 
                                    result = accId;                 
                                }
                            }else{
                                System.debug('Customer find '+qbId);
                                result = 'Customer with this Name, already Exists. Please Try With Different Company Name'; 
                            }
                        }
	                }
                    return result;   
                } catch (Exception e) {   throw new AuraHandledException(e.getMessage());    }
    }

 

    public class conwrapperClass{
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String id;
        public conwrapperClass(String Name,String id){
       this.Name=Name;
       this.id=id;
        }
    }
    @AuraEnabled
    public static Quote__c getProducerDetails(string qouteid) {
        try {
            return[select Id,Applicant_Insured__c,Amount__c	,Applicant_Insured__r.Agent_to_Bill__r.Name,Applicant_Insured__r.Name,Applicant_Insured__r.Contact_Person_First_Name__c,
            Applicant_Insured__r.Contact_Person_Last_Name__c,Producer__r.Account.QB_External_Id__c,
             Applicant_Insured__r.BillingAddress,Producer_City__c,Producer_Country__c,Producer_State_Province__c,	
             Desired_Attachment_Date__c ,Applicant_Insured__r.Physical_Street_Address__c,Producer_Street__c	,
             Applicant_Insured__r.Physical_City__c ,Applicant_Insured__r.Physical_State__c,Producer_Zip_Postal_Code__c,Producer__r.LastName	,
             Applicant_Insured__r.Physical_Zip_Code__c,Applicant_Insured__r.Physical_Address_2__c,Producer__r.Name,Producer__r.FirstName,Producer__r.Agency_Name__c,
             Applicant_Insured__r.Agency__c	 ,Applicant_Insured__r.Email__c	  ,Applicant_Insured__r.Agency_Phone__c	,Producer__r.Email,Producer__r.MobilePhone	
             from Quote__c where id=: qouteid];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Quote__c getAllDetails(string qouteid) {
        try {
            return[SELECT 
            Id,
            Applicant_Insured__c,
            Amount__c,
            Applicant_Insured__r.QB_Parent_Id__c,
            Applicant_Insured__r.QB_External_Id__c,
            Applicant_Insured__r.Name,
            Applicant_Insured__r.Contact_Person_First_Name__c,
            Applicant_Insured__r.Contact_Person_Last_Name__c,
            Applicant_Insured__r.BillingAddress,
            Applicant_Insured__r.Physical_Street_Address__c,
            Applicant_Insured__r.Agency__c,
            Applicant_Insured__r.Email__c,
            Applicant_Insured__r.Agency_Phone__c,
            Applicant_Insured__r.Physical_City__c,
            Applicant_Insured__r.Physical_State__c,
            Applicant_Insured__r.Physical_Zip_Code__c,
            Applicant_Insured__r.Physical_Address_2__c,
            Applicant_Insured__r.Total_Discount_Value__c,
            Applicant_Insured__r.Commission__c,
            Applicant_Insured__r.Indicated_Premium__c,
            Applicant_Insured__r.Discount_Amount__c,
            Applicant_Insured__r.Agent_Email_Application__c,
            Applicant_Insured__r.Agent_Phone_Application__c,
            Producer__r.Id,
            Producer_City__c,
            Producer_Country__c,
            Producer__r.Name,
            Producer__r.FirstName,
            Producer__r.LastName,
            Producer_State_Province__c,
            Desired_Attachment_Date__c,
            Producer_Street__c,
            Producer_Zip_Postal_Code__c,
            Producer__r.Agency_Name__c,
            Producer__r.Email,
            Producer__r.MobilePhone 
            from Quote__c 
            WHERE id=: qouteid];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}