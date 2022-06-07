trigger ConvertExpenseAmount on Payment__c (before update, before insert,after insert, after update) {
    if(CheckExecuteAnonymous.getRun())
    {
            if(Trigger.isBefore)
            {
                CurrencyUtilities.setConversionRates();
                Set<Id> idSet=new Set<Id>();
                Map<Id,Date> oppCloseDateMap=new Map<Id,Date>();
                for(Payment__c cust : trigger.new)
                {
                    idSet.add(cust.Opportunity__c);
                }
                List<Opportunity> oppList=[select id,CloseDate from Opportunity where id in :idSet ];
                for(Opportunity opp:oppList)
                {
                    oppCloseDateMap.put(opp.Id,opp.CloseDate);
                }
                for(Payment__c exp : trigger.new)
                { 
                    exp.N_Payment_Amount_USD__c = CurrencyUtilities.ConvertAmount(exp.Amount__c, exp.CurrencyIsoCode, oppCloseDateMap.get(exp.Opportunity__c));
                }
            }
            if(Trigger.isAfter)
            {	
                Set<Id> oppIdSet=new Set<Id>();
                List<Payment__c> pList=Trigger.new;
                for(Payment__c p:pList)
                {
                    oppIdSet.add(p.Opportunity__c);
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