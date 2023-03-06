@isTest(SeeAllData=true)
public class createCustomerCtrl_Test {
    @isTest static void myTest() {
        
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 1;
        applicant.Name                ='Test';
        applicant.Physical_City__c    = 'City';
        insert applicant;
        
        
        Contact con                   = new Contact();
        con.AccountId                 = applicant.id;
        con.LastName                  = 'Last';
        con.FirstName                 = 'First';
        insert con;
        
        
        Quote__c  quote               = new Quote__c();
        quote.Amount__c               = 100;
        quote.Date_of_Quote__c        = Date.newInstance(2022, 11, 9);
        quote.Quote_Expires_in__c     = '30 days';
        quote.Applicant_Insured__c    = applicant.id;
        insert quote;
        
        

        createCustomerCtrl.getContacts(applicant.id);
        createCustomerCtrl.getAllDetailsOfApplicant(quote.id);
        createCustomerCtrl.getProducerDetails(quote.id); 
        createCustomerCtrl.getAllDetails(quote.id);
   }

    @isTest static void myTest2() {
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 1;
        applicant.Name                ='Test';
        applicant.Physical_City__c    = 'City';
        insert applicant;
        
        Account applicant2             = new Account() ;
        applicant2.Number_of_Units__c  = 1;
        applicant2.Name                ='Test';
        applicant2.Physical_City__c    = 'City';
        string account = String.valueOf(applicant2);
        createCustomerCtrl.creatingCustomer(account,applicant.id,applicant.Name );
        //QB_External_API.createCustomerAndSync(account,applicant.id);
      
        createCustomerCtrl.getContacts('');
    }
    
}