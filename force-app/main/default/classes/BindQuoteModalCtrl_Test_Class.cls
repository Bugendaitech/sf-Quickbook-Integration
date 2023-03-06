@isTest
public class BindQuoteModalCtrl_Test_Class {
    
    @isTest static void myTest() {
          Account applicant             = new Account() ;
          applicant.Number_of_Units__c  = 1;
          applicant.Name                ='Test';
          applicant.Physical_City__c    = 'City';
          insert applicant;
        
        	  
            Quote__c  quote            = new Quote__c();
            quote.Amount__c            = 100;
            quote.Date_of_Quote__c     = Date.newInstance(2022, 11, 9);
            quote.Quote_Expires_in__c  = '30 days';
            quote.Applicant_Insured__c = applicant.id;
            insert quote;
        
        BindQuoteModalCtrl.checkProducre(quote.id);
    }

}