public class TestTriggerHandler extends TriggerHandler{
    
    List<test__c> newAddressList = new List<test__c>();
    List<test__c> oldAddressList = new List<test__c>(); 
    Map<Id,test__c> newAddressMap;
    Map<Id,test__c> oldAddressMap; 
    
    
    public TestTriggerHandler() 
    {
        this.newAddressList = Trigger.New;
        this.oldAddressList = Trigger.Old;
        this.newAddressMap = (Map<Id,test__c>) Trigger.newMap; 
        this.oldAddressMap = (Map<Id,test__c>) Trigger.oldMap; 
    }        
    public override void beforeInsert() 
    {
        
    }
    public override void afterInsert() 
    {
         
    }
    
    public override void afterUpdate()
    {
         
    }
}