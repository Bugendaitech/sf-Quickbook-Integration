trigger CompanyTrigger on QB_Company__c (before update, after update) {

    // if (Trigger.isBefore) {
    //     System.debug('********Trigger values***********');
    //     System.debug('***SFDC: Trigger.old is: ' + Trigger.old);
    //     System.debug('***SFDC: Trigger.new is: ' + Trigger.new);
    // }
    

    if (Trigger.isAfter && Trigger.isUpdate) {
        System.debug('********Trigger values***********');    

        //System.debug('***SFDC: Trigger.old is: ' + Trigger.old);
        //System.debug('***SFDC: Trigger.new is: ' + Trigger.new);
        if(checkRecursive.isFirstTime)
        {
            checkRecursive.isFirstTime = false;
            CompanyTriggerHandler.handleCompanyData(Trigger.old,Trigger.new);       
            
        }
    }

}