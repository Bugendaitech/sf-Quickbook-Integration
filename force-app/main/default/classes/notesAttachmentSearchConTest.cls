@isTest(SeeAllData=true)
public class notesAttachmentSearchConTest {
    
static testmethod void testmethod1(){
        Test.startTest();
       /* Account accA =new Account(Name='Testaccount',Physical_City__c='ohoio',Number_of_Units__c=5);
        insert accA ; 
        Opportunity opp = new Opportunity(Name='test opp',StageName='stage', AccountId = accA.Id ,Probability = 95, CloseDate=system.today());
        insert opp;*/
        List<opportunity> opplist = [Select id from Opportunity limit 1];
    if(opplist.size()>0){
  ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
    ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=opplist[0].id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
    insert contentlink;
    notesAttachmentSearchCon.getFiles(opplist[0].id);
    notesAttachmentSearchCon.getContentDocuments(opplist[0].id);
        Test.stopTest();
}
}
}