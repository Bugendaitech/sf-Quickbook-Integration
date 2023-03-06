@isTest(SeeAllData=true)
public class createInvoiceCtrl_Test{
           
    @isTest static void positiveTests() {
        test.startTest();
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 1;
        applicant.Name                ='Test';
        applicant.Physical_City__c    = 'City';
        insert applicant;
        
        createInvoiceCtrl.getcondominiumdetails(applicant.id);
        Quote__c  quote            = new Quote__c();
        quote.Amount__c            = 100;
        quote.Date_of_Quote__c     = Date.newInstance(2022, 11, 9);
        quote.Quote_Expires_in__c  = '30 days';
        quote.Applicant_Insured__c = applicant.id;
        insert quote;
        createInvoiceCtrl.getProducerDetails(quote.id);
        createInvoiceCtrl.getBillingAddress(quote.id);
        test.stopTest();
        
    }
    
    @isTest static void negativeTests() {
        test.startTest();
        String wrongId = '78969868997';
        createInvoiceCtrl.getcondominiumdetails(wrongId);         
        createInvoiceCtrl.getProducerDetails(wrongId);
        createInvoiceCtrl.getBillingAddress(wrongId);
        test.stopTest();

    }
    
    @isTest static void myTest2() {
        test.startTest();

        Id Insured = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        Account applicant             = new Account() ;
        applicant.Number_of_Units__c  = 100;
        applicant.Name                ='Test';
        applicant.Physical_City__c    = 'City';
        applicant.recordTypeId        = Insured;
        insert applicant;
         
         QB_Invoice__c invoiceObj = new QB_Invoice__c();

        //invoiceObj.QB_Company__c = this.companyId;
        invoiceObj.Type__c                  = 'Invoice';
        invoiceObj.Total_Tax__c             = 0.00;
        invoiceObj.Shipping_Charges__c      = 0.00;
        invoiceObj.Amount_Received__c       = 0.00;
        invoiceObj.Message_Displayed__c     = 'message'; 
        invoiceObj.QBO_Org_Name__c          ='Sandbox Company'; 
        invoiceObj.Due_Date__c              = Date.newInstance(2022, 12, 9);
        invoiceObj.Terms__c                 = 'Due On Recipt';
        invoiceObj.Account__c               = applicant.Id;
        invoiceObj.Invoice_Date__c          = Date.newInstance(2022, 12, 9); 
        invoiceObj.Email__c                 = 'email@gmial.com';
        invoiceObj.Email_Status__c          = 'NeedToSend'; 
        invoiceObj.Billing_State__c          = 'State';
        invoiceObj.Billing_City__c           = 'City';
        invoiceObj.Billing_Country__c        = 'USA';
        invoiceObj.Billing_Postal_Code__c    = '12456';
        invoiceObj.Billing_Street_Address__c = 'Street Address';
        invoiceObj.Sales_Rep__c             = 'John Test';
        invoiceObj.Policy__c                = '20222611D';
        invoiceObj.Amount_Due__c            = 100.00;
        invoiceObj.Total__c                 = 100.00;
        invoiceObj.Statement_Memo__c        = 'Statement Memo';
        
        QB_Line_Item__c itemData = new QB_Line_Item__c();

        itemData.Product_Service__c = 'Gross Premium';
        itemData.Quantity__c = 1;
        itemData.Rate__c = 220.00;
        itemData.Amount__c = 220.00;
        itemData.Line_Number__c = 1;
        itemData.Description__c = 'Desc';
        
        QB_Line_Item__c itemData1 = new QB_Line_Item__c();

        itemData1.Product_Service__c = 'Commissions';
        itemData1.Quantity__c = 1;
        itemData1.Rate__c = -120.00;
        itemData1.Amount__c = -120.00;
        itemData1.Line_Number__c = 2;
        itemData1.Description__c = 'Desc';
                      
		 List<QB_Line_Item__c> lineItemLisTToBeInserted = new List<QB_Line_Item__c>();       
        lineItemLisTToBeInserted.add(itemData);
        lineItemLisTToBeInserted.add(itemData1);
        
        String invoiceJSON   = JSON.serialize(invoiceObj);
        String lineItemJSON  = JSON.serialize(lineItemLisTToBeInserted);
        
        createInvoiceCtrl.creatingInvoiceRecord(invoiceJSON,lineItemJSON);
        test.stopTest();
    }
}