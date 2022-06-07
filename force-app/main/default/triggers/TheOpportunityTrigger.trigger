trigger TheOpportunityTrigger on Opportunity (before update, before insert,after update, after insert) {
    
    if(CheckExecuteAnonymous.getRun())
    {   
            if(Trigger.isInsert && Trigger.isBefore)
            {
                Set<Id> oppOwnerSet=new Set<Id>();
                for(Opportunity o: trigger.new)
                {
                    oppOwnerSet.add(o.OwnerId);      
                       
                }
                List<Pricebook2> PricebookPublicSales = [Select Id,Name from Pricebook2 where Name = 'Public Sales Price Book' LIMIT 1]; 
                List<Pricebook2> PricebookSales = [Select Id, Name from Pricebook2 where Name = 'Sales Price Book' LIMIT 1];
                List<Pricebook2> PricebookSol = [Select Id,Name from Pricebook2 where Name = 'Solution Price Book' LIMIT 1];
                List<Pricebook2> PricebookPublicSol = [Select Id,Name from Pricebook2 where Name = 'Public Solution Price Book' LIMIT 1];
                //Id CyberUser = [SELECT Id FROM User WHERE Functional_Title_Group__c = 'CyberSecurity;' LIMIT 1].Id;
             
                List<SS_Members__c> ssMemberList=new List<SS_Members__c>([ select id,Member__c,Sales_Segments__r.Business_Unit__c,Sales_Segments__r.Business_Unit__r.Name ,Sales_Segments__c from SS_Members__c where Member__c in:oppOwnerSet]);
                Map<Id ,SS_Members__c> ssMemberMap = new Map< Id,SS_Members__c>();
                for(SS_Members__c ssm:ssMemberList)
                {
                    ssMemberMap.put(ssm.Member__c,ssm);
                }
				for(Opportunity o: trigger.new)
                {
                    if(ssMemberMap.get(o.OwnerId)!=null)
                    {                         
                        o.Sales_Segment__c=ssMemberMap.get(o.OwnerId).Sales_Segments__c;
                    	o.Business_Unit_A__c=ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__c;
                        
                        //Berk
                        Id recTypeId25K = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('OPPORTUNITY 25K').getRecordTypeId();
                        Id oppRecordTypeId = o.RecordTypeId;
                        //Berk
                        
                        system.debug('SS Member Business Unit Name : '+ ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__r.Name);
                        
						if(ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__r.Name == 'Public' && !oppRecordTypeId.equals(recTypeId25K) )
                        {
                            system.debug('Pricebook Name : '+PricebookPublicSales[0].Id);
                            o.Pricebook2Id = PricebookPublicSales[0].Id;
                        }else if(ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__r.Name == 'Public' && oppRecordTypeId.equals(recTypeId25K)){
                            system.debug('Pricebook Name : '+PricebookPublicSol[0].Id);
                            o.Pricebook2Id = PricebookPublicSol[0].Id;
                        }else if(ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__r.Name != 'Public' && oppRecordTypeId.equals(recTypeId25K)){
                            
                            o.Pricebook2Id = PricebookSol[0].Id;
                        }else if(ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__r.Name != 'Public' && !oppRecordTypeId.equals(recTypeId25K)){
                            o.Pricebook2Id = PricebookSales[0].Id;
                        }
                        
                        
                      /*  if(o.Is_CyberSecurity__c == true) 
                        {
                            oppTeamList.add(new OpportunityTeamMember(  UserId = CyberUser,	
                                                                        OpportunityId = o.Id,
                                                                        TeamMemberRole = 'Solution',
                                                                        Role_Type__c = 'Solution Expert',
                                                                        OpportunityAccessLevel = 'Edit' 
                                                             	  ));
                            
                        } */
                    }
                } 
               
                
            }
        
        
        	if(Trigger.isAfter && Trigger.isInsert)
            {
                List<OpportunityTeamMember> oppTeamList = new List <OpportunityTeamMember>();
                //Berk
                List<User> CyberUser = [SELECT Id,Functional_Title_Group__c FROM User WHERE Functional_Title_Group__c = 'CyberSecurity;' LIMIT 1];
                
                
                for(Opportunity o: trigger.new)
                {
                    if(o.Is_CyberSecurity__c == true) 
                    {
                                oppTeamList.add(new OpportunityTeamMember(  UserId = CyberUser[0].Id,	
                                                                            OpportunityId = o.Id,
                                                                            TeamMemberRole = 'Solution',
                                                                            Role_Type__c = 'Solution Expert',
                                                                            OpportunityAccessLevel = 'Edit' 
                                                                      ));
                                
                            }
                }
				insert oppTeamList;
            } 
        
           if(Trigger.isUpdate && Trigger.isAfter )
           {
               
               Set<Id> convertedOppIdSet = new Set<Id>();
               for(Opportunity opp : Trigger.old)
               {
                   if(opp.Business_Unit_A__c == NULL || opp.Sales_Segment__c == NULL)
                   {
               	    convertedOppIdSet.add(opp.Id);
                   }
               }
               

               if(checkRecursive.runOnceforLead()){
               checkRecursive.isFirstTime = false;
                   
               List<Opportunity> oppList  = [SELECT Id, Business_Unit_A__c, Sales_Segment__c, Sales_Segment__r.Name,OwnerId FROM Opportunity WHERE Id in:convertedOppIdSet];

               
               Set<Id> oppOwnerSet=new Set<Id>();
               List<String> oppSalesSegmentList = new List<String>();
               for(Opportunity o : oppList)
               {
				 oppOwnerSet.add(o.OwnerId);  
                 oppSalesSegmentList.add(o.Sales_Segment__r.Name);  
               }
                List<Pricebook2> PricebookPublicSales = [Select Id,Name from Pricebook2 where Name = 'Public Sales Price Book' LIMIT 1]; /*Publi Aktarılırken bu alan açılacak*/
                List<Pricebook2> PricebookSales = [Select Id, Name from Pricebook2 where Name = 'Sales Price Book' LIMIT 1];
                List<Pricebook2> PricebookSol = [Select Id,Name from Pricebook2 where Name = 'Solution Price Book' LIMIT 1];
                List<Pricebook2> PricebookPublicSol = [Select Id,Name from Pricebook2 where Name = 'Public Solution Price Book' LIMIT 1];
                List<SS_Members__c> ssMemberList=new List<SS_Members__c>([ select id,Member__c,Sales_Segments__r.Business_Unit__c,Sales_Segments__r.Business_Unit__r.Name ,Sales_Segments__c 
                                                                           from SS_Members__c where Member__c in:oppOwnerSet]);
                Map<Id ,SS_Members__c> ssMemberMap = new Map< Id,SS_Members__c>();
                for(SS_Members__c ssm:ssMemberList)
                {
                    ssMemberMap.put(ssm.Member__c,ssm);
                }
               //Berk
               List<Opportunity> oppsToUpdate = new List<Opportunity>{};
				for(Opportunity o: oppList)
                {
                    if(ssMemberMap.get(o.OwnerId)!=null)
                    {                         
                        o.Sales_Segment__c=ssMemberMap.get(o.OwnerId).Sales_Segments__c;
                    	o.Business_Unit_A__c=ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__c;

                        if(ssMemberMap.get(o.OwnerId).Sales_Segments__r.Business_Unit__r.Name == 'Public'){
                            o.Pricebook2Id = PricebookPublicSales[0].Id;
                        }else{
                            o.Pricebook2Id = PricebookSales[0].Id;
                        }
						 
                        oppsToUpdate.add(o);
                    }
                } 
               //Berk
               if(oppsToUpdate.size() > 0)
               {
                   update oppsToUpdate;
               }
               //Berk
                 
               
               Id oppId = NULL;
               for(Opportunity o: trigger.new)
               {
                  if( o.StageName== 'Qualification' && trigger.oldMap.get(o.id).StageName=='Prospecting' && (o.RecordType.DeveloperName != 'OPPORTUNITY_25K' || o.RecordType.DeveloperName != 'OPPORTUNITY_25K_Closed') )
                  {
                    oppId = o.Id;  
                  }
               }
               system.debug('oppId : '+oppId);
               
              /* if(oppId != NULL && !Test.isRunningTest())
               {
                    List<OpportunityTeamMember> oppTeamList = [SELECT Id, OpportunityId FROM OpportunityTeamMember WHERE OpportunityId  =: oppId AND TeamMemberRole = 'Solution'];
                    system.debug('oppTeamList size : ' + oppTeamList.size());
                   
                   for(Opportunity o: trigger.new)
                   {                   
                       if(oppTeamList.size() == 0 && o.StageName== 'Qualification' && trigger.oldMap.get(o.id).StageName=='Prospecting' && !o.F_Sales_Segment__c.equals('BDH') &&(o.RecordType.DeveloperName != 'OPPORTUNITY_25K' || o.RecordType.DeveloperName != 'OPPORTUNITY_25K_Closed'))
                       {                       
                            o.addError('You should add related solution user to this opportunity !');                     
                       }
                   }
               } */
               }
           }
        
        	Set<Id> oppIdProposalSetCB=new Set<Id>();
        
             if(Trigger.isUpdate && Trigger.isBefore)
            {                
                 for(Opportunity o: trigger.new)
                 {
                     
                        if( o.StageName== 'Qualification' && trigger.oldMap.get(o.id).StageName=='Prospecting') // Prospecting Completed Day
                        {
                            o.Prospecting_Completed_Date__c = system.today();
                        }
                        if( o.StageName== 'Value Proposition' && trigger.oldMap.get(o.id).StageName=='Qualification') // Qualification Completed Day
                        {
                            o.Qualification_Completed_Date__c = system.today();
                        }
                        if(o.StageName=='Solution & Proposal Development' && trigger.oldMap.get(o.id).StageName=='Value Proposition') // Value Proposition Completed Day
                        {
                            o.Value_Proposition_Completed_Date__c = system.today();
                        }
                        if( o.StageName== 'Proposal & Price Quote' && trigger.oldMap.get(o.id).StageName=='Solution & Proposal Development') // Solution Completed Day
                        {
                            oppIdProposalSetCB.add(o.Id);
                            o.Solution_Completed_Date__c = system.today();
                        }
                        if( o.StageName== 'Negotiation & Review' && trigger.oldMap.get(o.id).StageName=='Proposal & Price Quote')// Proposal Completed Day
                        {
                            o.Proposal_Completed_Date__c = system.today();
                        }
                        if((o.StageName== 'Closed Won' || o.StageName== 'Closed Lost' || o.StageName== 'Closed Cancelled') && trigger.oldMap.get(o.id).StageName=='Negotiation & Review')// Negotiation Completed Day
                        {
                            o.Negotiation_Completed_Date__c = system.today();
                        }
                     
                     	
                 }
            }
    }// İf'i kaldır test 80 olur (Berk)     

            Set<Id> oppIdSet=new Set<Id>();
            Set<Id> oppIdProposalSet=new Set<Id>();
            Set<Id> oppIdSolutionSet=new Set<Id>();
            Set<Id> oppIdCancelledSet=new Set<Id>();
            Set<Id> oppIdWonSet=new Set<Id>();
    
    //Berk
    		//List<Id> oppIdToSent = new List<Id>();
    //Berk		
    		if(Trigger.isBefore) /*isBefore oldugu icin approverları atmıyor*/
            {
                CurrencyUtilities.setConversionRates();
                for(Opportunity o:trigger.new)
                {
                    o.Amount_USD__c = CurrencyUtilities.ConvertAmount(o.Amount, o.CurrencyIsoCode, o.CloseDate);
                    o.Total_Product_Cost_USD__c = CurrencyUtilities.ConvertAmount(o.Total_Product_Cost__c, o.CurrencyIsoCode, o.CloseDate);
           
                }
                
                
                if(Trigger.isUpdate && Trigger.New != null)
                {
                    if(CheckRecursive.runOnceApprovers())
                    {
                    OpportunityUtilities.findApprovers(Trigger.New);                        
                    }
                }
            }
            if(Trigger.isUpdate && Trigger.isAfter)
            {
                if((CheckRecursive.runOnce() || Test.isRunningTest()))
                {
                    for(Opportunity o:trigger.new)
                    {                        
                        if(o.StageName=='Value Proposition' && trigger.oldMap.get(o.id).StageName=='Qualification')
                        {
                            oppIdSet.add(o.Id);
                        } 
                        if(o.StageName=='Solution & Proposal Development' && trigger.oldMap.get(o.id).StageName=='Value Proposition')
                        {
                            oppIdSet.add(o.Id);
                            oppIdSolutionSet.add(o.Id);
                        }
                        
                        if(o.StageName == 'Proposal & Price Quote' || o.StageName== 'Negotiation & Review')
                        {
                            oppIdProposalSet.add(o.Id);
                        }
                        if(o.StageName=='Closed Cancelled' || o.StageName=='Closed Lost')
                        {
                            oppIdCancelledSet.add(o.Id);
                        }
                        if(o.StageName=='Closed Won' && (trigger.oldMap.get(o.id).StageName== 'Negotiation & Review' || trigger.oldMap.get(o.id).StageName== '25K Active'))
                        {
                            oppIdWonSet.add(o.Id);
                            //Berk
                            //oppIdToSent.add(o.Id);
                            //Berk
                        } 
                    }
                    
                    if(oppIdSet.size()>0)
                    {
                        CustomerBillingUtilities.SyncCustomerBillings(oppIdSet);                        
                    }
                    if(oppIdSolutionSet.size()>0)
                    {
                        OpportunityUtilities.createTDWorkItems(oppIdSet);
                        OpportunityUtilities.assignTDWorkItems(oppIdSolutionSet,Trigger.newMap);
                    }
                    if(oppIdProposalSet.size()>0)
                    {
                    }
                    if(oppIdCancelledSet.size()>0)
                    {
                        OpportunityUtilities.cancelTDWorkItems(oppIdCancelledSet);
                    }
                    if(oppIdWonSet.size()>0)
                    {

                      BatchSalesforceToSAPUtilities BSTSU = new BatchSalesforceToSAPUtilities();
                      Database.executeBatch(new BatchSalesforceToSAPUtilities(),1);

                      //Berk
                      for(Id i:oppIdWonSet)
                      { 
                          if(!Test.isRunningTest())
                          {
                           OpportunityPDFClass.CreateOrderPDF(i); 
                          }
                      }
                    }   
                }
            }
    
    else
    {
        System.debug('ANONYMOUS');
    }
}