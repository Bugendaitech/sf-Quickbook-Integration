public with sharing class QB_QuickBooksService {
    
    @future(callout=true)
    public static void createCustomerFromAccount(String accId){
        system.debug('Stage is RFP rewarded Anugrah, Manish Test');
        createCustomerFromAccountSync(accId);
    }
    public static void createCustomerFromAccountSync(String accId){
        System.debug('Create Customer From AccountId');
        String qbId = '';
        Account accObj = [SELECT Id,QB_Customer_Id__c,QB_Sync_Token__c,Name,Insured_Name__c,Mailing_City__c,Email__c,Phone FROM Account WHERE Id =: accId];
        //QB_External_API.createCustomer(accObj); 
             
    }
         
}