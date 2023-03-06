import {  LightningElement,  track,  api,  wire} from 'lwc';
import {  NavigationMixin} from 'lightning/navigation';
import {  CloseActionScreenEvent} from 'lightning/actions';
import checkProducre from "@salesforce/apex/BindQuoteModalCtrl.checkProducre"; 


export default class BindQuoteModalCMP extends NavigationMixin(LightningElement) {
  @api recordId;
  @track typeVal = 'QuoteRenewal';
  @track recId = '';
  parameters = {};
  @track showbutton = true;
  @track checkboxVal = false;
  @track haveProducer = true;
  @track haveExternalId = true;
  @track haveParentId = true;
  @track anyError     = false; 
  @track errorMessage = '';
   

  connectedCallback(){
      

  }

  getQueryParameters() {
 
      var params = {};
      var search = location.search.substring(1);

      if (search) {
          params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
              return key === "" ? value : decodeURIComponent(value)
          });
      }
        //console.log('Get Record Id:: ' + params);
      return params;
  }


  onchangeHandler(event) {
      let res = event.target.value;
      this.typeVal = res;
        //console.log('Selected Value:: ' + res);
  }


  handlecheckboxVal(event) {
      let check = event.target.checked;

      checkProducre({
              quoteId: this.recordId
          })
          .then((result) => {
                console.log('result ' + JSON.stringify(result));
                if(result!=null || result!=undefined){
                    let data  = result;
                     
                    
                    if(data.Producer__c== undefined){
                        this.haveProducer = false;
                    }
                    
                    if(data.Applicant_Insured__r.QB_Parent_Id__c==undefined){
                      this.haveParentId = false;
                    }                  

                    if(data.Applicant_Insured__r.QB_External_Id__c== undefined){
                      this.haveExternalId = false; 
                    } 

                    
                  
                }else{
                    this.haveProducer = false;
                    this.haveParentId = false;
                    this.haveExternalId = false;
                }
               
          })
          .catch((error) => {
                //console.log('result ' + JSON.stringify(error))
          })
          .finally(() => {
                //console.log('finally')
          })


      if (check == true) {
          this.showbutton = false;
            //console.log('Button Check:' + this.showbutton);
      }
      if (check == false) {
          this.showbutton = true;
            //console.log('Button Check:' + this.showbutton);
      }
  }

  handleNavigate(event) {
      let componentDef = {
          componentDef: "c:multiStepInvoiceCmp",
          attributes: {
              label: "Navigated",
              recordId: this.parameters.quoteId
          }
      };

      let encodedComponentDef = btoa(JSON.stringify(componentDef));

        //console.log('https://bold--bugendai.sandbox.lightning.force.com/one/one.app#' + encodedComponentDef);
      this[NavigationMixin.Navigate]({
          type: "standard__webPage",
          attributes: {
              url: "/one/one.app#" + encodedComponentDef
          }
      });
  }

  handleContinue() { 
       
      if (this.typeVal == 'QuoteRenewal') { 

             
            
            if (!this.haveProducer || !this.haveParentId) {
              this.anyError = true;
              this.errorMessage = 'Please Check Producer and Producers Agency';
              this.showbutton = false;
              return
            }
            if (!this.haveExternalId) {
              this.anyError = true;
              this.errorMessage = 'Please Create New client first';
              this.showbutton = false;
              return
            }
      
          // this.navigateToVFPage();
          let url = "/apex/BindVFPage?quoteId=" + this.recordId;
          //window.open(url);
          window.open(url);
          this.dispatchEvent(new CloseActionScreenEvent());

      } else if (this.typeVal == 'NewCustomer') {
          if (!this.haveProducer || !this.haveParentId) {
            this.anyError = true;
            this.showbutton = false;
            return
          }
          let url = "/apex/BindNewCustomer?quoteId=" + this.recordId;
          //window.open(url);
          window.open(url);
          this.dispatchEvent(new CloseActionScreenEvent());
      }


  }

  navigateToVFPage() {
        //console.log('recId:: ' + this.recordId);
      this[NavigationMixin.GenerateUrl]({
          type: 'standard__webPage',
          attributes: {
              url: "/apex/BindVFPage?quoteId=" + this.recordId
          }
      }).then(generatedUrl => {
            //console.log('Under then' + generatedUrl);
          window.open(generatedUrl);
            //console.log('then close' + generatedUrl);
      });
  }
}