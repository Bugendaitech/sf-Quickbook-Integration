import { LightningElement ,wire,track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation'; 
import { refreshApex } from '@salesforce/apex';
import getInvoicesList from '@salesforce/apex/invoiceDataTableListCtrl.getInvoicesList';


export default class InvoiceDataTableList extends NavigationMixin(LightningElement){

    @track records = [];
    serachKey       = "";
    @track spinnerStatus = false;
    @track searchPlaceholder = 'Search By Invoice Name';

    @track byStatus   = 'All';
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
    @track selectedFields = ['Id','Name','StageName','CloseDate','Actual_Revenue__c'];

    get disablePreviousButtons() {
        if(this.selectedFields == undefined || this.selectedFields.length == 0 || this.pageNumber == 1)
            return true;
    }

    get disableNextButtons() {
        if(this.selectedFields == undefined || this.selectedFields.length == 0 || this.pageNumber == this.totalPages)
            return true;
    }
    
    get sortByStatus(){
        return[
            { label: 'All', value: 'All' },
            { label: 'Closed', value: 'Closed' },
            { label: 'Open', value: 'Open' },
            { label: 'Overdue', value: 'Overdue' },
            { label: 'Paid', value: 'Paid' }
        ];
    }
    
    get sortByOptions(){
        return[
            { label: 'Account', value: 'Account.Name' },
            { label: 'Opportunity Name', value: 'Name' },
            { label: 'Stage', value: 'StageName' },
            { label: 'Actual Revenue', value: 'Actual_Revenue__c' },
            { label: 'Sum of RFP Quantity', value: 'Total_RFP_Quantity__c' }
        ];
    }
    get sortOrderOptions(){
        return[
            { label: 'ASC', value: 'ASC' },
            { label: 'DESC', value: 'DESC' }
        ];
    }

    // _wiredMyData;
    // @wire(fetchInvoices)
    // wireInvoiceData(wireResultMy) { 
    //     const { data, error } = wireResultMy;
    //     this._wiredMyData = wireResultMy;          
    //         if (data) {  
    //             if (data.length > 0) {
    //                 this.records = JSON.parse(data); 
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

    handleValues(event){
        this.byStatus = event.target.value; 
    }

    handleNavigate(event) { 
        let componentDef = {
            componentDef: "c:viewInvoiceCMP",
            attributes: {
              label: "Navigated",
              recordId: event.currentTarget.dataset.id
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

   
    handleSearch(event){
        this.spinnerStatus = false;  
        this.serachKey = event.target.value;
        //send to method
        let searchTerm = this.serachKey;
        if(this.serachKey.length>=3){ 

            let allData = [...this.totalRecordsBuffer];

            let filteredData =  allData.filter(function (el) {
                                    return el.Name.includes(searchTerm.toUpperCase());
                                });

            if(filteredData.length>0){
                this.records                = filteredData;
                this.totalRecords           = filteredData.length;
                this.totalPages             = Math.ceil(filteredData.length / Number(this.recordSize)) > 0 ? Math.ceil(filteredData.length / Number(this.recordSize)) : 1;                                         
                    

            }else{
                this.records                = [];
                this.totalRecords           = 0;
                this.totalPages             = 1;
            }
            this.spinnerStatus = true;  
             
        }else if(this.serachKey.length==0){ 
            this.serachKey = '';
            
            let allData         = [...this.totalRecordsBuffer];
            this.records        = allData;
            this.totalRecords   = allData.length;
            this.spinnerStatus  = true;  
             
        }else{ 
            this.spinnerStatus = true; 
            return refreshApex(this._wiredMyData);
        }
    }

    handleRefresh(event)
    {
        eval("$A.get('e.force:refreshView').fire();");

    }
    @wire(getInvoicesList,{ 
        pageNumber   : 1,
        lastRecordId : null,
        recordSize   : 25,
        actionType   : 'DESC',
        needQuery    : true,
        orderBy      : 'Name',
        byStatus     : '$byStatus'
     })
        wireAccountData(wireResultMy) {         
        // console.log('before  '+this.topRecordId+' && '+this.bottomRecordId);
        // console.log('User Id '+Id);
        const { data, error } = wireResultMy;
        // this._wiredMyData = wireResultMy; 
        // this.spinnerStatus              = false; 
        // console.log('Records'+data);
            if (data) {   
                if (data.length > 0) {
                    
                    let wholeData;
                    let myRev ;
                    let allRev ; 
                    let allRecords              = [];
                    wholeData                   = JSON.parse(data);
                    allRecords                  = wholeData.records; 
                    let curSize                 = allRecords.length;
                    this.totalRecordsBuffer     = [...allRecords];  
                    this.records                = allRecords.slice(0,Number(this.recordSize)); 
                    this.totalRecords           = wholeData.totalRecords;  
                    if(curSize>0){
                        if(curSize>=Number(this.recordSize)){
                            this.topRecordId       = allRecords[0].SrNo ;                              
                            this.bottomRecordId    = allRecords[this.recordSize].SrNo ;
                            // this.bottomRecordId = this.getLastIndex(this.topRecordId,Number(this.recordSize));
                        }else{
                            this.topRecordId       = null ;
                            this.bottomRecordId    = null;
                        }
                    }     
                                         
                    this.totalPages                 = Math.ceil(wholeData.totalRecords / Number(this.recordSize)) > 0 ? Math.ceil(wholeData.totalRecords / Number(this.recordSize)) : 1;                                         
                    this.totalPagesBuffer           = this.totalPages;
                    this.spinnerStatus              = true; 
                    if(wholeData.totalRecords>0){
                        this.dataExists  = true;
                    }else{
                        this.dataExists  = false;  
                        return
                    } 
                //    console.log('Data '+JSON.stringify(this.records));
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
 
 
        let wholeData               = [...this.totalRecordsBuffer];
        let fromIndex               = ((this.pageNumber*this.recordSize)-this.recordSize);
        let toIndex                 = ((this.pageNumber*this.recordSize));
        let newArrayOfData          = wholeData.slice(fromIndex,toIndex); 
        this.records                = [...newArrayOfData];
    }
}