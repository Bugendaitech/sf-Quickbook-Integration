public class qbGetCount {
    Public static void getCount(String recid){  
        Date dateToday = Date.today();
        String Month = String.valueof(dateToday.month());
        String Day = String.valueof(dateToday.day());
        if(Month.length()==1){
            Month = '0' + Month;
        }
        if(Day.length()==1){
            Day = '0' + Day;
        }
        String sToday = String.valueof(dateToday.year()) + Month + Day ;
        //System.debug(sToday);
       // List<Integer> Chars = New List<Integer>();
        String dateChar;
         AggregateResult qbCount = [SELECT Count(id) ctid FROM QB_Invoice__c WHERE Account__c =: recid];
        Integer ct = (Integer) qbCount.get('ctid');
        //System.debug(qbCount);
         dateChar = sToday + 'A';
        System.debug(dateChar);
        
        for(Integer i=0; i<ct; i++){
            if(i>=1){
                Integer charCode = 'A'.charAt(0);
                List<Integer> chars = new List<Integer>{charCode+i};
                
                    String nextChar = String.fromCharArray(Chars);
                //System.debug(nextChar);
                dateChar = sToday + nextChar;
                System.debug(dateChar);
            }
        }
        
        
    }
}