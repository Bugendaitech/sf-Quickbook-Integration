trigger QuoteTrigger on Quote__c (before Update) {
    
    if(Trigger.isBefore && trigger.isUpdate){
        System.debug('## QuoteTrigger - Trigger.isBefore && Trigger.isUpdate');
        QuoteTriggerHandler.CreatingInvoice(Trigger.new);
    }
}