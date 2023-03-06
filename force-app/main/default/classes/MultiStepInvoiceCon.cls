public  class MultiStepInvoiceCon {
 @AuraEnabled
public static Quote__c getBillingAddress(string qouteid) {
    try {
 return[select Id,Applicant_Insured__c, Applicant_Insured__r.BillingAddress,Applicant_Insured__r.Commission__c, Applicant_Insured__r.Indicated_Premium__c,Applicant_Insured__r.Discount_Amount__c from Quote__c where id=: qouteid];
} catch (Exception e) {
    throw new AuraHandledException(e.getMessage());
}
}
}