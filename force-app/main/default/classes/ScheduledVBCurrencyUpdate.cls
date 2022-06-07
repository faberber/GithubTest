global class ScheduledVBCurrencyUpdate implements Schedulable{

    global void execute(SchedulableContext ctx){ 

        //Database.executeBatch(new BatchCurrencyUpdater('Customer_Billing__c'),10);
        Database.executeBatch(new BatchCurrencyUpdater('Vendor__c'),10);                
        //Database.executeBatch(new BatchCurrencyUpdater('Opportunity'),10);
     
    }
    
    
}