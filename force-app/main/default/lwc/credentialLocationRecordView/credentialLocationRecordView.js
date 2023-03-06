import { LightningElement, wire, api } from "lwc";
import { getRelatedListRecords } from "lightning/uiRelatedListApi";

export default class CredentialLocationRecordView extends LightningElement {
  @api recordId;
  error;
  records;
  @wire(getRelatedListRecords, {
    parentRecordId: "$recordId",
    relatedListId: "AttachedContentDocuments",
    fields: ['AttachedContentDocument.ContentDocumentId', 'AttachedContentDocument.Title', 'AttachedContentDocument.FileType']
    // fields: ["Contact.Id", "Contact.Name"],
    //where: '{ and:[{Name:{like:"Test%"}}]}'
  })
  const({ error, data }) {
    console.log('result '+JSON.stringify(error)+' data '+data)
    if (data) {
      console.log('Data ');
      console.log(JSON.stringify(data.records));
      this.records = data.records;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.records = undefined;
    }
  }
}