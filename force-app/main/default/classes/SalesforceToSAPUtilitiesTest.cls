@isTest
public class SalesforceToSAPUtilitiesTest {
    
    static testMethod void testSFToSAP()
    {
        TestDataFactory.createBaseTestData();        
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
                         Business_Unit__c,CD_USD__c, CloseDate,Company__c,Contract_Date__c,Contract_Risk_USD__c,
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
        CheckExecuteAnonymous.changeRun(true);
        
        List<Id> oppIds = new List<Id>();

        /*List<Opportunity> opps = [SELECT Id, Opportunity_ID__c,CurrencyIsoCode,
                           AccountId, Account_Sap_Id__c, Account_Record_Type__c,
                           Companyy__c,Opportunity_Type__c,Amount,Amount_USD__c,
                           F_Business_Unit__c,F_Sales_Segment__c,Description,
                           StageName FROM Opportunity WHERE StageName= 'Closed Won' AND Sent_To_SAP__c = false LIMIT 1];*/ 

        System.RunAs(testUser){

            opp.StageName = 'Qualification';
            update opp;                       
                 
            opp.StageName='Value Proposition';
            update opp; 
            
            opp.StageName='Solution & Proposal Development';
            update opp;
            
            opp.StageName = 'Negotiation & Review';
            update opp; 
            
            opp.StageName = 'Closed Won';
            update opp;
            SalesforceToSAPUtilities.ResultVM result = new SalesforceToSAPUtilities.ResultVM();  
            result.OpportunityId = '1111';
            result.ResultCode = 'TEST'; 
            result.ResultDescription='Test';    
        }

        oppIds.add(opp.Id);
        

        //SalesforceToSAPUtilities.SendOpportunityToSAP(oppIds);
         
        BatchSalesforceToSAPUtilities bc = new BatchSalesforceToSAPUtilities();
        Database.executeBatch(bc);
        
        BatchOpportunityToSAP bc2 = new BatchOpportunityToSAP(opp.Opportunity_ID__c);
        Database.executeBatch(bc2);
		
        ScheduledSalesforceToSAPUtilities SSTSAPU = new ScheduledSalesforceToSAPUtilities();
        SSTSAPU.execute(NULL);
      
    }
}