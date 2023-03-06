public class InvoiceListCtrl {

    @AuraEnabled
    public static String getDataByFilter(String searchKey) {
        
        ReturnWrapper ret   = new ReturnWrapper();
        List<wrapperInv> warpperList = new List<wrapperInv>();
        List<QB_Invoice__c> invList = new List<QB_Invoice__c>();
       //System.debug('KEy  '+searchKey);
        if(searchKey != null && searchKey !=''){
            String key = '%'+ searchKey +'%'; 
            invList =  [SELECT Id,Agency__c,InvoiceNumber__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!='' AND (Name LIKE : key  OR InvoiceNumber__c LIKE : key) ORDER BY Name DESC]; 
        }else{
            invList =  [SELECT Id,Agency__c,InvoiceNumber__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!='' AND Account__c!=''  ORDER BY Name DESC];
        }

        String countQuery  = 'SELECT count() FROM  QB_Invoice__c WHERE Agency__c!= null AND Account__c!=null AND (Name LIKE : key  OR InvoiceNumber__c LIKE : key)'; 
        ret.totalRecords   = Database.countQuery(countQuery); 
        
        system.debug('key '+searchKey);
        system.debug('countQuery '+countQuery);
       //System.debug('List '+invList);
       if(!invList.isEmpty()){
        Integer i = 1;
        for(QB_Invoice__c invIte : invList){  
            wrapperInv wraObj = new wrapperInv(
                i,
                invIte.Agency__c,
                invIte.InvoiceNumber__c,
                invIte.Id,
                invIte.Status__c,
                invIte.QB_Status_Flag__c,
                invIte.Name,
                invIte.Terms__c,
                invIte.Account__c,
                invIte.Account__r.Name,
                invIte.Due_Date__c,
                invIte.Invoice_Date__c,
                invIte.Inception_Date__c,
                invIte.Amount_Received__c,
                invIte.Amount_Credited__c,
                invIte.Amount_Due__c,
                invIte.Amount_Overdue__c,
                invIte.Discount_Amount__c,
                invIte.Credit_Memo_Total_Amount__c,
                invIte.Total__c
                ); 
            warpperList.add(wraObj); 
            i++; 
        }  

            ret.records        = warpperList;
            ret.status         = 'success';

        }else{
            ret.totalRecords   = 0;
            ret.records        = null;
            ret.status         = 'success';
        }   

        return JSON.serialize(ret);
    }


    @AuraEnabled(cacheable = true)
    public static String getInvoicesList(
        Integer pageNumber,
        String lastRecordId,
        Integer recordSize, 
        String actionType,
        Boolean needQuery, 
        String orderBy
        )
    {           
       
        ReturnWrapper ret   = new ReturnWrapper();
        List<wrapperInv> wrapperList = new List<wrapperInv>();

        try {
              // get loggedIn user Detials      
                String invIteectName   = 'QB_Invoice__c';    
                Decimal conLastId   = null;
                Boolean isClosed    = false;   
                Date  filterForCloseDate  = null;

    
                String query        = 'SELECT Id,Agency__c,InvoiceNumber__c,Status__c,QB_Status_Flag__c,Name,Terms__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c FROM QB_Invoice__c WHERE Agency__c!= null AND Account__c!=null';
              
                        
                if(actionType == 'DESC'){
                    query+=' ORDER BY ' + orderBy + ' DESC';
                }else{
                    query+=' ORDER BY ' + orderBy + ' DESC';
                }
            
            List<QB_Invoice__c> invList =  Database.query(query);                
           
            String countQuery  = 'SELECT count() FROM  QB_Invoice__c WHERE Agency__c!= null AND Account__c!=null'; 
            ret.totalRecords   = Database.countQuery(countQuery); 
            
            
            if(!invList.isEmpty()){
                Integer i = 1;
                for(QB_Invoice__c invIte : invList){  
                    wrapperInv wraObj = new wrapperInv(
                        i,
                        invIte.Agency__c,
                        invIte.InvoiceNumber__c,
                        invIte.Id,
                        invIte.Status__c,
                        invIte.QB_Status_Flag__c,
                        invIte.Name,
                        invIte.Terms__c,
                        invIte.Account__c,
                        invIte.Account__r.Name,
                        invIte.Due_Date__c,
                        invIte.Invoice_Date__c,
                        invIte.Inception_Date__c,
                        invIte.Amount_Received__c,
                        invIte.Amount_Credited__c,
                        invIte.Amount_Due__c,
                        invIte.Amount_Overdue__c,
                        invIte.Discount_Amount__c,
                        invIte.Credit_Memo_Total_Amount__c,
                        invIte.Total__c
                        ); 
                    wrapperList.add(wraObj); 
                    i++; 
                }  

                ret.records        = wrapperList;
                ret.status         = 'success';

            }else{
                ret.records        = null;
                ret.status         = 'success';
            }   
        
        return JSON.serialize(ret);

    } catch (Exception e) {
        
            ret.totalRecords   = 0;
            ret.records        = null;
            ret.status         = 'success';
            return JSON.serialize(ret);
    }
    
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
            this.urlaccount = '/'+Account;
            this.shortName            = AccountName.abbreviate(13);          
            this.shortAgencyName      = AgencyName.abbreviate(13); 
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
    


public class ReturnWrapper {
    @AuraEnabled public List<wrapperInv> records;
    @AuraEnabled public Integer totalRecords;
    @AuraEnabled public String status;
}

 


}