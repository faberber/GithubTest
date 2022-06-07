global class BatchUserUpdate implements Database.Batchable<AggregateResult>, Schedulable {
  // The batch job starts
  // 
  // 
      global BatchUserUpdate()
      {
      }
  	  global void execute(SchedulableContext ctx)
      {      
        Database.executeBatch(new BatchUserUpdate('Account'),10);
        Database.executeBatch(new BatchUserUpdate('Opportunity'),10);
        Database.executeBatch(new BatchUserUpdate('Lead'),10);
      }
    
  	  String SObjectType;
      global BatchUserUpdate(String SObjectType)
      {
            this.SObjectType=SObjectType;
      }
      global Iterable<AggregateResult> start(Database.BatchableContext bc){
        String query = 'SELECT COUNT(Id) cnt, OwnerId FROM '+SObjectType+' GROUP BY OwnerId';
        return new AggregateResultIterable(query);
      } 
      // The batch job executes and operates on one batch of records
      global void execute(Database.BatchableContext bc, List<sObject> scope){ 
        Map <String, Schema.SObjectField> schemaMap = Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap();
        Schema.SObjectField sf=null;
        String str='';
        for(String s:schemaMap.keySet())
        {
            if(s.containsIgnoreCase(SObjectType.substring(0, 3)) && s.containsIgnoreCase('count'))
            {
                sf=schemaMap.get(s);
                str=sf.getDescribe().getName();
            }
        }
          
          
        List<User> ul=new List<User>();
        for(sObject sObj : scope) {
          AggregateResult ar = (AggregateResult)sObj;
            String s=String.valueOf(ar.get('OwnerId'));
            if(s.substring(0, 3)!='00G')
            {
                User u=new User(Id=Id.valueOf(String.valueOf(ar.get('OwnerId'))));
                Decimal d=(Decimal)u.put(str,Decimal.valueOf(String.valueOf(ar.get('cnt'))));
                ul.add(u);
            }
        }
          if(ul.size()>0)
          {
              update ul;
          }
      }

      // The batch job finishes
      global void finish(Database.BatchableContext bc){ }
}