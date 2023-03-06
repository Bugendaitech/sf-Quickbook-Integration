@isTest(SeeAllData=true)
public class Getpdfdata_Test {    
    
    @isTest static void myTest(){
         QB_Invoice__c invoice          = new QB_Invoice__c();
         invoice.Policy__c              = '20222611D';
         invoice.Due_Date__c            = system.today();
         invoice.Invoice_Date__c        = system.today();
         invoice.Amount_Received__c     = 1000;
         invoice.Amount_Credited__c     = 1000;
         invoice.Discount_Amount__c     = 1000;
         invoice.Amount_Due__c          = 1000;
         invoice.Credit_Memo_Total_Amount__c     = 1000;
         invoice.Total__c     = 1000;        
         insert invoice;
        QB_Line_Item__c qbLineObj   = new  QB_Line_Item__c();
        qbLineObj.Amount__c         = 1000;
        qbLineObj.Rate__c           = 10;
        qbLineObj.Invoice__c        = invoice.id;
        qbLineObj.Product_Service__c = 'Commissions';
        insert qbLineObj;
            Test.startTest();
                QB_Invoice__c  invoiceObj = [SELECT Account__r.Amount_Due__c,Account__r.Commission__c,Internal_Status__c,Account__r.Indicated_Premium__c,Billing_Street_Address__c,Billing_City__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Policy__c,Sales_Rep__c,Id,Status__c,QB_Status_Flag__c,Name,Term__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE Id =:invoice.Id];

            Test.stopTest();
        Getpdfdata.getInvoiceDataPdf(invoiceObj.id);
        
        
    }
}