@isTest

public class OpportunityTeamMemberTest {
    
    
    public String operationType{get;set;}
    
    public OpportunityTeamMember tempOpportunityTeamMember{get;set;}
    public Id OpportunityTeamMemberId{get;set;}
    public String OpportunityTeammemberRoleType{get;set;}
    public String OpportunityTeamMemberRole{get;set;}
    public String OpportunityTeamMemberAccessLevel {get;set;}
    

    static testMethod void testOppTeamMemberMethod()
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
        

        CheckExecuteAnonymous.changeRun(true);
        

        
        PageReference pageRef = Page.OpportunityTeamMemberPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
       
        PageReference pageRef2 = Page.OpportunityTeamMemberPage;
        Test.setCurrentPage(pageRef2);
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc2 = new ApexPages.StandardController(opp);
       
        
        System.RunAs(testUser)
        {
            OpportunityTeamMember otm =new OpportunityTeamMember(OpportunityId = opp.Id, 
                                                                 UserId = testUser.Id,
                                                                 TeamMemberRole= 'Solution', 
                                                                 Role_Type__c = 'Solution Expert',
                                                                 OpportunityAccessLevel = '');
            insert otm;
            
            
            OpportunityTeamMember otm2 =new OpportunityTeamMember(OpportunityId = opp.Id, 
                                                                 UserId = testUser.Id,
                                                                 TeamMemberRole= 'Solution', 
                                                                 Role_Type__c = 'Solution Expert');
            insert otm2;

         
      
            OpportunityTeamMemberPageController oppTeamMemberPageController = new OpportunityTeamMemberPageController(sc);

            OpportunityTeamMemberPageController oppTeamMemberPageController2 = new OpportunityTeamMemberPageController(sc2);

            OpportunityTeamMemberPageController tmpOppTeamMemberPageController = new OpportunityTeamMemberPageController();
            
            
            oppTeamMemberPageController.objectType ='OpportunityTeamMember';
            oppTeamMemberPageController.operationType ='';
            oppTeamMemberPageController.tempOpportunityTeamMember = otm;
            oppTeamMemberPageController.OpportunityTeamMemberId = otm.Id;
            oppTeamMemberPageController.OpportunityTeamMemberAccessLevel = otm.OpportunityAccessLevel;
            oppTeamMemberPageController.OpportunityTeamMemberRole = otm.TeamMemberRole;
            oppTeamMemberPageController.OpportunityTeammemberRoleType = otm.Role_Type__c;
            oppTeamMemberPageController.addRow();
            
            oppTeamMemberPageController2.objectType ='OpportunityTeamMember';
            oppTeamMemberPageController2.operationType ='';
            oppTeamMemberPageController2.tempOpportunityTeamMember = otm2;
            oppTeamMemberPageController2.OpportunityTeamMemberId = otm2.Id;
            oppTeamMemberPageController2.OpportunityTeamMemberAccessLevel = otm2.OpportunityAccessLevel;
            oppTeamMemberPageController2.OpportunityTeamMemberRole = otm2.TeamMemberRole;
            oppTeamMemberPageController2.OpportunityTeammemberRoleType = otm2.Role_Type__c;
            oppTeamMemberPageController2.addRow();

        }
    }
}