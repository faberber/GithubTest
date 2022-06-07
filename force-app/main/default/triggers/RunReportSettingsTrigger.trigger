trigger RunReportSettingsTrigger on Report_Setting__c (after update) {

    Boolean RunReport = false;
    for(Report_Setting__c rs : trigger.new)
    {
        if(RS.Run_Report__c == true)
        {
            RunReport = true;
        }
    }
    
    if(RunReport == true && !Test.isRunningTest())
    {
        ReportUtilities.callReports();
    }
    
    List<Report_Setting__c> settingList = [SELECT Id, Run_Report__c FROM Report_Setting__c WHERE Run_Report__c = True];
    if(settingList.size() > 0)
    {
        for(Integer i = 0; i < settingList.size() ; i++)
        {
            settingList[i].Run_Report__c = false;
        }
        update settingList;
    }
}