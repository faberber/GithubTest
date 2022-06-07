global class BatchProjectIntegration implements Database.Batchable<sObject>,Database.AllowsCallouts {
   global final String Query;

   global BatchProjectIntegration(){ 

       Query='Select id,SAP_Account_No__c from Account where  SAP_Account_No__c!=NULL';

	}
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     CheckExecuteAnonymous.changeRun(false);  
     List<Account> accList=scope;
     NNDProjectIntegration.SendAccountToSAP(accList); 
     update scope;
    }

   global void finish(Database.BatchableContext BC){

   }

}