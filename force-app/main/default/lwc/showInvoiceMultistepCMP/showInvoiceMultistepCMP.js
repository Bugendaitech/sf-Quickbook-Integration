import { LightningElement, track,wire,api } from 'lwc';
import getBillingAddress from "@salesforce/apex/createInvoiceCtrl.getBillingAddress";
//import getDataByaplicantID from "@salesforce/apex/createInvoiceCtrl.getDataByaplicantID";

export default class ShowInvoiceMultistepCMP extends LightningElement {
    @track currentStep = '2';
    @track billingAddress;
    @track recordId;
    @track commision='0';
    @track indiactedPerimum='0';
    @track discountValue='0';
    @track applicantName;
    @track applicantId;
    @api paramValue;
    @track  handleShowPath=false;
    @track  handleShowEditPath=false;
    @track step2='2';
    @track step3='3';
    @track step4='3'; 
    @track step5='3';
    @track currentCpm = 'normal';
    // @track _titleText= 'New QuickBooks Invoice';
    // @track _smallText= 'Breadwinner • QuickBooks';
    @track _titleText= 'New QuickBooks Invoice';
    @track _smallText= 'QuickBooks';
    @api companyId;
    @track accresult;
    @track editId;
    
    sticky = false;
    timeout = 3000;
    
    connectedCallback(){

        
        //console.log('showInvoice');
        
        if(this.paramValue) {
            this.recordId = this.paramValue;
        ////console.log('this.paramValue '+this.paramValue);
        getBillingAddress({ 
            qouteid : this.paramValue
         })
         .then(result =>{
             ////console.log('ResultfromApex '+JSON.stringify(result));
             this.applicantId = result.Applicant_Insured__c;
             //console.log('ths1 '+this.applicantId);
             if(result.Applicant_Insured__r.BillingAddress){
                this.billingAddress=result.Applicant_Insured__r.BillingAddress;

            }
            //console.log('Name '+result.Applicant_Insured__r.Name);
            this.applicantName = result.Applicant_Insured__r.Name;

            if(result.Applicant_Insured__r.Indicated_Premium__c)
            {
              this.indiactedPerimum = result.Applicant_Insured__r.Indicated_Premium__c;
            }
            if(result.Applicant_Insured__r.Commission__c)
            {
              this.commision = result.Applicant_Insured__r.Commission__c;
            }
            if(result.Applicant_Insured__r.Discount_Amount__c)
            {
              this.discountValue = result.Applicant_Insured__r.Discount_Amount__c;
            }
             ////console.log('this.billingAddress'+JSON.stringify(this.billingAddress));
             /*getDataByaplicantID({ 
                varapplicantId : this.applicantId 
             }).then(data =>{
                 this.accresult=data;  
                 ////console.log('this.accresult'+this.accresult); 
                 this.companyId=this.accresult;
             }).catch(error =>{
                ////console.log('ErrorfromApex'+JSON.stringify(error));
            })*/
            
         })
         .catch(error =>{
             ////console.log('ErrorfromApex'+JSON.stringify(error));
         })
        
          }
          
      }

  

 

    handleOnStepClick(event) {
        
        this.currentCpm = event.target.label;     
        if(this.currentCpm == 'Create QuickBooks Invoice'){
           //this._titleText='Create QuickBooks Invoice';
            if(this.companyId == 'New'){
                //this.currentStep = event.target.value;
                this.showToastNotification('error',"Please Create Customer first.");
            }else{
                this.currentStep = event.target.value;
            }
        }else{
            this.currentStep = event.target.value;  
        } 
       
    }
 
    get isStepOne() {
        //return this.currentStep === "1";
        return false;
    }
 
    get isStepTwo() {
        return this.currentStep === "2";
    }
 
    get isStepThree() {
        return this.currentStep === "3";
    }
    get isStepFour(){
        return this.currentStep === "4";
    }
    get isEnableNext() {
        return this.currentStep != "3";
    }
 
    get isEnablePrev() {
        return this.currentStep != "1";
    }
 
    get isEnableFinish() {
        return this.currentStep === "3";
    }
 
    handleNext(){ 
        if(this.currentStep == "1"){
            //console.log('under 1');
            this.currentStep = "2";
        }
        else if(this.currentStep == "2"){
            //console.log('under 2');
            // if(this.handleShowPath){
                //console.log('under 2 true');
                this.currentStep = "3";
                // if(this.handleShowEditPath){
            //         this.currentStep = "3";
            //     }
            // }else{
            //     //console.log('under 2 false');
            //     this.currentStep = "3";
            // }
        }
        else if(this.currentStep == "3"){
            //console.log('under 3 true');
            this.currentStep = "4";
        }
    }
 
    handlePrev(){
        if(this.currentStep == "3"){
            this.currentStep = "2";
        }
        else
         if(this.currentStep = "2"){
            this.currentStep = "1";
        }
    }
 
    handleFinish(){
 
    }

    handleNewCustButtonValues(event){	        
        let recValue = event.detail;
        //console.log('On Parent '+recValue);
        if(recValue=='NewCust'){
            //console.log('In New');
            this.valuesWithNewCutomer();
        }else{
            //console.log('In With Out');
            this.companyId=recValue;
            //console.log(this.companyId);
            this.valuesWithoutNewCutomer();
        }
        this.checkValues();
     }
    
    valuesWithNewCutomer(){
        this.handleShowPath=true;
        this.handleShowEditPath=false; 
        this.step1  = '1';
        this.step2  = '2';
        this.step3  = '3';
        this.step4  = '4';
        let errorVar = this.template.querySelector('#auraErrorMessage');
        if(errorVar!=null || errorVar!=undefined){
            errorVar.style.display = "none";
        }
        //console.log('New CMP without Id');
    }

    valuesWithoutNewCutomer(){
        this.handleShowPath = false;
        this.handleShowEditPath=false; 
        this.step1  = '1';
        this.step2  = '2';
        this.step3  = '3';
        this.step4  = '3';        
        //console.log('New CMP with Id');
     }

    handleIdNav(event){
        let idVal = event.detail; 
        this.editId=idVal;
        //console.log('handleShowPath:::'+this.handleShowPath);// false
        //console.log('Value after create Company::'+idVal);
        if(idVal!='' ||idVal!=null||idVal!=undefined ){
            this.valuesWithEditCustomer();
        if(this.currentStep == '2'){
            this.handleShowEditPath=true;
           // this.handleShowPath=true;
            if(this.handleShowEditPath){
                this.currentStep = "3";
            }            
       }
      
       }else{
        this.valuesWithoutEditCustomer();
       }
       this.checkValues();
    }

    valuesWithEditCustomer(){
        
        this.handleShowEditPath=true; 
        this.handleShowPath  = false;
        this.step1  = '1';
        this.step2  = '2';
        this.step3  = '3';
       // this.step5  = '3';
        this.step4  = '4';
        //console.log('edit CMP with Id');
        
    }
     
    valuesWithoutEditCustomer(){
        this.handleShowEditPath = false; 
        this.handleShowPath  = false;
        this.step1  = '1';
        this.step2  = '2';
        this.step3  = '3';
        this.step4  = '3';
        //console.log('edit CMP without Id');
    }


    showToastNotification(type,message) {
        this.template
          .querySelector("c-custom-toast-notification")
          .showToast(type, message);
    }


    handlenewInv(event){
        let resValue = event.detail; 
        //console.log('Value after create Company::'+resValue);
        if(resValue=="error"){
            if(this.currentStep == "3"){
                //console.log('under 3 true');
                this.currentStep = "4";
            }
        }
    }

    handleditInv(event){
        let varresValue = event.detail; 
        //console.log('Value after edit Company::'+varresValue);
        if(varresValue=='success'){
            if(this.currentStep == "3"){
                //console.log('under 3 true');
                this.connectedCallback();
                this.currentStep = "4";
            }
        }

    }
    checkValues(){
        //console.log('Value for New '+this.handleShowPath);
        //console.log('Value for Edit '+this.handleShowEditPath);
    }        
}