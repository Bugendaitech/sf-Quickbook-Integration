public class applicantProducerCtrl {
    public static void getAccount(List<Contact> conList){
        List<Id> accId=new List<Id>();
        List<Contact> updtCon = New List<Contact>();
        contact con=new contact();
        for(Contact conItr:conList){
            if(conItr.AccountId!=null){
                accId.add(conItr.AccountId);
            }
        }
        
        List<Contact> prodList = new List<Contact>();
        List<Account> accList=[SELECT  id,Mailing_Address__c,Mailing_Address2__c,Mailing_City__c,Mailing_State__c,Mailing_Zip_Code__c 
                               FROM Account WHERE id IN:accId];
        String address1 = '',address2='' ;
        
        if(accList[0].Mailing_Address__c !=null || accList[0].Mailing_Address2__c!=null){
            if(accList[0].Mailing_Address__c !=null ){
                address1 = accList[0].Mailing_Address__c;
            }
               if(accList[0].Mailing_Address2__c !=null ){
                address2 = accList[0].Mailing_Address2__c;
            }
            con.MailingStreet = address1 + ' ' + address2;
        }else{
            con.MailingStreet ='';
        }
        if(accList[0].Mailing_City__c!=null){
            con.MailingCity = accList[0].Mailing_City__c;
        }else{
            con.MailingCity = '';
        }
        
        if(accList[0].Mailing_State__c !=null){
            con.MailingState = accList[0].Mailing_State__c;
        }else{
             con.MailingState='';
        }
        
        if(accList[0].Mailing_Zip_Code__c!=null){
             con.MailingPostalCode = accList[0].Mailing_Zip_Code__c;
        }else{
             con.MailingPostalCode='';
        }
       
        con.id=conList[0].id;
        updtCon.add(con);
        
        update updtCon;
    }
    
}