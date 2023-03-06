public class QBInvoiceParser {

	public cls_Invoice Invoice;
	//public String time;	//2023-01-05T05:27:37.329-08:00
	public class cls_Invoice {
		public boolean AllowIPNPayment;
		public boolean AllowOnlinePayment;
		public boolean AllowOnlineCreditCardPayment;
		public boolean AllowOnlineACHPayment;
		public String domain;	//QBO
		public boolean sparse;
		public String Id;	//241
		public String SyncToken;	//0
		public cls_MetaData MetaData;
		public cls_CustomField[] CustomField;
		public String DocNumber;	//1132
		public String TxnDate;	//2023-01-05
		public cls_CurrencyRef CurrencyRef;
		public cls_LinkedTxn[] LinkedTxn;
		public cls_Line[] Line;
		public cls_TxnTaxDetail TxnTaxDetail;
		public cls_CustomerRef CustomerRef;
		public cls_BillAddr BillAddr;
		public cls_ShipFromAddr ShipFromAddr;
		public cls_SalesTermRef SalesTermRef;
		public String DueDate;	//2023-01-28
		public Double TotalAmt;	//245.65
		public boolean ApplyTaxAfterDiscount;
		public String PrintStatus;	//NeedToPrint
		public String EmailStatus;	//NotSet
		public Double Balance;	//245.65
	}
	public class cls_MetaData {
		public String CreateTime;	//2023-01-05T04:44:44-08:00
		public cls_LastModifiedByRef LastModifiedByRef;
		public String LastUpdatedTime;	//2023-01-05T04:44:44-08:00
	}
	public class cls_LastModifiedByRef {
		public String value;	//9130354503741216
	}
	public class cls_CustomField {
		public String DefinitionId;	//1
		public String Name;	//Crew #
		public String Type;	//StringType
	}
   public class cls_CurrencyRef {
		public String value;	//USD
		public String name;	//United States Dollar
	}
	public class cls_LinkedTxn {
	}
	public class cls_Line {
		public String Id;	//1
		public Integer LineNum;	//1
		public Integer Amount;	//289
		public String DetailType;	//SalesItemLineDetail
		public cls_SalesItemLineDetail SalesItemLineDetail;
	}
  public class cls_SalesItemLineDetail {
		public cls_ItemRef ItemRef;
		public Integer UnitPrice;	//289
		public Integer Qty;	//1
		public cls_ItemAccountRef ItemAccountRef;
		public cls_TaxCodeRef TaxCodeRef;
	}
	public class cls_ItemRef {
		public String value;	//23
		public String name;	//Gross Premium
	}
	public class cls_ItemAccountRef {
		public String value;	//1
		public String name;	//Services
	}
	public class cls_TaxCodeRef {
		public String value;	//NON
	}
	public class cls_TxnTaxDetail {
		public Integer TotalTax;	//0
	}
	public class cls_CustomerRef {
		public String value;	//288
		public String name;	//Adam Will
	}
	public class cls_BillAddr {
		public String Id;	//436
		public String Line1;	//Street New Park 23/A
		public String City;	//California
		public String Country;	//USA
		public String CountrySubDivisionCode;	//US
		public String PostalCode;	//74541
	}
	public class cls_ShipFromAddr {
		public String Id;	//441
		public String Line1;	//123 Sierra Way
		public String Line2;	//San Pablo, CA  87999 US
	}
   public class cls_SalesTermRef {
		public String value;	//1
		public String name;	//Due on receipt
	}
	public static QBInvoiceParser parse(String json){
		return (QBInvoiceParser) System.JSON.deserialize(json, QBInvoiceParser.class);
	}

/*	static testMethod void testParse() {
		String json=		'{'+
		' "Invoice": {'+
		'  "AllowIPNPayment": false,'+
		'  "AllowOnlinePayment": false,'+
		'  "AllowOnlineCreditCardPayment": false,'+
		'  "AllowOnlineACHPayment": false,'+
		'  "domain": "QBO",'+
		'  "sparse": false,'+
		'  "Id": "241",'+
		'  "SyncToken": "0",'+
		'  "MetaData": {'+
		'   "CreateTime": "2023-01-05T04:44:44-08:00",'+
		'   "LastModifiedByRef": {'+
		'    "value": "9130354503741216"'+
		'   },'+
		'   "LastUpdatedTime": "2023-01-05T04:44:44-08:00"'+
		'  },'+
		'  "CustomField": ['+
		'   {'+
		'    "DefinitionId": "1",'+
		'    "Name": "Crew #",'+
		'    "Type": "StringType"'+
		'   }'+
		'  ],'+
		'  "DocNumber": "1132",'+
		'  "TxnDate": "2023-01-05",'+
		'  "CurrencyRef": {'+
		'   "value": "USD",'+
		'   "name": "United States Dollar"'+
		'  },'+
		'  "LinkedTxn": [],'+
		'  "Line": ['+
		'   {'+
		'    "Id": "1",'+
		'    "LineNum": 1,'+
		'    "Amount": 289,'+
		'    "DetailType": "SalesItemLineDetail",'+
		'    "SalesItemLineDetail": {'+
		'     "ItemRef": {'+
		'      "value": "23",'+
		'      "name": "Gross Premium"'+
		'     },'+
		'     "UnitPrice": 289,'+
		'     "Qty": 1,'+
		'     "ItemAccountRef": {'+
		'      "value": "1",'+
		'      "name": "Services"'+
		'     },'+
		'     "TaxCodeRef": {'+
		'      "value": "NON"'+
		'     }'+
		'    }'+
		'   },'+
		'   {'+
		'    "Id": "2",'+
		'    "LineNum": 2,'+
		'    "Amount": -43.35,'+
		'    "DetailType": "SalesItemLineDetail",'+
		'    "SalesItemLineDetail": {'+
		'     "ItemRef": {'+
		'      "value": "20",'+
		'      "name": "Comission"'+
		'     },'+
		'     "UnitPrice": -43.35,'+
		'     "Qty": 1,'+
		'     "ItemAccountRef": {'+
		'      "value": "1",'+
		'      "name": "Services"'+
		'     },'+
		'     "TaxCodeRef": {'+
		'      "value": "NON"'+
		'     }'+
		'    }'+
		'   },'+
		'   {'+
		'    "Amount": 245.65,'+
		'    "DetailType": "SubTotalLineDetail",'+
		'    "SubTotalLineDetail": {}'+
		'   }'+
		'  ],'+
		'  "TxnTaxDetail": {'+
		'   "TotalTax": 0'+
		'  },'+
		'  "CustomerRef": {'+
		'   "value": "288",'+
		'   "name": "Adam Will"'+
		'  },'+
		'  "BillAddr": {'+
		'   "Id": "436",'+
		'   "Line1": "Street New Park 23/A",'+
		'   "City": "California",'+
		'   "Country": "USA",'+
		'   "CountrySubDivisionCode": "US",'+
		'   "PostalCode": "74541"'+
		'  },'+
		'  "ShipFromAddr": {'+
		'   "Id": "441",'+
		'   "Line1": "123 Sierra Way",'+
		'   "Line2": "San Pablo, CA  87999 US"'+
		'  },'+
		'  "SalesTermRef": {'+
		'   "value": "1",'+
		'   "name": "Due on receipt"'+
		'  },'+
		'  "DueDate": "2023-01-28",'+
		'  "TotalAmt": 245.65,'+
		'  "ApplyTaxAfterDiscount": false,'+
		'  "PrintStatus": "NeedToPrint",'+
		'  "EmailStatus": "NotSet",'+
		'  "Balance": 245.65'+
		' },'+
		' "time": "2023-01-05T05:27:37.329-08:00"'+
		'}';
		fromJSON obj = parse(json);
		System.assert(obj != null);
	}*/

}