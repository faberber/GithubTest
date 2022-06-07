trigger ConvertVendorBillingAmount on Vendor__c (before update, before insert) {
    if(CheckExecuteAnonymous.getRun())
    {
            CurrencyUtilities.setConversionRates();
            Set<Id> idSet=new Set<Id>();
            Map<Id,Date> oppCloseDateMap=new Map<Id,Date>();
            for(Vendor__c cust : trigger.new)
            {
                idSet.add(cust.Opportunity__c);
            }
            List<Opportunity> oppList=[select id,CloseDate from Opportunity where id in :idSet ];
            for(Opportunity opp:oppList)
            {
                oppCloseDateMap.put(opp.Id,opp.CloseDate);
            }
            for(Vendor__c vend : trigger.new)
            {
                vend.N_Billing_Amount_USD__c = CurrencyUtilities.ConvertAmount(vend.N_Billing_Amount__c, vend.CurrencyIsoCode, oppCloseDateMap.get(vend.Opportunity__c));
            }
    }
    else
    {
        System.debug('ANONYMOUS');
    }    
}