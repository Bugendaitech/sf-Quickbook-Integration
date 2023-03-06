import { LightningElement, track, wire, api } from 'lwc';
import getFiles from '@salesforce/apex/NotesAndAttachmentsCtrl.getFiles';
import getContentDocuments from '@salesforce/apex/NotesAndAttachmentsCtrl.getContentDocuments'; 
import { NavigationMixin } from 'lightning/navigation';

export default class CustomerSearchCmp extends NavigationMixin(LightningElement) {
    @track spinnerStatus = true;
    @api recordId;
    @api searchPlaceholder = "Search";
    @api isValueSelected;
    @api selectedFieldLabel;
    @api sObjectName;
    @track files=[];
    @track filesBackup=[];
    @track showSpinner= false;
    @track haveData = false;
    @track showMessage=false;
    cpn = {};
    listOfFields;
    searchTerm='';
    
    inputClass = '';

    connectedCallback(){
        console.log('notesAttachment');
    }


    @wire(getFiles, { optyid: '$recordId' })
    wiredRecordsMethod({ error, data }) {
        //console.log('Hello '+data);
        if (data) {
            //console.log('(data---> ' + JSON.stringify(data));
            let checkData = JSON.stringify(data);
            //console.log('Lenght '+checkData.length);
           /* if(checkData.length>2){                    
                this.files = data; 
                this.filesBackup= data; 
                this.haveData = true;
            }else{                
                this.files = []; 
                this.filesBackup = []; 
                this.haveData = false;
            }*/
            this.files = data; 
            this.filesBackup = data; 
            this.haveData = false;0
        } else if (error) {
            this.files = [];
            this.haveData = false;
            //console.log('(error---> ' + JSON.stringify(error));
        }
        //console.log('Final '+this.haveData);
    }

    refreshFiles(event){ 
       
        
        this.showSpinner= true;
        //console.log('this.recordId'+this.recordId);
        getContentDocuments({ 
            optyid : this.recordId
        })
        .then(result => {
            //console.log('result'+result);
            this.files= result; 
            this.filesBackup= result;
            this.showSpinner = false;
            this.haveData=false;
        })
        .catch(error => {
            //console.log('Error: ', error);
            this.showSpinner = false;
        });
    

    }
    searchKeyword(event) {
        
        this.searchTerm = event.target.value;
        var searchIteam = this.searchTerm.toLowerCase();
        console.log('this.searchTerm '+this.searchTerm);
         if(searchIteam == ''){
            this.showMessage=false;
         } else if(searchIteam && searchIteam.length<=2){
            this.showMessage=true;
         }
        if(searchIteam && searchIteam.length>2){
            this.showMessage=false;
        var filtreFiles=[];
        this.filesBackup.forEach(function(record) {
        //console.log('record'+record);
        var docTitle=record.ContentDocument.Title.toLowerCase();
        if(docTitle.startsWith(searchIteam)){
        //console.log('insidefile');
        filtreFiles.push(record);
        }   
        });
        this.files=filtreFiles;
        this.haveData=true;
        }
        else{
          //  this.files=this.filesBackup;
          this.haveData=false;
        }
        }
    
   /* isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('Lightning-input');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.cpn[inputField.name] = inputField.value;
        });
        return isValid;
    }*/
  handleClick(event){
    const recordId = event.target.dataset.oppid;
    var currentURL =window.location.href;
				 //console.log('currentURL'+currentURL);
				 var baseURL = currentURL.substring(0, currentURL.indexOf("lightning/r"));
				 //console.log('baseURL after removing'+baseURL);
				 baseURL = baseURL +recordId;
				 window.open(baseURL, '_blank');
    
                
                }
            }