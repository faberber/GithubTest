trigger CustomSharingTDWorkItem on TD_Work_Item__c (after insert,after update) {
 /*   public Id TechDomainId;    
    public String UserRole;  
    List<OpportunityTeamMember> oppTeamList = new List <OpportunityTeamMember>();
    List<TD_Work_Item__Share> tShare=new List<TD_Work_Item__Share>();
    List<CustomSharingObject__c> CustomObjectShare = new List<CustomSharingObject__c>();
    List<String> UserRoles = new List<String>();
    List<User> UserRoleIds ;
  if(CheckExecuteAnonymous.getRun())
    {   
        for(TD_Work_Item__c TDWI : Trigger.new)
        {  
           TechDomainId = null;
           TechDomainId = TDWI.Technology_Domain__c;
        
			       
           	 CustomObjectShare = null;
             CustomObjectShare = [SELECT Id,Technology_Domain__c, User_Role__c,Opportunity_Team_Role_Type__c from CustomSharingObject__c where Technology_Domain__c =: TechDomainId];              
         	 system.debug('Custom Object Shares : '+CustomObjectShare);
         
            if(CustomObjectShare.size()>0 && CustomObjectShare!=NULL ) 
            { 
               UserRoles = null;
               UserRoles = new List<String>();
                for(CustomSharingObject__c CSO : CustomObjectShare)    
                {
                   UserRole = '';
                   UserRole = CSO.User_Role__c;
                    system.debug('UserRole : '+UserRole);
                   if(UserRole!='')
                   UserRoles.add(UserRole); 
                }
               
                system.debug('User Roles : '+UserRoles);
                
               UserRoleIds = null; 
               UserRoleIds = [Select Id, Name, UserRole.Name from User where isActive = True and UserRole.Name in : UserRoles]; 
                
                system.debug('UserRoleIds : '+UserRoleIds);
                
                for(User user:UserRoleIds)
                {    
                           
              		if(TDWI.Assigned__c == True)
                    {                  
                        if(user.UserRole.Name == 'Enterprise Cybersecurity Director')
                        {
                        
                    	oppTeamList.add(new OpportunityTeamMember(      UserId = user.Id,	
                                                                        OpportunityId = TDWI.Related_Opportunity__c,
                                                                        TeamMemberRole = 'Director',
                                                                        Role_Type__c = 'CyberSecuirty Director',
                                                                        OpportunityAccessLevel = 'Edit' 
                                                             	  ));
                        }
                        
                        else if(user.UserRole.Name == 'Enterprise Solution Security Solutions Manager')
                        {
                            oppTeamList.add(new OpportunityTeamMember(      UserId = user.Id,	
                                                                            OpportunityId = TDWI.Related_Opportunity__c,
                                                                            TeamMemberRole = 'Solution',
                                                                            Role_Type__c = 'CyberSecuirty Manager',
                                                                            OpportunityAccessLevel = 'Edit' 
                                                                      ));
                        }    
                        
                            TD_Work_Item__Share ts=null;
                        	ts = new TD_Work_Item__Share();
                            ts.AccessLevel='Edit';
                            ts.ParentId=tdwi.Id;
                            ts.RowCause=Schema.TD_Work_Item__Share.RowCause.Manual; 
                            ts.UserOrGroupId =user.Id;
                            tShare.add(ts); 
                       
                	}
              else if(TDWI.Engaged__c == True)
              { 
                  
                   if(user.UserRole.Name == 'Enterprise Cybersecurity Director')
                        {
                        
                    	oppTeamList.add(new OpportunityTeamMember(      UserId = user.Id,	
                                                                        OpportunityId = TDWI.Related_Opportunity__c,
                                                                        TeamMemberRole = 'Director',
                                                                        Role_Type__c = 'CyberSecuirty Director',
                                                                        OpportunityAccessLevel = 'Edit' 
                                                             	  ));
                        }
                        
                        else if(user.UserRole.Name == 'Enterprise Solution Security Solutions Manager')
                        {
                            oppTeamList.add(new OpportunityTeamMember(      UserId = user.Id,	
                                                                            OpportunityId = TDWI.Related_Opportunity__c,
                                                                            TeamMemberRole = 'Solution',
                                                                            Role_Type__c = 'CyberSecuirty Manager',
                                                                            OpportunityAccessLevel = 'Edit' 
                                                                      ));
                        }    
                            TD_Work_Item__Share ts=null;
                        	ts = new TD_Work_Item__Share();
                            ts.AccessLevel='Edit';
                            ts.ParentId=tdwi.Id;
                            ts.RowCause=Schema.TD_Work_Item__Share.RowCause.Manual; 
                            ts.UserOrGroupId =user.Id;
                            tShare.add(ts); 
               			 }
       		 		} 
            	}   
            }	
       if(tShare.size()>0){
                            insert tShare;
                        }
        
     insert oppTeamList;
 } */
}