trigger AccountTrigger on Account (before insert, after insert) {
    
    if(Trigger.isBefore && Trigger.isInsert) {
        System.debug('## AccountTrigger - Trigger.isBefore && Trigger.isInsert');
        //AccountTriggerHandler.checkAndCreateCustomer(Trigger.new);        
        //QB_External_API.createCustomer();
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        System.debug('## AccountTrigger - Trigger.isAfter && Trigger.isInsert');
        //AccountTriggerHandler.checkAndCreateCustomer(Trigger.new);        
        
        for (Integer i = 0; i < Trigger.new.size(); i++) {
            Account acc = Trigger.new[i];
            //Account oldAccObj = Trigger.old[i];
                if(true){                    
                    system.debug('Customer Creation Condition');
                 //   QB_QuickBooksService.createCustomerFromAccount(acc.Id);
                }
        }
    }
}