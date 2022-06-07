public class OpportunityTeamMemberPageController {
    
    public String oppId{get;set;}
    
    //Product Variables    
    public String objectType{get;set;}
    public String operationType{get;set;}
    
    public OpportunityTeamMember tempOpportunityTeamMember{get;set;}
    public Id OpportunityTeamMemberId{get;set;}
    public String OpportunityTeammemberRoleType{get;set;}
    public String OpportunityTeamMemberRole{get;set;}
    public String OpportunityTeamMemberAccessLevel {get;set;}
    public Boolean tempProductError{get;set;}
    
    public List<OpportunityTeamMember> opportunityTeamMemberList{get;set;}
    public Map<String,Boolean> deleteRecordsMap{get;set;}
    
    string CurrencyCode;
    public OpportunityTeamMemberPageController(ApexPages.StandardController stdController){
        deleteRecordsMap = new Map<String,Boolean>();
        Opportunity tempOpp = new Opportunity();
        tempOpp = (Opportunity) stdController.getRecord();
        oppId = tempOpp.id;
        init();
    }
    
    public OpportunityTeamMemberPageController(){
    }
    
    private void init(){
        tempOpportunityTeamMember = new OpportunityTeamMember(OpportunityId = oppId);
        tempProductError = false;
        opportunityTeamMemberList = new List<OpportunityTeamMember>();
        opportunityTeamMemberList  = [SELECT Id,
                                   		  UserId,
                                   		  Role_Type__c,
                                   		  TeamMemberRole,	
                                   		  OpportunityAccessLevel
                                   FROM OpportunityTeamMember 
                                   WHERE OpportunityId =: oppId];      
    }
    
    public void addRow(){
        User tempUserList;
        if(objectType.equalsIgnoreCase('OpportunityTeamMember')){
            if(tempOpportunityTeamMember!= NULL)
            {            
                if(tempOpportunityTeamMember.UserId == NULL || tempOpportunityTeamMember.Role_Type__c == NULL || tempOpportunityTeamMember.TeamMemberRole == NULL || tempOpportunityTeamMember.OpportunityAccessLevel == NULL)
                {	
                    tempProductError = true;
                    tempOpportunityTeamMember.addError('Line 154 : All fields must be filled !');
                } 
                else
                {  
                   OpportunityTeamMember otm =new OpportunityTeamMember
                                                (OpportunityId = oppId, 
                                                 UserId = tempOpportunityTeamMember.UserId,
                                                 TeamMemberRole=tempOpportunityTeamMember.TeamMemberRole, 
                                                 Role_Type__c = tempOpportunityTeamMember.Role_Type__c,
                                                 OpportunityAccessLevel=tempOpportunityTeamMember.OpportunityAccessLevel);
                    insert otm;        
                }
            }    
        }         
    }
}