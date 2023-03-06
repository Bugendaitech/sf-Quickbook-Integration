public class BoldLegalUtils {

    public static String siteHomeUrl            = Url.getSalesforceBaseUrl().toExternalForm() + '/one/one.app#';
    
    public static String qbAgencyRecIdSand      = '5000000000000051988';
    public static String qbInsuredRecIdSand     = '5000000000000051989';

    public static String qbAgencyRecIdProd      = '100000000000216828';
    public static String qbInsuredRecIdProd     = '100000000000216827';

    public static String qbGrossRecIdSand       = '23';
    public static String qbComissionRecIdSand   = '20';

    public static String qbGrossRecIdProd       = '2';
    public static String qbComissionRecIdProd   = '7';
    
    public static String qbSalesTermSand        = '1';
    public static String qbSalesTermProd        = '5';
    
    public static String qbPaymentMethodRefSand           = '1';
    public static String qbPaymentMethodRefProd           = '8';
    
    @AuraEnabled(cacheable = true)
    public static string getAllStaticValues(){
        try {     
            String mainUrl = Url.getSalesforceBaseUrl()+'';
            WrapperForUtil wrapObj = new WrapperForUtil();
            if(mainUrl.contains('sandbox')){wrapObj.siteURL = siteHomeUrl; wrapObj.qbAgencyRecTypeId = qbAgencyRecIdSand; wrapObj.qbInsuredRecTypeId = qbInsuredRecIdSand; wrapObj.qbGrossRectyepId = qbGrossRecIdSand; wrapObj.qbComisssionRectyepId = qbComissionRecIdSand; wrapObj.qbSalesTermId = qbSalesTermSand ; wrapObj.qbPaymentMethodRefId = qbPaymentMethodRefSand; } else{wrapObj.siteURL = siteHomeUrl; wrapObj.qbAgencyRecTypeId = qbAgencyRecIdProd; wrapObj.qbInsuredRecTypeId = qbInsuredRecIdProd; wrapObj.qbGrossRectyepId = qbGrossRecIdProd; wrapObj.qbComisssionRectyepId = qbComissionRecIdProd;wrapObj.qbSalesTermId = qbSalesTermProd ; wrapObj.qbPaymentMethodRefId = qbPaymentMethodRefProd; }           
            return JSON.serialize(wrapObj); } catch (Exception e) { throw new AuraHandledException(e.getMessage()); }
    }

    public class WrapperForUtil{

        public String siteURL;
        public String qbAgencyRecTypeId;
        public String qbInsuredRecTypeId;
        public String qbGrossRectyepId;
        public String qbComisssionRectyepId;
        public String qbSalesTermId;
        public String qbPaymentMethodRefId;
    }
    

}