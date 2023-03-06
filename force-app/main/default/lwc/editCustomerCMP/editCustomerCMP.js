import { LightningElement,api,track, wire } from 'lwc';
import getAllDetailsOfApplicant from "@salesforce/apex/EditCustomerCtrl.getAllDetailsOfApplicant";
import UpdateCustomer from "@salesforce/apex/EditCustomerCtrl.UpdateCustomer";

export default class EditCustomerCMP extends LightningElement {
   
    @api editId;
    @track _firstName     = '';
    @track _lastName      = '';
    @track _email         = '';  
    @track _street        = '';
    @track _city          = '';
    @track _state         = '';
    @track _postalCode    = '';
    @track _country       = '';
    @track _phone         = '';
    @track _companyName   = '';
    @track _applicant     = '';
    @track havePro        = true;


 connectedCallback() {
        console.log('editCustomerCMP');
        console.log('this.paramValue '+this.editId);
        getAllDetailsOfApplicant({ 
            qouteid : this.editId
         })
         .then(result =>{
             console.log('ResultfromApex New SS '+JSON.stringify(result));  
                    
                    let checkPro =    result.QB_Salesforce_Account__r.Agent_to_Bill__c;
                    if(checkPro!=''){
                        this.havePro  = false;
                        this._applicant     = result.QB_Salesforce_Account__c;
                        this._companyName   = result. QB_Company_Name__c;
                        this._firstName     = result.QB_Given_First_Name__c;
                        this._lastName      = result.QB_Family_Last_Name__c	;
                        this._email         = result.QB_Email__c	; 
                        this._street        = result.QB_Street_Address__c	;
                        this._city          = result.QB_City__c	;
                        this._state         = result.QB_Region__c	;
                        this._postalCode    = result.QB_Postal_Code__c	;
                        this._country       = result.QB_Country__c	;
                        this._phone         = result.QB_Salesforce_Account__r.Agent_Phone_Application__c;
                        this.spinnerStatus  = true;
                    }  
                  
         })
         .catch(error =>{
             this.spinnerStatus = true;  
             console.log('ErrorfromApex'+JSON.stringify(error));
         })      
         

        }

        handleUpdateCustomer(){

       
        let fName        = this.template.querySelector("[data-field='FName']").value;
        let lName        = this.template.querySelector("[data-field='LName']").value;
        let Name         = fName+' '+lName;
        let Email        = this.template.querySelector("[data-field='email']").value;
        let Phone        = this.template.querySelector("[data-field='phone']").value;
        let Mobile       = this.template.querySelector("[data-field='mobile']").value;
        let State        = this.template.querySelector("[data-field='state']").value;
        let City         = this.template.querySelector("[data-field='city']").value;
        let PostCode     = this.template.querySelector("[data-field='postcode']").value;
        let Street       = this.template.querySelector("[data-field='street']").value;
        let Country      = this.template.querySelector("[data-field='country']").value;
        let CompanyName  = this.template.querySelector("[data-field='company']").value;
        let displayName  = this.template.querySelector("[data-field='displayName']").value;
        let paymentMethod= this.template.querySelector("[data-field='paymentMethod']").value;
        let terms        = this.template.querySelector("[data-field='terms']").value; 

        let com                        = new Object();  
        com.id                         = this.editId
        com.QB_Company_Name__c         = CompanyName;
        com.QB_Display_Name__c         = displayName;
        com.QB_Given_First_Name__c     = fName;
        com.QB_Family_Last_Name__c     = lName;
        com.QB_Email__c                = Email;
        com.QB_Phone_Number__c         = Phone;
        com.QB_Other_Phone_Number__c   = Mobile;
        com.QB_Status__c               = 'ACTIVE';
        com.QB_City__c                 = City;
        com.QB_Country__c              = Country;
        com.QB_Postal_Code__c          = PostCode;
        com.QB_Region__c               = State;
        com.QB_Street_Address__c       = Street;
        com.QB_Currency__c             = 'USD';
        com.QB_Taxable__c              = false;
        com.QB_Salesforce_Account__c   = this._applicant;
        com.QB_Preferred_Delivery_Method__c = paymentMethod;
        com.QB_Default_Terms_Ref__c         = terms;

        // for parent company if we have
        if(this.showParentSelect){             
          com.QB_Sync_Status__c          = 'Affiliated with SF Account';
          com.QB_Bill_with_Parent__c     = false;
          com.QB_Fully_Qualified_Name__c = this.selectedCompany+' : '+CompanyName;
          com.QB_ParentRef__c            = this.selectedCompanyId;
          com.QB_Company_Name__c         = this.selectedCompany;
          //Name                           = this.selectedCompany+' : '+CompanyName;
         
          // com.QB_Display_Name__c         = this.selectedCompany;            
         // displayName         = this.selectedCompany;         
        }

        //console.log('Compnay Data  '+JSON.stringify(com));
    
    let JSONString = '{'+
            //'  "FullyQualifiedName": '+'"'+Name+'", \n'+
            '  "PrimaryEmailAddr": {'+
            '    "Address": '+'"'+Email+'"'+ 
            '  }, '+
            '  "DisplayName": '+'"'+displayName+'", \n'+ 
            '  "FamilyName": '+'"'+lName+'", \n'+
            '  "PrimaryPhone": {'+
            '    "FreeFormNumber": '+'"'+Phone+'"'+ 
            '  }, '+
            '  "SalesTermRef": { '+
            '  "value": '+'"'+terms+'"'+ 
            '  }, '+
            ' "PaymentMethodRef": { '+
            '  "value": '+'"'+paymentMethod+'"'+ 
            ' },' +
            '  "Mobile": { '+
            '  "FreeFormNumber": '+'"'+Mobile+'"'+ 
            '  }, '+
            '  "CompanyName": '+'"'+CompanyName+'", \n'+
            '  "BillAddr": {'+
            '    "CountrySubDivisionCode": '+'"'+State+'", '+
            '    "City": '+'"'+City+'", '+
            '    "PostalCode":'+'"'+PostCode+'", '+
            '    "Line1": '+'"'+Street+'", '+
            '    "Country": '+'"'+Country+'" ';
            

            // start if we have parent
            // console.log('Here '+this.showParentSelect);
            if(this.showParentSelect){
              JSONString+=' }, '+
              ' "Job": true, '+
              ' "BillWithParent": true, '+
              ' "ParentRef": { '+
              '  "value": '+'"'+this.selectedCompanyId+'" '+
              ' } ';
            }else{
              JSONString+='  } ';
            }                
            // end if we have parent

            // JSONString+='  "GivenName": '+'"'+Name+'" '+
            // '}';
            JSONString+='  } ';
            
    
            // console.log('Applicant  '+this._applicant);
             console.log('Data '+JSONString);


             UpdateCustomer({companyData : JSON.stringify(com)})
        .then((result) => { 
          //console.log('Result '+result);
          if(result=='error'){
            this.showToastNotification('error',result);
          }else{      
             let resVal =result;
            console.log('Result::'+resVal);
            this.sendValues(resVal);         
            this.showToastNotification('success','Customer Updated Successfully.');               
          }
        })
        .catch((error) => {  
          console.log('Catch '+JSON.stringify(error));
          this.showToastNotification('error','Something wrong, Please Try Again.');
        })            
        .finally(() => {
          console.log('finally 1');
          this.spinnerStatus = true; 
          this.template.querySelector("[data-field='FName']").value = fName;
          this.template.querySelector("[data-field='LName']").value = lName;
          this.template.querySelector("[data-field='company']").value = CompanyName;
          this.template.querySelector("[data-field='displayName']").value = displayName;

        });    
      }
      sendValues(resVal) {
        // console.log('caalled');
         const oEvent = new CustomEvent('editinvoicetoupdate',
             {
                 'detail': resVal
             }
         );
         this.dispatchEvent(oEvent);
     }
    }