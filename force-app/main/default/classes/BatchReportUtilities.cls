global class BatchReportUtilities implements Database.Batchable<sObject>, Database.Stateful{
   global final String Query;
   global final String[] stageList;
   global final String ReportType;
   global BatchReportUtilities(String[] stageList, String ReportType){ 
 	   this.stageList=stageList;
       this.ReportType=ReportType;
       CheckExecuteAnonymous.changeRun(false);
       Query='SELECT Id, Name '+
                    'FROM Opportunity '+
                    'WHERE StageName in :stageList';

	}

    global Database.QueryLocator start(Database.BatchableContext BC){
      CheckExecuteAnonymous.changeRun(false);
      return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
       CheckExecuteAnonymous.changeRun(false);
       Set<Id> oppIds=new Set<Id>();
       
       for(sObject s:scope)
       {
           oppIds.add(s.Id);
           System.debug('Scope :  '+s.Id);
       }
        
       if(ReportType == 'Solution')
       {
           ReportUtilities.SolutionVisibleReportBatch(oppIds);
       }
       else
       {
           ReportUtilities.SalesVisibleReportBatch(oppIds);
       }
     }

     global void finish(Database.BatchableContext BC){

     }

}