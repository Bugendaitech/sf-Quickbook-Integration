public class QB_CustomerJSON {
    public QueryResponse QueryResponse;
    public Customer Customer;
    
    public class QueryResponse {
		public List<Customer> Customer;
	}	
    
	public class Customer {
		public String Id;
		public String CompanyName;
		public String DisplayName;
		public WebAddr WebAddr;
		public Fax Fax;
		public String Notes;
		public PrimaryPhone PrimaryPhone;
		public PrimaryEmailAddr PrimaryEmailAddr;
		public BillAddr BillAddr;
        public SalesTermRef SalesTermRef;
		public MetaData MetaData;
		public Boolean Active;

        public Customer(Account acc){
			this.CompanyName = acc.Name;
            this.DisplayName = acc.Name;
            this.WebAddr = new WebAddr(acc.Website);
            this.Fax = new Fax(acc.Fax);
            //this.Notes = acc.Description;
            this.PrimaryPhone = new PrimaryPhone(acc.Phone);
            this.PrimaryEmailAddr = new PrimaryEmailAddr(acc.Email__c);
            this.BillAddr = new BillAddr(acc.BillingState, acc.BillingCity, acc.BillingPostalCode, acc.BillingStreet, acc.BillingCountry);
            this.SalesTermRef = new SalesTermRef('3');
        }
	}
    
    public class WebAddr {
		public String URI;
        public WebAddr(String URI){
            this.URI = URI;
        }
	}
    
    public class Fax {
		public String FreeFormNumber;
        public Fax(String FreeFormNumber){
            this.FreeFormNumber = FreeFormNumber;
        }
	}

	public class PrimaryPhone {
		public String FreeFormNumber;
        public PrimaryPhone(String FreeFormNumber){
            this.FreeFormNumber = FreeFormNumber;
        }
	}

	public class PrimaryEmailAddr {
		public String Address;
        public PrimaryEmailAddr(String Address){
            this.Address = Address;
        }
	}
    
    public class BillAddr {
		public String Id;
		public String Line1;
		public String City;
		public String Country;
		public String CountrySubDivisionCode;
		public String PostalCode;
        public BillAddr(String CountrySubDivisionCode, String City, String PostalCode, String Line1, String Country){
            this.CountrySubDivisionCode = CountrySubDivisionCode;
            this.City = City;
            this.PostalCode = PostalCode;
            this.Line1 = Line1;
            this.Country = Country;
        }
	}
    
    public class SalesTermRef {
		public String value;
        public SalesTermRef(String value){
            
            System.debug('Value is 1 '+value);
            this.value = value;            
            System.debug('Value is 2 '+value);
        }

	}
    
    public class MetaData {
		public String CreateTime;
		public String LastUpdatedTime;
	}
	
	public static QB_CustomerJSON parse(String json) {
		return (QB_CustomerJSON) System.JSON.deserialize(json, QB_CustomerJSON.class);
	}
}