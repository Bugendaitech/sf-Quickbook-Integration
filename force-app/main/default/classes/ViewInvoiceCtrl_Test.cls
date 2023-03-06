@isTest
public class ViewInvoiceCtrl_Test {
    @isTest static void myTest() {
        
        Test.startTest();
     
        QB_Invoice__c invoice          = new QB_Invoice__c();
        invoice.Policy__c              = '20222611D';
        invoice.Due_Date__c            = Date.newInstance(2022, 12, 9);
        invoice.Invoice_Date__c        = Date.newInstance(2022, 11, 9);
        invoice.Amount_Received__c     = 1000;
        invoice.Amount_Credited__c     = 1000;
        invoice.Discount_Amount__c     = 1000;
        invoice.Amount_Due__c          = 1000;
        invoice.Credit_Memo_Total_Amount__c     = 1000;
        invoice.Total__c     = 1000;        
        insert invoice;
        
        QB_Line_Item__c  lineitem  = new QB_Line_Item__c();
        lineitem.Amount__c         = 1000;
        lineitem.Rate__c           = 10;
        lineitem.Invoice__c        = invoice.id;
        insert lineitem;
        
        QB_Invoice__c  invoiceObj = [SELECT Id,Billing_Street_Address__c,Billing_City__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Policy__c,Sales_Rep__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Account__r.Agent_to_Bill__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Statement_Memo__c,Days_Overdue__c,Total__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE Id =: invoice.id];
        
        ViewInvoiceCtrl.getInvoiceDetails(invoiceObj.id);
        //ViewInvoiceCtrl.generatePdf(invoice.id);
      
        Test.stopTest();
        
    }
    
    @isTest static void myTest2() {
        Test.startTest();
        QB_Invoice__c invoice          = new QB_Invoice__c();
        invoice.Policy__c              = '20222611D';
        invoice.Due_Date__c            = Date.newInstance(2022, 12, 9);
        invoice.Invoice_Date__c        = Date.newInstance(2022, 11, 9);
        invoice.Amount_Received__c     = 1000;
        invoice.Amount_Credited__c     = 1000;
        invoice.Discount_Amount__c     = 1000;
        invoice.Amount_Due__c          = 1000;
        invoice.Credit_Memo_Total_Amount__c     = 1000;
        invoice.Total__c     = 1000;
        insert invoice;
        
        QB_Line_Item__c  lineitem  = new QB_Line_Item__c();
        lineitem.Amount__c         = 1000;
        lineitem.Rate__c           = 10;
        lineitem.Invoice__c        = invoice.id;
        insert lineitem;
        
        QB_Invoice__c  invoiceObj = [SELECT Id,Billing_Street_Address__c,Billing_City__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Policy__c,Sales_Rep__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Account__r.Agent_to_Bill__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Statement_Memo__c,Days_Overdue__c,Total__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE Id =: invoice.id];
        
        
        ViewInvoiceCtrl.UpdateQB(invoiceObj.id);
        Test.stopTest();
        
    }
    
    
  
}