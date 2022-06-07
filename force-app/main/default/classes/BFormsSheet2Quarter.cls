public class BFormsSheet2Quarter{
    
    public string oppId{get;set;}
    
    date startMonth;
    date endMonth;
    public integer totalMoths{get;set;}
    
    public Opportunity oppObj{get;set;}
    
    public BFormsSheet2Quarter(ApexPages.StandardController stdController){
        oppId = stdController.getRecord().Id;
        init();
    }

    public void init(){
        if(oppId == null) oppId = apexpages.currentpage().getparameters().get('id');
        oppObj = [ select id,Amount, Indirect_COS_Amount__c, Interest_Rate__c from Opportunity where id =: oppId ];
        if( oppObj.Interest_Rate__c == null ){
            oppObj.Interest_Rate__c = 0;
        }
        if( oppObj.amount == null ){
            oppObj.amount = 0;
        }
        totalMoths = 0;
        
        calculateStartEndMonth();
        fillMapOfQuarter();
        fillDataByMonth();
        
        totalMoths = keyYearMonth.size();
        
        IRRcal = 0;
        calculateIRR();
    }
    
    public Decimal IRRcal{get;set;}
    private void calculateIRR(){
        XIRR myXIRR = new XIRR();
        
        for( string sKey : keyYearMonth ){
            if( mapOfCumulativeCash.get(sKey) != 0 ){
                decimal ncsh = (mapOfInFlowInvoiceAdvance.get(sKey) + mapOfInFlowInvoiceInvoicingCollection.get(sKey)) - mapOfOutFlowPayment.get(sKey);
                
                if( ncsh != 0 ){
                    myXIRR.addCashflow( fetchDateFromSkey(sKey) , ncsh);
                }
            }
        }
        
        try {
            IRRcal = myXIRR.calculate();
        } 
        catch(XIRR.XIRRException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, + e.getMessage() ));
        }
    }
    
    private Date fetchDateFromSkey(string skey){
    
        string qu = skey.split('-')[1];
        integer yr = integer.valueOf( skey.split('-')[0] );
        integer mthInt = 0;
        if( qu == 'Q1' ){
            mthInt = 1;
        }else if( qu == 'Q2' ){
            mthInt = 4;
        }else if( qu == 'Q3' ){
            mthInt = 7;
        }else if( qu == 'Q4' ){
            mthInt = 10;
        }
        
        return Date.newInstance(yr, mthInt, 1);
    }
    
    
    List<Customer_Billing__c> customerBillingLst;
    List<Vendor__c> VendorBillingLst;
    List<Payment__c> PaymentBillingLst;
    List<Other_CoS__c> OtherCoSBillingLst;
    List<Revenue__c> RevenueBillingLst;
    
    private void calculateStartEndMonth(){
        customerBillingLst = [ select id, Opportunity__c, Billing_Date__c, Billing_Amount__c from Customer_Billing__c where Opportunity__c =: oppId];
        VendorBillingLst = [ select id, Opportunity__c, Billing_Date__c, Billing_Amount__c, Name from Vendor__c where Opportunity__c =: oppId]; 
        PaymentBillingLst = [ select id, Opportunity__c, Date__c, Amount__c,name from Payment__c where Opportunity__c =: oppId]; 
        OtherCoSBillingLst = [ select id, Opportunity__c, Date__c, Amount__c,name from Other_CoS__c where Opportunity__c =: oppId];
        RevenueBillingLst = [ select id, Opportunity__c, Revenue_Date__c, Revenue_Amount__c, Advance_Payment__c from Revenue__c where Opportunity__c =: oppId]; 
        
        boolean firstTime = true;
        for( Customer_Billing__c cbObj : customerBillingLst ){
            if( firstTime && cbObj.Billing_Date__c != null ){
                startMonth = endMonth = cbObj.Billing_Date__c;
                firstTime = false;
            }
            if( cbObj.Billing_Date__c != null && cbObj.Billing_Date__c < startMonth ){
                startMonth = cbObj.Billing_Date__c;
            }
            if( cbObj.Billing_Date__c != null && cbObj.Billing_Date__c > endMonth ){
                endMonth = cbObj.Billing_Date__c;
            }
        }
        
        for( Vendor__c cbObj : VendorBillingLst ){
            if( firstTime && cbObj.Billing_Date__c != null ){
                startMonth = endMonth = cbObj.Billing_Date__c;
                firstTime = false;
            }
            if( cbObj.Billing_Date__c != null && cbObj.Billing_Date__c < startMonth ){
                startMonth = cbObj.Billing_Date__c;
            }
            if( cbObj.Billing_Date__c != null && cbObj.Billing_Date__c > endMonth ){
                endMonth = cbObj.Billing_Date__c;
            }
        }
        
        for( Payment__c cbObj : PaymentBillingLst ){
            if( firstTime && cbObj.Date__c != null ){
                startMonth = endMonth = cbObj.Date__c;
                firstTime = false;
            }
            if( cbObj.Date__c != null && cbObj.Date__c < startMonth ){
                startMonth = cbObj.Date__c;
            }
            if( cbObj.Date__c != null && cbObj.Date__c > endMonth ){
                endMonth = cbObj.Date__c;
            }
        }
        
        for( Other_CoS__c cbObj : OtherCoSBillingLst){
            if( firstTime && cbObj.Date__c != null ){
                startMonth = endMonth = cbObj.Date__c;
                firstTime = false;
            }
            if( cbObj.Date__c != null && cbObj.Date__c < startMonth ){
                startMonth = cbObj.Date__c;
            }
            if( cbObj.Date__c != null && cbObj.Date__c > endMonth ){
                endMonth = cbObj.Date__c;
            }
        }
        
        for( Revenue__c cbObj : RevenueBillingLst){
            if( firstTime && cbObj.Revenue_Date__c != null ){
                startMonth = endMonth = cbObj.Revenue_Date__c;
                firstTime = false;
            }
            if( cbObj.Revenue_Date__c != null && cbObj.Revenue_Date__c < startMonth ){
                startMonth = cbObj.Revenue_Date__c;
            }
            if( cbObj.Revenue_Date__c != null && cbObj.Revenue_Date__c > endMonth ){
                endMonth = cbObj.Revenue_Date__c;
            }
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


    public set<string> keyYearMonth{get;set;}
    
    private void fillDataByMonth(){
        //Filling Data for Inflow Invoicing
        mapOfInFlowInvoicing = new Map<string,decimal>();
        for( Customer_Billing__c cbObj : customerBillingLst ){
            if( cbObj.Billing_Date__c != null && cbObj.Billing_Amount__c != null ){
                Decimal amt = 0;
                string keyStr = cbObj.Billing_Date__c.year()+'-'+ calculateQuqter(cbObj.Billing_Date__c);
                if( mapOfInFlowInvoicing.get(keyStr) != null ){
                    amt = mapOfInFlowInvoicing.get(keyStr);
                }
                amt += cbObj.Billing_Amount__c;
                mapOfInFlowInvoicing.put(keyStr, amt);
            }
        }
        
        //Filling Data for Inflow Invoice Advance and Collection
        mapOfInFlowInvoiceAdvance = new Map<string,decimal>();
        mapOfInFlowInvoiceInvoicingCollection = new Map<string,decimal>();
        for( Revenue__c cbObj : RevenueBillingLst ){
            if( cbObj.Revenue_Date__c != null && cbObj.Revenue_Amount__c != null ){
                Decimal amt = 0;
                string keyStr = cbObj.Revenue_Date__c.year()+'-'+ calculateQuqter(cbObj.Revenue_Date__c);
                if( cbObj.Advance_Payment__c ){
                    if( mapOfInFlowInvoiceAdvance.get(keyStr) != null ){
                        amt = mapOfInFlowInvoiceAdvance.get(keyStr);
                    }
                    amt += cbObj.Revenue_Amount__c;
                    mapOfInFlowInvoiceAdvance.put(keyStr, amt);
                }else{
                    if( mapOfInFlowInvoiceInvoicingCollection.get(keyStr) != null ){
                        amt = mapOfInFlowInvoiceInvoicingCollection.get(keyStr);
                    }
                    amt += cbObj.Revenue_Amount__c;
                    mapOfInFlowInvoiceInvoicingCollection.put(keyStr, amt);
                }
            }
        }
        
        //Filling Data for Outflow Invoicing List and Invoicing sum
        mapOfOutFlowInvoiceLst = new List< Map<string, Vendor__c > >();
        mapOfOutFlowInvoice = new Map<string,decimal>();
        for( Vendor__c cbObj : VendorBillingLst ){
            if( cbObj.Billing_Date__c != null && cbObj.Billing_Amount__c != null ){
                Decimal amt = 0;
                Decimal amt2 = 0;
                string keyStr = cbObj.Billing_Date__c.year()+'-'+ calculateQuqter(cbObj.Billing_Date__c);
                Map<string,Vendor__c> mapOfOutFlowInvoicing = new Map<string,Vendor__c>();
                mapOfOutFlowInvoicing.put(keyStr, cbObj);
                mapOfOutFlowInvoiceLst.add(mapOfOutFlowInvoicing);

                if( mapOfOutFlowInvoice.get(keyStr) != null ){
                    amt2 = mapOfOutFlowInvoice.get(keyStr);
                }
                amt2 += cbObj.Billing_Amount__c;
                mapOfOutFlowInvoice.put(keyStr, amt2);
            }
        }

        //Filling Data for Outflow Payment List and Payment sum
        mapOfOutFlowPaymentLst = new List< Map<string, Payment__c > >();
        mapOfOutFlowPayment = new Map<string,decimal>();
        for( Payment__c cbObj : PaymentBillingLst ){
            if( cbObj.Date__c != null && cbObj.Amount__c != null ){
                Decimal amt = 0;
                Decimal amt2 = 0;
                string keyStr = cbObj.Date__c.year()+'-'+ calculateQuqter(cbObj.Date__c);
                Map<string,Payment__c> mapOfOutFlowPaymentTemp = new Map<string,Payment__c>();
                mapOfOutFlowPaymentTemp.put(keyStr, cbObj);
                mapOfOutFlowPaymentLst.add(mapOfOutFlowPaymentTemp);

                if( mapOfOutFlowPayment.get(keyStr) != null ){
                    amt2 = mapOfOutFlowPayment.get(keyStr);
                }
                amt2 += cbObj.Amount__c;
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
                string keyStr = cbObj.Date__c.year()+'-'+ calculateQuqter(cbObj.Date__c);
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
                    lstMapOfOutF.put(keyStr,new Vendor__c(Billing_Amount__c=0));
                }
            }
            if( mapOfOutFlowInvoice.get(keyStr) == null ){
                mapOfOutFlowInvoice.put(keyStr,0);
            }
            
            for( Map<string,Payment__c>  lstMapOfOutF : mapOfOutFlowPaymentLst){
                if( lstMapOfOutF.get(keyStr) == null ){
                    lstMapOfOutF.put(keyStr,new Payment__c(Amount__c=0));
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
            Decimal outflow = mapOfOutFlowPayment.get(keyStr) ;
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
        
    }
    
    private void fillMapOfQuarter(){
        date TempstartMonth = startMonth;
        date TempendMonth = endMonth;
        yearMonth = new Map<string,list<MonthsWrapper>>();
        keyYearMonth = new Set<String>();
        while(true){
            if( TempstartMonth >= TempendMonth  ){
                break;
            }
            
            List<MonthsWrapper> monthsLst = new List<MonthsWrapper>();
            if( yearMonth.get(TempstartMonth.year()+'') != null ){
                monthsLst = yearMonth.get(TempstartMonth.year()+'') ;  
            }
            
            MonthsWrapper MW = new MonthsWrapper();
            MW.months = calculateQuqter(TempstartMonth);
            boolean dupFound = false;
            for( MonthsWrapper ml : monthsLst){
                if( ml.months == calculateQuqter(TempstartMonth) ){
                    dupFound = true;
                }
            }
            if( !dupFound ){
                monthsLst.add( MW );
            }
            
            string keyStr = TempstartMonth.year()+'-'+ calculateQuqter(TempstartMonth);
            keyYearMonth.add(keyStr);
            
            yearMonth.put(TempstartMonth.year()+'',monthsLst);
            
            TempstartMonth = TempstartMonth.addMonths(1);
        }
        
        //Setting up size for total months ( Year Colspan on page)
        for( string str : yearMonth.keySet() ){
            yearMonth.get(str)[0].TotalSize = yearMonth.get(str).size();
        }
    }
    
    private string calculateQuqter( Date dt){
        if( dt.month() >= 1 && dt.month() <= 3 ){
            return 'Q1';
        }
        else if( dt.month() >= 4 && dt.month() <= 6 ){
            return 'Q2';
        }
        else if( dt.month() >= 7 && dt.month() <= 9 ){
            return 'Q3';
        }
        return 'Q4';
    }
    
    public class MonthsWrapper{
        public string months{get;set;}
        public integer TotalSize{get;set;}
    }
}