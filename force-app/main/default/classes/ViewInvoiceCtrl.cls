public class ViewInvoiceCtrl {
 

    @AuraEnabled(cacheable = true)
    public static String getInvoiceDetails(String invId){
        
        Integer srNo;
        String billCity = '';
        String billCountry = '';
        String billState = '';
        String billPostal = '';
        String billStreet = '';
        String emailStatus = '';
        String email = '';
        String policy = '';
        String status = '';
        String salesRep = '';
        String qbFlag = '';
        String Name = '';
        String terms = '';
        String recId = '';
        String account = '';
        String accountName = '';
        String dueDate = '';
        String invoiceDate = '';
        String inceptionDate = ''; 
        string insuredName = '';
        Decimal amountReceived;
        Decimal amountCredited;
        Decimal amountDue;
        Decimal amountOverdue;
        Decimal discountAmount;
        Decimal creditCashMemo;
        Decimal qbAmountReceive; 
        Decimal qbAmountCreited; 
        Decimal qbAmountDue; 
        Decimal qbAmountOverdue; 
        Decimal qbDiscount; 
        Decimal qbTotalAmount; 
        Decimal qbCMTotalAmount;
        Decimal qb;
        
        

        try {
            

            QB_Invoice__c  invoiceObj = [SELECT Id,Billing_Street_Address__c,Billing_City__c,InceptionDate__c,Billing_State__c,Billing_Postal_Code__c,Billing_Country__c,Email_Status__c,Email__c,Policy__c,Sales_Rep__c,Status__c,QB_Status_Flag__c,InvoiceNumber__c,Name,Terms__c,Account__c,Account__r.Name,Account__r.Agent_to_Bill__r.Name,Due_Date__c,Invoice_Date__c,Inception_Date__c,Amount_Received__c,Amount_Credited__c,Amount_Due__c,Amount_Overdue__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Statement_Memo__c,Days_Overdue__c,Total__c,(SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE Id =: invId];
 
                
                List<subWrapper> subWrapperObj = new List<subWrapper>(); 
                
                if( invoiceObj.Due_Date__c!= null){
                    Date d1 = invoiceObj.Due_Date__c ;                       
                    dueDate = DateTime.newInstance(d1.year(),d1.month(),d1.day()).format('MM/dd/YYYY');
                }
                if(invoiceObj.Invoice_Date__c != null){
                    Date d2 = invoiceObj.Invoice_Date__c;                       
                    invoiceDate = DateTime.newInstance(d2.year(),d2.month(),d2.day()).format('MM/dd/YYYY');
                }
                if(invoiceObj.InceptionDate__c!= null){
                    // Date d3 = invoiceObj.Inception_Date__c; 
                    Date d3 = invoiceObj.InceptionDate__c;                           
                    inceptionDate = DateTime.newInstance(d3.year(),d3.month(),d3.day()).format('MM/dd/YYYY');
                }
             
                if(invoiceObj.Amount_Received__c !=null){
                    qbAmountReceive = invoiceObj.Amount_Received__c.setScale(2);
                }
                if(invoiceObj.Amount_Credited__c != null){
                    qbAmountCreited= invoiceObj.Amount_Credited__c.setScale(2);
                }
                if(invoiceObj.Amount_Due__c != null){
                    qbAmountDue= invoiceObj.Amount_Due__c.setScale(2);
                }
                if(invoiceObj.Amount_Overdue__c != null){
 				    qbAmountOverdue= invoiceObj.Amount_Overdue__c.setScale(2);
                }
                if(invoiceObj.Discount_Amount__c != null){
                   qbDiscount= invoiceObj.Discount_Amount__c.setScale(2);
                }
                if(invoiceObj.Credit_Memo_Total_Amount__c != null){
                   qbCMTotalAmount= invoiceObj.Credit_Memo_Total_Amount__c.setScale(2);
                }
                if(invoiceObj.Total__c != null){
                    qbTotalAmount= invoiceObj.Total__c.setScale(2);
                 }    
            

                Integer i = 1;
                for(QB_Line_Item__c qbLineIte : invoiceObj.QB_Line_Items__r){
                    if(qbLineIte.Amount__c != null){
                        qbLineIte.Amount__c = qbLineIte.Amount__c.setScale(2);
                    }
                    if(qbLineIte.Rate__c != null){
                        qbLineIte.Rate__c = qbLineIte.Rate__c.setScale(2);
                    }

                    subWrapper subWrapperClass = new subWrapper(i, qbLineIte.Id, qbLineIte.Name, qbLineIte.Rate__c, qbLineIte.Quantity__c, qbLineIte.Amount__c, qbLineIte.Product_Service__c,
                    qbLineIte.Description__c);                                     
                    subWrapperObj.add(subWrapperClass);
                    i++;                    
                }
                	
                    mainWrapper mainWrapperClass    =  new mainWrapper(
                        invoiceObj.Days_Overdue__c,
                        invoiceObj.Statement_Memo__c,
                        invoiceObj.Id,
                        invoiceObj.Billing_Street_Address__c,
                        invoiceObj.Billing_City__c,
                        invoiceObj.Billing_State__c,
                        invoiceObj.Billing_Postal_Code__c,
                        invoiceObj.Billing_Country__c,
                        invoiceObj.Email_Status__c,
                        invoiceObj.Email__c,
                        invoiceObj.Policy__c,
                        invoiceObj.Sales_Rep__c,
                        invoiceObj.Status__c,
                        invoiceObj.QB_Status_Flag__c,
                        invoiceObj.Name,
                        invoiceObj.InvoiceNumber__c,
                        invoiceObj.Terms__c,
                        invoiceObj.Account__c,
                        invoiceObj.Account__r.Agent_to_Bill__r.Name,
                        invoiceObj.Account__r.Name,
                        dueDate,
                        invoiceDate,
                        inceptionDate,          
                        qbAmountReceive,
                        qbAmountCreited,
                        qbAmountDue,
                        qbAmountOverdue,
                        qbDiscount,
                        qbTotalAmount,
                        qbCMTotalAmount,
                        subWrapperObj);
             
            return JSON.serialize(mainWrapperClass);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    
    public class mainWrapper{

        @AuraEnabled
        public Decimal dueDays;
        @AuraEnabled
        public String statement;
        @AuraEnabled
        public String recId;        
        @AuraEnabled
        public String billStreet;          
        @AuraEnabled
        public String billCity;        
        @AuraEnabled
        public string billState;
        @AuraEnabled
        public String billPostal;        
        @AuraEnabled
        public String billCountry;
        @AuraEnabled
        public String emailStatus;        
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String policy;        
        @AuraEnabled
        public String salesRep;
        @AuraEnabled
        public String status;        
        @AuraEnabled
        public String qbFlag;
        @AuraEnabled
        public String name;    
        @AuraEnabled 
        public String invoiceName;      
        @AuraEnabled
        public String terms;    
        @AuraEnabled
        public String account;        
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public String dueDate;        
        @AuraEnabled
        public String invoiceDate;
        @AuraEnabled
        public String inceptionDate;        
        @AuraEnabled
        public String insuredName;
        @AuraEnabled
        public Decimal amountReceived;
        @AuraEnabled
        public Decimal amountCredited;        
        @AuraEnabled
        public Decimal amountDue;
        @AuraEnabled
        public Decimal amountOverdue;
        @AuraEnabled
        public Decimal discountAmount;
        @AuraEnabled
        public Decimal creditCashMemo;
        @AuraEnabled
        public Decimal totalAmount;
        @AuraEnabled   
        public String URL;
        @AuraEnabled   
        public List<subWrapper> LineItems;
        @AuraEnabled   
        public String bgClass;         
      

        public mainWrapper(Decimal dueDays, String statement, String recId, String billStreet,String  billCity,String  billState ,String billPostal ,String billCountry ,
        String emailStatus ,String email ,String policy,String salesRep,String  status,String  qbFlag,String  name,String invoiceName,String terms,String  account ,String accountName ,String insuredName ,String dueDate,String  invoiceDate ,String inceptionDate,Decimal amountReceived
        ,Decimal amountCredited,Decimal amountDue,Decimal amountOverdue ,Decimal discountAmount ,Decimal totalAmount,Decimal creditCashMemo,List<subWrapper> LineItems ){
           
            // thissrNo=srNo;
            this.dueDays   = dueDays;
            this.statement = statement;
            this.recId = recId;           
            this.billStreet=billStreet;
            this.billCity =billCity;
            this.billState= billState;
            this.billPostal=billPostal;
            this.billCountry =billCountry;
            this.emailStatus=emailStatus;
            this.email =email;
            this.policy =policy;
            this.insuredName = insuredName;
            this.salesRep =salesRep;
            this.status =status;
            this.qbFlag =qbFlag;            
            this.terms =terms;
            this.account =account;
            this.accountName= accountName;
            this.dueDate =dueDate;
            this.invoiceDate =invoiceDate;
            this.inceptionDate =inceptionDate;
            this.amountReceived =amountReceived;
            this.amountCredited = amountCredited;
            this.amountDue  =amountDue;
            this.amountOverdue=amountOverdue;
            this.discountAmount =discountAmount;
            this.creditCashMemo=creditCashMemo;
            this.totalAmount = totalAmount;
            this.URL= '/'+recId;
            this.LineItems=LineItems;
            if(invoiceName!= null){
                this.name = invoiceName;
            }else{
                this.name =name;
            }       
           
            if(status == 'Open'){
                this.bgClass = 'slds-size_2-of-3 slds-text-align_left open-class';
            }else if(status=='Overdue'){
                this.bgClass = 'slds-size_2-of-3 slds-text-align_left overdue-class';
            }else if(status=='Closed'){
                this.bgClass = 'slds-size_2-of-3 slds-text-align_left closed-class';
            }else if(status=='Paid'){
                this.bgClass = 'slds-size_2-of-3 slds-text-align_left paid-class';
            }
        }       
    }

    public class subWrapper{

        @AuraEnabled
        public Integer srNo;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String srdesc;
        @AuraEnabled
        public String linename;
        @AuraEnabled
        public Decimal rate;
        @AuraEnabled
        public Decimal quantity;
        @AuraEnabled
        public Decimal lineamount;
        @AuraEnabled
        public String productService;
        @AuraEnabled   
        public String URL;
        @AuraEnabled   
        public Boolean isCommission;
        
          public subWrapper(Integer srNo ,String id ,String linename  ,Decimal rate ,Decimal quantity  ,Decimal lineamount ,String productService, String srdesc)
          {
            this.srdesc = srdesc;
            this.srNo =srNo;
            this.id =id;
            this.linename =linename;
            this.rate =rate;
            this.quantity =quantity;
            this.lineamount =lineamount;
            this.productService = productService;
            
            if(productService == 'Commissions'){
                this.isCommission = true;
            }else{
                this.isCommission = false;
            }
            this.URL= '/'+Id;
          }
    }
    
    
    
    @AuraEnabled
    public static string generatePdf(String invId){
        try {
            PageReference PDFPage = new PageReference('/apex/PDFdownload?Id=' + invId);
            Blob pdfBlob = PDFPage.getContent();
            try{
                Policy__c policy= [SELECT Id FROM Policy__c WHERE QB_Invoice__c =:invId];
                //Attach PDF to Invoice... **Dec 6th 2022..
                if(policy!= null){
                    ContentVersion file = new ContentVersion();
                    file.Title = 'Invoice.pdf';
                    file.PathOnClient = 'Invoice.pdf';
                    file.VersionData = pdfBlob;
                    file.FirstPublishLocationId = policy.Id;
                    insert file;
                }
                String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
                return base64Pdf;
                
                // System.debug('Pdf Blob'+pdfBlob);
                
            }catch(Exception e){
                // System.debug('Pdf Blob'+pdfBlob);
                String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
                return base64Pdf;
            }
           
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string generatePLPolicyPdf(String invId){
        try {
            PageReference PDFPage = new PageReference('/apex/PLPolicyVFPage?Id=' + invId);
            Blob pdfBlob = PDFPage.getContent();
            try{
                Policy__c policy= [SELECT Id,Name FROM Policy__c WHERE QB_Invoice__c =:invId];
                if(policy != null){
                    //Attach PDF to Invoice... **Dec 6th 2022..
                    ContentVersion file = new ContentVersion();
                    file.Title = 'BOLD PL Policy'+policy.Name+'.pdf';
                    file.PathOnClient =  'BOLD PL Policy'+policy.Name+'.pdf';
                    file.VersionData = pdfBlob;
                    file.FirstPublishLocationId = policy.Id;
                    insert file;
                    
                }
                String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
                return base64Pdf;
            }catch(Exception e){
                // System.debug('Pdf Blob'+pdfBlob);
                String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
                return base64Pdf;
            }
           
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string UpdateQB(String invId){
        String result='Initial';
        String siteUrl     = BoldLegalUtils.siteHomeUrl;
        String commisionId = null;
        String grossId     = null;
        String salesTermId = null;
        List<QB_Line_Item__c> qbToUpdate=new List<QB_Line_Item__c>();
        List<QB_Invoice__c> invToUpdate=new List<QB_Invoice__c>();
        List<QB_Invoice__c>  invoiceObj = [SELECT Id,Statement_Memo__c,Discount_Amount__c,Credit_Memo_Total_Amount__c,Amount_Due__c,Amount_Overdue__c,Status__c,Total__c,
        Amount_Received__c,Amount_Credited__c,Internal_Status__c,Sync_Token__c,Due_Date__c,
        QB_External_Id__c,InvoiceNumber__c,Account__r.QB_External_Id__c,Account__r.Name,
        (SELECT Id,Name,Rate__c,Quantity__c,Amount__c,Product_Service__c,Description__c FROM QB_Line_Items__r) FROM QB_Invoice__c WHERE Id=: invId];
        String JSON ='';
        if(siteUrl.contains('sandbox')){
            commisionId      = BoldLegalUtils.qbComissionRecIdSand;
            grossId          = BoldLegalUtils.qbGrossRecIdSand;
            salesTermId         = BoldLegalUtils.qbSalesTermSand;
        }else{
            commisionId      = BoldLegalUtils.qbComissionRecIdProd;
            grossId          = BoldLegalUtils.qbGrossRecIdProd;
            salesTermId      = BoldLegalUtils.qbSalesTermProd;
        }
        for(QB_Invoice__c qbItr:invoiceObj )
        {
            JSON += '{  "sparse": true,\n'+
           ' "Id": '+'"'+qbItr.QB_External_Id__c+'",\n'+
           ' "SyncToken": '+'"'+qbItr.Sync_Token__c+'"\n'+
           '} ';
            qbItr.Internal_Status__c='Voided';
            qbItr.Total__c=0.00;
            qbItr.Statement_Memo__c='Voided';  
            qbItr.Amount_Due__c=0.00;
            qbItr.Credit_Memo_Total_Amount__c=0.00;
            qbItr.Discount_Amount__c=0.00;
            qbItr.Amount_Received__c=0.00;
            qbItr.Amount_Credited__c=0.00;
            invToUpdate.add(qbItr);          
            for(QB_Line_Item__c itemsItr:qbItr.QB_Line_Items__r ){
                itemsItr.Quantity__c=0.00;
                itemsItr.Amount__c=0.00;
                itemsItr.Rate__c=0.00;
                itemsItr.Description__c='';
                // String serviceName = null;
                // String serviceId   = null;
                // if(itemsItr.Product_Service__c=='Commissions'){
                //     // tempDecimal = itemsItr.Quantity__c * itemsItr.Rate__c;
                //     serviceName = 'Comission';
                //     serviceId   = commisionId;
                // }else{
                //     // tempDecimal = itemsItr.Quantity__c * itemsItr.Rate__c;
                //     serviceName = 'Gross Premium';
                //     serviceId   = grossId;
                // }
                // qbToUpdate.add( itemsItr);

            }
        }
        System.debug('Void Invoice Data: '+JSON);
        QB_External_API.updateInvoice(JSON);
        update qbToUpdate;
        update invToUpdate;
        result='Success';
        return result;
    }

}