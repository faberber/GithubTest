public class TDWICountUtilities {

    public static void updateTDWICounts(Set<Id> opptyIdSet)
    {
        
        Map<Id,Integer> opptyCountMap=new Map<Id,Integer>();
        Map<Id,Integer> completedOpptyCountMap=new Map<Id,Integer>();
        Map<Id,Integer> tdwiCountMap=new Map<Id,Integer>();
        Map<Id,Integer> completedtdwiCountMap=new Map<Id,Integer>();
        List<Opportunity> opptyList=[
            Select id,Count_Of_Completed_TDWI__c,Count_Of_TDWI__c ,Has_BDHSolution__c,StageName
            from Opportunity where id in :opptyIdSet];
        List<TD_Work_Item__c> tdList=[
            select id,status__c,ChildCount__c,ClosedChildCount__c,
            Parent_TD_Work_Item__c,Related_Opportunity__c, Has_BDHSolution__c
            from TD_Work_Item__c
            where Related_Opportunity__c in : opptyIdSet
        	];
        Map<Id,Boolean> tdOppMap=new Map<Id,Boolean>();
        for(TD_Work_Item__c tdwi : tdList)
        {
            if(tdwi.Has_BDHSolution__c==true)
            {
                tdOppMap.put(tdwi.Related_Opportunity__c,true);
            }
            else
            {
                tdOppMap.put(tdwi.Related_Opportunity__c, false);
            }
            if(tdwi.Status__c=='Completed')
            {
                if(tdwi.Parent_TD_Work_Item__c!=null)
                {
                    if(completedtdwiCountMap.get(tdwi.Parent_TD_Work_Item__c)==null)
                    {
                        completedtdwiCountMap.put(tdwi.Parent_TD_Work_Item__c, 1);
                    }
                    else 
                    {
                        Integer tempInt=completedtdwiCountMap.get(tdwi.Parent_TD_Work_Item__c);
                    	tempInt++;
                        completedtdwiCountMap.put(tdwi.Parent_TD_Work_Item__c,tempInt);
                    }
                }
                if(completedOpptyCountMap.get(tdwi.Related_Opportunity__c)==null)
                {
                    completedOpptyCountMap.put(tdwi.Related_Opportunity__c,1);
                }
                else
                {
                    Integer tempInt=completedOpptyCountMap.get(tdwi.Related_Opportunity__c);
                    tempInt++;
                    completedOpptyCountMap.put(tdwi.Related_Opportunity__c,tempInt);
                }
                
            }
            if(tdwi.Status__c!='Cancelled' && tdwi.Status__c!='Rejected')
            {
                if(tdwi.Parent_TD_Work_Item__c!=null)
                {
                    if(tdwiCountMap.get(tdwi.Parent_TD_Work_Item__c)==null)
                    {
                        tdwiCountMap.put(tdwi.Parent_TD_Work_Item__c, 1);
                    }
                    else
                    {
                        Integer tempInt=tdwiCountMap.get(tdwi.Parent_TD_Work_Item__c);
                    	tempInt++;
                        tdwiCountMap.put(tdwi.Parent_TD_Work_Item__c,tempInt);
                    }
                }
                if(opptyCountMap.get(tdwi.Related_Opportunity__c)==null)
                {
                    opptyCountMap.put(tdwi.Related_Opportunity__c,1);
                }
                else
                {
                    Integer tempInt=opptyCountMap.get(tdwi.Related_Opportunity__c);
                    tempInt++;
                    opptyCountMap.put(tdwi.Related_Opportunity__c,tempInt);
                }
            }
                  
        }
      	  for(Integer i=0;i<opptyList.size();i++)
            {
                Opportunity oppty = opptyList.get(i);
                oppty.Has_BDHSolution__c=tdOppMap.get(oppty.Id);
                if(opptyCountMap.get(oppty.Id)!=null)
                {
                    oppty.Count_Of_TDWI__c=opptyCountMap.get(oppty.Id);
                }
                else
                {
                   oppty.Count_Of_TDWI__c=0; 
                }
                if(completedOpptyCountMap.get(oppty.Id)!=null)
                {
                    oppty.Count_Of_Completed_TDWI__c=completedOpptyCountMap.get(oppty.Id);
                }
                else
                {
                   oppty.Count_Of_Completed_TDWI__c=0; 
                }
                
                if(oppty.StageName.contains('Closed'))
                {
                    opptyList.remove(i);
                    i--;
                }
            }
        for(Integer i=0;i<tdList.size();i++)
        {
            TD_Work_Item__c tdwi=tdList.get(i);
            Boolean tdUpdated=false;
            	if(tdwiCountMap.get(tdwi.Id)!=null && tdwi.ChildCount__c!=tdwiCountMap.get(tdwi.Id))
                {
                    tdwi.ChildCount__c=tdwiCountMap.get(tdwi.Id);
                    tdUpdated=true;
                }
                else if(tdwiCountMap.get(tdwi.Id)==null && tdwi.ChildCount__c!=0)
                {
                   tdwi.ChildCount__c=0; 
                    tdUpdated=true;
                }
                if(completedtdwiCountMap.get(tdwi.Id)!=null && tdwi.ClosedChildCount__c!=completedtdwiCountMap.get(tdwi.Id))
                {
                     tdwi.ClosedChildCount__c=completedtdwiCountMap.get(tdwi.Id);
                    tdUpdated=true;
                }
                else if(completedtdwiCountMap.get(tdwi.Id)==null && tdwi.ClosedChildCount__c!=0)
                {
                    tdwi.ClosedChildCount__c=0;
                    tdUpdated=true;
                }
            if(tdUpdated==false)
            {
                tdList.remove(i);
                i--;
            }
        }
        if(tdList.size()>0)
        {
            update tdList;
        }
        if(opptyList.size()>0)
        {
            update opptyList; 
        }
            
        
    }
}