trigger TestTrigger on test__c (before insert) {
    new TestTriggerHandler().run();
    
}