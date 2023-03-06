public with sharing class ExistingCustomerCtrl {
    public ExistingCustomerCtrl() {

    }
    @AuraEnabled(cacheable = true)
    public static String getAllData(String accId) {
       
        List<wrapperClass> wrapperList = new List<wrapperClass>();
        try {
            String id='';
            String name='';
            String companyName='';
            String displayName='';
            String givenFName='';
            String familyLName='';
            String email;
            String phoneNum='';
            String otherphoneNum='';
            String status='';
            String city='';
            String country='';
            String postalCode='';
            String region='';
            String streetAddress='';
            String synctatus='';
            String fullyQualifiedName='';
            String parentRef='';
            String varcurrency='';
            String sfAccount='';
            String sfAccountName='';
            Boolean taxable;
            List<QB_Company__c> qbComList = [SELECT Id,
            Name,
            QB_Company_Name__c,
            QB_Display_Name__c,
            QB_Given_First_Name__c,
            QB_Family_Last_Name__c,
            QB_Email__c,
            QB_Phone_Number__c,
            QB_Other_Phone_Number__c,
            QB_Status__c,
            QB_City__c,
            QB_Country__c,
            QB_Postal_Code__c,
            QB_Region__c,
            QB_Street_Address__c,
            QB_Sync_Status__c,
            QB_Fully_Qualified_Name__c,
            QB_ParentRef__c,
            QB_Currency__c,
            QB_Salesforce_Account__c,
            QB_Salesforce_Account__r.Name,
            QB_Taxable__c FROM QB_Company__c WHERE QB_Company_Name__c!=null AND QB_Salesforce_Account__c=: accId ORDER BY CreatedDate ASC ];
            Integer i = 1;
            if(!qbComList.isEmpty()){
                Boolean firstCom = false;
                for(QB_Company__c obj : qbComList)
                {
                    if(i==1){
                        firstCom = true;
                    }else{
                        firstCom = false;
                    }
                    wrapperClass wrapOj = new wrapperClass(
                    firstCom,
                    i,
                    id=obj.Id,
                    name=obj.Name,
                    companyName=obj.QB_Company_Name__c,
                    displayName=obj.QB_Display_Name__c,
                    givenFName=obj.QB_Given_First_Name__c,
                    familyLName=obj.QB_Family_Last_Name__c,
                    email=obj.QB_Email__c,
                    phoneNum=obj.QB_Phone_Number__c,
                    otherphoneNum=obj.QB_Other_Phone_Number__c,
                    status=obj.QB_Status__c,
                    city=obj.QB_City__c,
                    country=obj.QB_Country__c,
                    postalCode=obj.QB_Postal_Code__c,
                    region=obj.QB_Region__c,
                    streetAddress=obj.QB_Street_Address__c,
                    synctatus=obj.QB_Sync_Status__c,
                    fullyQualifiedName=obj.QB_Fully_Qualified_Name__c,
                    parentRef=obj.QB_ParentRef__c,
                    varcurrency=obj.QB_Currency__c,
                    sfAccount=obj.QB_Salesforce_Account__c,
                    sfAccountName=obj.QB_Salesforce_Account__r.Name,
                    taxable=obj.QB_Taxable__c
                    );
                    wrapperList.add(wrapOj);
                    i++;
                }
            }

            return JSON.serialize(wrapperList);


            // if(!qbComList.isEmpty()){
            //     return JSON.serialize(qbComList);
            // }else{
            //     return null;
            // } 

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class wrapperClass{
        @AuraEnabled
        Public Boolean isChecked;
        @AuraEnabled
        Public Integer srNo;
        @AuraEnabled
        Public String id;
        @AuraEnabled
        Public String name;
        @AuraEnabled
        Public String companyName;
        @AuraEnabled
        Public String displayName;
        @AuraEnabled
        Public String givenFName;
        @AuraEnabled
        Public String familyLName;
        @AuraEnabled
        Public String email;
        @AuraEnabled
        Public String phoneNum;
        @AuraEnabled
        Public String otherphoneNum;
        @AuraEnabled
        Public String status;
        @AuraEnabled
        Public String city;
        @AuraEnabled
        Public String country;
        @AuraEnabled
        Public String postalCode;
        @AuraEnabled
        Public String region;
        @AuraEnabled
        Public String streetAddress;
        @AuraEnabled
        Public String synctatus;
        @AuraEnabled
        Public String fullyQualifiedName;
        @AuraEnabled
        Public String parentRef;
        @AuraEnabled
        Public String varcurrency;
        @AuraEnabled
        Public String sfAccount;
        @AuraEnabled
        Public String sfAccountName;
        @AuraEnabled
        Public Boolean taxable;
        @AuraEnabled   
        public String NameURL;
        public wrapperClass(Boolean isChecked,Integer srNo,String id, String name,String companyName,String displayName,String givenFName,String familyLName,String email,String phoneNum,
           String otherphoneNum,String status,String city,String country, String postalCode,String region,String streetAddress,String synctatus,String fullyQualifiedName,
           String parentRef,String varcurrency,String sfAccount,String sfAccountName,Boolean taxable)
        {
            this.isChecked= isChecked;
            this.srNo=srNo;
            this.id=id;
            this.name=name;
            this.companyName=companyName;
            this.displayName=displayName;
            this.givenFName=givenFName;
            this.familyLName=familyLName;
            this.email=email;
            this.phoneNum=phoneNum;
            this.otherphoneNum=otherphoneNum;
            this.status=status;
            this.city=city;
            this.country=country;
            this.postalCode=postalCode;
            this.region=region;
            this.streetAddress=streetAddress;
            this.synctatus=synctatus;
            this.fullyQualifiedName=fullyQualifiedName;
            this.parentRef=parentRef;
            this.varcurrency=varcurrency;
            this.sfAccount=sfAccount;
            this.sfAccountName=sfAccountName;
            this.taxable=taxable;
            this.NameURL='/'+Id;

        }
    }
}