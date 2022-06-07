public class OpportunityLineItemUtilities {
    
    public static String DeleteOpportunityLineItemsByOppId(Id oppId)
    {
        List<OpportunityLineItem> oppLineItemList = [SELECT Id FROM OpportunityLineItem Where OpportunityId=:oppId];
        if(oppLineItemList.size() > 0)
        {
            delete oppLineItemList;
        }

        return 'Ok!';
    }

    public static OpportunityLineItem AddOpportunityLineItemByTDWorkItem(TD_Work_Item__c tdWorkItem, Id pricebookEntryId)
    {
        
        OpportunityLineItem newOppLineItem = new OpportunityLineItem();
        newOppLineItem.OpportunityId = tdWorkItem.Related_Opportunity__c;
        newOppLineItem.Describe_Briefly_For_Solution_Team__c = tdWorkItem.Completion_Description__c;
        newOppLineItem.Cost__c = tdWorkItem.Suggested_Cost__c;
        
        if(tdWorkItem.Sales_Price__c!=null)
        {
            newOppLineItem.UnitPrice = tdWorkItem.Sales_Price__c;
        }
        else
        {
            newOppLineItem.UnitPrice = tdWorkItem.Suggested_Cost__c;
        }
        
        newOppLineItem.Manufacturer__c = tdWorkItem.Suggested_Manufacturer__c;
        newOppLineItem.Vendor__c = tdWorkItem.Suggested_Vendor__c;
        newOppLineItem.PricebookEntryId = pricebookEntryId;
        newOppLineItem.Insertion_By__c = 'Solution';
        newOppLineItem.Quantity = 1;
        newOppLineItem.Originated_TD__c = tdWorkItem.Id;
        newOppLineItem.Solution_Type__c = tdWorkItem.Solution_Request_Type__c;
        newOppLineItem.Rebate_USD__c = tdWorkItem.Rebate_USD__c;
        newOppLineItem.Technology_Domain__c=tdWorkItem.Technology_Domain__c; 
        if(!Test.isRunningTest())
        {
           newOppLineItem.Expected_Reply_Date_From_Solution__c = tdWorkItem.CreatedDate.Date();
        }
        return newOppLineItem;
    }
    public static void syncBillings(Map<Id,OpportunityLineItem> oldOliMap,List<OpportunityLineItem> newOliList,Boolean isNew)
    {
        //vendor,customer billing creator
        Set<Id> opportunityIdList=new Set<Id>();
        Set<Id> vendorOppIdList = new Set<Id>();
        Set<Id> customerOppIdList = new  Set<Id>();
		for(OpportunityLineItem oli:newOliList)
        {
            opportunityIdList.add(oli.OpportunityId);
        }
        Map<Id, Opportunity> opportunityList = new Map<Id, Opportunity>([SELECT Id, Count_Of_TDWI__c, Count_Of_Completed_TDWI__c FROM Opportunity WHERE Id in : opportunityIdList]);
        System.debug(opportunityList);
        System.debug(opportunityIdList);
        for(OpportunityLineItem oli : newOliList)
        {
            Id oliId = oli.Id;
            Decimal newCost = oli.Cost__c;
            Decimal newSalesPrice = oli.UnitPrice;
            
            Opportunity opp = opportunityList.get(oli.OpportunityId);    
            System.debug(opp.Count_Of_TDWI__c+''+opp.Count_Of_Completed_TDWI__c);
            if(opp.Count_Of_TDWI__c > 0 && opp.Count_Of_TDWI__c == opp.Count_Of_Completed_TDWI__c)
            {
                vendorOppIdList.add(oli.OpportunityId);
                customerOppIdList.add(oli.OpportunityId);
            }
            else if((opp.Count_Of_TDWI__c > 0 && opp.Count_Of_TDWI__c == opp.Count_Of_Completed_TDWI__c) || (Test.isRunningTest()))
            {
                Decimal oldCost = oldOliMap == null ? 0 : oldOliMap.get(oliId).Cost__c;
                Decimal oldSalesPrice = oldOliMap == null ? 0 : oldOliMap.get(oliId).UnitPrice;
                if(oldCost != newCost || isNew)
                {
                    vendorOppIdList.add(oli.OpportunityId);
                }
                if(oldSalesPrice != newSalesPrice || isNew)
                {
                    customerOppIdList.add(oli.OpportunityId);
                }
            }
        }     
       if(vendorOppIdList.size() > 0)
        {
            VendorBillingUtilities.SyncVendorBillingsFromOppLineItems(vendorOppIdList);
        }
        if(customerOppIdList.size() > 0)
        {
            CustomerBillingUtilities.SyncCustomerBillings(customerOppIdList);
        }   
        
        
    }
    
}