@isTest
public class GetInvoiceCtrl_Test {
 @isTest static void myTest(){
     
       Account applicant             = new Account();
        applicant.Number_of_Units__c  = 100;
        applicant.Name                ='Test Account Name For Acc 1';
        applicant.Physical_City__c    = 'City';
        applicant.RecordTypeId        = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        insert applicant;
     
         QB_Invoice__c invoice          = new QB_Invoice__c();
         invoice.Policy__c              = '20222611D';
         invoice.Due_Date__c            = system.today();
         invoice.Invoice_Date__c        = system.today();
         invoice.Amount_Received__c     = 1000;
         invoice.Amount_Credited__c     = 1000;
         invoice.Discount_Amount__c     = 1000;
         invoice.Amount_Due__c          = 1000;
         invoice.Credit_Memo_Total_Amount__c     = 1000;
         invoice.Total__c                = 1000;    
         invoice.Account__c              = applicant.Id;
         insert invoice;
         Test.startTest();
        
        QB_Invoice__c qbInvoice =[SELECT Id,QB_Status_Flag__c,Status__c,Name,Due_Date__c FROM QB_Invoice__c WHERE Account__c =:applicant.Id ORDER BY createddate DESC];
        GetInvoiceCtrl.getInvoiceCount(applicant.Id);
        GetInvoiceCtrl.getInvoiceRecords(applicant.Id);
     	GetInvoiceCtrl.getGetRecordType(applicant.Id);
        Test.stopTest();
 }
}