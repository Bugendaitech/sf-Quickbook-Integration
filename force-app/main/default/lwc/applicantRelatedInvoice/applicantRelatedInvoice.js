import { LightningElement, wire,api,track } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import getInvoiceRecords from '@salesforce/apex/GetInvoiceCtrl.getInvoiceRecords';
import { NavigationMixin } from 'lightning/navigation';
import getInvoiceCount from '@salesforce/apex/GetInvoiceCtrl.getInvoiceCount';
import getGetRecordType from '@salesforce/apex/GetInvoiceCtrl.getGetRecordType';

export default class ApplicantRelatedInvoice extends NavigationMixin(LightningElement){
    @api recordId;
    @track records = [];
    @track count = 0 ;
    @track isShowInvoices;
    @track isShowInvoiceRecords;
    // connectedCallback(){
    //     console.log('$recordId');

    // }
    // error;
    // records;
    // @wire(getRelatedListRecords, {
    //     recordId: '0017A00000vNH2NQAW',
    //     relatedListId: 'Account',
    //     fields: ['Account.Id','Account.Name']
    // })listInfo({ error, data }) {
    //     if (data) {
    //         console.log('Data'+data);
    //         this.records = data.records;
    //         this.error = undefined;
    //     } else if (error) {
    //         this.error = error;
    //         this.records = undefined;
    //     }
    // }
    connectedCallback(){
        getGetRecordType({
            recId : this.recordId
        })
        .then(result =>{
           console.log('IS SHOW : '+result);
           this.isShowInvoices = result;
         
    }).catch(error =>{
        console.log('Is Show Error '+JSON.stringify(error));
    })
    }

    _wiredMyData;
    @wire(getInvoiceRecords, {
        recId : '$recordId'
    })
    wireAccountData(wireResultMy) {
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;
        // console.log('called port'+data);
        if (data) {
            // console.log('called port If Data');
            if (data.length > 0) {
             this.records = JSON.parse(data);
            //  console.log('this.records'+this.records)
            //  console.log('Data Length'+data.length);
            } else if (data.length == 0) {
            //    console.log('Data 0');
            }
        } else if (error) {
            console.log(this.error);
        }
    }
    _wiredMyData;
    @wire(getInvoiceCount, {
        recId : '$recordId'
    })
    wiregetInvoiceCount(wireResultMy) {
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;
        console.log('called port count :: '+data);
        if (data) {
            console.log('called port If Data');
             if (data != 0) {
            
             console.log('this.count'+this.count);
            //  if(data == 0){
            //     this.count = 0;
            //  }else{
                this.count = data; 
                this.isShowInvoiceRecords = true;
                //this.count = '0';
           }else{
            this.isShowInvoiceRecords = false;
           }
            // } else if (data.length == 0) {
            //    console.log('Data 0');
            // }
        } else if (error) {
            console.log(this.error);
        }
    }

    handleNavigate(event) { 
        console.log('Id'+event.currentTarget.dataset.id);
        let navObj = {};
        navObj.recordId     = event.currentTarget.dataset.id;
        navObj.accountRecId = this.recordId;
        navObj.from         = 'Account';
        let componentDef = {
            componentDef: "c:viewInvoiceCMP",
            attributes: {
              label: "Navigated",
            //   recordId: event.currentTarget.dataset.id
              recordId:  navObj
            }
          };
      
          let encodedComponentDef = btoa(JSON.stringify(componentDef));

          //console.log('https://bold--bugendai.sandbox.lightning.force.com/one/one.app#'+encodedComponentDef);
          this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
              url: "/one/one.app#" + encodedComponentDef
            }
          });

          
    }

}