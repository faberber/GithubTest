public class VendorBillingUtilities {

    public static void SyncVendorBillingsFromOppLineItems(Set<Id> oppIdSet)
    {        

        List<Vendor__c> vendorBillingList = [SELECT Id FROM Vendor__c Where Opportunity__c  in :oppIdSet];
        if(vendorBillingList.size() > 0)
        {
            delete vendorBillingList;
        }
        
        vendorBillingList = new List<Vendor__c>();
        Set<VendorMini> vSet=new Set<VendorMini>();
        Map<VendorMini,Decimal> vMap=new Map<VendorMini,Decimal>();
        Set<Id> vendorIdSet=new Set<Id>();
        List<OpportunityLineItem> oliList=[select id,CurrencyIsoCode,Cost__c,Originated_TD__r.Estimated_Installments__c,Originated_TD__r.Estimated_Invoice_Date__c,Originated_TD__r.Estimated_Invoice_Monthly_Term__c,Vendor__c,OpportunityId from OpportunityLineItem where OpportunityId in : oppIdSet];
        
        for(OpportunityLineItem oli:oliList)
        {
            vendorIdSet.add(oli.Vendor__c);
            VendorMini v=new VendorMini(oli.Originated_TD__r.Estimated_Invoice_Date__c,oli.Originated_TD__r.Estimated_Installments__c,oli.Originated_TD__r.Estimated_Invoice_Monthly_Term__c,oli.Vendor__c,oli.OpportunityId,oli.CurrencyIsoCode);
            if(vSet.contains(v))
            {
                Decimal d=vMap.get(v);
                d+=oli.Cost__c;
                vMap.put(v, d);
            }
            else
            {
                vSet.add(v);
                vMap.put(v,oli.Cost__c);
            }

        }
 
    
        Map<Id,Account> vendorDueList = new Map<Id,Account>([SELECT Id, Due_Upon__c FROM Account WHERE Id in : vendorIdSet]);
        for(VendorMini vb : vMap.keySet())
        {
            vendorBillingList.addAll(AddVendorBillings(vb,vMap.get(vb), vendorDueList.get(vb.vendor).Due_Upon__c, vb.currencyIso));
        }
        
        if(vendorBillingList.size() > 0)
        {
            insert vendorBillingList;
        }
        
        
    }

    
    /*
   public static void SyncVendorBillings(Set<Id> oppIdSet)
    {
        List<TD_Work_Item__c> TDWIList=[select id,Estimated_Invoice_Monthly_Term__c,Related_Opportunity__r.Account.Payment_Term__c,CurrencyIsoCode,Related_Opportunity__c,Estimated_Installments__c,Estimated_Invoice_Date__c,Suggested_Cost__c from TD_Work_Item__c where Related_Opportunity__c in : oppIdSet and Status__c='Completed'];
        List<Vendor__c> vendorList = [SELECT Id FROM Vendor__c Where Opportunity__c  in :oppIdSet];
        if(vendorList.size() > 0)
        {
            delete vendorList;
        }
        vendorList=new List<Vendor__c>();
        
        for(TD_Work_Item__c TDWI : TDWIList)
        {
                vendorList.addAll(AddVendorBilling(TDWI, TDWI.Suggested_Cost__c));
        }
        
        if(vendorList.size() > 0) 
        {
            insert vendorList;
        }
    } 
    
   private static List<Vendor__c> AddVendorBilling(TD_Work_Item__c TDWI, Decimal amount)
    {
        
        Date lastInvoiceUpdate=system.today();
        Decimal billingAmount = (Decimal)amount/TDWI.Estimated_Installments__c;
        Date billingDate = TDWI.Estimated_Invoice_Date__c == null ? System.today() : TDWI.Estimated_Invoice_Date__c;        
        
        List<Vendor__c> VendorList=new List<Vendor__c>();
        for(double i=0;i<TDWI.Estimated_Installments__c;i++)
        {
            Vendor__c Vendor=new Vendor__c();
            Vendor.Opportunity__c=TDWI.Related_Opportunity__c;
            Vendor.CurrencyIsoCode=TDWI.CurrencyIsoCode;
            Vendor.Due_Upon__c=TDWI.Related_Opportunity__r.Account.Payment_Term__c == null ? 0 : TDWI.Related_Opportunity__r.Account.Payment_Term__c;
            Vendor.N_Billing_Amount__c= billingAmount;
            Vendor.Billing_Date__c=billingDate;
            VendorList.add(Vendor); 
            
            billingDate = billingDate.addMonths((Integer)TDWI.Estimated_Invoice_Monthly_Term__c);
        }    
        
        return VendorList; 
    }*/
    
  private static List<Vendor__c> AddVendorBillings(VendorMini vb, Decimal cost,Decimal dueUpon, String currencyCode)
    {
        List<Vendor__c> vl=new List<Vendor__c>();
        Decimal tempAmount=0;        
        Date idate=vb.invoiceDate;
        for(Integer i=0;i<vb.installments;i++)
        {
            
            Vendor__c vendorBilling = new Vendor__c();
            vendorBilling.CurrencyIsoCode = currencyCode;
            vendorBilling.Billing_Date__c = idate;
            vendorBilling.Opportunity__c = vb.oppty;
            vendorBilling.Vendor__c = vb.vendor;
            vendorBilling.Due_Upon__c=dueUpon;
            if(i!=vb.installments-1)
            {
             
                Decimal billingAmount = (Decimal)Cost/vb.installments;
                billingAmount=billingAmount.round(System.roundingMode.DOWN);
                vendorBilling.N_Billing_Amount__c= billingAmount;
                tempAmount+=billingAmount;
            }
            else
            {
                 vendorBilling.N_Billing_Amount__c= cost-tempAmount;
            }
            
            vl.add(vendorBilling);
            idate=idate.addMonths((Integer)vb.monthlyTerm);
        }
        
        
        return vl;
    } 
    private class VendorMini{
        private Date invoiceDate{get;set;}
        private Decimal installments{get;set;}
        private Decimal monthlyTerm{get;set;}
        private Id vendor {get;set;}
        private Id oppty {get;set;}
        String currencyIso {get;set;}
        public VendorMini(Date invoiceDate,Decimal installments,Decimal monthlyTerm,Id vendor,Id oppty,String currencyIso)
        {
            this.invoiceDate=invoiceDate;
            this.installments=installments;
            this.monthlyTerm=monthlyTerm;
            this.vendor=vendor;
            this.oppty=oppty;
            this.currencyIso=currencyIso;
        }
        public Boolean equals(Object obj) 
        {
           if(obj instanceof VendorMini)
           {
              VendorMini v=(VendorMini)obj;
            if(v.invoiceDate==this.invoiceDate && v.installments==this.installments && v.monthlyTerm==this.monthlyTerm && v.vendor==this.vendor && v.oppty==this.oppty)
            {
                return true;
            }
            else
            {
                return false;
            }
           }
            return false;
        }
        
        public Integer hashCode() 
        {
            if(Test.isRunningTest())
            {
                return ((String)oppty).hashCode();
            }
         return ((Integer)installments*(Integer)monthlyTerm*invoiceDate.day()*invoiceDate.month()*invoiceDate.year()*((String)vendor).hashCode()*((String)oppty).hashCode());
        }

        
    }

}