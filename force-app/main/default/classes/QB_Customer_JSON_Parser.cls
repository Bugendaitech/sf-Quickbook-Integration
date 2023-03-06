public class QB_Customer_JSON_Parser{
	public cls_QueryResponse QueryResponse;
	public String curtime;	//2022-12-21T03:54:07.903-08:00
	public class cls_QueryResponse {
		public cls_Customer[] Customer;
		public Integer startPosition;	//1
		public Integer maxResults;	//1
	}
	public class cls_Customer {
		public boolean Taxable;
		public cls_BillAddr BillAddr;
		public boolean Job;
		public boolean BillWithParent;
		public cls_ParentRef ParentRef;
		public Integer Level;	//1
		public cls_CustomerTypeRef CustomerTypeRef;
		public cls_SalesTermRef SalesTermRef;
		public cls_PaymentMethodRef PaymentMethodRef;
		public Double Balance;	//510.76
		public Double BalanceWithJobs;	//510.76
		public cls_CurrencyRef CurrencyRef;
		public String PreferredDeliveryMethod;	//Print
		public boolean IsProject;
		public String ClientEntityId;	//0
		public String domain;	//QBO
		public boolean sparse;
		public String Id;	//274
		public String SyncToken;	//1
		public cls_MetaData MetaData;
		public String FamilyName;	//Stevert Producer 2
		public String FullyQualifiedName;	//John Stevert Agency2:Testing new
		public String CompanyName;	//Testing new
		public String DisplayName;	//Testing new
		public String PrintOnCheckName;	//Testing new
		public boolean Active;
		public String V4IDPseudonym;	//002098f5e9a0d9162a44a4b2a589fa00ce3274
	}
	public class cls_BillAddr {
		public String Id;	//413
		public String Line1;	//Street New Park 23/A
		public String City;	//California
		public String Country;	//USA
		public String CountrySubDivisionCode;	//US
		public String PostalCode;	//74541
	}
	public class cls_ParentRef {
		public String value;	//236
	}
	public class cls_CustomerTypeRef {
		public String value;	//5000000000000051989
	}
	public class cls_SalesTermRef {
		public String value;	//1
	}
	public class cls_PaymentMethodRef {
		public String value;	//1
	}
	public class cls_CurrencyRef {
		public String value;	//USD
		public String name;	//United States Dollar
	}
	public class cls_MetaData {
		public String CreateTime;	//2022-12-20T03:12:40-08:00
		public String LastUpdatedTime;	//2022-12-20T11:52:21-08:00
	}
	public static QB_Customer_JSON_Parser parse(String json){
		return (QB_Customer_JSON_Parser) System.JSON.deserialize(json, QB_Customer_JSON_Parser.class);
	}


}