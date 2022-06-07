public class OppRelatedListModel {
    public Id opportunityId;
    public List<Customer_Billing__c> customerBillingList = new List<Customer_Billing__c>();
    public List<OpportunityProductModel> oppLineItemList = new List<OpportunityProductModel>();
}