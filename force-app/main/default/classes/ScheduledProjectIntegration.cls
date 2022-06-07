global class ScheduledProjectIntegration implements Schedulable{

    global void execute(SchedulableContext ctx){ 
              
        Database.executeBatch(new BatchProjectIntegration(),10); 
     
    }
    
     
}