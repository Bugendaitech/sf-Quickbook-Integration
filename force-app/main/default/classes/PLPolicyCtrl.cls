public class PLPolicyCtrl {
  public static QB_Invoice__c invoice {
        get;
        set;
    }
    public static Policy__c policyData {
        get;
        set;
    }
    public static List<subWrapper> subWrapperObj{get;set;}
    public static Decimal totalAmount{get;set;} 
    public static string  invoiceDate{get;set;}
    public static string  invoiceDueDate{get;set;}
    public static string  invoiceInceptionDate{get;set;} 
    public static Decimal totalGrossAmount{get;set;}
    public static Boolean  showVoid{get;set;}
    public PLPolicyCtrl(){
        string Id = ApexPages.currentPage().getParameters().get('Id');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=AccountReport.pdf');        
        if(Id!= null)
        {
            getInvoiceDataPdf(Id);
        }
    }
    public static void getInvoiceDataPdf(String invId){
        // Decimal lineAmount;
        QB_Invoice__c  invoiceObj = [SELECT Account__r.Amount_Due__c,Account__r.BillingStreet,Account__r.BillingCity, Account__r.BillingState, Account__r.BillingCountry, Account__r.BillingPostalCode,Account__r.Mailing_Address__c,Account__r.Mailing_City__c,Account__r.Mailing_State__c,Account__r.Mailing_Address2__c,Account__r.Mailing_Zip_Code__c,Account__r.Commission__c,Internal_Status__c,Account__r.Indicated_Premium__c,Billing_Street_Address__c,Billing_City__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Policy__c,Sales_Rep__c,Id,Status__c,QB_Status_Flag__c,Name,Term__c,Account__c,Account__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Total__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE Id =: invId];
        Policy__c  policy = [SELECT Name, CreatedDate__c,Insured__r.Agency__c,Insured__r.Agent_To_Bill__r.Account.Physical_Address_2__c, 
                             Insured__r.Agent_To_Bill__r.Account.Physical_Zip_Code__c,
                             Insured__r.Agent_To_Bill__r.Account.Physical_City__c,
                             Insured__r.Agent_To_Bill__r.Account.Physical_State__c
                             FROM Policy__c WHERE QB_Invoice__c =:invId];
        policyData = policy;
        Date d = invoiceObj.Invoice_Date__c;                       
        invoiceDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
        Date d2 = invoiceObj.Due_Date__c;                       
        invoiceDueDate = DateTime.newInstance(d2.year(),d2.month(),d2.day()).format('MM/dd/YYYY'); 
        Date d3 = invoiceObj.Inception_Date__c;                       
        invoiceInceptionDate = DateTime.newInstance(d3.year(),d3.month(),d3.day()).format('MM/dd/YYYY');
        invoice=invoiceObj; 
        if(invoiceObj.Internal_Status__c=='Voided'){
            showVoid=true;
            system.debug('True:'+showVoid);
        }else{
             showVoid=false;
            system.debug('False:'+showVoid);
        }
        totalGrossAmount = invoiceObj.Total__c.setScale(2);
        subWrapperObj    = new List<subWrapper>();  
        
        Integer i=1; 
        Decimal rounded;
        for(QB_Line_Item__c qbLineIte : invoiceObj.QB_Line_Items__r){
            if(qbLineIte.Amount__c != null){
                // qbLineIte.Amount__c = qbLineIte.Amount__c.setScale(2);
                Decimal toRound =qbLineIte.Amount__c;   
                //rounded  = Math.round(toRound * 100) / 100.0;
                rounded=toRound.setScale(2);
            }
            
            
            
            subWrapper subWrapperClass = new subWrapper(i, qbLineIte.Id, qbLineIte.Name, qbLineIte.Rate__c, qbLineIte.Quantity__c,rounded, qbLineIte.Product_Service__c);                                     
            system.debug(subWrapperClass); 
            subWrapperObj.add(subWrapperClass);  
            system.debug(subWrapperObj); 
            i++; 
        }
        
        
        
    }
    
    public class subWrapper{
        
        public Integer srNo{get;Set;}       
        public String id{get;Set;}             
        public String linename{get;Set;}        
        public Decimal rate{get;Set;}       
        public Decimal quantity{get;Set;}       
        public Decimal lineamount{get;Set;}
        public String productService{get;Set;}     
        
        public subWrapper(Integer srNo ,String id ,String linename  ,Decimal rate ,Decimal quantity  ,Decimal lineamount ,String productService)
        { 
            this.srNo =srNo;
            this.id =id;
            this.linename =linename;
            this.rate =rate;
            this.quantity =quantity;
            if(lineamount != null){
            	this.lineamount = lineamount.setScale(2);    
            }else{
                this.lineamount = 0.00;
            }
            
            this.productService = productService; 
        }
    }
    
    
}