@isTest
public class InvoiceListCtrl_Test {
    
    @isTest static void myTest1() { 
        Account agency             = new Account();
        agency.Number_of_Units__c  = 1;
        agency.Name                = 'Agency Account Name For Acc 1';
        agency.Physical_City__c    = 'City';
        agency.RecordTypeId        = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agencies').getRecordTypeId();
        insert agency;
        
        Contact producre   = new Contact();
        producre.LastName  = 'Test Producre';
        producre.FirstName = 'Test Producre';
        producre.AccountId = agency.Id;
        insert producre;
        
        Account applicant             = new Account();
        applicant.Number_of_Units__c  = 100;
        applicant.Name                ='Test Account Name For Acc 1';
        applicant.Physical_City__c    = 'City';
        applicant.Agent_to_Bill__c    = producre.Id;
        applicant.RecordTypeId        = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        insert applicant;
        
        QB_Invoice__c invoice           = new QB_Invoice__c();
        invoice.Policy__c              = '20222611C';
        invoice.Due_Date__c            = Date.newInstance(2022, 12, 9);
        invoice.Invoice_Date__c        = Date.newInstance(2022, 11, 9); 
        invoice.Amount_Received__c     = 1000.00;
        invoice.Amount_Credited__c     = 1000.00;
        invoice.Discount_Amount__c     = 1000.00;
        invoice.Amount_Due__c          = 1000.00;
        invoice.Total__c               = 1000.00; 
        invoice.Account__c 				= applicant.Id;
        invoice.Credit_Memo_Total_Amount__c     = 1000.00;
        
        insert invoice; 
        test.startTest();
        InvoiceListCtrl.getDataByFilter(invoice.Name);
        test.stopTest();
        
        //  InvoiceListCtrl.fetchInvoices();
    }
    
    
    @isTest static void myTest2() {
        Account acc              = new Account() ;
        acc.Number_of_Units__c   = 1;
        acc.Name                 ='Test';
        acc.Physical_City__c     = 'City';
        acc.Mailing_Address2__c  = 'Street2';
        acc.Mailing_Address__c   = 'Street';
        acc.Mailing_City__c      = 'Test';
        acc.Mailing_State__c     = 'IN';
        acc.Mailing_Zip_Code__c  = '4232';
        acc.QB_Parent_Id__c	     = 4532;
        acc.QB_External_Id__c	 = 55360;
        insert acc;
        
        
        Contact con                   = new Contact();
        con.AccountId                 = acc.id;
        con.LastName                  = 'Last';
        insert con;
        
        
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 100;
        applicant.Name                ='Test Account Name For Acc 1';
        applicant.Physical_City__c    = 'City';
        applicant.RecordTypeId        = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        applicant.Agent_to_Bill__c    = con.Id;
        applicant.QB_External_Id__c	  = 553562;
        insert applicant;
        
        Quote__c  quote            = new Quote__c();
        quote.Amount__c            = 100;
        quote.Date_of_Quote__c     = Date.newInstance(2022, 11, 9);
        quote.Quote_Expires_in__c  = '30 days';
        quote.Applicant_Insured__c = applicant.id;
        quote.Producer__c	     = con.Id;
        insert quote;
        
        QB_Invoice__c invoice          = new QB_Invoice__c();
        invoice.Policy__c              = '20222611D';
        invoice.Due_Date__c            = Date.newInstance(2023, 02, 16);
        invoice.Invoice_Date__c        = Date.newInstance(2023, 02, 03);
        invoice.Amount_Received__c     = 00.00;
        invoice.Amount_Credited__c     = 00.00;
        invoice.Discount_Amount__c     = 00.00;
        invoice.Amount_Due__c          = 399.00;
        invoice.Credit_Memo_Total_Amount__c     = 00.00;
        invoice.Total__c                        = 399.00; 
        invoice.Account__c 				= applicant.Id;
        invoice.InceptionDate__c           = system.today();
        invoice.InvoiceNumber__c           = 'INV-1147';
        invoice.Terms__c                  = 'Due on receipt';
        insert invoice; 
        QB_Invoice__c inv          = new QB_Invoice__c();
        inv.Policy__c              = '20222611D';
        inv.Due_Date__c            = Date.newInstance(2023, 02, 16);
        inv.Invoice_Date__c        = Date.newInstance(2023, 02, 03);
        inv.Amount_Received__c     = 00.00;
        inv.Amount_Credited__c     = 00.00;
        inv.Discount_Amount__c     = 00.00;
        inv.Amount_Due__c          = 399.00;
        inv.Credit_Memo_Total_Amount__c     = 00.00;
        inv.Total__c                        = 399.00; 
        inv.Account__c 				= applicant.Id;
        inv.InceptionDate__c           = system.today();
        inv.InvoiceNumber__c           = 'INV-1147';
        inv.Terms__c                  = 'Due on receipt';
        insert inv; 
        
       // List<QB_Invoice__c> qbinvoiceList = [SELECT Id,Agency__c,InvoiceNumber__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!= null AND Account__c!=null AND Id=:inv.Id AND Status__c = 'Open' ORDER BY Name DESC];
        
        Test.startTest();
      
        String result = InvoiceListCtrl.getInvoicesList(1,null,26,'DESC',true,'Name','closed');
        Test.stopTest();
    }
    @isTest static void myTest3() {
        
        Test.startTest();
        InvoiceListCtrl.getInvoicesList(1,null,1,null,false,null,'open');
        Test.stopTest();
    }
    @isTest static void myTest4() { 
        
        test.startTest();
        InvoiceListCtrl.getDataByFilter('');
        Test.stopTest();
    }
    
    
}