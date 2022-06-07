global class BatchOpportunityToSAP implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {


    String SObjectType;
    String query;
    
    global BatchOpportunityToSAP(String oppId){   
        query = 'SELECT Id, Opportunity_ID__c, CurrencyIsoCode, AccountId, Account_Sap_Id__c, Account_Record_Type__c,Companyy__c,Opportunity_Type__c,Amount,Amount_USD__c,F_Business_Unit__c,F_Sales_Segment__c,Description,StageName FROM Opportunity WHERE Opportunity_ID__c = \''+ oppId +'\' AND StageName=\'Closed Won\' AND Sent_To_SAP__c = false';
		System.debug('QUERY' + query);
  }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Opportunity> oppList=scope;
       List<Id> oppIds = new List<Id>();
       
       for (Opportunity opp : oppList){
           oppIds.add(opp.Id);
       }
       SalesforceToSAPUtilities.SendOpportunityToSAP(oppIds); 
       update scope;
    }

   global void finish(Database.BatchableContext BC){
       
   }  
    
}