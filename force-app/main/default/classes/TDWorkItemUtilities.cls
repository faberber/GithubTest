public class TDWorkItemUtilities {
    
   public static void addToOpportunityTeam(List<TD_Work_Item__c> tdList,Set<Id> opptyIdSet)
    {
                  
       List<OpportunityTeamMember> oppTeamList = new List <OpportunityTeamMember>();
       List<OpportunityTeamMember> oppTeamExisting=[select id,userid,OpportunityId from OpportunityTeamMember where opportunityId in : opptyIdSet];
       Map<Id,Id> userOTMap=new Map<Id,Id>(); 
       List<TD_Work_Item__Share> tShare=new List<TD_Work_Item__Share>();
        
       for(OpportunityTeamMember otm: oppTeamExisting)
        {
            userOTMap.put(otm.UserId,otm.OpportunityId);
        }
       
           
       for(TD_Work_Item__c tdwi : tdList)
       {
          if(TDWI.Assigned__c == True)
          {  
           if( !Test.isRunningTest() && string.valueOf(TDWI.OwnerId).startsWith('005')) //check if owner is user     
           { 
               if(userOTMap.get(TDWI.OwnerId)==null)
               {
            oppTeamList.add(new OpportunityTeamMember(  UserId = TDWI.OwnerId,
                                                        OpportunityId = TDWI.Related_Opportunity__c,
                                                        TeamMemberRole = 'Solution',
                                                        Role_Type__c = 'Solution Expert',
                                                        OpportunityAccessLevel = 'Edit' 
                                    ));
               }
             
             }
           }
          
          else if(TDWI.Engaged__c == True)
          {  
           if(string.valueOf(TDWI.Completed_by_User__c).startsWith('005')) //check if owner is user     
           {    
               if(userOTMap.get(TDWI.Completed_by_User__c)==null)
               {
                 oppTeamList.add(new OpportunityTeamMember(  UserId = TDWI.Completed_by_User__c,
                                                             OpportunityId = TDWI.Related_Opportunity__c,  
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
    
    public static String ChangeTDWorkItemStatusByOppLineItemId(Id oppLineItemId, String status)
    {
        List<TD_Work_Item__c> tdWorkItemList = [SELECT Id,Status__c,Work_Item_Closed_Date__c  FROM TD_Work_Item__c Where OpptyLineID__c=:oppLineItemId];

        for(TD_Work_Item__c tdWorkItem : tdWorkItemList)
        {
            if(tdWorkItem.Status__c != status && tdWorkItem.Status__c != 'Completed')
            {
                tdWorkItem.Status__c = status;
                tdWorkItem.Work_Item_Closed_Date__c = Datetime.now();
                update tdWorkItem;

                return 'Changed!';
            }
        }

        return 'Not Changed!';
    }

    public static String CancelTDWorkItemByParentWorkItem(Set<Id> workItemId)
    {       
        List<TD_Work_Item__c> childWorkItemList = [SELECT Id,Status__c,Work_Item_Closed_Date__c  FROM TD_Work_Item__c Where Parent_TD_Work_Item__c in :workItemId ];
        for(TD_Work_Item__c childWorkItem : childWorkItemList)
        {
            if(childWorkItem.Status__c!='Cancelled' && childWorkItem.Status__c!='Completed')
            {
                childWorkItem.Status__c = 'Cancelled';
                childWorkItem.Work_Item_Closed_Date__c = Datetime.now();
            }
        }
        update childWorkItemList;
        return 'Ok!';
    }

    public static Boolean IsAllChildrenClosed(Id workItemId)
    {
        Boolean result = true;
        system.debug('I AM HERE');
        
        List<TD_Work_Item__c> childWorkItemList = [SELECT Id,Status__c,Work_Item_Closed_Date__c FROM TD_Work_Item__c Where Parent_TD_Work_Item__c=:workItemId LIMIT 100];
        
        system.debug('LIST SIZE : '+childWorkItemList.size());
        for(TD_Work_Item__c childWorkItem : childWorkItemList)
        {
            if((childWorkItem.Status__c != 'Cancelled' && childWorkItem.Status__c != 'Completed') || result == false)
            {
                return false; 
            }
            else
            {
                result = IsAllChildrenClosed(childWorkItem.Id);
            }
        }

        return result;
    }

    public static String ChangeTDWorkItemStatusByOppId(Id oppId, String status)
    {
        List<TD_Work_Item__c> tdWorkItemList = [SELECT Id,Status__c,Work_Item_Closed_Date__c  FROM TD_Work_Item__c Where Related_Opportunity__c=:oppId];

        for(TD_Work_Item__c tdWorkItem : tdWorkItemList)
        {
            if(tdWorkItem.Status__c != status && tdWorkItem.Status__c != 'Completed')
            {
                tdWorkItem.Status__c = status;
                tdWorkItem.Work_Item_Closed_Date__c = Datetime.now();
                update tdWorkItem;

                return 'Changed!';
            }
        }

        return 'Not Changed!';
    }

    public static Boolean AddParentChildCount(TD_Work_Item__c workItem)
    {
        Boolean result = true;
        
        if(workItem.Parent_TD_Work_Item__c == null || result == false)
        {
            return false;
        }
        else
        {
            TD_Work_Item__c parentWorkItem = [SELECT Id,ChildCount__c,Parent_TD_Work_Item__c  FROM TD_Work_Item__c Where Id =:workItem.Parent_TD_Work_Item__c LIMIT 1];
            parentWorkItem.ChildCount__c++;
            update parentWorkItem;

            result = AddParentChildCount(parentWorkItem);
        }

        return result;
    }

    public static Boolean AddParentCompletedChildCount(TD_Work_Item__c workItem)
    {
        Boolean result = true;

        if(workItem.Parent_TD_Work_Item__c == null || result == false)
        {
            return false;
        }
        else
        {
            TD_Work_Item__c parentWorkItem = [SELECT Id,ClosedChildCount__c,Parent_TD_Work_Item__c FROM TD_Work_Item__c Where Id =:workItem.Parent_TD_Work_Item__c LIMIT 1];
            parentWorkItem.ClosedChildCount__c++;
            update parentWorkItem;

            result = AddParentCompletedChildCount(parentWorkItem);
        }
        
        return result;
    }

    
    public static void addOpportunityProductByTDWorkItem(List<TD_Work_Item__c> tdList)
    {
        Set<Id> oppIdList = new Set<Id>();
        Set<Id> productIdList =  new Set<Id>();
        Set<String> currencyList = new Set<String>();
        for(TD_Work_Item__c tdWorkItem : tdList)
        {
            oppIdList.add(tdWorkItem.Related_Opportunity__c);
            productIdList.add(tdWorkItem.SuggestedSolutionProduct__c);
        }
        
        Map<Id, Opportunity> oppCurrencyList = new Map<Id, Opportunity>([SELECT Id, CurrencyIsoCode FROM Opportunity WHERE Id in : oppIdList]);
        
        List<PricebookEntry> pricebookEntryList = [SELECT Id,IsActive,Product2Id, CurrencyIsoCode  FROM PricebookEntry WHERE Product2Id in : productIdList and (Pricebook2.Name='Solution Price Book' OR Pricebook2.Name='Public Solution Price Book')];
  
         
        Map<TD_Work_Item__c, Id> tdPriceBookEntry = new Map<TD_Work_Item__c, Id>(); 
        
        for(TD_Work_Item__c tdWorkItem : tdList)
        { 
            for(PricebookEntry pricebook : pricebookEntryList)
            {
                if(pricebook.Product2Id == tdWorkItem.SuggestedSolutionProduct__c && pricebook.IsActive == true && pricebook.CurrencyIsoCode == oppCurrencyList.get(tdWorkItem.Related_Opportunity__c).CurrencyIsoCode)
                {
                    tdPriceBookEntry.put(tdWorkItem, pricebook.Id);
                    break;
                }
            }  
        }
        
        List<OpportunityLineItem> newOppLineItemList = new List<OpportunityLineItem>();
        for(TD_Work_Item__c tdWorkItem : tdList)
        {
            if(    tdWorkItem.Insert_Product__c == 'Approve product insert'
                && tdWorkItem.Completion_Description__c != null 
                && tdWorkItem.Completion_Description__c != ''
                && tdWorkItem.Suggested_Cost__c != null
                && tdWorkItem.SuggestedSolutionProduct__c != null
                /*&& tdWorkItem.Suggested_Manufacturer__c != null*/
                && tdWorkItem.Suggested_Vendor__c != null
                )
            {
                newOppLineItemList.add(OpportunityLineItemUtilities.AddOpportunityLineItemByTDWorkItem(tdWorkItem, tdPriceBookEntry.get(tdWorkItem)));
            }
        }
        
        if(!Test.isRunningTest() && newOppLineItemList.size()>0)
        {
          insert newOppLineItemList;
        }
    }
    
     public static void findApprovers(Map<Id,TD_Work_Item__c> TDWorkMap)
    {
        List<TD_Work_Item__c> TDWIList = new List<TD_Work_Item__c>();

        Set<Id> oppIdSet=new Set<Id>();
        for(TD_Work_Item__c TDWI: TDWorkMap.values())
        {
            
          oppIdSet.add(TDWI.Related_Opportunity__c);
            if(TDWI.Status__c == 'On Approval')
            {
                TDWIList.add(TDWI);
            }
        }
    Map<Id,Technology_Domain__c> DomainMap = new Map<Id,Technology_Domain__c>([SELECT Id,Name FROM Technology_Domain__c ]);
        Map<Id,Product2> SolutionMap = new Map<Id,Product2>([SELECT Id,Name FROM Product2 ]);
        Map<Id,Opportunity> TDOppMap = new Map<Id,Opportunity>([Select Id,Name,AL_for_Solution__c,Need_AL1_Approval__c FROM Opportunity where ID in : oppIdSet ]);
        
        Map<String,List<User>> approverMap=new Map<String,List<User>>();
        List<User> UserList = new List<User>([Select Id, Business_Unit__c, AL__c, 
                                      Approval_Group__c, Finance_Approval_Group__c, 
                                      Approval_Company__c, ManagerId,Upper_Manager__c, Functional_Title_Group__c 
                                      FROM User 
                                      WHERE IsActive = TRUE AND
                                             Approval_Group__c !=NULL ]);
    
        
        for(User u:UserList)
        {
            if(u.Approval_Group__c.contains('DefenseTD'))
            {
                if(approverMap.get('DefenseTD')==null)
                {
                    List<User> ul=new List<User>();
                    ul.add(u);
                    approverMap.put('DefenseTD',ul);
                }
                else
                {
                    List<User> ul=approverMap.get('DefenseTD');
                    ul.add(u);
                    approverMap.put('DefenseTD',ul);    
                }
            }
            if(u.Approval_Group__c.contains('R&DTD'))
            {
                if(approverMap.get('R&DTD')==null)
                {
                    List<User> ul=new List<User>();
                    ul.add(u);
                    approverMap.put('R&DTD',ul);
                }
                else
                {
                    List<User> ul=approverMap.get('R&DTD');
                    ul.add(u);
                    approverMap.put('R&DTD',ul);    
                }
            }   
            if(u.Approval_Group__c.contains('NOC1-2'))
            {
                if(approverMap.get('NOC1-2')==null)
                {
                    List<User> ul=new List<User>();
                    ul.add(u);
                    approverMap.put('NOC1-2',ul);
                }
                else
                {
                    List<User> ul=approverMap.get('NOC1-2');
                    ul.add(u);
                    approverMap.put('NOC1-2',ul);    
                }
            }
            if(u.Approval_Group__c.contains('NOC3'))
            {
                if(approverMap.get('NOC3')==null)
                {
                    List<User> ul=new List<User>();
                    ul.add(u);
                    approverMap.put('NOC3',ul);
                }
                else
                {
                    List<User> ul=approverMap.get('NOC3');
                    ul.add(u);
                    approverMap.put('NOC3',ul);    
                }
            } 
            if(u.Approval_Group__c.contains('SOC'))
            {
                if(approverMap.get('SOC')==null)
                {
                    List<User> ul=new List<User>();
                    ul.add(u);
                    approverMap.put('SOC',ul);
                }
                else
                {
                    List<User> ul=approverMap.get('SOC');
                    ul.add(u);
                    approverMap.put('SOC',ul);    
                }
            } 
        }
        
        
        for(TD_Work_Item__c TDWI: TDWIList)
        {
            if(TDWI.Sales_Segment__c == 'Defense' && TDWI.Solution_Request_Type__c == 'R&D consultancy')
            {
              TDWI.TDWI_Approver__c = approverMap.get('DefenseTD').get(0).Id;
            }
            else if(TDWI.Sales_Segment__c != 'Defense' && TDWI.Solution_Request_Type__c == 'R&D consultancy')
            {
              TDWI.TDWI_Approver__c = approverMap.get('R&DTD').get(0).Id;
              TDWI.TDWI_Approver_2__c = approverMap.get('R&DTD').get(1).Id;  
            }
            if(DomainMap.get(TDWI.Technology_Domain__c).name == 'NOC' && (TDOppMap.get(TDWI.Related_Opportunity__c).AL_for_Solution__c == '2'|| TDOppMap.get(TDWI.Related_Opportunity__c).Need_AL1_Approval__c == true))
            {
              TDWI.TDWI_Tech_Approver__c = approverMap.get('NOC1-2').get(0).Id;  
            }            
            if(DomainMap.get(TDWI.Technology_Domain__c).name == 'NOC' && TDOppMap.get(TDWI.Related_Opportunity__c).AL_for_Solution__c == '3')
            {
              TDWI.TDWI_Tech_Approver__c = approverMap.get('NOC3').get(0).Id;  
            }
            if(DomainMap.get(TDWI.Technology_Domain__c).name == 'CyberSecurity' && SolutionMap.get(TDWI.SuggestedSolutionProduct__c).name=='SOC')
            {
               TDWI.TDWI_Tech_Approver__c = approverMap.get('SOC').get(0).Id; 
            }
        
        }
    }
}