@isTest
public class QB_CustomerJSON_Test {
    @isTest static void myTest() {
        String resBody   = '{"QueryResponse":{"Customer":[{"Taxable":true,"BillAddr":{"Id":"413","Line1":"Street New Park 23/A","City":"California","Country":"USA","CountrySubDivisionCode":"US","PostalCode":"74541"},"Job":true,"BillWithParent":false,"ParentRef":{"value":"236"},"Level":1,"CustomerTypeRef":{"value":"5000000000000051989"},"SalesTermRef":{"value":"1"},"PaymentMethodRef":{"value":"1"},"Balance":510.76,"BalanceWithJobs":510.76,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"ClientEntityId":"0","domain":"QBO","sparse":false,"Id":"274","SyncToken":"1","MetaData":{"CreateTime":"2022-12-20T03:12:40-08:00","LastUpdatedTime":"2022-12-20T11:52:21-08:00"},"FamilyName":"Stevert Producer 2","FullyQualifiedName":"John Stevert Agency2:Testing new","CompanyName":"Testing new","DisplayName":"Testing new","PrintOnCheckName":"Testing new","Active":true,"V4IDPseudonym":"002098f5e9a0d9162a44a4b2a589fa00ce3274"}],"startPosition":1,"maxResults":1},"time":"2022-12-21T00:36:20.957-08:00"}';
        QB_CustomerJSON qbCust = QB_CustomerJSON.parse(resBody);
        
        //qbCust.QueryResponse.Customer(qbCust.QueryResponse.Customer[0]);
        //System.debug('Cust '+qbCust.QueryResponse.Customer[0]);
          
    }
    
    
}