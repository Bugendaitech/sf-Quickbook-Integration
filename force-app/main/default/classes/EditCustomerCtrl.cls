public with sharing class EditCustomerCtrl {
    public EditCustomerCtrl() {

    }
    @AuraEnabled
    public static QB_Company__c getAllDetailsOfApplicant(string qouteid) {
        try { 

        return[SELECT 
        QB_Salesforce_Account__r.BillingAddress,
        QB_Salesforce_Account__r.Agent_Phone_Application__c,
        QB_Salesforce_Account__r.Agent_Email_Application__c,
        QB_Salesforce_Account__r.Producer_Last_Name__c,
        QB_Salesforce_Account__c,
        QB_Salesforce_Account__r.Name,
        QB_Salesforce_Account__r.Producer_First_Name__c ,
        QB_Given_First_Name__c,
        QB_Family_Last_Name__c,
        QB_Company_Name__c,QB_Email__c,
        QB_Street_Address__c,QB_City__c	,QB_Country__c,
        QB_Postal_Code__c,QB_Region__c	
        FROM QB_Company__c
        WHERE id=: qouteid];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String UpdateCustomer(String companyData){
        try {
                // System.debug('Applicant Id '+accId);
                // System.debug('Customer Data '+customerData);
                
                String result  = 'error';
                String comName = 'Company Name';
                QB_Company__c comObj  = (QB_Company__c)System.JSON.deserializeStrict(companyData, QB_Company__c.Class);
                comName = comObj.QB_Display_Name__c;

               // List<QB_Company__c> comList = [SELECT Id FROM QB_Company__c WHERE QB_Display_Name__c =: comName];
               // if(comList.isEmpty()){
                //     System.debug('comObj Id '+comObj.Id);                    
                //     if(comName!=''){

                //         if(!Test.isRunningTest()){
                //             QB_External_API.createCustomerAndSync(customerData, comName);
                //         }
                //         QB_Company__c comDetails = [Select Id,Name, QB_External_ID__c,QB_Sync_Token__c From QB_Company__c Where Id = :comObj.Id ];
                //                     System.debug('Account Data '+comDetails.Name+' Account Customer ID '+comDetails.QB_External_ID__c);
                //         if (string.isBlank(comDetails.QB_External_ID__c) || comDetails.QB_External_ID__c == null ){
                //             result = 'error';
                //         }else{
                //             result = 'success';  
                //         }
                //     }
                // }else{
                //     result = 'Company with this Name, already Exists. Please Try With Different Display Name';
                // }
                Database.SaveResult srList = Database.update(comObj, false);
                    if (srList.isSuccess()) {
                        result = 'success';  
                    }else{
                        result = 'error';
                    }
                  
                               
                return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}