public without sharing class CompanyTriggerHandler {
    public CompanyTriggerHandler() {

    }


    public static void handleCompanyData(List<QB_Company__c> companyOldData,List<QB_Company__c> companyNewData){
            
        // get main values for callout
        String comId         =  companyNewData[0].Id;
        String qbExternalId  =  companyNewData[0].QB_External_Id__c;
        String curSyncToken  =  companyNewData[0].QB_Sync_Token__c;

        String fName         = '';
        String lName         = '';
        String email         = '';
        String comName       = '';
        String displayName   = '';
        String phone         = '';
        String mobile        = '';
        String state         = '';
        String postcode      = '';
        String city          = '';
        String country       = '';
        String street        = '';
        String paymentRef    = '';
        String termRef       = '';


        // check values
        if(companyNewData[0].QB_Given_First_Name__c != companyOldData[0].QB_Given_First_Name__c){
            //System.debug('Not Changed '+companyNewData[0].QB_Phone_Number__c+' & '+companyOldData[0].QB_Phone_Number__c);
            fName = companyNewData[0].QB_Given_First_Name__c;
        }

        // check values
        if(companyNewData[0].QB_Family_Last_Name__c != companyOldData[0].QB_Family_Last_Name__c){            
            lName = companyNewData[0].QB_Family_Last_Name__c;
        }


         // check values
         if(companyNewData[0].QB_Company_Name__c != companyOldData[0].QB_Company_Name__c){            
            comName = companyNewData[0].QB_Company_Name__c;
        }

         // check values
         if(companyNewData[0].QB_Email__c != companyOldData[0].QB_Email__c){            
            email  = companyNewData[0].QB_Email__c;
        }

         // check values for phone
         if(companyNewData[0].QB_Phone_Number__c != companyOldData[0].QB_Phone_Number__c){            
            phone  = companyNewData[0].QB_Phone_Number__c;
        }

         // check values for phone
         if(companyNewData[0].QB_Other_Phone_Number__c != companyOldData[0].QB_Other_Phone_Number__c){            
            mobile  = companyNewData[0].QB_Other_Phone_Number__c;
        }

        if(companyNewData[0].QB_Region__c != companyOldData[0].QB_Region__c){            
            state  = companyNewData[0].QB_Region__c;
        }
        if(companyNewData[0].QB_City__c != companyOldData[0].QB_City__c){            
            city  = companyNewData[0].QB_City__c;
        }
        if(companyNewData[0].QB_Street_Address__c != companyOldData[0].QB_Street_Address__c){            
            street  = companyNewData[0].QB_Street_Address__c;
        }
        if(companyNewData[0].QB_Country__c != companyOldData[0].QB_Country__c){            
            country  = companyNewData[0].QB_Country__c;
        }
        if(companyNewData[0].QB_Postal_Code__c != companyOldData[0].QB_Postal_Code__c){            
            postcode  = companyNewData[0].QB_Postal_Code__c;
        }
        if(companyNewData[0].QB_Default_Terms_Ref__c != companyOldData[0].QB_Default_Terms_Ref__c){            
            termRef  = companyNewData[0].QB_Default_Terms_Ref__c;
        }
        if(companyNewData[0].QB_Preferred_Delivery_Method__c != companyOldData[0].QB_Preferred_Delivery_Method__c){            
            paymentRef  = companyNewData[0].QB_Preferred_Delivery_Method__c;
        }

        
        System.debug('Email '+email);
        System.debug('curSyncToken '+curSyncToken);
        //curSyncToken = '9';

        displayName = fName+lName;
        system.debug('Display Name :: '+displayName);

        String fullyQuaName  =  'Jack Knight : '+displayName;
        
        //String json   = '      "Id": "95", ';

        String json = '{'+
        '      "Id": '+'"'+qbExternalId+'", ';
        
        
        if(fullyQuaName!=''){
            json+='   "FullyQualifiedName": '+'"'+fullyQuaName+'", ';
        } 

        if(displayName!=''){
            json+='      "DisplayName": '+'"'+displayName+'", ';
        }

        if(displayName!=''){
            json+='      "CompanyName": '+'"'+comName+'", ';
        }

        if(email!=''){ 
            json+='   "PrimaryEmailAddr": {'+
            '          "Address": '+'"'+email+'"'+ 
            '      }, ';
        }
        
        if(phone!=''){
            json+='  "PrimaryPhone": {'+
                '    "FreeFormNumber": '+'"'+phone+'"'+ 
                '  }, ';
        }

        if(mobile!=''){
            json+='  "Mobile": { '+
                '  "FreeFormNumber": '+'"'+mobile+'"'+ 
            '  }, ';
        }
        if(state!=''){
        json+='  "BillAddr": {'+
        '    "CountrySubDivisionCode": '+'"'+state+'",';
        }
        if(city!=''){
        json+='    "City": '+'"'+city+'", ';
        }
        if(postcode!=''){
        json+='    "PostalCode":'+'"'+postcode+'", ';
        }
        if(street!=''){
        json+= '    "Line1": '+'"'+street+'", ';
        }
        if(country!=''){
        json+= '    "Country": '+'"'+country+'" '+
        '  }, ';
        }
        if(termRef!=''){
            json+='  "SalesTermRef": { '+
                '  "value": '+'"'+termRef+'"'+ 
                '  }, ';
        }
        if(paymentRef!=''){
            json+=        ' "PaymentMethodRef": { '+
                '  "value": '+'"'+paymentRef+'"'+ 
                ' },' ;
        }       
		
		json+='      "MiddleName": "B", '+
		'      "FamilyName": '+'"'+fName+'", '+
		'      "GivenName": '+'"'+lName+'", '+
		/*'      "SyncToken": '+'"'+curSyncToken+'", '+*/
        '      "SyncToken": '+'"'+curSyncToken+'", '+  
		'      "sparse": true'+
		'    } ';

        System.debug('JSON '+json);

        //QB_External_API.updateCustomerAndSync(json,comId,curSyncToken);
        //companyNewData[0].QB_Sync_Token__c+1;
    }
}