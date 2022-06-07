trigger ConvertCustomerBillingAmount on Customer_Billing__c (before update, before insert) {
    if(CheckExecuteAnonymous.getRun())
    {
            CurrencyUtilities.setConversionRates();
            Set<Id> idSet=new Set<Id>();
            Map<Id,Date> oppCloseDateMap=new Map<Id,Date>();
            for(Customer_Billing__c cust : trigger.new)
            {
                idSet.add(cust.Opportunity__c);
            }
            List<Opportunity> oppList=[select id,CloseDate from Opportunity where id in :idSet ];
            for(Opportunity opp:oppList)
            {
                oppCloseDateMap.put(opp.Id,opp.CloseDate);
            }
            for(Customer_Billing__c cust : trigger.new)
            {
                cust.N_Billing_Amount_USD__c = CurrencyUtilities.ConvertAmount(cust.N_Billing_Amount__c, cust.CurrencyIsoCode, oppCloseDateMap.get(cust.Opportunity__c));
            }
    }
    else
    {
        System.debug('ANONYMOUS');
    }
}