global class BatchCurrencyUpdater implements Database.Batchable<sObject> {

   global final String Query;
   global final Datetime tDay;
   private Integer batchSize;
   global BatchCurrencyUpdater(String SObjectType){
 	   batchSize=0;
       
       Integer hour=19;
       Integer minute=30;
       CurrencyUpdater__c cu=CurrencyUpdater__c.getInstance();
       if(cu!=null)
       {
           hour=(Integer)cu.Hour__c;
           minute=(Integer)cu.Minute__C;
       }
       System.debug(hour+'   '+minute);
       if(!Test.isRunningTest())
       {
       tDay = DateTime.newInstance(system.today(), Time.newInstance(hour, minute, 0, 0)); 
       }
       else
       {
           tDay = System.now().addDays(1);
       }
       if(SObjectType=='Opportunity')
       {
           Query='Select id from '+SObjectType+' where LastModifiedDate<:tday '+' and (StageName != \'Closed Won\' AND StageName != \'Closed Lost\' AND StageName != \'Closed Cancelled\')';
       }
       else
       {
           Query='Select id from '+SObjectType+' where lastmodifieddate<:tday '+' and (Opportunity__r.StageName != \'Closed Won\' AND Opportunity__r.StageName != \'Closed Lost\' AND Opportunity__r.StageName != \'Closed Cancelled\')';
       }
	}

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     batchSize=scope.size();
     update scope;
    }

   global void finish(Database.BatchableContext BC){
       if(batchSize>0)
       {
          Database.executeBatch(this,10);
       }
   }
}