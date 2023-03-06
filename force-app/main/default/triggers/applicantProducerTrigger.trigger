trigger applicantProducerTrigger on Contact (After insert,after update) {
    
    if (Trigger.isInsert &&Trigger.isAfter && checkRecursive.isFirstTime) {
        checkRecursive.isFirstTime=false;
        applicantProducerCtrl.getAccount(Trigger.New);
        
        
    }
    if (Trigger.isUpdate && Trigger.isafter && checkRecursive.isFirstTime ) {    checkRecursive.isFirstTime=false;applicantProducerCtrl.getAccount(Trigger.New); }
}