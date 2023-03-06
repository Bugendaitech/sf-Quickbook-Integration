public without sharing class GetInvoiceCtrl {

    @AuraEnabled(cacheable=true)
    public static Integer getInvoiceCount(String recId) {
        Integer countVal = 0;
        Integer count = [SELECT Count() FROM QB_Invoice__c WHERE Account__c =:recId];
        return count;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean getGetRecordType(String recId) {
        system.debug('getGetRecordType Record Id'+recId);
        Boolean isShow = false ;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insured').getRecordTypeId();
        Account  accObj = [SELECT RecordTypeId FROM Account WHERE Id =:recId];
        if(accObj.RecordTypeId  == devRecordTypeId){
            isShow = true;
        }else{
            isShow = false;
        }
        return isShow;
    }

    @AuraEnabled(cacheable=true)
    public static String getInvoiceRecords(String recId) {
        try {
            system.debug('recId'+recId);
            List<wrapperInv> warpperList = new List<wrapperInv>();
        List<QB_Invoice__c> invList = [SELECT Id,QB_Status_Flag__c,InvoiceNumber__c,Status__c,Name,Due_Date__c FROM QB_Invoice__c WHERE Account__c =:recId ORDER BY createddate DESC ];

        Integer i = 1; 
        if(!invList.isEmpty()){
                   for(QB_Invoice__c invIte : invList){ 
                    wrapperInv wraObj = new wrapperInv(i,invite.Id,invite.InvoiceNumber__c,invite.QB_Status_Flag__c,invite.Name,invite.Status__c,invite.Due_Date__c);
                    warpperList.add(wraObj); 
                    i++;
                }  
            return JSON.serialize(warpperList);  }else{  return null;   }  } catch (Exception e) { throw new AuraHandledException(e.getMessage());
            
            }

        
}
public class wrapperInv{
    @AuraEnabled   
    public Integer SrNo;
    @AuraEnabled   
    public String  InvoiceName;
    @AuraEnabled   
    public String Status;
    @AuraEnabled   
    public String  StatusFlag;
    @AuraEnabled   
    public Date  duedate;
    @AuraEnabled   
    public String  Flag;
    @AuraEnabled   
    public String  Id;
    @AuraEnabled   
    public List<String> FlagArray;

    public wrapperInv(Integer SrNo,String Id,String invoiceNumber,String  StatusFlag,String  InvoiceName,String Status, Date  duedate){
        this.SrNo = SrNo;
        this.Id   = Id;
        // this.StatusFlag = StatusFlag;
        if(invoiceNumber == null){
            this.InvoiceName = InvoiceName;
        }else{
            this.InvoiceName =invoiceNumber;
        }
     
        this.Status = Status;
        this.duedate = duedate;
        this.FlagArray   = StatusFlag.split('"');
        this.StatusFlag   = this.FlagArray[1];

    }
    }
}