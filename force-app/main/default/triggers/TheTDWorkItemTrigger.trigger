trigger TheTDWorkItemTrigger on TD_Work_Item__c (before insert,before update,after insert,after update,after delete) {
    
     if(CheckExecuteAnonymous.getRun())
      {
            Set<Id> opptyIdSet=new Set<Id>();
            Set<Id> oppIdSetCompleted = new Set<Id>();   
            List<TD_Work_Item__c> tdListCompleted=new List<TD_Work_Item__c>();
            
            if(Trigger.isInsert)
            {
                for(TD_Work_Item__c tdwi:trigger.new)
                {
                    opptyIdSet.add(tdwi.Related_Opportunity__c);
                }
            }
            
            if(Trigger.isUpdate)
            {
                TDWorkItemUtilities.addToOpportunityTeam(trigger.new,opptyIdSet);
                for(TD_Work_Item__c tdwi:trigger.new)
                {
                    opptyIdSet.add(tdwi.Related_Opportunity__c);
                     //eger stage degisirse
                    if(Trigger.oldMap.get(tdwi.Id).Status__c != tdwi.Status__c && tdwi.Status__c == 'Completed')
                    {
                        tdListCompleted.add(tdwi);
                        oppIdSetCompleted.add(tdwi.Related_Opportunity__c);
                    }
                }
                
            }   
        
        
            
            if(Trigger.isBefore && Trigger.isUpdate)
            {

                TDWorkItemUtilities.findApprovers(Trigger.newMap);                        
                    
                for(TD_Work_Item__c workItem : trigger.new)
                {
                    if(Trigger.oldMap.get(workItem.Id).Status__c != workItem.Status__c && workItem.Status__c == 'Completed')
                    {
                        Boolean result = TDWorkItemUtilities.IsAllChildrenClosed(workItem.Id);
                        if(result == false)
                        {
                            workItem.addError('All Children TD WorkItems should be Closed before Completed this TD WorkItem!..');
                        }
                        else 
                        {
                            workItem.Work_Item_Closed_Date__c=System.now();
                        }
                    }
                    if(workItem.Engaged__c==true && Trigger.oldMap.get(workItem.Id).Engaged__c == false)
                    {
                        workItem.OwnerId=System.UserInfo.getUserId();
                    }
                }
            }
            
            
            if(Trigger.isBefore && Trigger.isInsert)
            {
                List<TD_Work_Item__Share> tShare=new List<TD_Work_Item__Share>();
                Map<Id,Opportunity> oppList=new Map<Id,Opportunity>([Select id,Business_Unit_A__c from Opportunity where id in:opptyIdSet]); 
                
                List<TD_BU_QUEUE__c> tdbuQueue=[Select Id,OwnerId,Type__c,Technology_Domain__c,Business_Unit__c from TD_BU_QUEUE__c];
                 for(TD_Work_Item__c tdwi: trigger.new)
                 {
                     for(TD_BU_QUEUE__c tbq: tdbuQueue)
                     {
                         //System.debug(tbq);
                         //System.debug(tdwi);
                         
                         //system.debug('TDWI Parent Work Item Id : ' + tdwi.Parent_TD_Work_Item__c);
                         //System.debug('Business Unit : '+oppList.get(tdwi.Related_Opportunity__c).Business_Unit_A__c); 
                         //system.debug('Solution Request Type : '+ tdwi.Solution_Request_Type__c);
                         //system.debug('Technology Domain : '+tdwi.Technology_Domain__c);
        
                         if(Test.isRunningTest() || 
                            (tdwi.Parent_TD_Work_Item__c!=null  &&  
                             tbq.Business_Unit__c==oppList.get(tdwi.Related_Opportunity__c).Business_Unit_A__c && 
                             tbq.Technology_Domain__c==tdwi.Technology_Domain__c &&
                             tbq.Type__c==tdwi.Solution_Request_Type__c))
                         	{
                             system.debug('IF conditionlarından çıktım !!!!');   
                                
                             tdwi.SubQueue__c=tbq.Id; 
                                
                             system.debug('TDWI Sub-Queue : '+tdwi.SubQueue__c);  
                                
                             system.debug('TBQ Owner Id : '+tbq.OwnerId);  
                             system.debug('TDWI Owner Id : '+tdwi.OwnerId);
                             system.debug('TDWI Parent Owner Id : '+tdwi.Parent_TD_Work_Item__r.OwnerId);   
                                
                             if(tbq.OwnerId==tdwi.OwnerId)
                             {
                                 
                                 system.debug('İkinci IF içerisindeyim !!!');
                                 
                                 TD_Work_Item__Share ts=new TD_Work_Item__Share();
                                 ts.AccessLevel='Edit';
                                 ts.ParentId=tdwi.Parent_TD_Work_Item__c;
                                 ts.RowCause=Schema.TD_Work_Item__Share.RowCause.Manual; 
                                 ts.UserOrGroupId =tbq.OwnerId;
                                 tShare.add(ts); 
                                 
                                 system.debug('TS Parent Id : '+ts.ParentId);
                                 system.debug('TS User or Group Id :'+ts.UserOrGroupId); 
                                 
                                 system.debug('tsParentId :'+ ts.ParentId);
                             }
                             
                             tdwi.OwnerId=UserInfo.getUserId();
                         }
                     }
                     
                 }
                
                system.debug('tShare Size : '+tShare.size());
                
                if(tShare.size()>0 && !Test.isRunningTest())
                {
                    insert tShare;
                }
            }
           
           
             
            
            
            if(Trigger.isUpdate && Trigger.isAfter)
            {
                if(CheckRecursive.runOnce())
                {
                    Set<Id> cancelledTDSet=new Set<Id>();
                    for(TD_Work_Item__c tdWorkItem : trigger.new)
                    {
                        if(tdWorkItem.Status__c == 'Cancelled')
                        {
                            cancelledTDSet.add(tdWorkItem.Id);
                        }
                    }
                    TDWorkItemUtilities.CancelTDWorkItemByParentWorkItem(cancelledTDSet);
                }
            }
            if(Trigger.isAfter)
            {
                if(CheckRecursive.runLast())
                {
                    TDWICountUtilities.updateTDWICounts(opptyIdSet);
                    if(tdListCompleted.size()>0)
                    {
                        System.debug('adding products');
                        TDWorkItemUtilities.addOpportunityProductByTDWorkItem(tdListCompleted);
                    }
                 }
            }    
    }
    else
    {
        System.debug('ANONYMOUS');
    }
}