import { LightningElement,track,wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fetchInvoices from '@salesforce/apex/dataTableInvoiceCtrl.fetchInvoices';
import  getDataByFilter from '@salesforce/apex/dataTableInvoiceCtrl.getDataByFilter';
import getInvoiceData from '@salesforce/apex/dataTableInvoiceCtrl.getInvoiceData';
import { refreshApex } from '@salesforce/apex';

const COLUMN = [
    {label:'Invoice Name', fieldName: 'Name',type:'url',sortable: "true",
    typeAttributes: { label: { fieldName: 'Name' }, tooltip:"Name", target: "_blank" } },
    // {label:'Status Flag',fieldName: 'Flag', type:'url',
    // typeAttributes: { label: { fieldName: 'Flag' ,type:'image'} },}, 
    // { label: 'Status Flag', fieldName: 'Flag', type:'image'},
    // {label:'Status Flag',cellAttributes: { class: 'Flag'  }},
    // {
    //     label: 'Status Flag',
    //     fieldName: 'Status',
    //     type: 'text',
        // formatter: this.statusFormatter

        // typeAttributes: {
        //     src : {fieldName : 'Flag'},
        //   width: '50',
        //   height: '50'
        // }
        // cell-class-name: 'img-css ',
        // cellAttributes: { class: 'img-css '  }
    //   },
    {label: 'Status Flag',cellAttributes:{
        class:{fieldName:'Flag'}}},

    {label:'Status', fieldName: 'Status'},
    {label:'Account', fieldName: 'AccountName',type:'url',sortable: "true",
    typeAttributes: { label: { fieldName: 'AccountName' }, tooltip:"AccountName"} },
    {label:'Due Date', fieldName: 'DueDate'},
    {label:'Invoice Date', fieldName: 'InvoiceDate'},
    {label:'Amount Overdue', fieldName: 'AmtOverDue',type:'Currency'},
    {label:'Amount Due', fieldName: 'AmtDue',type:'Currency'},
    {label:'Amount Received', fieldName: 'AmtReceived',type:'Currency'},
    {label:'Total', fieldName: 'AmtTotal',type:'Currency'}
];

export default class InvoiceListTestCMP extends NavigationMixin(LightningElement)  {
    @track records = [];
    @track varinvoiceData=[];
    serachKey       = "";
    @track spinnerStatus = false;
    @track searchPlaceholder = 'Search By Invoice Name';
    column =COLUMN;
    @track viewInvoice;
    @track sortBy;
    @track sortDirection;
    // @track FlagStatus = 'background-image: url("/resource/1671476878000/StatusImages/StatusImages/red-flag.png"); background-repeat: no-repeat; background-size: 30px; background-position: center; ' ;
    
    
    @track selectedFields = ['Id','Name','StageName','CloseDate','Actual_Revenue__c'];
    @track pageNumber = 1;
    @track recordSize = '25';
    @track recordLength = 0;
    @track records;
    @track totalRecords;
    @track totalRecordsBuffer;
    @track actionType = 'ASC';
    @track totalPages;
    @track totalPagesBuffer;
    @track arrayOfLastIndexs = [0];
    @track dataExists  = true;
    
    @track previousRecordId = null;   // c    
    @track topRecordId     = null;   // b
    @track bottomLastRecordId  = null;   // a
    @track needCall = false;
    @track counter  = 1;

    get disablePreviousButtons() {
        if(this.selectedFields == undefined || this.selectedFields.length == 0 || this.pageNumber == 1)
            return true;
    }

    get disableNextButtons() {
        if(this.selectedFields == undefined || this.selectedFields.length == 0 || this.pageNumber == this.totalPages)
            return true;
    }
    
   
    // _wiredMyData;
    // @wire(fetchInvoices)
    // wireInvoiceData(wireResultMy) { 
    //     const { data, error } = wireResultMy;
    //     this._wiredMyData = wireResultMy;  
        
    //     console.log('called ');
    //         if (data) {  
    //             console.log('called '+data);
    //             if (data.length > 0) {
    //                 //data = JSON.parse(data);
    //                 // this.records = JSON.parse(data);
    //                 this.varinvoiceData=this.records;
    //                 // this.records = JSON.parse(data).map(function (currentItem, index, actArray) {
    //                 //     console.log('Flag '+currentItem);
    //                 //     // console.log('Flag '+currentItem.QB_Status_Flag__c.split('"')[1]);
    //                 // });
    //                 this.spinnerStatus = true;  
    //             } else if (data.length == 0) {
    //                 this.records = []; 
    //                 this.spinnerStatus = true;
    //             }
    //         } else if (error) {
    //             this.error = error;
    //             this.spinnerStatus = true;
    //         }
    // }

    handleRowAction(event){
        const dataRow = event.detail.key;
       console.log('dataRow@@ ' + dataRow);
       // this.contactRow=dataRow;
      //  window.console.log('contactRow## ' + dataRow);
       // this.modalContainer=true;
     }

    handleNavigate(event) { 
        // const rowNode = event.toElement.closest('tr');
        // console.log(rowNode.dataset.rowKeyValue);
        let componentDef = {
            componentDef: "c:viewInvoiceCMP",
            attributes: {
              label: "Navigated",
              recordId: event.currentTarget.dataset.id
            }
          };
      
          let encodedComponentDef = btoa(JSON.stringify(componentDef));
           this.viewInvoice="/one/one.app#" + encodedComponentDef;
          console.log('https://bold--bugendai.sandbox.lightning.force.com/one/one.app#'+encodedComponentDef);
          this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
              url: "/one/one.app#" + encodedComponentDef
            }
          });

          
    }
    handleSearch(event){
        this.spinnerStatus = false;  
        this.serachKey = event.target.value;
        //send to method
        
        if(this.serachKey.length>=3){ 
            getDataByFilter({ searchKey: this.serachKey})
            .then(res => { 
                this.records = JSON.parse(res);
                this.varinvoiceData= this.records;
                this.spinnerStatus = true;  
            })
            .catch(err=>{
                this.spinnerStatus = true;  
            });
        }else if(this.serachKey.length==0){ 
            this.serachKey = '';
            getDataByFilter({ searchKey: this.serachKey})
            .then(res => { 
                this.records = JSON.parse(res);
                this.varinvoiceData= this.records;
                this.spinnerStatus = true;  
            })
            .catch(err=>{
                this.spinnerStatus = true;  
            });
        }else{ 
            this.spinnerStatus = true; 
            return refreshApex(this._wiredMyData);
        }
    }

    handleRefresh(event)
    {
        eval("$A.get('e.force:refreshView').fire();");

    }
    handleSortInvoiceData(event) {       
        this.sortBy = event.detail.fieldName;       
        this.sortDirection = event.detail.sortDirection;       
        this.sortInvoiceData(event.detail.fieldName, event.detail.sortDirection);
    }


    sortInvoiceData(fieldname, direction) {
        
        let parseData = this.varinvoiceData;
       
        let keyValue = (a) => {
            return a[fieldname];
        };


       let isReverse = direction === 'asc' ? 1: -1;


           parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
           
            return isReverse * ((x > y) - (y > x));
        });
        
        this.varinvoiceData = parseData;
    }


    @wire(getInvoiceData,{ 
        pageNumber   : 1,
        lastRecordId : null,
        recordSize   : 25,
        actionType   : 'DESC',
        needQuery    : true,
        orderBy      : 'Name'
     })
        wireAccountData(wireResultMy) {         
        // console.log('before  '+this.topRecordId+' && '+this.bottomRecordId);
        // console.log('User Id '+Id);
        const { data, error } = wireResultMy;
        // this._wiredMyData = wireResultMy; 
        //console.log(data);
            if (data) {   
                if (data.length > 0) {
                    
                    let wholeData;
                    let myRev ;
                    let allRev ; 
                    let allRecords              = [];
                    wholeData                   = JSON.parse(data);
                    allRecords                  = wholeData.records;                    
                    let curSize                 = allRecords.length;
                    this.oppBufferList          = [...allRecords]; 
                    console.log('oppBufferList')
                    this.records                = allRecords.slice(0,Number(this.recordSize-1)); 
                    this.totalRecords           = wholeData.totalRecords; 
                    console.log('totalRecords'+this.totalRecords);
                    if(curSize>0){
                        if(curSize>=Number(this.recordSize)){
                            this.topRecordId       = allRecords[0].SrNo ;                              
                            this.bottomRecordId    = allRecords[24].SrNo ;
                            // this.bottomRecordId = this.getLastIndex(this.topRecordId,Number(this.recordSize));
                        }else{
                            this.topRecordId       = null ;
                            this.bottomRecordId    = null;
                        }
                    }     
                            
                    this.totalRecordsBuffer         = this.totalRecords;             
                    this.totalPages                 = Math.ceil(wholeData.totalRecords / Number(this.recordSize)) > 0 ? Math.ceil(wholeData.totalRecords / Number(this.recordSize)) : 1;                                         
                    this.totalPagesBuffer           = this.totalPages;
                    this.spinnerStatus              = true; 
                    if(wholeData.totalRecords>0){
                        this.dataExists  = true;
                    }else{
                        this.dataExists  = false;  
                        return
                    } 
                } else if (data.length == 0) {
                    this.dataExists  = false;
                    this.records = [];  
                    this.spinnerStatus = true;
                }
            } else if (error) {
                this.error = error;
                this.spinnerStatus = true;
            }
    }

    handleNavigation(event){
        let buttonName = event.target.label;
        this.needCall  = true;
        if(buttonName == 'First') {
            this.pageNumber   = 1; 
            this.actionType   = 'ASC';
        } else if(buttonName == 'Next') {
            this.pageNumber   = this.pageNumber >= this.totalPages ? this.totalPages : this.pageNumber + 1;             
            this.actionType   = 'ASC';
        } else if(buttonName == 'Previous') { 
                        
            this.pageNumber   = this.pageNumber > 1 ? this.pageNumber - 1 : 1; 
            let retIndex      = this.pageNumber;
            if(retIndex==1){
                this.arrayOfLastIndexs = [0];                
                this.bottomRecordId = null;
            }else{
                this.bottomRecordId = this.arrayOfLastIndexs[retIndex];
               // console.log(this.arrayOfLastIndexs[retIndex]+' index');
            }
            this.actionType   = 'DESC'; 
             

        } else if(buttonName == 'Last') {
           // console.log('Inside');
            this.pageNumber   = this.totalPages;             
            this.topRecordId = null;
            this.actionType   = 'DESC';
           // console.log('Inside');
            this.pageNumber   = this.totalPages;
           // console.log('Inside 1 '+this.totalRecords+' & ');
            let lastIndex     = Math.ceil(parseInt(this.totalRecords) - parseInt(this.recordSize)); 
           // console.log('Inside 2 '+lastIndex);          
            if(lastIndex>this.recordSize){
                let lastDigit = lastIndex.sub
            }
        }
       // console.log('done');
        this.handlePagination(event);
    }

    handleRecordSizeChange(event) {
        this.recordSize = event.detail.value;
        this.topRecordId = null;
        this.pageNumber = 1;
        this.handlePagination(event);
    }


    handlePagination(event){  
 
 
        let wholeData               = [...this.oppBufferList];
        let fromIndex               = ((this.pageNumber*this.recordSize)-this.recordSize);
        let toIndex                 = ((this.pageNumber*this.recordSize)-1);
        let newArrayOfData          = wholeData.slice(fromIndex,toIndex); 
        this.records                = [...newArrayOfData];
    }

}