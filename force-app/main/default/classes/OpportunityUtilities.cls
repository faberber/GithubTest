public class OpportunityUtilities {
    
    public static void createTDWorkItems(Set<Id> oppIdSet)
    {
          List<RecordType> rList=[select id,developername,SObjectType from RecordType where SObjectType='TD_Work_Item__c'];
         Map<String,Id> rtMap=new Map<String,Id>();
         for(RecordType r:rList)
         {
             rtMap.put(r.developername,r.Id);
         }
         List<OpportunityLineItem> oliList=[Select id,
                                            Product2.Name,
                                            Product2Id,
                                            Product2.Technology_Domain__c,
                                            Describe_Briefly_For_Solution_Team__c,
                                            Brief_for_Solution_Team__c,
                                            Expected_Reply_Date_From_Solution__c,
                                            Opportunity.Business_Unit_A__r.Name,
                                            Name,
                                            OpportunityId,
                                            Opportunity.Sales_Segment__r.Name,
                                            UnitPrice,
                                            Need_Assistance_For__c
                                            from OpportunityLineItem 
                                            where OpportunityId in :oppIdSet];
        
        List<TD_Work_Item__c> tdList=new List<TD_Work_Item__C>();
        
        Pricebook2 solutionPb=[Select id,name from Pricebook2 where name='Solution Price Book' LIMIT 1];
        system.debug('solutionPb : '+solutionPb.Name);
        
        
        Pricebook2 PublicsolutionPb2 = [Select id,name from Pricebook2 where Name='Public Solution Price Book' LIMIT 1];
        system.debug('PublicsolutionPb : '+PublicsolutionPb2.Name);
        
        for(OpportunityLineItem oli: oliList)
        {
            String[] types = oli.Need_Assistance_For__c.split(';');
            for(Integer i=0;i<types.size();i++)
            {
                if (oli.Opportunity.Business_Unit_A__r.Name !='Public' && types[i]=='R&D consultancy' ){
                    TD_Work_Item__c td=new TD_Work_Item__c();
                    td.RecordTypeId=rtMap.get('TD_INT_REC_TYPE');
                    td.Comments_Description__c=oli.Brief_for_Solution_Team__c;
                    td.Expected_Completion_SLA__c=oli.Expected_Reply_Date_From_Solution__c;
                    td.Init0__c=true;
                    td.Name=oli.Product2.Name;
                    td.Opportunity_Stage__c='Value Proposition';
                    td.OpptyLineID__c=oli.Id;
                    td.Price_Book__c=solutionPb.Id;
                    td.Related_Opportunity__c=oli.OpportunityId; 
                    td.Sales_Price__c=oli.UnitPrice;
                    td.Solution_Request_Type__c=types[i];
                    td.Status__c='Open';
                    td.Technology_Domain__c=oli.Product2.Technology_Domain__c;
                    tdList.add(td);
                } else if (oli.Opportunity.Business_Unit_A__r.Name=='Public' && types[i]=='R&D consultancy') {
                    TD_Work_Item__c td=new TD_Work_Item__c();
                    td.RecordTypeId=rtMap.get('TD_INT_REC_TYPE');
                    td.Comments_Description__c=oli.Brief_for_Solution_Team__c;
                    td.Expected_Completion_SLA__c=oli.Expected_Reply_Date_From_Solution__c;
                    td.Init0__c=true;
                    td.Name=oli.Product2.Name;
                    td.Opportunity_Stage__c='Value Proposition';
                    td.OpptyLineID__c=oli.Id;
                    td.Price_Book__c=PublicsolutionPb2.Id;
                    td.Related_Opportunity__c=oli.OpportunityId;
                    td.Sales_Price__c=oli.UnitPrice;
                    td.Solution_Request_Type__c=types[i];
                    td.Status__c='Open';
                    td.Technology_Domain__c=oli.Product2.Technology_Domain__c;
                    tdList.add(td);          
                  } else if (oli.Opportunity.Business_Unit_A__r.Name =='International' ){
                    TD_Work_Item__c td=new TD_Work_Item__c();
                    td.RecordTypeId=rtMap.get('TD_INT_REC_TYPE');
                    td.Comments_Description__c=oli.Brief_for_Solution_Team__c;
                    td.Expected_Completion_SLA__c=oli.Expected_Reply_Date_From_Solution__c;
                    td.Init0__c=true;
                    td.Name=oli.Product2.Name;
                    td.Opportunity_Stage__c='Value Proposition';
                    td.OpptyLineID__c=oli.Id;
                    td.Price_Book__c=solutionPb.Id;
                    td.Related_Opportunity__c=oli.OpportunityId; 
                    td.Sales_Price__c=oli.UnitPrice;
                    td.Solution_Request_Type__c=types[i];
                    td.Status__c='Open';
                    td.Technology_Domain__c=oli.Product2.Technology_Domain__c;
                    tdList.add(td);
                }else if(oli.Opportunity.Business_Unit_A__r.Name=='Public'){
                    TD_Work_Item__c td=new TD_Work_Item__c();
                    td.RecordTypeId=rtMap.get('TD_WIRECTYPE');
                    td.Comments_Description__c=oli.Brief_for_Solution_Team__c;
                    td.Expected_Completion_SLA__c=oli.Expected_Reply_Date_From_Solution__c;
                    td.Init0__c=true;
                    td.Name=oli.Product2.Name;
                    td.Opportunity_Stage__c='Value Proposition';
                    td.OpptyLineID__c=oli.Id;
                    td.Price_Book__c=PublicsolutionPb2.Id;
                    td.Related_Opportunity__c=oli.OpportunityId;
                    td.Sales_Price__c=oli.UnitPrice;
                    td.Solution_Request_Type__c=types[i];
                    td.Status__c='Open';
                    td.Technology_Domain__c=oli.Product2.Technology_Domain__c;
                    tdList.add(td);                   
                } else {
                    TD_Work_Item__c td=new TD_Work_Item__c();
                    td.RecordTypeId=rtMap.get('TD_WIRECTYPE');
                    td.Comments_Description__c=oli.Brief_for_Solution_Team__c;
                    td.Expected_Completion_SLA__c=oli.Expected_Reply_Date_From_Solution__c;
                    td.Init0__c=true;
                    td.Name=oli.Product2.Name;
                    td.Opportunity_Stage__c='Value Proposition';
                    td.OpptyLineID__c=oli.Id;
                    td.Price_Book__c=solutionPb.Id;
                    td.Related_Opportunity__c=oli.OpportunityId;
                    td.Sales_Price__c=oli.UnitPrice;
                    td.Solution_Request_Type__c=types[i];
                    td.Status__c='Open';
                    td.Technology_Domain__c=oli.Product2.Technology_Domain__c;
                    tdList.add(td);
                }
            }
        }
        
        insert tdList;
    } 
    
    public static void assignTDWorkItems(Set<Id> oppIdSet,Map<Id,Opportunity> oppMap)
    {
        
        Pricebook2 solutionPb=[Select id from Pricebook2 where name='Solution Price Book' LIMIT 1];
        Pricebook2 PublicsolutionPb = [Select Id from Pricebook2 where Name = 'Public Solution Price Book' LIMIT 1];
        
        List<TD_Work_Item__c> tdwiList=[select id,OwnerId,SubQueue__c,Related_Opportunity__c,Technology_Domain__c,Solution_Request_Type__c from TD_Work_Item__c where Related_Opportunity__C in : oppIdSet];   
        List<TD_BU_QUEUE__c> tdbuQueue=[Select Id,OwnerId,Type__c,Technology_Domain__c,Business_Unit__c from TD_BU_QUEUE__c];
        for(TD_Work_Item__c tdwi: tdwiList)
        {
            for(TD_BU_QUEUE__c tbq: tdbuQueue)
            {
                if(tbq.Business_Unit__c==oppMap.get(tdwi.Related_Opportunity__c).Business_Unit_A__c && 
                     tbq.Technology_Domain__c==tdwi.Technology_Domain__c &&
                     tbq.Type__c==tdwi.Solution_Request_Type__c)
                {
                    tdwi.SubQueue__c=tbq.Id;
                    tdwi.OwnerId=tbq.OwnerId;
                    tdwi.Assigned_To_RS_Queue__c=System.now();
                }
           
        }
        update tdwiList;
        
        List<OpportunityLineItem> oppProductList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId in:oppIdSet];
        if(oppProductList.size() > 0)
        {
            delete oppProductList; 
        }
        
        List<Opportunity> updateOppList = new List<Opportunity>();
        List<Opportunity> oppList = [SELECT Id,Business_Unit_A__r.Name, Pricebook2Id FROM Opportunity WHERE Id in: oppIdSet];
        for(Opportunity opp : oppList)
        {
            if(opp.Business_Unit_A__r.Name != 'Public' && opp.PriceBook2Id != solutionPb.Id)
            {
                opp.PriceBook2Id = solutionPb.Id;
                updateOppList.add(opp);
            }
            if(opp.Business_Unit_A__r.Name == 'Public' && opp.PriceBook2Id != PublicsolutionPb.Id)
            {
              opp.PriceBook2Id = PublicsolutionPb.Id;
              updateOppList.add(opp);  
            }
        }
        
        if(updateOppList.size() > 0)
        {
            update updateOppList;
        }
      }
    
    } 
    public static void cancelTDWorkItems(Set<Id> oppIdSet)
    { 
        
         List<TD_Work_Item__c> tdList=[select id,status__c,Engagement_Type__c from TD_Work_Item__c where Related_Opportunity__c in : oppIdSet];
        for(Integer i=0;i<tdList.size();i++)
         {
             if(tdList.get(i).Status__c!='Cancelled' && tdList.get(i).Status__c!='Completed')
             {
                 tdList.get(i).Engagement_Type__c ='Self';
                 tdList.get(i).Status__c='Cancelled';
                 System.debug('EEEE : '+tdList.get(i));
             }
             else
             {
                 tdList.remove(i);
             }
         }
         if(tdList.size()>0)
         {
             update tdList; 
         }
       
    }
    
    public static void findApprovers(List<Opportunity> oppList)
    {
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Opportunity opp: oppList)
        {
            if(opp.Business_Unit_A__c != NULL)
            {
                opportunityList.add(opp);
            }
        }
        //Find OppIds
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : opportunityList)
        {
            oppIdSet.add(opp.Id);
        }
        
        //Find and Map BUs
        Set<Id> BUSet = new Set<Id>();
        for(Opportunity opp: opportunityList)
        {
            BUSet.add(opp.Business_Unit_A__c);
        }
        Map<Id,Business_Unit__c> BUMap = new Map<Id,Business_Unit__c>([Select Id, OwnerId from Business_Unit__c where Id in :BUSet]);
        
        //Find and Map Approver Users / Find CFO
        Id CFOId;
    List<User> approverList = new List<User>();
        Map<Id,User> UserMap = new Map<Id,User>([Select Id, Business_Unit__c, AL__c, 
                                      Approval_Group__c, Finance_Approval_Group__c, 
                                      Approval_Company__c, ManagerId, Upper_Manager__c, Functional_Title_Group__c 
                                      FROM User 
                                      WHERE IsActive = TRUE ]); /* LIMIT 100 olmazsa 101 hatası alınıyor */
        for(User user : userMap.values())
        {
            if(user.Functional_Title_Group__c!=null)
            {
                if(user.Functional_Title_Group__c.contains('CFO'))
                {
                    CFOId = user.Id;
                }
            }
            if(user.AL__c != null)
            {
                approverList.add(user);
            }
        }
        
        //Find and Map TdWorkItem by Opportunity
        Map<Id, OppTdwiModel> oppTdwiMap = new Map<Id, OppTdwiModel>();
        List<Td_Work_Item__c> tdwiList = [SELECT Id,OwnerManager__c,Owner_Upper_Manager__c,Related_Opportunity__c FROM Td_Work_Item__c WHERE Related_Opportunity__c in : oppIdSet AND Status__c = 'Completed'];
        for(Td_Work_Item__c tdwi : tdwiList)
        {
            OppTdwiModel otModel = new OppTdwiModel();
            if(oppTdwiMap.get(tdwi.Related_Opportunity__c) != null)
            {
                otModel = oppTdwiMap.get(tdwi.Related_Opportunity__c);
            }          
            otModel.OpportunityId = tdwi.Related_Opportunity__c;
            otModel.TdwiList.add(tdwi);
            oppTdwiMap.put(tdwi.Related_Opportunity__c, otModel);
        }       
        
        //find and set approvers
        for(Opportunity opp: opportunityList)
        {
            opp.Approver_Opportunity_Manager__c = UserMap.get(opp.OwnerId) == null ? opp.OwnerId : (UserMap.get(opp.OwnerId).ManagerId != null ? UserMap.get(opp.OwnerId).ManagerId : opp.OwnerId);
            opp.Approver_Opportunity_Upper_Manager_c__c = UserMap.get(opp.OwnerId) == null ? opp.OwnerId :  (UserMap.get(opp.OwnerId).Upper_Manager__c != NULL ? UserMap.get(opp.OwnerId).Upper_Manager__c : (UserMap.get(opp.OwnerId).ManagerId == null ? opp.OwnerId : UserMap.get(UserMap.get(opp.OwnerId).ManagerId).ManagerId));
            opp.Approvers_for_BU_General_Manager__c = BUMap.get(opp.Business_Unit_A__c).OwnerId;
            opp.Approvers_for_CFO__c = CFOId;            
            
            Integer count = 0;
            if(oppTdwiMap.get(opp.Id) != null)
            {
                for(TD_Work_Item__c  tdwi : oppTdwiMap.get(opp.Id).TdwiList)
                {
                    if(count == 0)
                    {
                        if(opp.AL_For_Solution__c == '3')
                        {   
                            opp.Approver_TDWI_Owner_Manager_1__c = tdwi.OwnerManager__c;
                        }
                        else if(opp.AL_For_Solution__c == '2')
                        {
                            opp.Approver_TDWI_Owner_Manager_1__c = tdwi.Owner_Upper_Manager__c;
                            if(tdwi.OwnerManager__c != null)
                            {
                                String checkAL = UserMap.get(tdwi.OwnerManager__c).AL__c;
                                if(checkAL != null)
                                {
                                    if(checkAL.contains('2') || checkAL.contains('1'))
                                    {
                                        opp.Approver_TDWI_Owner_Manager_1__c = tdwi.OwnerManager__c;
                                    } 
                                }
                            }
                        }
                        if(opp.Approver_TDWI_Owner_Manager_1__c != null)
                        {
                          count++;
                        }
                    }
                    else if (count == 1 && opp.Approver_TDWI_Owner_Manager_1__c != tdwi.OwnerManager__c)
                    {
                        if(opp.AL_For_Solution__c == '3')
                        {
                            opp.Approver_TDWI_Owner_Manager_2__c = tdwi.OwnerManager__c;
                        }
                        else if(opp.AL_For_Solution__c == '2')
                        {
                            opp.Approver_TDWI_Owner_Manager_2__c = tdwi.Owner_Upper_Manager__c;
                            if(tdwi.OwnerManager__c != null)
                            {
                                String checkAL = UserMap.get(tdwi.OwnerManager__c).AL__c;
                                if(checkAL != null)
                                {
                                    if(checkAL.contains('2') || checkAL.contains('1'))
                                    {
                                        opp.Approver_TDWI_Owner_Manager_2__c = tdwi.OwnerManager__c;
                                    }
                                }
                            }
                        }
                        if(opp.Approver_TDWI_Owner_Manager_2__c != null)
                        {
                          count++;
                        }
                    }
                    else if (count == 2 && opp.Approver_TDWI_Owner_Manager_2__c != tdwi.OwnerManager__c)
                    {
                        if(opp.AL_For_Solution__c == '3')
                        {
                            opp.Approver_TDWI_Owner_Manager_3__c = tdwi.OwnerManager__c;
                        }
                        else if(opp.AL_For_Solution__c == '2')
                        {
                            opp.Approver_TDWI_Owner_Manager_3__c = tdwi.Owner_Upper_Manager__c;
                            if(tdwi.OwnerManager__c != null)
                            {
                                String checkAL = UserMap.get(tdwi.OwnerManager__c).AL__c;
                                if(checkAL != null)
                                {
                                    if(checkAL.contains('2') || checkAL.contains('1'))
                                    {
                                        opp.Approver_TDWI_Owner_Manager_3__c = tdwi.OwnerManager__c;
                                    } 
                                }
                            }
                        }
                        break;
                    }
                }
            }
            
            // *** Account *** 
            if((opp.AL_For_Account__c =='2' ||  opp.AL_For_Account__c =='3') && opp.F_Sales_Segment__c == 'BDH') 
            {
                 for(User user : approverList)
                 {
                     if(user.Approval_Group__c != NULL && user.Approval_Group__c.contains('BDHAccount2'))
                     {
                       opp.Approvers_For_Account__c = user.Id;
                     }    
                 }    
            }
                      
            else if(opp.AL_For_Account__c == '3' && opp.F_Sales_Segment__c != 'BDH')
            {
                opp.Approvers_For_Account__c = opp.Approver_Opportunity_Manager__c;
            }
            else if(opp.AL_For_Account__c == '2' && opp.F_Sales_Segment__c != 'BDH')
            {
                opp.Approvers_For_Account__c = opp.Approver_Opportunity_Upper_Manager_c__c;
                if(UserMap.get(opp.OwnerId) != null)
                {
                    if(UserMap.get(opp.OwnerId).ManagerId != null)
                    {
                        String checkAL = UserMap.get(UserMap.get(opp.OwnerId).ManagerId).AL__c;
                        if(checkAL != null)
                        {
                            if(checkAL.contains('2') || checkAL.contains('1'))
                            {
                                opp.Approvers_For_Account__c = opp.Approver_Opportunity_Manager__c;
                            }
                        }
                    }
                }
            }
            
            for(User user : approverList)
            {
                if(user.Approval_Group__c != null)
                {
                    //*** DCA1 Approvers ***//
                    
                    if(user.Approval_Group__c.contains('DCA1'))
                    {
                        if(user.Business_Unit__c == 'Public')
                        {
                            opp.Public_DCA_1_Approver__c = user.Id;
                        }
                        if(user.Business_Unit__c == 'Enterprise')
                        {
                            opp.Enterprise_DCA_1_Approver__c = user.Id;
                        }
                        if(user.Business_Unit__c == 'International')
                        {
                            opp.International_DCA_1_Approver__c = user.Id;
                        }
                    }
                  // *** Supplier *** 
                    if(user.Approval_Group__c.contains('Supplier') && user.AL__c.contains(opp.AL_For_Supplier__c))
                    {
                        opp.Approvers_For_Supplier__c = user.Id;
                    }
                    // *** Finance *** 
                    
                    //1 //
                    else if(opp.AL_For_Finance__c == '2' && opp.F_Sales_Segment__c == 'BDH' && user.Approval_Group__c.contains('BDHFinance2'))
                    {
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    //2 aynı kaldı//
                     else if(opp.Need_AL1_Approval__c == true && opp.F_Sales_Segment__c == 'BDH' && user.Approval_Group__c.contains('BDHFinance1'))
                    {
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    //3//
                    else if(opp.AL_For_Finance__c == '3' && opp.F_Sales_Segment__c == 'BDH' && user.Approval_Group__c.contains('BDHFinance2'))
                    {
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    //4
                    else if(opp.AL_For_Finance__c == '2' && opp.F_Sales_Segment__c != 'BDH' && user.Approval_Group__c.contains('Finance') && user.AL__c.contains(opp.AL_For_Finance__c) )
                    {
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    //5
                    else if(opp.AL_For_Finance__c == '3' && opp.F_Sales_Segment__c != 'BDH' && user.Approval_Group__c.contains('Finance') && user.AL__c.contains(opp.AL_For_Finance__c) && user.Business_Unit__c == opp.F_Business_Unit__c)
                    {
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    //fatih yaptı//
                    //1 ve 3 birleştirildi
                    else if (opp.F_Sales_Segment__c == 'BDH' && user.Approval_Group__c.contains('BDHFinance2')&&(opp.AL_For_Finance__c == '2' || opp.AL_For_Finance__c == '3' )){
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    //4 ve 5 birleştirildi
                    else if((opp.F_Sales_Segment__c != 'BDH' && user.Approval_Group__c.contains('Finance') && user.AL__c.contains(opp.AL_For_Finance__c) ) &&  (opp.AL_For_Finance__c == '2'||( opp.AL_For_Finance__c == '3' && user.Business_Unit__c == opp.F_Business_Unit__c ) ) )
                    {
                        opp.Approvers_For_Finance__c = user.Id;
                    }
                    
                    //*** BDH ***//
                    else if(user.Approval_Group__c.contains('BDH') && user.AL__c.contains(opp.AL_For_Solution__c))
                    {
                        opp.Approver_for_BDH__c = user.Id;           
                    }
                    else if(user.Approval_Group__c.contains('BDH') && user.AL__c.contains('1'))
                    { 
                        opp.Approver_for_BDH_HL__c = user.Id;           
                    }
                }
            }
        }
    }
    
    private class OppTdwiModel{
        Id OpportunityId {get;set;}
        List<Td_Work_Item__c> TdwiList {get;set;}
        
        public OppTdwiModel(){
            this.OpportunityId = OpportunityId;
            this.TdwiList = new List<Td_Work_Item__c>();
        }
    }
}