public class CustomerBillingUtilities {

    public static void SyncCustomerBillings(Set<Id> oppIdList)
    {
        Set<Id> customerIdList = new Set<Id>();
        List<Customer_Billing__c> newCustomerBillingList = new List<Customer_Billing__c>();
        
         //1. Opportunitye ait tüm CustomerBilling recordları silinir.
        List<Customer_Billing__c> oldCustomerBillingList = [SELECT Id FROM Customer_Billing__c Where Opportunity__c  in :oppIdList];
        if(oldCustomerBillingList.size() > 0)
            delete oldCustomerBillingList;
        
        //2. Opportunitye ait tum  CustomerBillingler Insert edilir.
        List<OpportunityLineItem> oppLineItemList = [SELECT OpportunityId,UnitPrice FROM OpportunityLineItem Where OpportunityId in :oppIdList];
		Map<Id, Decimal> opptyToAmount = new Map<Id,Decimal>();
        for(OpportunityLineItem oli : oppLineItemList)
        {
            Decimal totalPrice = opptyToAmount.get(oli.OpportunityId) == null ? 0 : opptyToAmount.get(oli.OpportunityId);
            totalPrice = totalPrice + oli.UnitPrice;
            opptyToAmount.put(oli.OpportunityId, totalPrice);
        }
        
        List<Opportunity> oppList = [SELECT Id, Amount, Account.Payment_Term__c, Estimated_Installments__c, CurrencyIsoCode,Estimated_Invoice_Date__c,Estimated_Invoice_Monthly_Term__c FROM Opportunity WHERE Id in : oppIdList];
        for(Opportunity opp : oppList)
        {
            if(opptyToAmount.values().size()>0)
            {
               newCustomerBillingList.addAll(AddCustomerBilling(opp, opptyToAmount.get(opp.Id)));      
            }
        }
        
        if(newCustomerBillingList.size() > 0)
        {
           insert newCustomerBillingList; 
        } 
    }
    
    private static List<Customer_Billing__c> AddCustomerBilling(Opportunity opp, Decimal amount)
    {
        Date lastInvoiceUpdate=system.today();
        Decimal tempAmount=0;
        Date billingDate = opp.Estimated_Invoice_Date__c == null ? System.today() : opp.Estimated_Invoice_Date__c;        
        
		List<Customer_Billing__c> cbList=new List<Customer_Billing__c>();
        for(double i=0;i<opp.Estimated_Installments__c;i++)
        {
            Customer_Billing__c cb=new Customer_Billing__c();
            cb.Opportunity__c=opp.Id;            
            cb.CurrencyIsoCode=opp.CurrencyIsoCode;
            cb.Due_Upon_c__c=opp.Account.Payment_Term__c == null ? 0 : opp.Account.Payment_Term__c;
            if(i!=opp.Estimated_Installments__c-1)
            {
                Decimal billingAmount = (Decimal)amount/opp.Estimated_Installments__c;
                billingAmount=billingAmount.round(System.roundingMode.DOWN);
                cb.N_Billing_Amount__c= billingAmount;
                tempAmount+=billingAmount;
            }
            else
            {
                cb.N_Billing_Amount__c= amount-tempAmount;
            }
            
            cb.Billing_Date__c=billingDate;
            cbList.add(cb);
            
            billingDate = billingDate.addMonths((Integer)opp.Estimated_Invoice_Monthly_Term__c);
        }    
        
        return cbList;
    }
}