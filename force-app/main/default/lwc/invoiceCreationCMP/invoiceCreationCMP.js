import { LightningElement,track } from 'lwc';

export default class InvoiceCreationCMP extends LightningElement {
  @track value = 'option1';

    get options() {
        return [
            { label: 'Invoice', value: 'option1',checked:'trues'},
            { label: 'Sales Receipt', value: 'option2' },
        ];
    }
    // handleRadioChange(event) {
    //     const selectedOption = event.detail.value;
    //     //alert('selectedOption ' + selectedOption);
    //     if (selectedOption == 'Invoice'){
    //         this.value = option1;
    //     }else
      
        
    //     if (selectedOption == 'Sales Receipt'){
    //         this.value = option2;
    //     }
    // }
}