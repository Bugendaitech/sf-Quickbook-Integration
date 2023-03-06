public class NotesAndAttachmentsCtrl {
     @AuraEnabled(cacheable=true)
    public Static List<ContentDocumentlink> getFiles(string optyid){
        Return [select id,ContentDocument.Title from ContentDocumentlink where LinkedEntityId = :optyid ];
        
    }
     @AuraEnabled
    public Static List<ContentDocumentlink> getContentDocuments(string optyid){
        Return [select id,ContentDocument.Title from ContentDocumentlink where LinkedEntityId = :optyid ];
        
    }

}