@isTest(SeeAllData=true)
public class applicantProducerCtrl_Test {
    @isTest static void myTest() {
          
        Account applicant              = new Account() ;
        applicant.Number_of_Units__c   = 1;
        applicant.Name                 ='Test';
        applicant.Physical_City__c     = 'City';
        applicant.Mailing_Address2__c  = 'Street2';
        applicant.Mailing_Address__c   = 'Street';
        applicant.Mailing_City__c      = 'Test';
        applicant.Mailing_State__c     = 'IN';
        applicant.Mailing_Zip_Code__c  = '4232';
        insert applicant;
        
        
        Contact con                   = new Contact();
        con.AccountId                 = applicant.id;
        con.LastName                  = 'Last';
        insert con;
        
        List<Contact>  conList    = [SELECT Name,AccountId FROM Contact WHERE Id =: con.id];
        Test.startTest();
        applicantProducerCtrl.getAccount(conList);
        Test.stopTest();    
    }
    
    @isTest static void myTest2() {
          
        Account applicant              = new Account() ;
        applicant.Number_of_Units__c   = 1;
        applicant.Name                 ='Test';
        applicant.Physical_City__c     = 'City';
      
        insert applicant;
        
        
        Contact con                   = new Contact();
        con.AccountId                 = applicant.id;
        con.LastName                  = 'Last';
        insert con;
        
        List<Contact>  conList    = [SELECT Name,AccountId FROM Contact WHERE Id =: con.id];
        Test.startTest();
        applicantProducerCtrl.getAccount(conList);
        Test.stopTest();    
    }
}