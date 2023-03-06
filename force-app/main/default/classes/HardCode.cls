public class HardCode {
    
    
    public static void getData(){
        
        // 0127A000000qEa0QAE
        Id agencyRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agencies').getRecordTypeId();
        
        // 01246000000NhgGAAS
        Id insuredRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        
        // list of Agencies
        List<Account> agenciesList  = [SELECT Id,Name,QB_External_Id__c,QB_Sync_Token__c,RecordTypeId,Number_of_Units__c FROM Account WHERE RecordTypeId =:agencyRecId AND QB_External_Id__c=null AND QB_Sync_Token__c=null AND Number_of_Units__c =1];
        Map<ID, Account> agenciesMap = new Map<ID, Account>([SELECT Id,Name,QB_External_Id__c,QB_Sync_Token__c,RecordTypeId,Number_of_Units__c FROM Account WHERE RecordTypeId =:agencyRecId AND QB_External_Id__c=null AND QB_Sync_Token__c=null AND Number_of_Units__c =1]);
		System.debug('Size of Agency '+agenciesList.size());

        
        // list of Condominum
        List<Account> condominumList  = [SELECT Id,Name,QB_External_Id__c,QB_Sync_Token__c,RecordTypeId,Number_of_Units__c FROM Account WHERE RecordTypeId =:insuredRecId AND QB_External_Id__c=null AND QB_Sync_Token__c=null AND Number_of_Units__c !=1];
        Map<ID, Account> condominumMap = new Map<ID, Account>([SELECT Id,Name,QB_External_Id__c,QB_Sync_Token__c,RecordTypeId,Number_of_Units__c FROM Account WHERE RecordTypeId =:insuredRecId AND QB_External_Id__c=null AND QB_Sync_Token__c=null AND Number_of_Units__c !=1]);
        System.debug('Size of Condo '+condominumList.size());
        
        // list from QB Companies 
        List<breadwinner_qbo__Breadwinner_Account_Connection__c> breadWinnerAgencyList  = [SELECT Id,breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c,breadwinner_qbo__Sync_Token__c FROM breadwinner_qbo__Breadwinner_Account_Connection__c WHERE breadwinner_qbo__Display_Name__c LIKE '.%' ORDER BY breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c ASC];
    	Map<ID, breadwinner_qbo__Breadwinner_Account_Connection__c> breadWinnerAgencyMap = new Map<ID, breadwinner_qbo__Breadwinner_Account_Connection__c>([SELECT Id,breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c,breadwinner_qbo__Sync_Token__c FROM breadwinner_qbo__Breadwinner_Account_Connection__c WHERE breadwinner_qbo__Display_Name__c LIKE '.%' ORDER BY breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c ASC]);
        System.debug('List of Agency from BreadWinner '+breadWinnerAgencyList.size());
        
        // list from QB Companies
        List<breadwinner_qbo__Breadwinner_Account_Connection__c> breadWinnerInsuredList = [SELECT Id,breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c,breadwinner_qbo__Sync_Token__c FROM breadwinner_qbo__Breadwinner_Account_Connection__c WHERE NOT breadwinner_qbo__Display_Name__c LIKE '.%' ORDER BY breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c   ASC ];
        Map<ID, breadwinner_qbo__Breadwinner_Account_Connection__c> breadWinnerInsuredMap = new Map<ID, breadwinner_qbo__Breadwinner_Account_Connection__c>([SELECT Id,breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c,breadwinner_qbo__Sync_Token__c FROM breadwinner_qbo__Breadwinner_Account_Connection__c WHERE NOT breadwinner_qbo__Display_Name__c LIKE '.%' ORDER BY breadwinner_qbo__Display_Name__c,breadwinner_qbo__Reference_Id__c ASC]);
        System.debug('List of Insured from BreadWinner '+breadWinnerInsuredList.size());
        
        
    }

    
    
    
    
}