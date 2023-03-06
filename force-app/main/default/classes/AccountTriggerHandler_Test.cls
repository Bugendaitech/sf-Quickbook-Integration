@isTest
public class AccountTriggerHandler_Test {
    @isTest static void accountTriggerTest() {
        Test.startTest();
         Id Insured = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();

        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 10;
        applicant.Name                ='Test';
        applicant.Physical_City__c    = 'City';
        applicant.Email__c            = 'test@gmail.com';
        applicant.Phone               = '451142';
        applicant.BillingState        = 'State';
        applicant.BillingCity         = 'City';
        applicant.BillingPostalCode   = '32432';
        applicant.BillingStreet       = 'Street';
        applicant.BillingCountry      = 'Country';
        applicant.RecordTypeId        = Insured;
        applicant.QB_External_Id__c   = 1839;
        insert applicant;
        
        Map<Id,Account> mapOldAccount    = new  Map<Id,Account>([SELECT Number_of_Units__c,Email__c,QB_Sync_Token__c,RecordTypeId,QB_External_Id__c,Name,Phone,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingStreet,Id,Physical_City__c FROM Account WHERE Id =: applicant.id]);   
       
        Account acc =[SELECT Number_of_Units__c,QB_External_Id__c,QB_Sync_Token__c,Name,Phone,RecordTypeId,Email__c,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingStreet,Id,Physical_City__c FROM Account WHERE Id =: applicant.id];
        acc.BillingCountry  = 'Country2';
        acc.Name            = 'Testing';
        acc.BillingState    = 'State2';
        acc.BillingCity     = 'City2'; 
        acc.Email__c        = 'testnew@email.com';
        acc.BillingPostalCode = 'Country2';
        acc.Physical_City__c  = 'City2';
        acc.Phone             = '554124';
        acc.BillingPostalCode = '41415';
        acc.BillingStreet     = 'Street2';
        acc.RecordTypeId        = Insured;
        acc.QB_External_Id__c   = 1839;      
        update acc;        
     
        Map<Id,Account> mapNewAccount    = new  Map<Id,Account>([SELECT Number_of_Units__c,QB_Sync_Token__c,Email__c,RecordTypeId,QB_External_Id__c,Name,Phone,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingStreet,Id,Physical_City__c FROM Account WHERE Id =: acc.id]);    
        Test.stopTest();
        AccountTriggerHandler.UpdateAccountRecords(mapOldAccount,mapNewAccount);
       
        
    }
}