trigger Account_Trigger on Account (After Update) {
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        System.debug('********Trigger values***********');    
        string isTrigger = label.isTrigger;
        if(isTrigger == 'true'){
            if(checkRecursive.isFirstTime)
            {
                checkRecursive.isFirstTime = false;
                AccountTriggerHandler.UpdateAccountRecords(Trigger.oldMap,Trigger.newMap);       
                
            }
        }
        
    }
}