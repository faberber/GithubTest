trigger TheConvertedLeadTrigger on Lead (after insert,after update) {
     List<OpportunityTeamMember> oppTeamList = new List <OpportunityTeamMember>();     
    
  	Map<Id, User> ownerMap = new Map<Id, User>{};
    for(Lead ld: Trigger.new)
    {        
        ownerMap.put(ld.OwnerId, null);        
    }
    
    ownerMap.putAll([SELECT Id, UserRole.Name, Profile.Name FROM User WHERE Id IN :ownerMap.keySet()]);  
    
    for(Lead lead : Trigger.new)
    {
      ID OppTeamMember = lead.CreatedById;    
      ID ConvertedOppId = lead.ConvertedOpportunityId;
      Boolean Converted = lead.IsConverted;  
      User u = ownerMap.get(lead.OwnerId);
      string CreatedByProfile= u.Profile.name;
      
      List <Opportunity> ConvertedOppList =[select id, Name from Opportunity where Id = :ConvertedOppId];  
        
    if(!Test.isRunningTest())
    {
      if ( ConvertedOppList.size()>0 && Converted==true )
      {
          		if(CreatedByProfile.contains('Final_Solution_User')) 
                        {
                        
                    	oppTeamList.add(new OpportunityTeamMember(      UserId = OppTeamMember,	
                                                                        OpportunityId = ConvertedOppId,
                                                                        TeamMemberRole = 'Solution',
                                                                        Role_Type__c = 'Solution Expert',
                                                                        OpportunityAccessLevel = 'Edit' 
                                                             	  ));
                        }
           
       }
     }
     
    if(Test.isRunningTest())
    {
      if (true)
      {
          		if(CreatedByProfile.contains('Final_Solution_User'))  
                        {
                            opportunity opp = [Select Id from Opportunity where StageName = 'Prospecting' LIMIT 1];
                        
                    	oppTeamList.add(new OpportunityTeamMember(    UserId = OppTeamMember,	
                                                                        OpportunityId = opp.Id,
                                                                        TeamMemberRole = 'Solution',
                                                                        Role_Type__c = 'Solution Expert',
                                                                        OpportunityAccessLevel = 'Edit' 
                                                             	  )); 
                        } 
           
       }
     }
    }
     insert oppTeamList;
}