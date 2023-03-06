public with sharing class dataTableInvoiceCtrl {

    @AuraEnabled(cacheable = true)
    public static string fetchInvoices(){
        try {
            List<wrapperInv> warpperList = new List<wrapperInv>();
            List<QB_Invoice__c> invList =  [SELECT Id,Agency__c,Status__c,InvoiceNumber__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!='' AND Account__c!='' ORDER BY Name DESC];
            Integer i = 1; 
            if(!invList.isEmpty()){
               	    for(QB_Invoice__c invIte : invList){ 
                        wrapperInv wraObj = new wrapperInv(i,invIte.Agency__c,invite.InvoiceNumber__c,invite.Id,invite.Status__c,invite.QB_Status_Flag__c,invite.Name,invite.Terms__c,invite.Account__c,invite.Account__r.Name,invite.Due_Date__c,invite.Invoice_Date__c,invite.Inception_Date__c,invite.Amount_Received__c,invite.Amount_Credited__c,invite.Amount_Due__c,invite.Amount_Overdue__c,invite.Discount_Amount__c,invite.Credit_Memo_Total_Amount__c,invite.Total__c);
                        warpperList.add(wraObj); 
                        i++;
                    }  
                return JSON.serialize(warpperList);  }else{  return null;   }  } catch (Exception e) { throw new AuraHandledException(e.getMessage());  }
    }

    @AuraEnabled
    public static String getDataByFilter(String searchKey) {
        
        List<wrapperInv> warpperList = new List<wrapperInv>();
        List<QB_Invoice__c> invList = new List<QB_Invoice__c>();
       //System.debug('KEy  '+searchKey);
        if(searchKey != null && searchKey !=''){
            String key = '%'+ searchKey +'%'; 
            invList =  [SELECT Id,Agency__c,Status__c,QB_Status_Flag__c,InvoiceNumber__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!='' AND Name LIKE : key  ORDER BY Name DESC]; 
        }else{
            invList =  [SELECT Id,Agency__c,Status__c,QB_Status_Flag__c,InvoiceNumber__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!='' AND Account__c!=''  ORDER BY Name DESC];
        }

       //System.debug('List '+invList);
        if(!invList.isEmpty()){
            Integer i = 1;
            for(QB_Invoice__c invIte : invList){  wrapperInv wraObj = new wrapperInv(i,invIte.Agency__c,invite.InvoiceNumber__c,invite.Id,invite.Status__c,invite.QB_Status_Flag__c,invite.Name,invite.Terms__c,invite.Account__c,invite.Account__r.Name,invite.Due_Date__c,invite.Invoice_Date__c,invite.Inception_Date__c,invite.Amount_Received__c,invite.Amount_Credited__c,invite.Amount_Due__c,invite.Amount_Overdue__c,invite.Discount_Amount__c,invite.Credit_Memo_Total_Amount__c,invite.Total__c); warpperList.add(wraObj); i++; }      
            return JSON.serialize(warpperList); }else{ return null; }   
    }

    public class wrapperInv{
        @AuraEnabled   
        public Integer SrNo;
        @AuraEnabled   
        public String  AgencyName;
        @AuraEnabled   
        public String shortAgencyName;
        @AuraEnabled   
        public String  Id;
        @AuraEnabled   
        public String  Status;
        @AuraEnabled   
        public String  Flag;
        @AuraEnabled   
        public String  Name;
        @AuraEnabled   
        public String shortName;
        @AuraEnabled   
        public String  Term;
        @AuraEnabled   
        public String  Account;
        @AuraEnabled   
        public String  AccountName;
        @AuraEnabled   
        public String  DueDate;
        @AuraEnabled   
        public String  InvoiceDate;
        @AuraEnabled   
        public String  InceptionDate;
        @AuraEnabled   
        public Decimal  AmtReceived;
        @AuraEnabled   
        public Decimal  AmtCredit;
        @AuraEnabled   
        public Decimal  AmtDue;
        @AuraEnabled   
        public Decimal  AmtOverDue;
        @AuraEnabled   
        public Decimal  AmtDis;
        @AuraEnabled   
        public Decimal  AmtTotal;
        @AuraEnabled   
        public Decimal  CreditTotal;
        @AuraEnabled
        public String urlaccount;
        @AuraEnabled   
        public List<String> FlagArray;

        public wrapperInv(Integer SrNo,String AgencyName,String invoiceNumber,String  Id,String  Status,String  Flag,String  Name,String  Term,String  Account,String  AccountName,Date  DueDate,Date  InvoiceDate,Date  InceptionDate,Decimal  AmtReceived,Decimal  AmtCredit,Decimal  AmtDue,Decimal  AmtOverDue,Decimal  AmtDis,Decimal  CreditTotal,Decimal  AmtTotal ){
            this.SrNo   = SrNo;
            this.AgencyName = AgencyName;
            this.Id     = Id;
            this.Status = Status;
            // if(this.Status == 'Overdue'){
            //     this.Flag = '/resource/1671476878000/StatusImages/StatusImages/red-flag.png';
            // }else if(this.Status == 'Open'){
            //     this.Flag = '/resource/1671476878000/StatusImages/StatusImages/yflag.png';
            // }else if(this.Status == 'Voided'){
            //     this.Flag = '/resource/1671476878000/StatusImages/StatusImages/X.png';
            // }else if(this.Status == 'Closed'){
            //     this.Flag = '/resource/1671476878000/StatusImages/StatusImages/green-flag.png';
            // }
            this.FlagArray   = Flag.split('"');
            this.Flag   = this.FlagArray[1];
            if(invoiceNumber!=null){
                 this.Name   = invoiceNumber;
            }else{
                this.Name   = Name; 
            }
           
            this.Term   = Term;
            this.Account = Account;
            this.AccountName = AccountName; 
            this.urlaccount='/#'; 
            this.shortName            = AccountName;        
            this.shortAgencyName      = AgencyName;
            // .abbreviate(13);
            if( InvoiceDate!= null){  Date d1 = InvoiceDate ;  this.InvoiceDate = DateTime.newInstance(d1.year(),d1.month(),d1.day()).format('MM/dd/YYYY'); }else{  this.InvoiceDate = null; }
			if(InceptionDate != null){ Date d2 = InceptionDate;   this.InceptionDate = DateTime.newInstance(d2.year(),d2.month(),d2.day()).format('MM/dd/YYYY'); }else{ this.InceptionDate = null; }
            if(DueDate!= null){ Date d3 = DueDate; this.DueDate = DateTime.newInstance(d3.year(),d3.month(),d3.day()).format('MM/dd/YYYY'); }else{ this.DueDate = null; }
			if(AmtReceived != null){ this.AmtReceived = AmtReceived.setScale(2); }else{ this.AmtReceived = 0.00; }
            if(AmtCredit != null){ this.AmtCredit = AmtCredit.setScale(2); }else{ this.AmtCredit = 0.00; }
            if(AmtOverDue != null){ this.AmtOverDue = AmtOverDue.setScale(2); }else{ this.AmtOverDue = 0.00; }
            if(AmtDue != null){  this.AmtDue = AmtDue.setScale(2); }else{  this.AmtDue = 0.00; }
            if(AmtTotal != null){ this.AmtTotal = AmtTotal.setScale(2); }else{ this.AmtTotal = 0.00;}
            if(CreditTotal != null){ this.CreditTotal = CreditTotal.setScale(2); }else{  this.CreditTotal = 0.00;}
			if(AmtDis != null){ this.AmtDis = AmtDis.setScale(2); }else{ this.AmtDis = 0.00; }
        }
    }




    @AuraEnabled(cacheable = true)
    public static String getInvoiceData(
        Integer pageNumber,
        String lastRecordId,
        Integer recordSize, 
        String actionType,
        Boolean needQuery, 
        String orderBy
        )
    {           
       List<wrapperClass> wrapperList = new List<wrapperClass>();  
        try {
              // get loggedIn user Detials     
                ReturnWrapper ret   = new ReturnWrapper();
                String inviteectName   = 'QB_Invoice__c';    
                Decimal conLastId   = null;
                Boolean isClosed    = false;   
                Date  filterForCloseDate  = null;

    
                String query        = 'SELECT Id,Agency__c,InvoiceNumber__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!= null AND Account__c!=null';
              
                        
                if(actionType == 'DESC'){
                    query+=' ORDER BY ' + orderBy + ' DESC';
                }else{
                    query+=' ORDER BY ' + orderBy + ' DESC';
                }
            
            List<QB_Invoice__c> invData = new List<QB_Invoice__c>();
             
            System.debug('All Opp '+invData);
            invData = Database.query(query); 
           
            String countQuery = 'SELECT count() FROM  QB_Invoice__c WHERE Agency__c!= null AND Account__c!=null'; 
             ret.totalRecords   = Database.countQuery(countQuery); 
            
            if(!invData.isEmpty()){
                
            Integer i = 1;
            for(QB_Invoice__c invite  : invData ){        
                wrapperClass wrapOj = new wrapperClass(
                    i,
                    invite.Agency__c,
                    invite.InvoiceNumber__c,
                    invite.Id,
                    invite.Status__c,
                    invite.QB_Status_Flag__c,
                    invite.Name,
                    invite.Terms__c,
                    invite.Account__c,
                    invite.Account__r.Name,
                    invite.Due_Date__c,
                    invite.Invoice_Date__c,
                    invite.Inception_Date__c,
                    invite.Amount_Received__c,
                    invite.Amount_Credited__c,
                    invite.Amount_Due__c,
                    invite.Amount_Overdue__c,
                    invite.Discount_Amount__c,
                    invite.Credit_Memo_Total_Amount__c,
                    invite.Total__c,
                    false
                    );
                    wrapperList.add(wrapOj);
                    i++;
                
            }
             System.debug('All Opp '+wrapperList);
        }
        ret.records = wrapperList;
        return JSON.serialize(ret);

    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
    
}

public class ReturnWrapper {
    @AuraEnabled public List<wrapperClass> records;
    @AuraEnabled public Integer totalRecords;
}


public class wrapperClass{
    @AuraEnabled   
    public Integer SrNo;
    @AuraEnabled   
    public String  AgencyName;
    @AuraEnabled   
    public String shortAgencyName;
    @AuraEnabled   
    public String  Id;
    @AuraEnabled   
    public String  Status;
    @AuraEnabled   
    public String  Flag;
    @AuraEnabled   
    public String  Name;
    @AuraEnabled   
    public String shortName;
    @AuraEnabled   
    public String  Term;
    @AuraEnabled   
    public String  Account;
    @AuraEnabled   
    public String  AccountName;
    @AuraEnabled   
    public String  DueDate;
    @AuraEnabled   
    public String  InvoiceDate;
    @AuraEnabled   
    public String  InceptionDate;
    @AuraEnabled   
    public Decimal  AmtReceived;
    @AuraEnabled   
    public Decimal  AmtCredit;
    @AuraEnabled   
    public Decimal  AmtDue;
    @AuraEnabled   
    public Decimal  AmtOverDue;
    @AuraEnabled   
    public Decimal  AmtDis;
    @AuraEnabled   
    public Decimal  AmtTotal;
    @AuraEnabled   
    public Decimal  CreditTotal;
    @AuraEnabled
    public String urlaccount;
    @AuraEnabled    
    public List<String> FlagArray;
    @AuraEnabled
    public Boolean needQuery;

    public wrapperClass(Integer SrNo,String AgencyName,String invoiceNumber,String  Id,String  Status,String  Flag,String  Name,String  Term,String  Account,String  AccountName,Date  DueDate,Date  InvoiceDate,Date  InceptionDate,Decimal  AmtReceived,Decimal  AmtCredit,Decimal  AmtDue,Decimal  AmtOverDue,Decimal  AmtDis,Decimal  CreditTotal,Decimal  AmtTotal,Boolean needQuery ){
        this.SrNo         = SrNo;
        this.AgencyName   = AgencyName;
        this.Id           = Id;
        this.Status       = Status;
        this.FlagArray    = Flag.split('"');
        this.Flag         = this.FlagArray[1];
        this.shortName    = AccountName; 
        if(invoiceNumber!=null){
            this.Name     = invoiceNumber;
        }else{
           this.Name      = Name; 
        }
        this.Term         = Term;
        this.Account      = Account;
        this.AccountName  = AccountName; 
        this.urlaccount   = '/#'; 
        if( InvoiceDate!= null){  Date d1 = InvoiceDate ;  this.InvoiceDate = DateTime.newInstance(d1.year(),d1.month(),d1.day()).format('MM/dd/YYYY'); }else{  this.InvoiceDate = null; }
        if(InceptionDate != null){ Date d2 = InceptionDate;   this.InceptionDate = DateTime.newInstance(d2.year(),d2.month(),d2.day()).format('MM/dd/YYYY'); }else{ this.InceptionDate = null; }
        if(DueDate!= null){ Date d3 = DueDate; this.DueDate = DateTime.newInstance(d3.year(),d3.month(),d3.day()).format('MM/dd/YYYY'); }else{ this.DueDate = null; }
        if(AmtReceived != null){ this.AmtReceived = AmtReceived.setScale(2); }else{ this.AmtReceived = 0.00; }
        if(AmtCredit != null){ this.AmtCredit = AmtCredit.setScale(2); }else{ this.AmtCredit = 0.00; }
        if(AmtOverDue != null){ this.AmtOverDue = AmtOverDue.setScale(2); }else{ this.AmtOverDue = 0.00; }
        if(AmtDue != null){  this.AmtDue = AmtDue.setScale(2); }else{  this.AmtDue = 0.00; }
        if(AmtTotal != null){ this.AmtTotal = AmtTotal.setScale(2); }else{ this.AmtTotal = 0.00;}
        if(CreditTotal != null){ this.CreditTotal = CreditTotal.setScale(2); }else{  this.CreditTotal = 0.00;}
        if(AmtDis != null){ this.AmtDis = AmtDis.setScale(2); }else{ this.AmtDis = 0.00; }
        this.needQuery    = needQuery;
    }
}



}