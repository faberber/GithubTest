trigger addCollectionByCustomerBilling on Customer_Billing__c (after insert,after update,after delete) {
    if(CheckExecuteAnonymous.getRun())
    {
            if(Trigger.isInsert)
                {
                    List<Revenue__c> collectionList=new List<Revenue__c>();
                    for(Customer_Billing__c cust : trigger.new)
                    {
                        collectionList.add(CollectionUtilities.AddCollectionByCustomerBilling(cust));
                    }
                    insert collectionList;
                }
                else if(Trigger.isUpdate || Trigger.isDelete)
                {
                    Set<Id> oppListUpdate=new Set<Id>();
                    for(Customer_Billing__c cust : trigger.old)
                    {
                        oppListUpdate.add(cust.Opportunity__c);
                    }
                    CollectionUtilities.SyncCollectionsFromCustomerBillings(oppListUpdate);
                }
    }
    else
    {
        System.debug('ANONYMOUS');
    }
}