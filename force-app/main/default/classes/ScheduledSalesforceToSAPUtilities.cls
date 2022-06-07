global class ScheduledSalesforceToSAPUtilities implements Schedulable{

    global void execute(SchedulableContext ctx){ 
              
        Database.executeBatch(new BatchSalesforceToSAPUtilities(),1); 
     
    }
 
}