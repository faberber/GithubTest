trigger CheckOppTeamMember on OpportunityTeamMember (before insert,after insert, after update) {

  if(Trigger.isBefore)  
  {    
    Map<Id, User> ownerMap = new Map<Id, User>{};
    for(OpportunityTeamMember opTeam: Trigger.new)
    {        
        ownerMap.put(opTeam.UserId, null);        
    }
    
    ownerMap.putAll([SELECT Id, Profile.Name FROM User WHERE Id IN :ownerMap.keySet()]);  
    
    for(OpportunityTeamMember opTeam: trigger.new)
    {
        User u = ownerMap.get(opTeam.UserId);
        String ProfileName = u.Profile.Name;
        String MemberRole = opTeam.TeamMemberRole;
        
      if(ProfileName != 'System Administrator')
      {
        
        if((ProfileName == 'Final_Solution_User' && MemberRole != 'Solution'))
        {
            opTeam.addError('For this user you should select Team Member Role as Solution !');
        }
        else if((ProfileName != 'Final_Solution_User' && MemberRole == 'Solution'))
        {
            opTeam.addError('For this user you should select Team Member Role not Solution!');
        }  
      }
        
    }
  }
    
    
    if(Trigger.isAfter)
    {
            Map<Id, User> ownerMap = new Map<Id, User>{};
            for(OpportunityTeamMember opTeam: Trigger.new)
            {        
                ownerMap.put(opTeam.UserId, null);        
            }
        
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>{};
            for(OpportunityTeamMember opTeam: Trigger.new)
            {        
                oppMap.put(opTeam.OpportunityId, null);        
            }
        
        oppMap.putAll([SELECT Id, Is_CyberSecurity__c FROM Opportunity WHERE Id IN :oppMap.keySet()]);
        ownerMap.putAll([SELECT Id, Profile.Name,UserRole.Name FROM User WHERE Id IN :ownerMap.keySet()]);
        
        
        for(OpportunityTeamMember opTeam : trigger.new )
        {
            Opportunity opp = oppMap.get(opTeam.OpportunityId);
            
            User u = ownerMap.get(opTeam.UserId);            
            String UserRole =  u.UserRole.Name;
            
            if(UserRole.contains('Cyber'))
            {
                opp.Is_CyberSecurity__c = TRUE;
                oppMap.put(opp.Id, opp);
            }
        }
        
        if(oppMap.values().size() > 0)
        {
            update oppMap.values();
        }
        
        
    }
}