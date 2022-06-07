public class OpportunityCashFlowController {
	
    public string oppId{get;set;}
    public date startMonth{get;set;}
    public date endMonth{get;set;}
    public integer totalMoths{get;set;}
    public Opportunity oppObj{get;set;}
    public Decimal IRRcal{get;set;}  
    public Decimal IRRcal2{get;set;}
    public string Error{get;set;}
    Boolean test{get;set;}
    public Decimal SumOfFinanceCost{get;set;}
    public Decimal BSMV{get;set;}
    public Decimal KKDF{get;set;}
    public Decimal TotalFinanceCost{get;set;}

    public OpportunityCashFlowController(ApexPages.StandardController stdController){
        oppId = stdController.getRecord().Id;
        try {
            init();
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, + e.getMessage() ));
        } 
    }
    
    public void init(){
        oppObj = [ select id,Amount, Sum_Of_Payments_USD__c, Amount_USD__c, BForm_Indirect_Cost__c, Interest_Rate__c from Opportunity where id =: oppId ];
        
        if( oppObj.Interest_Rate__c == null ){
            oppObj.Interest_Rate__c = 11;
        }
        
        
        totalMoths = 0;
        test=calculateStartEndMonth();
        if(test==true)
        {
        fillMapOfYearMonth();
        totalMoths = keyYearMonth.size();
        fillDataByMonth();
        
        IRRcal = 0;
        calculateIRR();   
        }
        
         
    }
    
    private Date fetchDateFromSkey(string skey){
    
        string mth = skey.split('-')[1];
        integer yr = integer.valueOf( skey.split('-')[0] );
        integer mthInt = 0;
        if( mth == 'Jan' ){
            mthInt = 1;
        }else if( mth == 'Feb' ){
            mthInt = 2;
        }else if( mth == 'Mar' ){
            mthInt = 3;
        }else if( mth == 'Apr' ){
            mthInt = 4;
        }else if( mth == 'May' ){
            mthInt = 5;
        }else if( mth == 'Jun' ){
            mthInt = 6;
        }else if( mth == 'Jul' ){
            mthInt = 7;
        }else if( mth == 'Aug' ){
            mthInt = 8;
        }else if( mth == 'Sep' ){
            mthInt = 9;
        }else if( mth == 'Oct' ){
            mthInt = 10;
        }else if( mth == 'Nov' ){
            mthInt = 11;
        }else if( mth == 'Dec' ){
            mthInt = 12;
        }
        
        return Date.newInstance(yr, mthInt, 1);
    }
    
    private void calculateIRR(){
        XIRR myXIRR = new XIRR(); 
        
        for( string sKey : keyYearMonth ){
            if( mapOfCumulativeCash.get(sKey) != 0 ){
                decimal ncsh = (mapOfInFlowInvoiceAdvance.get(sKey) + mapOfInFlowInvoiceInvoicingCollection.get(sKey)) - ( mapOfOutFlowPayment.get(sKey) + mapOfOutFlowOtherCOS.get(sKey));
                System.debug(' Cash Detail : '+fetchDateFromSkey(sKey)+' --- '+ncsh );
                myXIRR.addCashflow( fetchDateFromSkey(sKey) , ncsh);
            }
        }
        
        try {
            IRRcal = myXIRR.calculate();
        } 
        catch(XIRR.XIRRException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, + e.getMessage() ));
        }
       
        
    }
    
    List<Customer_Billing__c> customerBillingLst;
    List<Vendor__c> VendorBillingLst;
    List<Payment__c> PaymentBillingLst;
    List<Other_CoS__c> OtherCoSBillingLst;
    List<Revenue__c> RevenueBillingLst;
    
    private Boolean calculateStartEndMonth(){
        customerBillingLst = [ select id, Opportunity__c, Billing_Date__c, N_Billing_Amount_USD__c from Customer_Billing__c where Opportunity__c =: oppId];
        VendorBillingLst = [ select id, Opportunity__c, Billing_Date__c, N_Billing_Amount_USD__c, Name from Vendor__c where Opportunity__c =: oppId];
        RevenueBillingLst = [ select id, Opportunity__c, Revenue_Date__c, N_Revenue_Amount_USD__c, Advance_Payment__c from Revenue__c where Opportunity__c =: oppId]; 
        PaymentBillingLst = [ select id, Opportunity__c, Date__c,name, N_Payment_Amount_USD__c, Advance_Payment__c from Payment__c where Opportunity__c =: oppId]; 
        OtherCoSBillingLst = [ select id, Opportunity__c, Date__c, Amount__c,name from Other_CoS__c where Opportunity__c =: oppId];
        
        list<date> lstdt = new list<date>();

        for( Customer_Billing__c cbObj : customerBillingLst ){
            if(cbObj.Billing_Date__c != null)
                lstdt.add(cbObj.Billing_Date__c);
        }
        
        for( Vendor__c cbObj : VendorBillingLst ){
            if(cbObj.Billing_Date__c != null)
                lstdt.add(cbObj.Billing_Date__c);
        }
        
        for( Payment__c cbObj : PaymentBillingLst ){
            if(cbObj.Date__c != null)
                lstdt.add(cbObj.Date__c);
        }
        
        for( Other_CoS__c cbObj : OtherCoSBillingLst){
            if(cbObj.Date__c != null)
                lstdt.add(cbObj.Date__c);
        }
        
        for( Revenue__c cbObj : RevenueBillingLst){
            if(cbObj.Revenue_Date__c != null)
                lstdt.add(cbObj.Revenue_Date__c);
        }
        
        lstdt.sort();
        
       if(lstdt.size()==0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no "COLLECTION" record for opportunity'));
           return false;
          }
        else{
        startMonth  = lstdt[0];
        endMonth = lstdt[lstdt.size()-1];
            return true;
        }
        
        
    }
    
    public Map<string,list<MonthsWrapper>> yearMonth{get;set;}
    
    public Map<string,decimal> mapOfInFlowInvoicing{get;set;}
    public Map<string,decimal> mapOfInFlowInvoiceAdvance{get;set;}
    public Map<string,decimal> mapOfInFlowInvoiceInvoicingCollection{get;set;}
    public Map<string,decimal> mapOfOutFlowInvoice{get;set;}
    public List< Map<string, Vendor__c > > mapOfOutFlowInvoiceLst{get;set;}
    public Map<string,decimal> mapOfOutFlowPayment{get;set;}
    public List< Map<string, Payment__c > > mapOfOutFlowPaymentLst{get;set;}
    public Map<string,decimal> mapOfOutFlowOtherCOS{get;set;}
    public List< Map<string, Other_CoS__c > > mapOfOutFlowOtherCOSLst{get;set;}
    public Map<string,decimal> mapOfCumulativeCash{get;set;}
    public Map<string,decimal> mapOfFinanceCost{get;set;}


    public set<string> keyYearMonth{get;set;}
    
    private void fillDataByMonth(){
        //Filling Data for Inflow Invoicing
        mapOfInFlowInvoicing = new Map<string,decimal>();
        for( Customer_Billing__c cbObj : customerBillingLst ){
            if( cbObj.Billing_Date__c != null && cbObj.N_Billing_Amount_USD__c != null ){
                Decimal amt = 0;
                string keyStr = cbObj.Billing_Date__c.year()+'-'+ DateTime.newInstance(cbObj.Billing_Date__c, time.newInstance(0,0,0,0) ).format('MMM');
                if( mapOfInFlowInvoicing.get(keyStr) != null ){
                    amt = mapOfInFlowInvoicing.get(keyStr);
                }
                amt += cbObj.N_Billing_Amount_USD__c;
                mapOfInFlowInvoicing.put(keyStr, amt);
            }
        }
        
        //Filling Data for Inflow Invoice Advance and Collection
        mapOfInFlowInvoiceAdvance = new Map<string,decimal>();
        mapOfInFlowInvoiceInvoicingCollection = new Map<string,decimal>();
        for( Revenue__c cbObj : RevenueBillingLst ){
            if( cbObj.Revenue_Date__c != null && cbObj.N_Revenue_Amount_USD__c != null ){
                Decimal amt = 0;
                string keyStr = cbObj.Revenue_Date__c.year()+'-'+ DateTime.newInstance(cbObj.Revenue_Date__c, time.newInstance(0,0,0,0) ).format('MMM');
                if( cbObj.Advance_Payment__c ){
                    if( mapOfInFlowInvoiceAdvance.get(keyStr) != null ){
                        amt = mapOfInFlowInvoiceAdvance.get(keyStr);
                    }
                    amt += cbObj.N_Revenue_Amount_USD__c;
                    mapOfInFlowInvoiceAdvance.put(keyStr, amt);
                }else{
                    if( mapOfInFlowInvoiceInvoicingCollection.get(keyStr) != null ){
                        amt = mapOfInFlowInvoiceInvoicingCollection.get(keyStr);
                    }
                    amt += cbObj.N_Revenue_Amount_USD__c;
                    mapOfInFlowInvoiceInvoicingCollection.put(keyStr, amt);
                }
            }
        }
        
        //Filling Data for Outflow Invoicing List and Invoicing sum
        mapOfOutFlowInvoiceLst = new List< Map<string, Vendor__c > >();
        mapOfOutFlowInvoice = new Map<string,decimal>();
        for( Vendor__c cbObj : VendorBillingLst ){
            if( cbObj.Billing_Date__c != null && cbObj.N_Billing_Amount_USD__c != null ){
                Decimal amt = 0;
                Decimal amt2 = 0;
                string keyStr = cbObj.Billing_Date__c.year()+'-'+ DateTime.newInstance(cbObj.Billing_Date__c, time.newInstance(0,0,0,0) ).format('MMM');
                Map<string,Vendor__c> mapOfOutFlowInvoicing = new Map<string,Vendor__c>();
                mapOfOutFlowInvoicing.put(keyStr, cbObj);
                mapOfOutFlowInvoiceLst.add(mapOfOutFlowInvoicing);

                if( mapOfOutFlowInvoice.get(keyStr) != null ){
                    amt2 = mapOfOutFlowInvoice.get(keyStr);
                }
                amt2 += cbObj.N_Billing_Amount_USD__c;
                mapOfOutFlowInvoice.put(keyStr, amt2);
            }
        }

        //Filling Data for Outflow Payment List and Payment sum
        mapOfOutFlowPaymentLst = new List< Map<string, Payment__c > >();
        mapOfOutFlowPayment = new Map<string,decimal>();
        for( Payment__c cbObj : PaymentBillingLst ){
            if( cbObj.Date__c != null && cbObj.N_Payment_Amount_USD__c != null ){
                Decimal amt = 0;
                Decimal amt2 = 0;
                string keyStr = cbObj.Date__c.year()+'-'+ DateTime.newInstance(cbObj.Date__c, time.newInstance(0,0,0,0) ).format('MMM');
                Map<string,Payment__c> mapOfOutFlowPaymentTemp = new Map<string,Payment__c>();
                mapOfOutFlowPaymentTemp.put(keyStr, cbObj);
                mapOfOutFlowPaymentLst.add(mapOfOutFlowPaymentTemp);

                if( mapOfOutFlowPayment.get(keyStr) != null ){
                    amt2 = mapOfOutFlowPayment.get(keyStr);
                }
                amt2 += cbObj.N_Payment_Amount_USD__c;
                mapOfOutFlowPayment.put(keyStr, amt2);
            }
        }
        
        //Filling Data for Outflow Other COS List and Other COS sum
        mapOfOutFlowOtherCOSLst = new List< Map<string, Other_CoS__c > >();
        mapOfOutFlowOtherCOS = new Map<string,decimal>();
        for( Other_CoS__c cbObj : OtherCoSBillingLst ){
            if( cbObj.Date__c != null && cbObj.Amount__c != null ){
                Decimal amt = 0;
                Decimal amt2 = 0;
                string keyStr = cbObj.Date__c.year()+'-'+ DateTime.newInstance(cbObj.Date__c, time.newInstance(0,0,0,0) ).format('MMM');
                Map<string,Other_CoS__c> mapOfOutFlowOtherCOSTemp = new Map<string,Other_CoS__c>();
                mapOfOutFlowOtherCOSTemp.put(keyStr, cbObj);
                mapOfOutFlowOtherCOSLst.add(mapOfOutFlowOtherCOSTemp);

                if( mapOfOutFlowOtherCOS.get(keyStr) != null ){
                    amt2 = mapOfOutFlowOtherCOS.get(keyStr);
                }
                amt2 += cbObj.Amount__c;
                mapOfOutFlowOtherCOS.put(keyStr, amt2);
            }
        }
        
        for( string keyStr : keyYearMonth ){
            if( mapOfInFlowInvoicing.get(keyStr) == null ){
                mapOfInFlowInvoicing.put(keyStr,0);
            }
            if( mapOfInFlowInvoiceAdvance.get(keyStr) == null ){
                mapOfInFlowInvoiceAdvance.put(keyStr,0);
            }
            if( mapOfInFlowInvoiceInvoicingCollection.get(keyStr) == null ){
                mapOfInFlowInvoiceInvoicingCollection.put(keyStr,0);
            }
            
            for( Map<string,Vendor__c>  lstMapOfOutF : mapOfOutFlowInvoiceLst){
                if( lstMapOfOutF.get(keyStr) == null ){
                    lstMapOfOutF.put(keyStr,new Vendor__c(N_Billing_Amount_USD__c=0));
                }
            }
            if( mapOfOutFlowInvoice.get(keyStr) == null ){
                mapOfOutFlowInvoice.put(keyStr,0);
            }
            
            for( Map<string,Payment__c>  lstMapOfOutF : mapOfOutFlowPaymentLst){
                if( lstMapOfOutF.get(keyStr) == null ){
                    lstMapOfOutF.put(keyStr,new Payment__c(N_Payment_Amount_USD__c=0));
                }
            }
            if( mapOfOutFlowPayment.get(keyStr) == null ){
                mapOfOutFlowPayment.put(keyStr,0);
            }
            
            for( Map<string,Other_CoS__c>  lstMapOfOutF : mapOfOutFlowOtherCOSLst){
                if( lstMapOfOutF.get(keyStr) == null ){
                    lstMapOfOutF.put(keyStr,new Other_CoS__c(Amount__c=0));
                }
            }
            if( mapOfOutFlowOtherCOS.get(keyStr) == null ){
                mapOfOutFlowOtherCOS.put(keyStr,0);
            }
        }
        
        //Calculatin and filling Cumulative Cash
        mapOfCumulativeCash = new Map<String,Decimal>();
        integer ymCount = 1;
        for( string keyStr : keyYearMonth ){
            Decimal inflow = mapOfInFlowInvoiceAdvance.get(keyStr) + mapOfInFlowInvoiceInvoicingCollection.get(keyStr);
            Decimal outflow = mapOfOutFlowPayment.get(keyStr) + mapOfOutFlowOtherCOS.get(keyStr); 
            Decimal netCash = inflow - outflow;
            Decimal cc = 0;
            if( ymCount == 1 ){
                cc = netCash;
            }
            else{
                Decimal preAmt = 0;
                integer j=1;
                for( string keyStrTemp : keyYearMonth ){
                    if( ymCount-1 == j ){
                        preAmt = mapOfCumulativeCash.get( keyStrTemp );
                        break;
                    }
                    j++;
                }
                cc = netCash + preAmt;
            }
            mapOfCumulativeCash.put(keyStr,cc);
            ymCount++;
        }
        
        // ERHAN Erhan Finance Cost Calculation Starts
        mapOfFinanceCost = new Map<String,Decimal>();
        SumOfFinanceCost=0;
        BSMV=0;
        KKDF=0;
        TotalFinanceCost=0;
        for( string keyStr : keyYearMonth )
        {
            Decimal FinanceCost = (((mapOfCumulativeCash.get(keyStr)*(oppObj.Interest_Rate__c/100))/360)*30);           
            mapOfFinanceCost.put(keyStr,FinanceCost);
            
                if(FinanceCost < 0)
                {
                   SumOfFinanceCost += FinanceCost * (-1);
                   system.debug(SumOfFinanceCost+'ERHAN0');                    
                }             
        }
        	    BSMV= SumOfFinanceCost * (0.05);
                system.debug(BSMV +'ERHAN1');
                KKDF= BSMV * (0.15);
                system.debug(KKDF +'ERHAN2');
                TotalFinanceCost = SumOfFinanceCost + BSMV + KKDF;
                system.debug(TotalFinanceCost +'ERHAN3'); 
        
        // ERHAN Finance Cost Calculation Ends 
        
    }
        
    
    
    private void fillMapOfYearMonth(){
        date TempstartMonth = Date.newInstance(startMonth.year(), startMonth.month(), 1);
        date TempendMonth = Date.newInstance(endMonth.year(), endMonth.month(), 1);
        yearMonth = new Map<string,list<MonthsWrapper>>();
        keyYearMonth = new Set<String>();
        
        date dloop;
        for( dloop = TempstartMonth ; dloop <= TempendMonth ; dloop=dloop.addMonths(1) ){
            
            List<MonthsWrapper> monthsLst = new List<MonthsWrapper>();
            if( yearMonth.get(dloop.year()+'') != null ){
                monthsLst = yearMonth.get(dloop.year()+'') ;  
            }
            
            MonthsWrapper MW = new MonthsWrapper();
            MW.months = DateTime.newInstance(dloop, time.newInstance(0,0,0,0) ).format('MMM');
            
            monthsLst.add( MW );
            
            string keyStr = dloop.year()+'-'+ DateTime.newInstance(dloop, time.newInstance(0,0,0,0) ).format('MMM');
            keyYearMonth.add(keyStr);
            
            yearMonth.put(dloop.year()+'',monthsLst); 
        }
        
        //Setting up size for total months ( Year Colspan on page)
        for( string str : yearMonth.keySet() ){
            yearMonth.get(str)[0].TotalSize = yearMonth.get(str).size();
        }
    }
    
    public class MonthsWrapper{
        public string months{get;set;}
        public integer TotalSize{get;set;}
    }
    
}