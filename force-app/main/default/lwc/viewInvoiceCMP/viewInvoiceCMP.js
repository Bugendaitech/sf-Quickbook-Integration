import { LightningElement, wire ,track, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getInvoiceDetails from '@salesforce/apex/ViewInvoiceCtrl.getInvoiceDetails';
import generatePdf from '@salesforce/apex/ViewInvoiceCtrl.generatePdf';
import generatePLPolicyPdf from '@salesforce/apex/ViewInvoiceCtrl.generatePLPolicyPdf';
import UpdateQB from '@salesforce/apex/ViewInvoiceCtrl.UpdateQB';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import downloadjs1 from '@salesforce/resourceUrl/downloadjs1';
import { loadScript } from "lightning/platformResourceLoader";
import { refreshApex } from '@salesforce/apex';


import { updateRecord } from 'lightning/uiRecordApi';
import QBLine from '@salesforce/schema/QB_Line_Item__c';
import QBInv from '@salesforce/schema/QB_Line_Item__c.Invoice__c';
import Rate from '@salesforce/schema/QB_Line_Item__c.Rate__c';
import Quantity from '@salesforce/schema/QB_Line_Item__c.Quantity__c';
import Amount from '@salesforce/schema/QB_Line_Item__c.Amount__c';
import Products from '@salesforce/schema/QB_Line_Item__c.Product_Service__c';
import Description from '@salesforce/schema/QB_Line_Item__c.Description__c';



export default class ViewInvoiceCMP extends NavigationMixin(LightningElement)  {
    
    @api recordId;
    @track spinnerStatus = true;
    @track records = [];
    @track LineItems = [];
    @track accName = '';
    @track policyName = '';
    @track accountName = '';
    @track grossVal ;
    @track commVal ;
    @track finalAmount = 0;
    @track thisInvDate;
    @track thisIncDate;

    @track isModalOpenAss = false;
    @track hideDownloadPDFButton = false;

    get modalClassAss() {
        return this.isModalOpenAss ?
            "slds-modal slds-modal_small slds-fade-in-open" :
            "slds-modal";
    }

    get modalBackdropClassAss() {
        return this.isModalOpenAss ?
            "slds-backdrop slds-p-around_medium slds-modal_small slds-backdrop_open" :
            "slds-backdrop";
    }
    
   
   

    _wiredMyData;
    @wire(getInvoiceDetails, { invId: '$recordId' })
    wireInvoiceData(wireResultMy) { 
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;   
        let Invdate;
        let Incdate;
          //console.log(data);
            if (data) {   
                if (data.length > 0) {
                    //data = JSON.parse(data);
                    this.records   = JSON.parse(data); 
                    this.accName   = this.records.name;   
                    //this.accName   = this.records.name;  
                    this.policyName = this.records.policy; 
                    this.accountName = this.records.accountName                 
                    //this.accName   =this.recordId.accountName;   
                   // console.log(this.records);                 
                    this.LineItems = this.records.LineItems;
                    Invdate = this.records.invoiceDate;  
                    Incdate = this.records.inceptionDate;  
                    this.LineItems = this.records.LineItems;

                    this.spinnerStatus = true;  
                } else if (data.length == 0) {
                    this.records = []; 
                    this.spinnerStatus = true;
                }
            } else if (error) {
                this.error = error;
                console.log('Error'+JSON.stringify(error));
                this.spinnerStatus = true;
            }
    }

    _wiredMyData;
    @wire(getInvoiceDetails, { invId: '$recordId.recordId' })
    wireInvoiceDataFromApplicant(wireResultMy) { 
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;   
        let Invdate;
        let Incdate;
          console.log('invoice Data'+data);
            if (data) {   
                if (data.length > 0) {
                    //data = JSON.parse(data);
                    this.records   = JSON.parse(data); 
                    this.accName   = this.records.name;  
                    this.policyName = this.records.policy; 
                    this.accountName = this.records.accountName   
                    //console.log('this.records.policy'+this.records.policy+'this.records.insuredName'+this.records.insuredName);             
                    //this.accName   =this.recordId.accountName;   
                    console.log(this.records);                 
                    this.LineItems = this.records.LineItems;
                    Invdate = this.records.invoiceDate;  
                    Incdate = this.records.inceptionDate;  
                    this.LineItems = this.records.LineItems;
                     
 
                    this.spinnerStatus = true;  
                } else if (data.length == 0) {
                    this.records = []; 
                    this.spinnerStatus = true;
                }
            } else if (error) {
                this.error = error;
                console.log('Error'+JSON.stringify(error));
                this.spinnerStatus = true;
            }
    }
  

   dateformat(inputDate) {
   // console.log(inputDate+' Id');
      var date = new Date(inputDate);
      if (!isNaN(date.getTime())) {
          // Months use 0 index.
          return date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear();
      }
  }

    goBackHandler(){
      let componentDef;
      if(this.recordId.from == 'Account'){
        this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
              recordId: this.recordId.accountRecId,
              objectApiName: 'Account',
              actionName: 'view'
          }
      });
      }
      else{
        componentDef = {
            componentDef: "c:invoiceListCMP",
            attributes: {
              label: "Navigated",
            //   recordId: event.currentTarget.dataset.id
            }
          };
      
          let encodedComponentDef = btoa(JSON.stringify(componentDef));
          this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
              url: "/one/one.app#" + encodedComponentDef
            }
          });
        }
      }

    cashMemoHandler(event){ 
      // console.log('Hey '+event.currentTarget.dataset.id);
      //   let componentDef = {
      //       componentDef: "c:cashMemoCMP",
      //       attributes: {
      //         label: "Navigated",
      //         recordId: event.currentTarget.dataset.id
      //       }
      //     };
      
      //     let encodedComponentDef = btoa(JSON.stringify(componentDef));
      //     this[NavigationMixin.Navigate]({
      //       type: "standard__webPage",
      //       attributes: {
      //         url: "/one/one.app#" + encodedComponentDef
      //       }
      //     });
      //this.handleUpdate();
     UpdateQB({ invId: this.recordId }).then((result) => {
              this.records.totalAmount=0.00;
              const toastEvent = new ShowToastEvent({
              title   : "Success",
              message : "Successfully Voided.",
              variant : "success",
              });
              dispatchEvent(toastEvent); 
              return refreshApex(this._wiredMyData);
     })
     .catch(error => {
        const toastEvent = new ShowToastEvent({
          title   : "Error",
            message : "Something wrong, Please Try Again.",
            variant : "error",
        });
      dispatchEvent(toastEvent);
  })
        .finally(() => {
           // this.spinnerStatus = true;
            return refreshApex(this._wiredMyData);
        });
    }

    lineItemHandler(event){      
        this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
              recordId: event.currentTarget.dataset.id,
              objectApiName: 'QB_Line_Item__c',
              actionName: 'view'
          },
      });
    }

    // DownloadInvoiceasPDF(event){
    //   generatePdf({invId: this.recordId})
    //   .then(result => {
    //   //console.log('result'+result);
    //     if(result){
    //     //console.log('inside');
    //     var strFile = "data:application/pdf;base64,"+result;
    //     window.download(strFile, this.accName+".pdf", "application/pdf");
    //     }

    // }).catch(error => {
    //   //console.log('Error: ' +JSON.stringify(error));
    // });
    // }

    async DownloadInvoiceasPDF(event){      
      let pdfdownload =  
       generatePdf({invId: this.recordId})
      .then(result => {
        if(result){
        let strFile = "data:application/pdf;base64,"+result;
        window.download(strFile, this.accName+".pdf", "application/pdf");
        }
    }).catch(error => {
      //console.log('Error: ' +JSON.stringify(error));
    });
 

 
  let plpolicy  =  generatePLPolicyPdf({invId: this.recordId})
      .then(data2 => {
        if(data2){   
        let strFile2 = "data:application/pdf;base64,"+data2;
        window.download(strFile2, this.policyName+' '+this.accountName+".pdf", "application/pdf");
        }
       }).catch(error => {
      //console.log('Error: ' +JSON.stringify(error));
       });
  

       await Promise.all([pdfdownload,plpolicy]);
       this.hideDownloadPDFButton =  true;
      }

    renderedCallback() {
      loadScript(this, downloadjs1).then(() => {});
    }

    roundToTwo(convertNum) { 
          return parseFloat(convertNum).toFixed(2);
      //return +(Math.round(conNum + "e+2")  + "e-2");
    }

    handleUpdate(){
      const fields = {};
            fields[QBInv.fieldApiName]         = this.recordId;
            fields[Amount.fieldApiName]        = 0.00	;
         // fields[Description.fieldApiName]   = this.;
            fields[Quantity.fieldApiName]      = 0.00; 
            fields[Rate.fieldApiName]          = 0.00	;
         // fields[Products.fieldApiName]      = qty.;
            
            const recordInput = { fields }; 
          //console.log(JSON.stringify(fields));
            updateRecord(recordInput) 
                    .then(() => {
                            const toastEvent = new ShowToastEvent({
                                title   : "Success",
                                message : "Records Updated Successfully.",
                                variant : "success",
                            });
                            dispatchEvent(toastEvent); 
                            return refreshApex(this._wiredMyData);
                    })
                    .catch(error => {
                        const toastEvent = new ShowToastEvent({
                            title   : "Error",
                            message : "Something wrong, Please Try Again.",
                            variant : "error",
                        });
                        dispatchEvent(toastEvent);
                    })
                    .finally(() => {
                        this.spinnerStatus = true;
                        return refreshApex(this._wiredMyData);
                    });
    }

    showModal(event) {
      this.isModalOpenAss = true;
    }

    closeModal() {
        this.isModalOpenAss = false;     
    }


}