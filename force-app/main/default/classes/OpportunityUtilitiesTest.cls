@isTest
public class OpportunityUtilitiesTest {
  static testMethod void testOpportunityUtilities()
  {
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus1'];
        User testUser2=[select id from user where Alias='testus1'];
        User testManager=[select id from user where Alias='testapp'];

        Sales_Segments__c ss=[select id from Sales_Segments__c];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        Opportunity opp=[SELECT AccountId, AL_For_Account__c,AL_For_Finance__c,
                         AL_For_Solution__c,AL_For_Supplier__c,Amount,Amount_USD__c,
                         Approval_Comment__c,Approval_Level_B__c,Approval_Level__c,
                         Approval_Status__c,Approved_Amount__c,Approved_Margin__c,
                         Approvers_For_Account__c,Approvers_for_BU_General_Manager__c,
                         Approvers_For_CEO__c,Approvers_for_CFO__c,Approvers_For_Finance__c,
                         Approvers_For_Operational__c,Approvers_For_R_D__c,Approvers_For_Solutions__c,
                         Approvers_For_Supplier__c,Approvers_For_Technology__c,Approvers_For_Treasuary__c,
                         Approver_AL_B__c,Approver_AL_PickList__c,Approver_AL__c,Approver_Opportunity_Manager__c,
                         Approver_Opportunity_Upper_Manager_c__c,Approver_TDWI_Owner_Manager_1__c,
                         Approver_TDWI_Owner_Manager_2__c,Approver_TDWI_Owner_Manager_3__c,Approver_TDWI_Owner_Upper_Manager_1__c,
                         Approver_TDWI_Owner_Upper_Manager_2__c,Approver_TDWI_Owner_Upper_Manager_3__c,BForm_EBIT_Perc__c,
                         BForm_EBIT__c,BForm_EBT_Perc__c,BForm_EBT__c,BForm_GM_Perc__c,BForm_GM__c,BForm_Indirect_Cost_Ratio__c,
                         BForm_Indirect_Cost__c,BForm_OPEX_Ratio__c,BForm_OPEX__c,BForm_SM_Perc__c,
                         BForm_SM__c,BFrom_EBT_Perc_Value__c, Business_Unit_A__c,Business_Unit_Detail__c,
                         Business_Unit__c,Business_Unit_A__r.Name,CD_USD__c, CloseDate,Company__c,Contract_Date__c,Contract_Risk_USD__c,
                         Count_Of_Completed_TDWI__c, Count_Of_TDWI__c,Count_Of_Vendor_Billings__c,CurrencyIsoCode,
                         Customer_Order_Date__c,DCA_Approval_Status__c,DCA_Status__c,Decision_Date__c,Description,
                         Estimated_Amount_USD__c, Estimated_Amount__c,Estimated_Installments__c,Estimated_Invoice_Date__c,
                         Estimated_Invoice_Monthly_Term__c, Estimated_Margin_Amount__c,Estimated_Margin_Perc__c,
                         Estimated_Solution_Segment__c,  Estimated_Sum_Of_Customer_Billing__c,Finance_Cost__c,
                         FiscalYear,ForecastCategory,ForecastCategoryName,F_Business_Unit__c,
                         General_Margin_Ratio__c,GM_Perc__c,GM__c,HasOpportunityLineItem,
                         HasOverdueTask,Has_BDHSolution__c,Id,Indirect_COS_Amount__c,Indirect_COS__c,Interest_Rate__c,
                         Invoicing__c,IsClosed,IsDeleted,IsExcludedFromTerritory2Filter,IsPrivate,IsTransferred__c,IsWon,
                         LD_USD__c,Loss_Reason__c,Margin__c,My_Forecast__c,Name,Need_AL1_Approval__c,
                         Need_Approval__c,Net_GM_Perc__c,Net_GM__c,NextStep,OPEX_Amount__c,OPEX_Ratio__c,Opportunity_Description__c,
                         Opportunity_ID__c,Opportunity_Nick__c,Opportunity_Probability__c,Opportunity_Type_B__c,Opportunity_Type__c,
                         Opp_Fiscal_Period__c,OwnerId,PAF_Approval_Status__c,PartnerAccountId,
                         Payment_Terms__c,Payment_Term__c,Pricebook2Id,PriceBookChanged__c,Probability,
                         Proposal_Date__c,Rebate__c,RecordTypeId,Recruitment__c,Revenue_Recognition__c,
                         Sales_Segment__c,Solution_Segment__c,StageName,
                         Stage_Probability__c, Status__c,Sum_Of_Collections_USD__c,
                         Sum_Of_Customer_Billings_USD__c,
                         Sum_Of_Payments_USD__c,Sum_Of_Vendor_Billings_USD__c,Tender_Type__c,
                         TotalOpportunityQuantity,Total_Customer_Billings__c,Total_Margin__c,Total_Product_Cost_USD__c,
                         Total_Product_Cost__c,Total_Product_Margin__c,Total_Rebate_USD__c,Total_Revenue__c,Total_Sales_Price_Currency__c,
                         Total_Sales_Price__c,Total_Vendor_Billings__c FROM Opportunity WHERE Name = 'TestDataFactory1'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        CheckExecuteAnonymous.changeRun(false);
        
        System.RunAs(testUser)
             {
                 
                Set<Id> oppIdSet=new Set<Id>();
                oppIdSet.add(opp.Id);
                //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
                OpportunityLineItem oliPC=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Product consultancy');
                OpportunityLineItem oliSC=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Service consultancy');
                OpportunityLineItem oliRND=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='R&D consultancy');
                List<OpportunityLineItem> oliList=new List<OpportunityLineItem>();
                 oliList.add(oliPC);
                 oliList.add(oliSC);
                 oliList.add(oliRND);
                 insert oliList;
                 
                                  System.debug('Contract_Risk_USD__c OF THE OPP 1: ' + opp.Contract_Risk_USD__c);
                                  System.debug('Estimated_Solution_Segment__c OF THE OPP 1: ' + opp.Estimated_Solution_Segment__c);
                                  System.debug('Amount_USD__c OF THE OPP 1: ' + opp.Amount);
                                  System.debug('Total_Product_Margin__c OF THE OPP 1: ' + opp.Total_Product_Margin__c);
                                  System.debug('F_Business_Unit__c OF THE OPP 1: ' + opp.F_Business_Unit__c);
                                  System.debug('AL_For_Solution__c OF THE OPP 1: ' + opp.AL_For_Solution__c);



                
                Map<Id,Opportunity> oppIdMap=new Map<Id,Opportunity>();
                oppIdMap.put(opp.Id,opp);
     
                TD_BU_QUEUE__c subQueuePC = new TD_BU_QUEUE__c(
                 Business_Unit__c = opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'Product consultancy'
                );
                 TD_BU_QUEUE__c subQueueSC = new TD_BU_QUEUE__c(
                 Business_Unit__c =  opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'Service consultancy'
                );
                 TD_BU_QUEUE__c subQueueRND = new TD_BU_QUEUE__c(
                 Business_Unit__c = opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'R&D consultancy'
                );
                 List<TD_BU_QUEUE__c> tdbql=new List<TD_BU_QUEUE__c>();
                 tdbql.add(subQueuePC);
                 tdbql.add(subQueueSC);
                 tdbql.add(subQueueRND);
                 insert tdbql;

                                  System.debug('Contract_Risk_USD__c OF THE OPP 1: ' + opp.Contract_Risk_USD__c);
                                  System.debug('Estimated_Solution_Segment__c OF THE OPP 1: ' + opp.Estimated_Solution_Segment__c);
                                  System.debug('Amount_USD__c OF THE OPP 1: ' + opp.Amount);
                                  System.debug('Total_Product_Margin__c OF THE OPP 1: ' + opp.Total_Product_Margin__c);
                                  System.debug('F_Business_Unit__c OF THE OPP 1: ' + opp.F_Business_Unit__c);
                                  System.debug('AL_For_Solution__c OF THE OPP 1: ' + opp.AL_For_Solution__c);

                opp.StageName='Value Proposition';
                update opp;

                                  System.debug('Contract_Risk_USD__c OF THE OPP 1: ' + opp.Contract_Risk_USD__c);
                                  System.debug('Estimated_Solution_Segment__c OF THE OPP 1: ' + opp.Estimated_Solution_Segment__c);
                                  System.debug('Amount_USD__c OF THE OPP 1: ' + opp.Amount);
                                  System.debug('Total_Product_Margin__c OF THE OPP 1: ' + opp.Total_Product_Margin__c);
                                  System.debug('F_Business_Unit__c OF THE OPP 1: ' + opp.F_Business_Unit__c);
                                  System.debug('AL_For_Solution__c OF THE OPP 1: ' + opp.AL_For_Solution__c);


                
                TD_Work_Item__c tdc =new TD_Work_Item__c();
                tdc.Related_Opportunity__c=opp.Id;
                tdc.OwnerId = testUser2.Id;
                tdc.Status__c='Waiting Sale Actions';
                tdc.Work_Item_Closed_Date__c=system.today();
                tdc.ChildCount__c=0;
                tdc.Suggested_Cost__c = 1000; 
                tdc.ClosedChildCount__c=0;
                tdc.Custom_Duration__c=10;
                tdc.Technology_Domain__c=td.Id;
                tdc.SuggestedSolutionProduct__c=solProd.Id;
                tdc.Price_Book__c = solPb.Id;
                tdc.Sales_Price__c = null;
                tdc.Custom_Duration__c=123;
                insert tdc;       
                                 
                                  System.debug('Contract_Risk_USD__c OF THE OPP 1: ' + opp.Contract_Risk_USD__c);
                                  System.debug('Estimated_Solution_Segment__c OF THE OPP 1: ' + opp.Estimated_Solution_Segment__c);
                                  System.debug('Amount_USD__c OF THE OPP 1: ' + opp.Amount);
                                  System.debug('Total_Product_Margin__c OF THE OPP 1: ' + opp.Total_Product_Margin__c);
                                  System.debug('F_Business_Unit__c OF THE OPP 1: ' + opp.F_Business_Unit__c);
                                  System.debug('AL_For_Solution__c OF THE OPP 1: ' + opp.AL_For_Solution__c);

                                  System.debug('OwnerId OF THE tdc 4: ' + tdc.OwnerId);

                TD_Work_Item__c tdcCompleted =new TD_Work_Item__c();
                tdcCompleted.Related_Opportunity__c=opp.Id;
                tdcCompleted.OwnerId = testUser2.Id;
                tdcCompleted.Status__c='Completed';
                tdcCompleted.Work_Item_Closed_Date__c=system.today();
                tdcCompleted.ChildCount__c=0;
                tdcCompleted.Suggested_Cost__c = 1000; 
                tdcCompleted.ClosedChildCount__c=0;
                tdcCompleted.Custom_Duration__c=10;
                tdcCompleted.Technology_Domain__c=td.Id;
                tdcCompleted.SuggestedSolutionProduct__c=solProd.Id;
                tdcCompleted.Price_Book__c = solPb.Id;
                tdcCompleted.Sales_Price__c = 1200;
                tdcCompleted.Suggested_Manufacturer__c =ven.Id;
                tdcCompleted.Suggested_Vendor__c =ven.Id;
                tdcCompleted.Insert_Product__c='Approve product insert';
                tdcCompleted.Custom_Duration__c=123;
                tdcCompleted.Completion_Description__c ='test desc';
                tdcCompleted.Solution_Request_Type__c='Product consultancy';
                insert tdcCompleted; 
                                
                                  System.debug('Contract_Risk_USD__c OF THE OPP 1: ' + opp.Contract_Risk_USD__c);
                                  System.debug('Estimated_Solution_Segment__c OF THE OPP 1: ' + opp.Estimated_Solution_Segment__c);
                                  System.debug('Amount_USD__c OF THE OPP 1: ' + opp.Amount);
                                  System.debug('Total_Product_Margin__c OF THE OPP 1: ' + opp.Total_Product_Margin__c);
                                  System.debug('F_Business_Unit__c OF THE OPP 1: ' + opp.F_Business_Unit__c);
                                  System.debug('AL_For_Solution__c OF THE OPP 1: ' + opp.AL_For_Solution__c);


                system.debug('werwe');
                system.debug(oppIdSet);
                OpportunityUtilities.createTDWorkItems(oppIdSet);
                OpportunityUtilities.assignTDWorkItems(oppIdSet,oppIdMap);
                List<Opportunity> oppList=new List<Opportunity>();
                oppList.add(opp);
                              
                                  System.debug('Contract_Risk_USD__c OF THE OPP 1: ' + opp.Contract_Risk_USD__c);
                                  System.debug('Estimated_Solution_Segment__c OF THE OPP 1: ' + opp.Estimated_Solution_Segment__c);
                                  System.debug('Amount_USD__c OF THE OPP 1: ' + opp.Amount);
                                  System.debug('Total_Product_Margin__c OF THE OPP 1: ' + opp.Total_Product_Margin__c);
                                  System.debug('F_Business_Unit__c OF THE OPP 1: ' + opp.F_Business_Unit__c);
                                  System.debug('AL_For_Solution__c OF THE OPP 1: ' + opp.AL_For_Solution__c);

              
                OpportunityUtilities.findApprovers(oppList);
          
                opp.StageName='Closed Cancelled';
                update opp;
                TD_Work_Item__c tdcCancel =new TD_Work_Item__c();
                tdcCancel.Related_Opportunity__c=opp.Id;
                tdcCancel.OwnerId = testUser2.Id;
                tdcCancel.Status__c='Open';
                tdcCancel.Work_Item_Closed_Date__c=system.today();
                tdcCancel.ChildCount__c=0;
                tdcCancel.Suggested_Cost__c = 1000; 
                tdcCancel.ClosedChildCount__c=0;
                tdcCancel.Custom_Duration__c=10;
                tdcCancel.Technology_Domain__c=td.Id;
                tdcCancel.SuggestedSolutionProduct__c=solProd.Id;
                tdcCancel.Price_Book__c = solPb.Id;
                tdcCancel.Sales_Price__c = null;
                tdcCancel.Custom_Duration__c=123;
                insert tdcCancel;
               
                OpportunityUtilities.cancelTDWorkItems(oppIdSet); 
                 
                   Business_Unit__c BDH = new Business_Unit__c();
                   BDH.Name = 'BDH';  
                   insert BDH;  
                 
                   Sales_Segments__c BDHss=new Sales_Segments__c();
                   BDHss.Name = 'BDH';
                   BDHss.Business_Unit__c=BDH.Id; 
                   insert BDHss;
                 
                   opp.Sales_Segment__c=BDHss.Id;
                   opp.By_Pass_Solution__c='Yes';
                   update opp;
                   OpportunityUtilities.findApprovers(oppList);  
                 
                   opp.StageName = 'Closed Won';
                   update opp;
                 
                   Set<Id> oppWonSetId=new Set<Id>();
                   oppWonSetId.add(opp.Id);
                  
                   ScheduledSalesforceToSAPUtilities SSTSU = new ScheduledSalesforceToSAPUtilities();
                   SSTSU.execute(NULL);
                   
                   //BatchSalesforceToSAPUtilities BSTSAPU = new BatchSalesforceToSAPUtilities();       
               //Database.executeBatch(BSTSAPU,10);  
    
                          
    }
}    
    
    static testMethod void testOpportunityUtilitiesInternational()
  {
        TestDataFactory.createBaseTestDataInternational();
        User testUser=[select id from user where Alias='testus1'];
        Sales_Segments__c ss=[select id from Sales_Segments__c];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        Opportunity opp=[SELECT AccountId, AL_For_Account__c,AL_For_Finance__c,
                         AL_For_Solution__c,AL_For_Supplier__c,Amount,Amount_USD__c,
                         Approval_Comment__c,Approval_Level_B__c,Approval_Level__c,
                         Approval_Status__c,Approved_Amount__c,Approved_Margin__c,
                         Approvers_For_Account__c,Approvers_for_BU_General_Manager__c,
                         Approvers_For_CEO__c,Approvers_for_CFO__c,Approvers_For_Finance__c,
                         Approvers_For_Operational__c,Approvers_For_R_D__c,Approvers_For_Solutions__c,
                         Approvers_For_Supplier__c,Approvers_For_Technology__c,Approvers_For_Treasuary__c,
                         Approver_AL_B__c,Approver_AL_PickList__c,Approver_AL__c,Approver_Opportunity_Manager__c,
                         Approver_Opportunity_Upper_Manager_c__c,Approver_TDWI_Owner_Manager_1__c,
                         Approver_TDWI_Owner_Manager_2__c,Approver_TDWI_Owner_Manager_3__c,Approver_TDWI_Owner_Upper_Manager_1__c,
                         Approver_TDWI_Owner_Upper_Manager_2__c,Approver_TDWI_Owner_Upper_Manager_3__c,BForm_EBIT_Perc__c,
                         BForm_EBIT__c,BForm_EBT_Perc__c,BForm_EBT__c,BForm_GM_Perc__c,BForm_GM__c,BForm_Indirect_Cost_Ratio__c,
                         BForm_Indirect_Cost__c,BForm_OPEX_Ratio__c,BForm_OPEX__c,BForm_SM_Perc__c,
                         BForm_SM__c,BFrom_EBT_Perc_Value__c, Business_Unit_A__c,Business_Unit_Detail__c,
                         Business_Unit__c,Business_Unit_A__r.Name,CD_USD__c, CloseDate,Company__c,Contract_Date__c,Contract_Risk_USD__c,
                         Count_Of_Completed_TDWI__c, Count_Of_TDWI__c,Count_Of_Vendor_Billings__c,CurrencyIsoCode,
                         Customer_Order_Date__c,DCA_Approval_Status__c,DCA_Status__c,Decision_Date__c,Description,
                         Estimated_Amount_USD__c, Estimated_Amount__c,Estimated_Installments__c,Estimated_Invoice_Date__c,
                         Estimated_Invoice_Monthly_Term__c, Estimated_Margin_Amount__c,Estimated_Margin_Perc__c,
                         Estimated_Solution_Segment__c,  Estimated_Sum_Of_Customer_Billing__c,Finance_Cost__c,
                         FiscalYear,ForecastCategory,ForecastCategoryName,F_Business_Unit__c,
                         General_Margin_Ratio__c,GM_Perc__c,GM__c,HasOpportunityLineItem,
                         HasOverdueTask,Has_BDHSolution__c,Id,Indirect_COS_Amount__c,Indirect_COS__c,Interest_Rate__c,
                         Invoicing__c,IsClosed,IsDeleted,IsExcludedFromTerritory2Filter,IsPrivate,IsTransferred__c,IsWon,
                         LD_USD__c,Loss_Reason__c,Margin__c,My_Forecast__c,Name,Need_AL1_Approval__c,
                         Need_Approval__c,Net_GM_Perc__c,Net_GM__c,NextStep,OPEX_Amount__c,OPEX_Ratio__c,Opportunity_Description__c,
                         Opportunity_ID__c,Opportunity_Nick__c,Opportunity_Probability__c,Opportunity_Type_B__c,Opportunity_Type__c,
                         Opp_Fiscal_Period__c,OwnerId,PAF_Approval_Status__c,PartnerAccountId,
                         Payment_Terms__c,Payment_Term__c,Pricebook2Id,PriceBookChanged__c,Probability,
                         Proposal_Date__c,Rebate__c,RecordTypeId,Recruitment__c,Revenue_Recognition__c,
                         Sales_Segment__c,Solution_Segment__c,StageName,
                         Stage_Probability__c, Status__c,Sum_Of_Collections_USD__c,
                         Sum_Of_Customer_Billings_USD__c,
                         Sum_Of_Payments_USD__c,Sum_Of_Vendor_Billings_USD__c,Tender_Type__c,
                         TotalOpportunityQuantity,Total_Customer_Billings__c,Total_Margin__c,Total_Product_Cost_USD__c,
                         Total_Product_Cost__c,Total_Product_Margin__c,Total_Rebate_USD__c,Total_Revenue__c,Total_Sales_Price_Currency__c,
                         Total_Sales_Price__c,Total_Vendor_Billings__c FROM Opportunity WHERE Name = 'TestDataFactory1'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        CheckExecuteAnonymous.changeRun(false);
        
        System.RunAs(testUser)
             {
                 
                Set<Id> oppIdSet=new Set<Id>();
                oppIdSet.add(opp.Id);
                //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
                OpportunityLineItem oliPC=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Product consultancy');
                OpportunityLineItem oliSC=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Service consultancy');
                OpportunityLineItem oliRND=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='R&D consultancy');
                List<OpportunityLineItem> oliList=new List<OpportunityLineItem>();
                 oliList.add(oliPC);
                 oliList.add(oliSC);
                 oliList.add(oliRND);
                 insert oliList;
                 
                 
                
                Map<Id,Opportunity> oppIdMap=new Map<Id,Opportunity>();
                oppIdMap.put(opp.Id,opp);
     
                TD_BU_QUEUE__c subQueuePC = new TD_BU_QUEUE__c(
                 Business_Unit__c = opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'Product consultancy'
                );
                 TD_BU_QUEUE__c subQueueSC = new TD_BU_QUEUE__c(
                 Business_Unit__c =  opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'Service consultancy'
                );
                 TD_BU_QUEUE__c subQueueRND = new TD_BU_QUEUE__c(
                 Business_Unit__c = opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'R&D consultancy'
                );
                 List<TD_BU_QUEUE__c> tdbql=new List<TD_BU_QUEUE__c>();
                 tdbql.add(subQueuePC);
                 tdbql.add(subQueueSC);
                 tdbql.add(subQueueRND);
                 insert tdbql;
                 
                opp.StageName='Value Proposition';
                update opp;
                opp.StageName='Solution & Proposal Development';
                update opp;
                 
                
                TD_Work_Item__c tdc =new TD_Work_Item__c();
                tdc.Related_Opportunity__c=opp.Id;
                tdc.Status__c='Waiting Sale Actions';
                tdc.Work_Item_Closed_Date__c=system.today();
                tdc.ChildCount__c=0;
                tdc.Suggested_Cost__c = 1000; 
                tdc.ClosedChildCount__c=0;
                tdc.Custom_Duration__c=10;
                tdc.Technology_Domain__c=td.Id;
                tdc.SuggestedSolutionProduct__c=solProd.Id;
                tdc.Price_Book__c = solPb.Id;
                tdc.Sales_Price__c = null;
                tdc.Custom_Duration__c=123;
                insert tdc;       
                 
                TD_Work_Item__c tdcCompleted =new TD_Work_Item__c();
                tdcCompleted.Related_Opportunity__c=opp.Id;
                tdcCompleted.Status__c='Completed';
                tdcCompleted.Work_Item_Closed_Date__c=system.today();
                tdcCompleted.ChildCount__c=0;
                tdcCompleted.Suggested_Cost__c = 1000; 
                tdcCompleted.ClosedChildCount__c=0;
                tdcCompleted.Custom_Duration__c=10;
                tdcCompleted.Technology_Domain__c=td.Id;
                tdcCompleted.SuggestedSolutionProduct__c=solProd.Id;
                tdcCompleted.Price_Book__c = solPb.Id;
                tdcCompleted.Sales_Price__c = 1200;
                tdcCompleted.Suggested_Manufacturer__c =ven.Id;
                tdcCompleted.Suggested_Vendor__c =ven.Id;
                tdcCompleted.Insert_Product__c='Approve product insert';
                tdcCompleted.Custom_Duration__c=123;
                tdcCompleted.Completion_Description__c ='test desc';
                tdcCompleted.Solution_Request_Type__c='Product consultancy';
                insert tdcCompleted; 
                
                system.debug('werwe');
                system.debug(oppIdSet);
                OpportunityUtilities.createTDWorkItems(oppIdSet);
                OpportunityUtilities.assignTDWorkItems(oppIdSet,oppIdMap);
                List<Opportunity> oppList=new List<Opportunity>();
                oppList.add(opp);
                 
              
                OpportunityUtilities.findApprovers(oppList);
               
                OpportunityUtilities.cancelTDWorkItems(oppIdSet); 
    
                          
    }
}    
  
    
    static testMethod void testOpportunityUtilitiesPublic()
  {
        
        TestDataFactory.createBaseTestDataPublic();
        User testUser=[select id from user where Alias='testus1'];
        Sales_Segments__c ss=[select id from Sales_Segments__c];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Technology_Domain__c td=[select id from Technology_Domain__c ];
        Opportunity opp=[SELECT AccountId,AL_For_Account__c,AL_For_Finance__c,
                         AL_For_Solution__c,AL_For_Supplier__c,Amount,Amount_USD__c,
                         Approval_Comment__c,Approval_Level_B__c,Approval_Level__c,
                         Approval_Status__c,Approved_Amount__c,Approved_Margin__c,
                         Approvers_For_Account__c,Approvers_for_BU_General_Manager__c,
                         Approvers_For_CEO__c,Approvers_for_CFO__c,Approvers_For_Finance__c,
                         Approvers_For_Operational__c,Approvers_For_R_D__c,Approvers_For_Solutions__c,
                         Approvers_For_Supplier__c,Approvers_For_Technology__c,Approvers_For_Treasuary__c,
                         Approver_AL_B__c,Approver_AL_PickList__c,Approver_AL__c,Approver_Opportunity_Manager__c,
                         Approver_Opportunity_Upper_Manager_c__c,Approver_TDWI_Owner_Manager_1__c,
                         Approver_TDWI_Owner_Manager_2__c,Approver_TDWI_Owner_Manager_3__c,Approver_TDWI_Owner_Upper_Manager_1__c,
                         Approver_TDWI_Owner_Upper_Manager_2__c,Approver_TDWI_Owner_Upper_Manager_3__c,Business_Unit_A__c,Business_Unit_Detail__c,
                         Business_Unit__c,CloseDate,Company__c,Count_Of_Completed_TDWI__c,
                         Count_Of_Customer_Billings__c,Count_Of_Payments__c,
                         Count_Of_TDWI__c,Count_Of_Vendor_Billings__c,CreatedById,CreatedDate,CurrencyIsoCode,
                         Customer_Order_Date__c,DCA_Approval_Status__c,DCA_Status__c,Decision_Date__c,
                         Estimated_Amount_Currency__c,Estimated_Amount_Dollar__c,Estimated_Amount_USD__c,
                         Estimated_Amount__c,Estimated_Installments__c,Estimated_Invoice_Date__c,Estimated_Invoice_Monthly_Term__c,
                         Estimated_Margin_Amount__c,Estimated_Margin_Perc__c,Estimated_Solution_Segment__c,
                         Estimated_Sum_Of_Customer_Billing__c,ExpectedRevenue,Finance_Cost__c,
                         F_Business_Unit__c,General_Amount_USD__c,General_Margin_Ratio__c,
                         Guarantee_Letter_Commission_Ratio__c,HasAttachments__c,
                         HasOverdueTask,Has_BDHSolution__c,Id,Invoicing__c,IsClosed,IsDeleted,IsTransferred__c,
                         LastModifiedById,LastModifiedDate,Loss_Description__c,
                         Loss_Reason__c,Name,Name__c,Need_AL1_Approval__c,
                         Need_Approval__c,NextStep,Opportunity_Description__c,
                         Opportunity_ID__c,Opportunity_Probability__c,Opportunity_Type__c,
                         OwnerId,PAF_Approval_Status__c,
                         Payment_Terms__c,Payment_Term__c,
                         Pricebook2Id,PriceBookChanged__c,Probability,
                         Proposal_Date__c,Rebate__c,RecordTypeId,
                         Sales_Segment__c,Solution_Segment__c,Source_Lead__c,StageName,
                         Stage_Probability__c,
                         Status__c,Sum_Of_Collections_USD__c,
                         Sum_Of_Customer_Billings_USD__c,
                         Sum_Of_Payments_USD__c,Sum_Of_Vendor_Billings_USD__c,Tender_Type__c,
                         Total_Customer_Billings__c,Total_Margin__c,Total_Product_Cost_USD__c,
                         Total_Product_Cost__c,Total_Product_Margin__c,Total_Sales_Price_Currency__c,
                         Total_Sales_Price__c,Total_Vendor_Billings__c,Type FROM Opportunity WHERE Name = 'TestDataFactory1'];
        
        Pricebook2 salPb=[select id,name from Pricebook2 where Name='Public Sales Price Book'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Public Solution Price Book'];
        Product2 salProd=[select id from Product2 where ProductCode='SALES'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Public Sales Price Book'];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Public Solution Price Book'];
        CheckExecuteAnonymous.changeRun(false);
        
        System.RunAs(testUser)
             {
                 
                Set<Id> oppIdSet=new Set<Id>();
                oppIdSet.add(opp.Id);
                //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
                OpportunityLineItem oliPC=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Product consultancy');
                OpportunityLineItem oliSC=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Service consultancy');
                OpportunityLineItem oliRND=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='R&D consultancy');
                List<OpportunityLineItem> oliList=new List<OpportunityLineItem>();
                 oliList.add(oliPC);
                 oliList.add(oliSC);
                 oliList.add(oliRND);
                 insert oliList;
                 
                 
                
                Map<Id,Opportunity> oppIdMap=new Map<Id,Opportunity>();
                oppIdMap.put(opp.Id,opp);
     
                TD_BU_QUEUE__c subQueuePC = new TD_BU_QUEUE__c(
                 Business_Unit__c = opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'Product consultancy'
                );
                 TD_BU_QUEUE__c subQueueSC = new TD_BU_QUEUE__c(
                 Business_Unit__c =  opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'Service consultancy'
                );
                 TD_BU_QUEUE__c subQueueRND = new TD_BU_QUEUE__c(
                 Business_Unit__c = opp.Business_Unit_A__c,
                 Technology_Domain__c = td.Id,
                 Type__c = 'R&D consultancy'
                );
                 List<TD_BU_QUEUE__c> tdbql=new List<TD_BU_QUEUE__c>();
                 tdbql.add(subQueuePC);
                 tdbql.add(subQueueSC);
                 tdbql.add(subQueueRND);
                 insert tdbql;

                opp.StageName='Value Proposition';
                update opp;
                opp.StageName='Solution & Proposal Development';
                update opp;
                 
                TD_Work_Item__c tdc =new TD_Work_Item__c();
                tdc.Related_Opportunity__c=opp.Id;
                tdc.Status__c='Waiting Sale Actions';
                tdc.Work_Item_Closed_Date__c=system.today();
                tdc.ChildCount__c=0;
                tdc.Suggested_Cost__c = 1000; 
                tdc.ClosedChildCount__c=0;
                tdc.Custom_Duration__c=10;
                tdc.Technology_Domain__c=td.Id;
                tdc.SuggestedSolutionProduct__c=solProd.Id;
                tdc.Price_Book__c = solPb.Id;
                tdc.Sales_Price__c = null;
                tdc.Custom_Duration__c=123;
                insert tdc;       
                 
                 
                TD_Work_Item__c tdcCompleted =new TD_Work_Item__c();
                tdcCompleted.Related_Opportunity__c=opp.Id;
                tdcCompleted.Status__c='Completed';
                tdcCompleted.Work_Item_Closed_Date__c=system.today();
                tdcCompleted.ChildCount__c=0;
                tdcCompleted.Suggested_Cost__c = 1000; 
                tdcCompleted.ClosedChildCount__c=0;
                tdcCompleted.Custom_Duration__c=10;
                tdcCompleted.Technology_Domain__c=td.Id;
                tdcCompleted.SuggestedSolutionProduct__c=solProd.Id;
                tdcCompleted.Price_Book__c = solPb.Id;
                tdcCompleted.Sales_Price__c = 1200;
                tdcCompleted.Suggested_Manufacturer__c =ven.Id;
                tdcCompleted.Suggested_Vendor__c =ven.Id;
                tdcCompleted.Insert_Product__c='Approve product insert';
                tdcCompleted.Custom_Duration__c=123;
                tdcCompleted.Completion_Description__c ='test desc';
                tdcCompleted.Solution_Request_Type__c='Product consultancy';
                insert tdcCompleted; 
                 
                OpportunityUtilities.createTDWorkItems(oppIdSet);
                OpportunityUtilities.assignTDWorkItems(oppIdSet,oppIdMap);
                List<Opportunity> oppList=new List<Opportunity>();
                oppList.add(opp);
                 
                 
                 
                OpportunityUtilities.findApprovers(oppList);
                
                opp.StageName='Closed Cancelled';
                update opp;
                TD_Work_Item__c tdcCancel =new TD_Work_Item__c();
                tdcCancel.Related_Opportunity__c=opp.Id;
                tdcCancel.Status__c='Open';
                tdcCancel.Work_Item_Closed_Date__c=system.today();
                tdcCancel.ChildCount__c=0;
                tdcCancel.Suggested_Cost__c = 1000; 
                tdcCancel.ClosedChildCount__c=0;
                tdcCancel.Custom_Duration__c=10;
                tdcCancel.Technology_Domain__c=td.Id;
                tdcCancel.SuggestedSolutionProduct__c=solProd.Id;
                tdcCancel.Price_Book__c = solPb.Id;
                tdcCancel.Sales_Price__c = null;
                tdcCancel.Custom_Duration__c=123;
                insert tdcCancel;
                OpportunityUtilities.cancelTDWorkItems(oppIdSet);
                 
                 
        opp.StageName = 'Closed Won';
                update opp;
                 
                Set<Id> oppWonSetId=new Set<Id>();
                oppWonSetId.add(opp.Id); 
                 
                 
                ScheduledSalesforceToSAPUtilities SSTSU = new ScheduledSalesforceToSAPUtilities();
                SSTSU.execute(NULL);
        //BatchSalesforceToSAPUtilities BSTSAPU = new BatchSalesforceToSAPUtilities();       
              //Database.executeBatch(BSTSAPU,10); 
                 
             }
    } 
    
}