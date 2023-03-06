public without sharing class BindQuoteModalCtrl {
  
    @AuraEnabled
    public static Quote__c checkProducre(String quoteId){
        //System.debug('recprd Id '+quoteId);
        
        Quote__c quoteObj = [SELECT Producer__c,Applicant_Insured__r.QB_Sync_Token__c,Applicant_Insured__r.QB_External_Id__c,Applicant_Insured__r.QB_Parent_Id__c FROM Quote__c WHERE Id=:quoteId];         

        return quoteObj;

    }
}