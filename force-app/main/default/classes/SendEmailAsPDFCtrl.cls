public with sharing class SendEmailAsPDFCtrl {
    public SendEmailAsPDFCtrl() {

    }
    public static void emailPdf()
    {
        Messaging.singleEmailMessage semail=new Messaging.singleEmailMessage();
        semail.setEntityAttachment('');
        //Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();

        semail.setSubject('PDF');
        semail.setSenderDisplayName('Bold Legal');
        semail.setPlainTextBody('Attchment');
        String[] toAddresses = new String[] {'payalkavitake25@gmail.com'}; 
        semail.sentToAddress(toAddresses);
        Messaging.singleEmail(new Messaging.singleEmail[]{semail} );
    }
}
