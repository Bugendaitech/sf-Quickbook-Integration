public class QuoteTriggerHandler {
    
    // public static void CreatingPolicyAndInvoice(List<Quote__c> quoList) {
    //     List<Policy__c> polToBeInsertedList = new List<Policy__c>();
    //     for(Quote__c queObj : quoList ) {
    //         if(queObj.Open_Closed__c == '' ){
                
    //         }
    //         Policy__c polObj = new Policy__c();
    //         /*Quote__c accObj : [SELECT Id,Name,Applicant_Insured__r.Number_of_Units__c,Applicant_Insured__r.Year_Built__c,
    //         Applicant_Insured__r.Physical_Street_Address__c,Applicant_Insured__r.Mailing_Address__c,Applicant_Insured__r.Mailing_City__c,
    //         Applicant_Insured__r.Mailing_State__c,Applicant_Insured__r.Mailing_Zip_Code__c,Applicant_Insured__r.Physical_City__c,
    //         Applicant_Insured__r.Physical_State__c,
    //         Applicant_Insured__r.Physical_Zip_Code__c,Applicant_Insured__r.Phone,Applicant_Insured__r.Email__c FROM Quote__c];*/
    //         //polObj.Insured__c= applicant;
    //         polObj.Previous_Policy__c = 'srcgeydtd';
    //         polToBeInsertedList.add(polObj);
    //     }
    //     System.debug('Data '+polToBeInsertedList);
    //     if(!polToBeInsertedList.isEmpty()){
    //         System.debug('data');
    //         insert polToBeInsertedList;
    //         system.debug('data inserted '+polToBeInsertedList);
    //     }
    // }

    public static void CreatingInvoice(List<Quote__c> quoList) {
        List<QB_Invoice__c> invListToBeInserted = new List<QB_Invoice__c>();        
        List<QB_Line_Item__c>  lineItemLisTToBeInserted = new List<QB_Line_Item__c>();

        List<Product2> proList = [SELECT ID,Name FROM Product2 WHERE Name IN ('Gross Premium','Commissions') AND IsActive = true ORDER BY Name DESC];
        Integer count = 1;
        for(Quote__c queObj : quoList ) {

            if(queObj.Open_Closed__c == 'Closed' ){
                System.debug('Called Closed Condition');  
                
                System.debug('Applicat Id '+queObj.Applicant_Insured__c);
                
                Account applicant = [SELECT Id,Name,Discount_Amount__c,Total_Discount_Value__c,Email__c FROM Account WHERE Id =: queObj.Applicant_Insured__c LIMIT 1];
                
                
                System.debug('Amount      '+applicant.Discount_Amount__c);
                System.debug('Dis Amount  '+applicant.Total_Discount_Value__c);

                // Policy__c polObj = new Policy__c();
                QB_Invoice__c invoiceObj = new QB_Invoice__c();
                invoiceObj.Name       = 'INV-'+Math.round((Math.random() * (9000) + 1000));
                invoiceObj.Account__c = queObj.Applicant_Insured__c;
                invoiceObj.Invoice_Date__c = System.today();
                //invoiceObj.Inception_Date__c	 = System.today();
                invoiceObj.Policy__c = '20220808A';
                if(applicant.Email__c!=''){
                    invoiceObj.Email__c = applicant.Email__c;
                    invoiceObj.Email_Status__c = 'Set';
                }else{
                    invoiceObj.Email_Status__c = 'NotSet';
                }           
                
                //invListToBeInserted.add(invoiceObj);

                if(true){
                    insert invoiceObj;

                    for(Product2 proIte : proList){
                        QB_Line_Item__c  lineItemObj = new QB_Line_Item__c();
                        // CM-2206-LineItem-1
                        lineItemObj.Name = 'INV-2208-LienItem-'+count;
                        // // field value like as Name from ProList (Gross Premium)
                        lineItemObj.Product_Service__c = proIte.Name;
                        // Quanitity 1
                        lineItemObj.Quantity__c = 1;
                        // Rate Fatched from Applicant/ Issuerd
                        if(proIte.Name == 'Gross Premium'){
                            lineItemObj.Rate__c = applicant.Discount_Amount__c;
                            lineItemObj.Amount__c = applicant.Discount_Amount__c;
                        }else if(proIte.Name == 'Commissions'){
                            lineItemObj.Rate__c = applicant.Total_Discount_Value__c;
                            lineItemObj.Amount__c = applicant.Total_Discount_Value__c;
                        }
                        // Invoice Id
                        lineItemObj.Invoice__c = invoiceObj.Id;
                        // field value like as 1, 2
                        lineItemObj.Line_Number__c = count;
                        // field value like as 702594170-CM-1809-1, 702594170-CM-1809-2
                        lineItemObj.Line_Item_Id__c = '702594170-INV-1809-'+count;
                        // add in the list , need to be inserted
                        lineItemLisTToBeInserted.add(lineItemObj);
                        count++;
                    } 
    
                    if(!lineItemLisTToBeInserted.isEmpty()){
                        insert lineItemLisTToBeInserted;
                    }
                }

                
             
            }
            
            // polToBeInsertedList.add(polObj);
        } 
        // if(!invListToBeInserted.isEmpty()){
        //     System.debug('data');
        //     insert invListToBeInserted;
        //     system.debug('Data of Invoice '+invListToBeInserted);
        //     System.debug('Data of Lien Item '+lineItemLisTToBeInserted);
        //     for(QB_Invoice__c invIte : invListToBeInserted){

        //     }
        // }
    }
}