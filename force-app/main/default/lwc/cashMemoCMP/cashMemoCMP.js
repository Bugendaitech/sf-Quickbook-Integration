import { LightningElement, wire ,track, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getInvoiceDetails from '@salesforce/apex/ViewInvoiceCtrl.getInvoiceDetails';


export default class CashMemoCMP extends NavigationMixin(LightningElement)  {

    @api recordId;    
    @track spinnerStatus = true;
    @track records = {};
    @track LineItems = [];
    @track accName = '';

    _wiredMyData;
    @wire(getInvoiceDetails, { invId: '$recordId' })
    wireInvoiceData(wireResultMy) { 
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;  
        let Invdate;
        let Incdate;
         console.log(data);
            if (data) {   
                if (data.length > 0) {
                    //data = JSON.parse(data);
                    this.records   = JSON.parse(data); 
                    this.accName   = this.records.name;
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
                this.spinnerStatus = true;
            }
    }

    goBackHandler(event){
        let componentDef = {
            componentDef: "c:viewInvoiceCMP",
            attributes: {
              label: "Navigated",
              recordId: event.currentTarget.dataset.id
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