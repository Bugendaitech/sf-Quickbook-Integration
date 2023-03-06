import {  LightningElement, api,  track,  wire } from 'lwc';

import getAllDetails from "@salesforce/apex/createCustomerCtrl.getAllDetails";
import creatingCustomer from "@salesforce/apex/createCustomerCtrl.creatingCustomer";
import getAllStaticValues from "@salesforce/apex/BoldLegalUtils.getAllStaticValues";  


export default class CreateNewCustomerCMP extends LightningElement {

  @track selectedCompany = '';
  @track selectedCompanyId = '';

  @api recordId;
  @api editId;
  @track isModalOpenAss = false;
  @track showParentSelect = true; //false
  @track isEModalOpenAss = false;
  @track havePro = true;
  @track spinnerStatus = false;
  @track _firstName = '';
  @track _lastName = '';
  @track _email = '';
  @track _street = '';
  @track _city = '';
  @track _state = '';
  @track _postalCode = '';
  @track _country = '';
  @track _phone = '';
  @track _companyName = '';
  @track _applicant = '';
  @track records = [];
  @track associated = [];
  @track unassociated = [];
  @track con = [];
  serachKey = '';
  @track _producerName = '';
  @track _producerId = '';
  @track _parentQBId = '';
  @track insuredrecordtypeId = '5000000000000051989';

  sticky = false;
  timeout = 3000;
  @track staticValues;

  connectedCallback() {
    //      //console.log('createNewCustomerCMP');
    //      //console.log('2');
      //   //console.log('this.paramValue '+this.recordId);
      getAllDetails({
              qouteid: this.recordId
          })
          .then(result => {
              //   //console.log('ResultfromApex New SS ' + JSON.stringify(result));

              
                  this.havePro = false;
                  
                  // producre details
                  this._producerId   = result.Producer__r.Id;
                  this._producerName = result.Producer__r.Name; 
                  this._firstName    = result.Producer__r.FirstName == undefined ? '' : result.Producer__r.FirstName;                 
                  this._lastName     = result.Producer__r.LastName == undefined ? '' : result.Producer__r.LastName;                  
                  this._email        = result.Producer__r.Email == undefined ? '' : result.Producer__r.Email;

                  // insured details                       
                  this._parentQBId  = result.Applicant_Insured__r.QB_Parent_Id__c;            
                  this._applicant   = result.Applicant_Insured__c;
                  this._companyName = result.Applicant_Insured__r.Name == undefined ? '' : result.Applicant_Insured__r.Name ; 
                  this._street      = result.Applicant_Insured__r.BillingAddress.street == undefined ? '' : result.Applicant_Insured__r.BillingAddress.street;                 
                  this._city        = result.Applicant_Insured__r.BillingAddress.city == undefined ? '' : result.Applicant_Insured__r.BillingAddress.city;                 
                  this._state       = result.Applicant_Insured__r.BillingAddress.state == undefined ? '' : result.Applicant_Insured__r.BillingAddress.state;                 
                  this._postalCode  = result.Applicant_Insured__r.BillingAddress.postalCode == undefined ? '' : result.Applicant_Insured__r.BillingAddress.postalCode;                 
                  this._country     = result.Applicant_Insured__r.BillingAddress.country == undefined ? '' : result.Applicant_Insured__r.BillingAddress.country;                 
                  this._phone       = result.Applicant_Insured__r.Agent_Phone_Application__c == undefined ? '' : result.Applicant_Insured__r.Agent_Phone_Application__c;                 
                  this.selectedCompany = result.Producer__r.Agency_Name__c == undefined ? '' : result.Producer__r.Agency_Name__c;
                

          })
          .catch(error => {
              this.spinnerStatus = true;
            //      //console.log('ErrorfromApex' + JSON.stringify(error));
          }).finally(()=>{
              this.spinnerStatus  = true;
          })

          getAllStaticValues()
            .then((result) => {  
                let data = JSON.parse(result);
                this.staticValues = data; 
            })
            .catch((error) => {
                
            })
            .finally(() => {
                //   //console.log('finally')
            })


  }
  


  get modalClassAss() {
      return this.isModalOpenAss ?
          "slds-modal slds-modal_large slds-fade-in-open" :
          "slds-modal";
  }

  get modalBackdropClassAss() {
      return this.isModalOpenAss ?
          "slds-backdrop slds-p-around_medium slds-modal_large slds-backdrop_open" :
          "slds-backdrop";
  }

  showModalAssignment(event) {
      this.isModalOpenAss = true;
  }

  closeModalAssignment() {
      this.isModalOpenAss = false;
  }

  stopSpinner() {
      setTimeout(function() {
          this.spinnerStatus = true;
      }, 3000)
  }

  onchangeCompany(event) {
      let curVal = event.target.value;
      //alert('This '+curVal);
      if (curVal == 'Create a Sub-Company or Project under a Company') {
          this.showParentSelect = true;
      } else {
          this.selectedCompanyId = '';
          this.selectedCompany = '';
          this.showParentSelect = false;
      }
  }


  selectCompany(event) {
      let comId = event.target.dataset.id;
      let comName = event.target.dataset.name;
    //      //console.log('Com ' + comId + ' comname ' + comName);
      this.selectedCompany = comName;
      this.selectedCompanyId = comId;
      this.closeModalAssignment();
  }

  // create new customer
  handleCreateCustomer() {


      this.spinnerStatus = false;
         //console.log('called Btn 1 '+JSON.stringify(this.staticValues)); 
      let fName = this.template.querySelector("[data-field='FName']").value;         
      let lName = this.template.querySelector("[data-field='LName']").value;          
      let Email = this.template.querySelector("[data-field='email']").value;         
      let Phone = this.template.querySelector("[data-field='phone']").value;         
      let Mobile = this.template.querySelector("[data-field='mobile']").value;         
      let State = this.template.querySelector("[data-field='state']").value;         
      let City  = this.template.querySelector("[data-field='city']").value;         
      let PostCode = this.template.querySelector("[data-field='postcode']").value;         
      let Street = this.template.querySelector("[data-field='street']").value;         
      let Country = this.template.querySelector("[data-field='country']").value;         
      let CompanyName = this.template.querySelector("[data-field='company']").value;          
      let displayName = CompanyName; 
         
      let paymentMethod ='1';
         
      let terms         ='1';
         //console.log('Yes '+this.staticValues.qbInsuredRecTypeId);
      
      let streetAddress = Street.replace(/[\r\n]/gm, '');
      //   //console.log('Compnay Data  '+JSON.stringify(com));

      let JSONString = '{' +
          //'  "FullyQualifiedName": '+'"'+Name+'", \n'+
          '  "PrimaryEmailAddr": {' +
          '    "Address": ' + '"' + Email + '"' +
          '  }, ' +
          '  "DisplayName": ' + '"' + displayName + '", \n' +
          '  "FamilyName": ' + '"' + lName + '", \n' +
          '  "PrimaryPhone": {' +
          '    "FreeFormNumber": ' + '"' + Phone + '"' +
          '  }, ' +
          '  "SalesTermRef": { ' +
          '  "value": ' + '"' + this.staticValues.qbSalesTermId + '"' +
          '  }, ' +
          ' "PaymentMethodRef": { ' +
          '  "value": ' + '"' + this.staticValues.qbPaymentMethodRefId + '"' +
          ' },' +
          '  "Mobile": { ' +
          '  "FreeFormNumber": ' + '"' + Mobile + '"' +
          '  }, ' +
          '  "CompanyName": ' + '"' + CompanyName + '", \n' +
          '  "BillAddr": {' +
          '    "CountrySubDivisionCode": ' + '"' + State + '", ' +
          '    "City": ' + '"' + City + '", ' +
          '    "PostalCode":' + '"' + PostCode + '", ' +
          '    "Line1": ' + '"' + streetAddress + '", ' +
          '    "Country": ' + '"' + Country + '" ';


      // start if we have parent 
      if (true) {
          JSONString += ' }, ' +
              ' "Job": true, ' +
              ' "BillWithParent": true, ' +
              ' "ParentRef": { ' +
              '  "value": ' + '"' + this._parentQBId + '" ' +
              ' }, ' +
              ' "CustomerTypeRef": {' +
              ' "value": ' + '"' + this.staticValues.qbInsuredRecTypeId + '"' +
              '}';
      } else {
          JSONString += '  } ';
      }
      // end if we have parent

      // JSONString+='  "GivenName": '+'"'+Name+'" '+
      // '}';
      JSONString += '  } ';


    //      //console.log('Applicant  '+this._applicant)
    //      //console.log('Data '+JSONString); 
        
      creatingCustomer({
              customerData: JSONString,
              accId: this._applicant,
              accName: CompanyName
          })
          .then((result) => {
              //console.log('Result '+result);
              if (result == 'Customer with this Name, already Exists. Please Try With Different Company Name') {
                  this.showToastNotification('error', result);
              } else {
                  this.showToastNotification('success', 'Customer Created Successfully.');
                  let newCustID = result;
                     //console.log('Result::' + newCustID);
                  this.sendValues(newCustID);
              }
          })
          .catch((error) => {
              console.log('Catch ' + JSON.stringify(error));
              this.showToastNotification('error', 'Something wrong, Please Try Again.');
          })
          .finally(() => {
            //      //console.log('finally 1');
              this.spinnerStatus = true;
              this.template.querySelector("[data-field='FName']").value = fName;
              this.template.querySelector("[data-field='LName']").value = lName;
              this.template.querySelector("[data-field='company']").value = CompanyName;
              //this.template.querySelector("[data-field='displayName']").value = displayName;

          });




      //createAccount({customerData : JSONString})


  }

  //send new Customer Value to newCustomerCMP
  sendValues(newCustID) {
    //      //console.log('called ' + newCustID);
      const oEvent = new CustomEvent('custval', {
          'detail': newCustID
      });
      this.dispatchEvent(oEvent);
  }

  showToastNotification(type, message) {
      this.template
          .querySelector("c-custom-toast-notification")
          .showToast(type, message);
  }

  handleSearch(event) {
      this.serachKey = event.target.value;
      //send to method

      if (this.serachKey.length >= 3) {
          getDisplayByNameFilter({
                  searchKey: this.serachKey
              })
              .then(res => {
                //      //console.log(res);
                  this.unassociated = JSON.parse(res);
                  this.spinnerStatus = true;
              })
              .catch(err => {
                  this.spinnerStatus = true;
              });
      } else if (this.serachKey.length == 0) {
          this.serachKey = '';
          this.unassociated = this.records;
      } else {
          this.spinnerStatus = true;
          this.unassociated = this.records;
      }
  }

}