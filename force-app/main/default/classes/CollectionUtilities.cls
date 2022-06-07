public class CollectionUtilities {

    // CustomerBilling e göre yeni bir Collection Eklenmesi
    public static Revenue__c AddCollectionByCustomerBilling(Customer_Billing__c customerBilling) {
        Revenue__c col = new Revenue__c();
        col.Opportunity__c = customerBilling.Opportunity__c;
        col.Revenue_Amount__c = customerBilling.N_Billing_Amount__c;
        col.N_Revenue_Amount_USD__c= customerBilling.N_Billing_Amount_USD__c;
        col.Revenue_Date__c = customerBilling.Payment_Date__c;
        col.CurrencyIsoCode = customerBilling.CurrencyIsoCode;
        col.Advance_Payment__c = false;
        return col;
    }
    
    public static String SyncCollectionsFromCustomerBillings(Id opportunityId)
    {
        //1. Opportunitye ait tüm Collection recordları silinir
        List<Revenue__c> collectionList = [SELECT Id FROM Revenue__c Where Opportunity__c  =:opportunityId LIMIT 50000];
        if(collectionList.size() > 0)
            delete collectionList;

        //2. Opportunitye üm CustomerBilling listesi alınır ve Collectionlar eklenir.
        List<Customer_Billing__c> customerBillingList = [SELECT Id,Name,Opportunity__c,N_Billing_Amount__c,Payment_Date__c,
                                                          CurrencyIsoCode, N_Billing_Amount_USD__c FROM Customer_Billing__c 
                                                          Where Opportunity__c =:opportunityId LIMIT 50000];
        collectionList =new List<Revenue__c>();
        for(Customer_Billing__c cust : customerBillingList)
        {
            collectionList.add(AddCollectionByCustomerBilling(cust));
        }
        insert collectionList;
        return 'Succeed';
    }
    public static String SyncCollectionsFromCustomerBillings(Set<Id> opportunityIdSet)
    {
        //1. Opportunitye ait tüm Collection recordları silinir
        List<Revenue__c> collectionList = [SELECT Id FROM Revenue__c Where Opportunity__c  =:opportunityIdSet];
        if(collectionList.size() > 0)
        {delete collectionList;}

        //2. Opportunitye üm CustomerBilling listesi alınır ve Collectionlar eklenir.
        List<Customer_Billing__c> customerBillingList = [SELECT Id,Name,Opportunity__c,N_Billing_Amount__c,Payment_Date__c,
                                                          CurrencyIsoCode, N_Billing_Amount_USD__c FROM Customer_Billing__c 
                                                          Where Opportunity__c =:opportunityIdSet];
        collectionList =new List<Revenue__c>();
        for(Customer_Billing__c cust : customerBillingList)
        {
            collectionList.add(AddCollectionByCustomerBilling(cust));
        }
        insert collectionList;
        return 'Succeed';
    }
}