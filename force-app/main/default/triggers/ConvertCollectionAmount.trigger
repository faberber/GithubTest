trigger ConvertCollectionAmount on Revenue__c (before update, before insert,after insert, after update) {
    if(CheckExecuteAnonymous.getRun())
    {
            if(Trigger.isBefore)
            {
                CurrencyUtilities.setConversionRates();
                Set<Id> idSet=new Set<Id>();
                Map<Id,Date> oppCloseDateMap=new Map<Id,Date>();
                for(Revenue__c cust : trigger.new)
                {
                    idSet.add(cust.Opportunity__c);
                }
                List<Opportunity> oppList=[select id,CloseDate from Opportunity where id in :idSet ];
                for(Opportunity opp:oppList)
                {
                    oppCloseDateMap.put(opp.Id,opp.CloseDate);
                }
                for(Revenue__c coll : trigger.new)
                {
                    coll.N_Revenue_Amount_USD__c = CurrencyUtilities.ConvertAmount(coll.Revenue_Amount__c, coll.CurrencyIsoCode, oppCloseDateMap.get(coll.Opportunity__c));
                }
            }
            if(Trigger.isAfter)
            {	
                Set<Id> oppIdSet=new Set<Id>();
                List<Revenue__c> rList=Trigger.new;
                for(Revenue__c r:rList)
                {
                    oppIdSet.add(r.Opportunity__c);
                }
                if(checkRecursive.runFinanceCostCalculator())
                {
                   FinancialCostCalculator.updateOpportunities(oppIdSet);
                }
            }
    }
    else
    {
        System.debug('ANONYMOUS');
    }
}