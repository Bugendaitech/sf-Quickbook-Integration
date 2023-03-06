import { api,LightningElement,wire,track} from 'lwc';
import getData from "@salesforce/apex/ExistingCustomerCtrl.getAllData";

export default class InvoicePathCMP extends LightningElement {
    @api cusId; 
    @track records = [];
    value = 'option1';
    @track spinnerStatus = false;
    @track existing1id;

    
    sticky = true;
    timeout = 3000;


    get options() {
        return [
            { label: 'Invoice', value: 'option1' },
            { label: 'Sales Receipt', value: 'option2' },
        ];
    }


    @wire(getData, { accId : '$cusId'})
    wireCompanyData(wireResultMy) { 
        const { data, error } = wireResultMy;           
            if (data) {   
                //console.log(data);
                //console.log('Yes Wire');  
                console.log('invoicePathCMP');
                console.log('Records For invoice'+data.length);              
                if (data.length > 2) { 
                   // console.log('Yes Wire have');
                    this.records = JSON.parse(data); 
                    console.log('Records For invoice'+ this.records);
                   // console.log('Yes Wire have 2');
                //    console.log('Company Data :: '+JSON.stringify(this.records));
                //    console.log('Company Id 1 ::'+JSON.stringify(this.records[0].id));
                   if(this.records.length>0){
                    this.existing1id=this.records[0].id;
                   }            
                   this.sendValues(this.existing1id);       
                   //console.log('this.existing1id'+this.existing1id);
                   this.spinnerStatus= true;
                } else if (data.length == 2) {
                   // console.log('Yes Wire Not');

                    this.records = [];  
                    this.spinnerStatus= true;
                    this.showToastNotification('error','No any Existing records found create new one.');
                    this.sendValues('New');

                }
            } else if (error) {
                this.spinnerStatus= true;
                this.error = error; 
            }
    }
 
    showToastNotification(type,message) {
        this.template
          .querySelector("c-custom-toast-notification")
          .showToast(type, message);
    }

    handleNewCustomer(event){
       // console.log('Called');
        let curVal = event.target.value;
        
       // console.log('on Child CMP '+curVal);
         this.sendValues(curVal);
    }
    
    // getCurretOptionValue(event){
    //     let curVal = event.target.value;
    //     this.sendValues(curVal);
    // }

    sendValues(curVal) {
       // console.log('caalled');
        const oEvent = new CustomEvent('lineitemvalue',
            {
                'detail': curVal
            }
        );
        this.dispatchEvent(oEvent);
    }


  handleNavigate(event)
  {
    console.log('Id on Link:: '+event.currentTarget.dataset.id);
    let navId =event.currentTarget.dataset.id
    this.sendNavIds(navId);
  }
  sendNavIds(navId){
    const oEvent = new CustomEvent('iditemvalue',
    {
        'detail': navId
    }
);
this.dispatchEvent(oEvent);
  }
}