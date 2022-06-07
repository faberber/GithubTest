global class ScheduledReportUtilities implements Schedulable {
    
    global void execute(SchedulableContext ctx){ 
        ReportUtilities.callReports();
    }

}