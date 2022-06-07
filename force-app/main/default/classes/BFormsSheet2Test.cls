@isTest
public class BFormsSheet2Test{
    @isTest
    public static void UnitTest(){
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'aa';
        oppObj.StageName = 'Test';
        oppObj.CloseDate = Date.today();
        insert oppObj;
        
        Customer_Billing__c CBObj = new Customer_Billing__c();
        CBObj.Opportunity__c = oppObj.id;
        CBObj.Billing_Amount__c = 122;
        CBObj.Billing_Date__c = Date.today();
        insert CBObj;
        
        Revenue__c RObj = new Revenue__c();
        RObj.Opportunity__c = oppObj.id;
        RObj.Revenue_Amount__c = 122;
        RObj.Revenue_Date__c = Date.today();
        insert RObj;
        
        Vendor__c VObj = new Vendor__c();
        VObj.Opportunity__c = oppObj.id;
        VObj.Billing_Amount__c = 122;
        VObj.Billing_Date__c = Date.today()+40;
        insert VObj;
        
        Payment__c PayObj = new Payment__c();
        PayObj.Opportunity__c = oppObj.id;
        PayObj.Amount__c = 122;
        PayObj.Date__c = Date.today()+30;
        insert PayObj;
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(oppObj);
        BFormsSheet2 OGC = new BFormsSheet2(sc1);
        OGC.init();
        
        ApexPages.StandardController sc2 = new ApexPages.standardController(oppObj);
        BFormsSheet2Quarter OGCQ = new BFormsSheet2Quarter(sc2); 
        OGCQ.init();
    }
}