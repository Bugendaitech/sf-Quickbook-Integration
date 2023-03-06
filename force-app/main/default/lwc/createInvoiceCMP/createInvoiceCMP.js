import {LightningElement,api,track,wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getBillingAddress from "@salesforce/apex/createInvoiceCtrl.getBillingAddress";
//import getCompanyDetails from "@salesforce/apex/createInvoiceCtrl.getCompanyDetails";
import creatingInvoiceRecord from "@salesforce/apex/createInvoiceCtrl.creatingInvoiceRecord";
import getcondominiumdetails from "@salesforce/apex/createInvoiceCtrl.getcondominiumdetails";
// quote fileds
import QUOTEID from "@salesforce/schema/Quote__c.Id";
import OPQNCLOSED from "@salesforce/schema/Quote__c.Open_Closed__c";
import getAllStaticValues from "@salesforce/apex/BoldLegalUtils.getAllStaticValues"; 

import { updateRecord} from "lightning/uiRecordApi";

export default class CreateInvoiceCMP extends NavigationMixin(LightningElement) {
  
  @track disabledButton=false;
  @api id;
  @api label;
  @api billingAddress;
  @api recordId;
  @api companyId;
  @api cusId; 
  @track spinnerStatus = false;
  @track staticValues = {};
  @track disableInvoiceCreate = false;
  text = `Please make checks payable to 
  BOLD LEGAL DEFENSE INSURANCE, INC.

  2385 NW Executive Center Drive
  Suite 100
  Boca Raton, FL 33431-8579
  (561) 988-1600
  `;

  @track commission = '0';
  @track indicatedPerimum = '0';
  @track selectedOption;
  @track selectedOption2;
  @track quantity = 0;;
  @track rateValue;
  @track street = '';
  @track city = '';
  @track country = '';
  @track postalCode = '';
  @track state = '';
  @track applicantId;
  @track lineItemList = [];
  @track index = 2;
  @track showDelete = false;

  @api paramValue;
  @track grossAmount = 0;
  @track comAmount = 0;
  @track commissionAmount = 0;
  @track discountValue = 0;
  @track finalAmount = 0;
  @track mainGrossAmount = 0.00;
  invoicedate;

  @track _QB_Company_Name__c = '';
  @track _QB_Street_Address__c = '';
  @track _QB_City__c = '';
  @track _QB_Region__c = '';
  @track _QB_Postal_Code__c = '';
  @track _QB_Country__c = '';
  @track _QB_Given_First_Name__c = '';
  @track _QB_Family_Last_Name__c = '';
  @track _QB_Email__c = '';
  @track _QB_Phone_Number__c = '';
  @track _policyRequiredMsg = '';
  @track _salesRepRequiredMsg = '';
  @track _dueDateRequiredMsg = '';
  @track _inceptionRequiredMsg = '';
   _duedateval;

  urlId = null;
  urlLanguage = null;
  quoteId = null;

  sticky = false;
  timeout = 3000;
  @track messageEscaped = null;

 

  rec = {
      key: 1,
      serType: '',
      serDesc: '',
      serAccount: '',
      serQuantiy: this.roundToTwo(1),
      serRate: this.roundToTwo(0),
      serAmount: this.roundToTwo(0),
      showDelete: this.showDelete,
      showAll: true,
      additional : false
  }

  /* get dateValue(){
     if(this.dateval == undefined)
     {
       this.invoicedate = new Date().toISOString().substring(0, 10);
     }
     return this.invoicedate;
   }*/

  get calculateInvoice() {
      const date = new Date();
      //console.log(recordType);

      let day = date.getDate();
      let month = date.getMonth() + 1;
      let year = date.getFullYear();

      // This arrangement can be altered based on how we want the date's format to appear.
      // let currentDate = `${day}-${month}-${year}`;
      let currentDate = `${year}-${month}-${day}`;
      //console.log('CurrentDate::' + currentDate);
      this.invoicedate = currentDate;
      return this.invoicedate;


  }

  // This method will fire the event and pass strText as a payload.
  // call first time 
  connectedCallback() {
       //console.log('createInvoice');
      //console.log('CompanyID '+ this.companyId);
      //console.log('this.paramValue '+ this.recordId);
      getBillingAddress({
              qouteid: this.recordId
          })
          .then(result => {
              //console.log('ResultfromApex '+JSON.stringify(result));
              this.street = result.Applicant_Insured__r.Agent_to_Bill__r.Name + '\n' + result.Applicant_Insured__r.Name + '\n' + result.Applicant_Insured__r.BillingAddress.street;
              this.city = result.Applicant_Insured__r.BillingAddress.city;
              this.state = result.Applicant_Insured__r.BillingAddress.state;
              this.postalCode = result.Applicant_Insured__r.BillingAddress.postalCode;
              this.country = result.Applicant_Insured__r.BillingAddress.country;
              this.indicatedPerimum = result.Applicant_Insured__r.Indicated_Premium__c;
              this.commission = result.Applicant_Insured__r.Commission__c;
              if(this.commission == '' || this.commission == null || this.commission== undefined){
                this.commission = 0;
              }
              //this.grossAmount       = result.Applicant_Insured__r.Indicated_Premium__c;
              this.grossAmount = result.Amount__c;
              //console.log('Gross Amount::'+this.grossAmount );
              this.mainGrossAmount = result.Amount__c;
              this.discountValue = result.Applicant_Insured__r.Discount_Amount__c;
              this.commissionAmount = -result.Applicant_Insured__r.Total_Discount_Value__c;
              this.applicantId = result.Applicant_Insured__c;
              this._duedateval=result.Desired_Attachment_Date__c;
              //console.log('Desired Attachment Date 1::'+result.Desired_Attachment_Date__c);
              //console.log('Attachment Date::'+this._duedateval);

              let grossObj = {
                  key: 1,
                  serType: 'Gross Premium',
                  grossTrue: true,
                  commTrue: false,
                  serDesc: '',
                  serAccount: 'Gross Premium',
                  serQuantiy: this.roundToTwo(1),
                  serRate:    this.roundToTwo(this.grossAmount),
                  serAmountS: this.roundToTwo(this.grossAmount),
                  serAmountR: this.roundToTwo(this.grossAmount),
                  showDelete: this.showDelete,
                  showAll: false,
                  additional : false
              }

              let comObj = {
                  key: 2,
                  serType: 'Commissions',
                  grossTrue: false,
                  commTrue: true,
                  serDesc: '',
                  serAccount: 'Retained Commissions',
                  serQuantiy: this.roundToTwo(1),
                  serRate: this.roundToTwo(this.commission),
                  serAmountS: -this.roundToTwo((this.grossAmount * (1 * this.commission)) / 100),
                  serAmountR: this.roundToTwo((this.grossAmount * (1 * this.commission)) / 100),
                  showDelete: this.showDelete,
                  showAll: false,
                  additional : false
              }


              this.finalAmount = this.roundToTwo((parseFloat(grossObj.serAmountS)) + (parseFloat(comObj.serAmountS))); 

              this.lineItemList.push(JSON.parse(JSON.stringify(grossObj)), JSON.parse(JSON.stringify(comObj)));
              this.spinnerStatus = true;
              //console.log('Line Item '+JSON.stringify(this.lineItemList));
          })
          .catch(error => {
              this.spinnerStatus = true;
              //console.log('ErrorfromApex' + JSON.stringify(error));
          })
        
        
             
            getcondominiumdetails ({applicantId: this.companyId})           
                .then(result => {
                        //console.log(result);
                        this._QB_Company_Name__c = result.Name;
                        this._QB_Street_Address__c = result.Physical_Street_Address__c;
                        this._QB_City__c = result.Physical_City__c ;
                        this._QB_Region__c = result.Physical_State__c;
                        this._QB_Postal_Code__c = result.Physical_Zip_Code__c;
                        this._QB_Country__c = result.Physical_Address_2__c;
                        this._QB_Given_First_Name__c = result.Agent_to_Bill__r.Name;
                        this._QB_Family_Last_Name__c = result.Agent_to_Bill__r.Agency_Name__c;
                        this._QB_Email__c = result.Agent_to_Bill__r.Email;
                        this._QB_Phone_Number__c = result.Agent_to_Bill__r.MobilePhone;
                })
                .catch(error => {
                    //console.log('error'+error);
                })

                getAllStaticValues()
                    .then((result) => { 
                        let data = JSON.parse(result);
                        this.staticValues = data; 
                    })
                    .catch((error) => {
                        
                    })
                    .finally(() => {
                        //console.log('finally')
                    })
 }


  addRow() {
      this.rec.ShowDel = true;
      this.index++;
      var i = this.index;
      this.rec.key = i;
      this.rec.additional = true;
      this.lineItemList.push(JSON.parse(JSON.stringify(this.rec)));
      this.calculateFinalAmount();
  }

  // for removing row 
  removeRow(event) {
      var selectedRow = event.currentTarget;
      var key = selectedRow.dataset.id;
      if (this.lineItemList.length > 2) {
          this.lineItemList.splice(key, 1);
          this.index--;
      } else if (this.lineItemList.length == 2) {
          this.lineItemList = [];
          this.index = 2;
      }
      this.calculateFinalAmount();
  }


  handleServiceChange(event) {
      let selectedRow = event.currentTarget;
      let key = selectedRow.dataset.id;
      this.lineItemList[key].serType = event.target.value;
      if (event.target.value == 'Commissions') { //this.lineItemList[key].commTrue   = true;      
          this.lineItemList[key].serAccount = 'Retained Commissions';
          this.lineItemList[key].serAmountS = -0.00;
      } else {
          this.lineItemList[key].serAccount = event.target.value;
      }
  }

  handleDescChange(event) {
      let selectedRow = event.currentTarget;
      let key = selectedRow.dataset.id;
      this.lineItemList[key].serDesc = event.target.value;
  }

  handleQuantityChange(event) {
      let selectedRow = event.currentTarget;
      let key = selectedRow.dataset.id;
      this.lineItemList[key].serQuantiy = this.roundToTwo(event.target.value);
      if (this.lineItemList[key].serType == 'Commissions') {
          //this.roundToTwo((this.grossAmount*(comQty*comRate))/100);   4000/100 * 1 * 10
          let grossForCom                   = this.lineItemList[key-1].serAmountR;
          this.lineItemList[key].serAmountS = -this.roundToTwo((grossForCom * (this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy)) / 100);
          this.lineItemList[key].serAmountR = this.roundToTwo((grossForCom * (this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy)) / 100);
      } else if (this.lineItemList[key].serType == 'Gross Premium') {
          this.lineItemList[key].serAmountS = this.roundToTwo((this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy));
          this.lineItemList[key].serAmountR = this.roundToTwo((this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy));
          this.mainGrossAmount = this.lineItemList[key].serAmountR;
      }
      this.calculateFinalAmount();
  }

  handleRateChange(event) {
      let selectedRow = event.currentTarget;
      let key = selectedRow.dataset.id;
      this.lineItemList[key].serRate = this.roundToTwo(event.target.value);
      if (this.lineItemList[key].serType == 'Commissions') {
          let grossForCom                   = this.lineItemList[key-1].serAmountR;
          this.lineItemList[key].serAmountS = -this.roundToTwo((grossForCom * (this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy)) / 100);
          this.lineItemList[key].serAmountR = this.roundToTwo((grossForCom * (this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy)) / 100);
      } else if (this.lineItemList[key].serType == 'Gross Premium') {
          //console.log('called ');
          this.lineItemList[key].serAmountS = this.roundToTwo((this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy));
          this.lineItemList[key].serAmountR = this.roundToTwo((this.lineItemList[key].serRate) * (this.lineItemList[key].serQuantiy));
          this.mainGrossAmount = this.lineItemList[key].serAmountR;
      }
      this.calculateFinalAmount();
  }

  roundToTwo(convertNum) {
      if (convertNum == '') {
          convertNum = 0;
      }
      return parseFloat(convertNum).toFixed(2);
      //return +(Math.round(conNum + "e+2")  + "e-2");
  }

  calculateFinalAmount() {
      //let grossAmt = this.mainGrossAmount;
      let amountS = 0.00;
      let amountR = 0.00;
      // recalculate commision 
      this.lineItemList = this.lineItemList.map(function(curItem, index, actArr) {
          if (curItem.serType == 'Commissions') {
            
              let grossAmt = actArr[index-1].serAmountR;
              amountS = -((grossAmt * (curItem.serRate) * (curItem.serQuantiy)) / 100);
              amountR =  ((grossAmt * (curItem.serRate) * (curItem.serQuantiy)) / 100);
          } else if (curItem.serType == 'Gross Premium') {
              amountS = actArr[index].serAmountR;
              amountR = actArr[index].serAmountR;
          } else {
              amountS = 0.00;
              amountR = 0.00;
          }
          return {
              ...curItem,
              'serAmountR': amountR,
              'serAmountS': amountS
          }
      });

      let finalTotal = this.lineItemList.reduce(function(total, currVal, idx, actArr) {
          return total + parseFloat(currVal.serAmountS);
      }, 0);

      this.finalAmount = this.roundToTwo(finalTotal);
  }

  showToastNotification(type, message) {
      this.template
          .querySelector("c-custom-toast-notification")
          .showToast(type, message);
  }


  // create invoice function
  createInvoiceHandler() {
    //console.log('called Invoice Handler');
      this._dueDateRequiredMsg = '';
      this._inceptionRequiredMsg = '';
      this._policyRequiredMsg = '';
      this._salesRepRequiredMsg = '';
      let anyError = false;  //true
      //console.log('called Invoice Handler 1');
      this.spinnerStatus = false;
      let term = this.template.querySelector("[data-field='term']").value;
      //console.log('Yes ');
      let invoiceDate = this.template.querySelector("[data-field='invoice-date']").value;
      //console.log('Yes ');
      let email = this.template.querySelector("[data-field='email']").value;
      //console.log('Yes ');
      let dueDate = this.template.querySelector("[data-field='due-date']").value;
      //console.log('Yes ');
      let policy = this.template.querySelector("[data-field='policy']").value;
      //console.log('Yes ');
      let salesRep = this.template.querySelector("[data-field='sales-rep']").value;
      //console.log('Yes ');
      let inceptionDate = this.template.querySelector("[data-field='inception-date']").value;
      //console.log('Yes ');
      let street = this.template.querySelector("[data-field='street']").value;
      //console.log('Yes ');
      let city = this.template.querySelector("[data-field='city']").value;
      //console.log('Yes ');
      let state = this.template.querySelector("[data-field='state']").value;
      //console.log('Yes ');
      let postalCode = this.template.querySelector("[data-field='postal-code']").value;
      //console.log('Yes ');
      let country = this.template.querySelector("[data-field='country']").value;
      //console.log('Yes ');
      let statement = this.template.querySelector("[data-field='statement']").value;
      //console.log('Yes ');
      let applicant = this.applicantId;
      //console.log('Yes ');
      let message   = this.template.querySelector("[data-field='message']").value;
      //console.log('Yes ');

      //console.log('After  1');

      let invoiceObj = new Object();

      //invoiceObj.QB_Company__c = this.companyId;
      invoiceObj.Type__c = 'Invoice';
      invoiceObj.Total_Tax__c = 0.00;
      invoiceObj.Shipping_Charges__c = 0.00;
      invoiceObj.Amount_Received__c = 0.00;

      //console.log('After  2');
        
      invoiceObj.Message_Displayed__c = message; 
      
      if(this.staticValues.siteURL.includes('sandbox')){
        invoiceObj.QBO_Org_Name__c      ='Sandbox Company';
      }else{
        invoiceObj.QBO_Org_Name__c      ='Bold Legal Defense';
      }
      
      this.messageEscaped             = message.replace(/\n/g, "\\n");
      
      //console.log('After  3');
      //console.log('Due Date value:'+dueDate);
      if (dueDate != null && dueDate != '') {
          invoiceObj.Due_Date__c = dueDate;

      } else {
          this._dueDateRequiredMsg = 'This Field is Required';
          anyError = true;
          this.spinnerStatus = true;
      }

      //console.log('After  4');

      if (term != '') {
          invoiceObj.Terms__c = term;
      } else {
          invoiceObj.Terms__c = '';
      }
      //console.log('After  5');

      if (applicant != '') {
          invoiceObj.Account__c = applicant;
      } else {
          invoiceObj.Account__c = '';
      }
      invoiceObj.Name = 'INV';
      //console.log('After  6');
      if (invoiceDate != null) {
          invoiceObj.Invoice_Date__c = invoiceDate;
      }

      //console.log('After  7');
      if (inceptionDate != null && inceptionDate != '') {
          invoiceObj.InceptionDate__c = inceptionDate;
      } else {
          this._inceptionRequiredMsg = 'This Field is Required';
          anyError = true;
          this.spinnerStatus = true;
      }

      invoiceObj.Email__c = email;
      //console.log('After  8');

      if (email == '') {
          // anyError                              = true;
          invoiceObj.Email_Status__c = 'NotSet';
          // this.showToastNotification('error','Email is a required Field, Please Fill Email');
      } else {
          invoiceObj.Email_Status__c = 'NeedToSend'; 
      }
      if (state != null) {
          invoiceObj.Billing_State__c = state;
      } else {
          invoiceObj.Billing_State__c = '';
      }
      if (city != null) {
          invoiceObj.Billing_City__c = city;
      } else {
          invoiceObj.Billing_City__c = '';
      }
      if (country != null) {
          invoiceObj.Billing_Country__c = country;
      } else {
          invoiceObj.Billing_Country__c = '';
      }
      if (postalCode != null) {
          invoiceObj.Billing_Postal_Code__c = postalCode;
      } else {
          invoiceObj.Billing_Postal_Code__c = '';
      }
      if (street != null) {
          invoiceObj.Billing_Street_Address__c = street;
      } else {
          invoiceObj.Billing_Street_Address__c = '';
      }
      if (salesRep != null && salesRep != '') {
          invoiceObj.Sales_Rep__c = salesRep;
      }

      if (policy != null && policy != '') {
          invoiceObj.Policy__c = policy;
      } else {
          //invoiceObj.Policy__c                  ='';  
          this._policyRequiredMsg = 'This Field is Required';
          anyError = true;
          this.spinnerStatus = true;
      }
      //invoiceObj.Sub_Total__c               = '';
      if (this.finalAmount != null) {
          invoiceObj.Amount_Due__c = this.finalAmount;
      } else {
          invoiceObj.Amount_Due__c = '';
      }
      if (this.finalAmount != null) {
          invoiceObj.Total__c = this.finalAmount;
      } else {
          invoiceObj.Total__c = '';
      }
      if (statement != null) {
          invoiceObj.Statement_Memo__c = statement;
      } else {
          invoiceObj.Statement_Memo__c = '';
      }

      //console.log('After 9');
      // line items
      let lineItemDataList = [];
      let readyToInsert = true;
      let blankRow = this.lineItemList;
      if (blankRow.length > 0) {
            //console.log('After  length');
            for (let i = 0; i < blankRow.length; i++) {
                if (blankRow[i] !== undefined) {
                  if (blankRow[i].serType.length == undefined) {
                      readyToInsert = false;
                  }
                  let itemData = new Object();

                  itemData.Rate__c              = this.roundToTwo(parseFloat(blankRow[i].serAmountS)/parseFloat(blankRow[i].serQuantiy));
                  itemData.Amount__c            = blankRow[i].serAmountS;
                  itemData.Product_Service__c   = blankRow[i].serType;
                  itemData.Quantity__c          = blankRow[i].serQuantiy;
                  itemData.Line_Number__c       = i;
 
                  if (blankRow[i].serDesc != null && blankRow[i].serDesc != '') {
                      itemData.Description__c = blankRow[i].serDesc;
                  } else {
                      itemData.Description__c = '';
                  }
                  lineItemDataList.push(itemData);
                }
            }
      }

    console.log('Here '+JSON.stringify(invoiceObj));
    console.log('Here Inv List Item '+JSON.stringify(lineItemDataList));
    //anyError = true;
      if (!anyError) {
        this.disableInvoiceCreate = true;
        console.log('After disableInvoiceCreate ');
          creatingInvoiceRecord({
                  invoiceData:  JSON.stringify(invoiceObj),
                  lineItemData: JSON.stringify(lineItemDataList) 
              })
              .then((result) => {
                  console.log('then 1 ' + result);
 
                  let componentDef = {
                    componentDef: "c:viewInvoiceCMP",
                    attributes: {
                      label: "Navigated",
                      recordId: result
                    }
                  };
                  
                  let encodedComponentDef = btoa(JSON.stringify(componentDef)); 
                  let redirectUrl = this.staticValues.siteURL+''+encodedComponentDef;
                    //console.log(redirectUrl+' URL');
                    
                    const fields = {};
                    fields[QUOTEID.fieldApiName] = this.recordId;
                    fields[OPQNCLOSED.fieldApiName] = 'Closed';
                    const recordInput = { fields };
                    //console.log(JSON.stringify(recordInput));
                    updateRecord(recordInput)
                    .then(() => { 
                      //console.log('then 2');              
                      this.showToastNotification('success','Invoice Created Successfully.');
                      setTimeout(function(){                    
                        window.location.assign(redirectUrl);
                      },3000);
                      //window.location.assign('https://bold--bugendai.sandbox.lightning.force.com/lightning/r/Quote__c/'+this.recordId+'/view');
                    })
                    .catch((error) => {            
                      //console.log('catch 2');    
                      this.showToastNotification('error',error.body.message);
                    })
                    .finally(() => { 
                      //console.log('finally 2');
                      this.spinnerStatus = true;
                    });  

              })
              .catch((error) => {
                  //console.log('catch 1');
                  this.showToastNotification('error', 'Please Fill All Required Fields.');
              })
              .finally(() => {
                  //console.log('finally 1');
                  this.spinnerStatus = true;
              });
      }

      //
  }


}