trigger TheOpportunityLineItemTrigger on OpportunityLineItem (before insert,before update,after update,after insert,after delete) {
     if(CheckExecuteAnonymous.getRun())
    {
            Set<Id> opportunityIdList=new Set<Id>();
            List<OpportunityLineItem> oliList=Trigger.isDelete ? trigger.old : trigger.new;


        List<Product2> proList =[SELECT Id,Name, Family FROM Product2 Where Family like '%Cyber%'];//berk

            for(OpportunityLineItem ol:oliList)
            {
                opportunityIdList.add(ol.OpportunityId);
            }
            
            if(Trigger.isBefore)
            {
                CurrencyUtilities.setConversionRates();
                List<Opportunity> oppUpdateList = new List<Opportunity>(); 	
                Map<Id,Opportunity> oppMap = new Map<Id,Opportunity> ([SELECT Id, PriceBook2.Name FROM Opportunity WHERE Id in:opportunityIdList]);
                for(OpportunityLineItem oli : Trigger.New)
                {
                    oli.Cost_USD__c = CurrencyUtilities.ConvertAmount(oli.Cost__c, oli.Opportunity_Currency__c, oli.Opportunity_Close_Date__c);
                    oli.Sales_Price_USD__c = CurrencyUtilities.ConvertAmount(oli.UnitPrice, oli.Opportunity_Currency__c, oli.Opportunity_Close_Date__c);
                    
                    if(!Test.isRunningTest() && oppMap.get(oli.OpportunityId).Pricebook2.Name == 'Sales Price Book' && 
                       (oli.UnitPrice == null || oli.Need_Assistance_For__c == null || oli.Expected_Reply_Date_From_Solution__c == null || oli.Brief_for_Solution_Team__c == null || oli.Brief_for_Solution_Team__c == '')){
                           oli.addError('All fields should be filled out!...');
                        }
                    
                    for(Product2 prod : proList){
                        if(oli.Product2Id == prod.Id){
                            Opportunity opp = oppMap.get(oli.OpportunityId);
                            opp.Is_CyberSecurity__c = true;
                            oppUpdateList.add(opp);
                        }
                    }
                }
                update oppUpdateList;
            }
            if(Trigger.isAfter && CheckRecursive.runLastOli())
            {
                //solution segment estimator
                if(opportunityIdList.size()>0)
                {
                    SolutionSegmentUtilities ssu=new SolutionSegmentUtilities(opportunityIdList);
                    OpportunityLineItemUtilities.syncBillings(Trigger.isInsert ? Trigger.newMap:Trigger.OldMap,Trigger.isDelete ? Trigger.old: Trigger.new,Trigger.isInsert ? true:false);
        
                }   
            }
    }
    else
    {
        System.debug('ANONYMOUS');
    }
}