global class ReportUtilities {
    
    //********************************************
    //********************************************
    //Solution Visible Report
    //********************************************
    //********************************************
    public static void SolutionVisibleReportInit(){
        
        ///***** find report type  *****///
        Report_Setting__c solutionReport = [SELECT Id, Start_Date__c, End_Date__c, StageList__c FROM Report_Setting__c Where Name = 'SolutionVisibleReport' LIMIT 1];
        String[] stageList = solutionReport.StageList__c.split(';');
        
        ///***** delete all report *****///
        List<SolutionVisibleReport__c> reportItemList = [SELECT Id FROM SolutionVisibleReport__c];
        if(reportItemList.size() > 0)
        {
            delete reportItemList;
        }
         
        ///***** insert all report *****///
        List<SolutionVisibleReport__c> insertReportItemList = new List<SolutionVisibleReport__c>();
        Map<Id, SolutionVisibleReport__c> oppReportItemMap = new Map<Id, SolutionVisibleReport__c>();
        Set<Id> oppIdList = new Set<Id>();
        
        //1. orderları oluştur
        List<Opportunity> opportunityList = [SELECT Id, Name, 
                                                    StageName,
                                                    Total_Margin__c,
                                                    Total_Product_Margin__c,  
                                                    Opportunity_ID__c, 
                                                    Amount, 
                                                    CurrencyIsoCode, 
                                                    Amount_USD__c, 
                                                    Account.Name, 
                                                    Account.SAP_Account_No__c, 
                                                    F_Business_Unit__c, 
                                                    Owner.Name, 
                                                    Owner.Manager.Name, 
                                                    Sales_Segment__r.Name, 
                                                    CloseDate  
                                             FROM Opportunity 
                                             WHERE CloseDate >=: solutionReport.Start_Date__c AND 
                                                   CloseDate <=: solutionReport.End_Date__c AND 
                                                   StageName in:stageList];
        for(Opportunity opp : opportunityList)
        {
            oppIdList.add(opp.Id);
            
            SolutionVisibleReport__c reportItem = new SolutionVisibleReport__c(
                Account_Name__c = opp.Account.Name,
                Account_Sap_Id__c = opp.Account.SAP_Account_No__c,
                Business_Unit__c = opp.F_Business_Unit__c,
                Opportunity_Amount__c = opp.Amount_USD__c,
                Opportunity_Id__c = opp.Opportunity_ID__c,
                Opportunity_Name__c = opp.Name,
                Opportunity_Owner__c = opp.Owner.Name,
                Opportunity_Owner_Manager__c = opp.Owner.Manager.Name,
                Sales_Segment__c = opp.Sales_Segment__r.Name,
                Opportunity_Stage__c = opp.StageName,
                Opportunity__c = opp.Id,
                Opportunity_Margin__c = opp.Total_Product_Margin__c == null ? 0 : opp.Total_Product_Margin__c 
            );
            reportItem.Opportunity_Quarter__c = FindQuarter(opp.CloseDate);
            oppReportItemMap.put(opp.Id, reportItem);
        }
        
        //2. Revenue ve Margin e geldik.
        Map<Id, OppRelatedListModel> oppRelatedListMap = new Map<Id, OppRelatedListModel>();
        
        //2.1. CustomerBilling leri Maple
        List<Customer_Billing__c> customerBillingList = [SELECT Id, N_Billing_Amount_USD__c, Billing_Date__c, Opportunity__c FROM Customer_Billing__c Where Opportunity__c in: oppIdList];
        for(Customer_Billing__c cb : customerBillingList)
        {
            OppRelatedListModel oppRelatedList = new OppRelatedListModel();
            if(oppRelatedListMap.get(cb.Opportunity__c) != null)
            {
                oppRelatedList = oppRelatedListMap.get(cb.Opportunity__c);   
            }
            oppRelatedList.opportunityId = cb.Opportunity__c;
            oppRelatedList.customerBillingList.add(cb);
            oppRelatedListMap.put(cb.Opportunity__c, oppRelatedList);
        }
        
        //2.2. OpportunityLineItem ları Maple
        AggregateResult[] groupedResults = [SELECT OpportunityId, SUM(Sales_Price_USD__c) TotalUnitPrice, MAX(Product2.Name) ProductName, MAX(Vendor__r.Name) VendorName, Solution_Type__c, 
                                            MAX(Technology_Domain__r.Name) TdName, MAX(Originated_TD__r.Completed_by_User__r.Name) CompletedUserName FROM OpportunityLineItem 
                                            WHERE Opportunity.IsDeleted = False AND OpportunityId in:oppIdList Group By OpportunityId, Technology_Domain__c, Solution_Type__c, Vendor__c];
		
        for(AggregateResult ar : groupedResults)
        {
            OpportunityProductModel oPM = new OpportunityProductModel();
            oPM.OpportunityId  = (Id)ar.get('OpportunityId');
            oPM.TotalUnitPrice = (Decimal)ar.get('TotalUnitPrice');
            oPM.ProductName = (String)ar.get('ProductName');
            oPM.VendorName = (String)ar.get('VendorName');
            oPM.SolutionType = (String)ar.get('Solution_Type__c');
            oPM.TdName = (String)ar.get('TdName');
            oPM.CompletedUserName = (String)ar.get('CompletedUserName');
                
            OppRelatedListModel oppRelatedList = new OppRelatedListModel();
            if(oppRelatedListMap.get(oPM.OpportunityId) != null)
            {
                oppRelatedList = oppRelatedListMap.get(oPM.OpportunityId);   
            }            
            oppRelatedList.opportunityId = oPM.OpportunityId;
            oppRelatedList.oppLineItemList.add(oPM);
            oppRelatedListMap.put(oPM.OpportunityId, oppRelatedList);
        }
        
        //2.3 Listeler içerisinde dönelim ve eklemeye başlayalım...
        insertReportItemList.clear();
        for(OppRelatedListModel orl : oppRelatedListMap.values())
        {
            SolutionVisibleReport__c tempReportItem = oppReportItemMap.get(orl.opportunityId);
            
            for(OpportunityProductModel oli : orl.oppLineItemList)
            {
                String tdGroup = '';
                String solutionManager = '';
                if(oli.TdName == 'Business Applications - Other' || oli.TdName == 'Business Applications - Microsoft Solutions' ||
                  	oli.TdName == 'Business Applications - Microsoft Licensing' || oli.TdName == 'Business Intelligence')
                {
                    tdGroup = 'MICROSOFT SOLUTIONS';
                    solutionManager = 'Selda Parın';
                }
                else if(oli.TdName == 'Mobility & Multimedia Solutions' || oli.TdName == 'BSS')
                {
                    tdGroup = 'ENTERPRISE MOBILITY & MULTIMEDIA SOLUTIONS';
                    solutionManager = 'Atınç Baytan';
                }
                else if(oli.TdName == 'Datacenter & Cloud' || oli.TdName == 'OSS' ||
                       	 oli.TdName == 'IoT' || oli.TdName == 'Broadband Networking')
                {
                    tdGroup = 'DATACENTER & INFRAST. NETWORK SOLUTIONS';
                    solutionManager = 'Cevdet Üresin';
                }
                else if(oli.TdName == 'CyberSecurity')
                {
                    tdGroup = 'SECURITY SOLUTIONS';
                    solutionManager = 'Cevdet Üresin';
                }
                else if(oli.TdName == 'System')
                {
                    tdGroup = 'DATACENTER SYSTEM SOLUTIONS';
                    solutionManager = 'Cevdet Üresin';
                }
                else if(oli.TdName == 'Business Applications - Salesforce')
                {
                    tdGroup = 'SALESFORCE';
                    solutionManager = 'Selda Parın';
                }
                else if(oli.TdName == 'Multi Technology')
                {
                    tdGroup = 'Multi Technology';
                    solutionManager = 'ALL SOLUTION';
                }
                else if(oli.TdName == 'SI')
                {
                    tdGroup = 'SI';
                    solutionManager = 'ALL SOLUTION';
                }
                
                SolutionVisibleReport__c  reportItem = new SolutionVisibleReport__c(
                    Account_Name__c = tempReportItem.Account_Name__c,
                    Account_Sap_Id__c = tempReportItem.Account_Sap_Id__c,
                    Business_Unit__c = tempReportItem.Business_Unit__c,
                    Opportunity_Amount__c = tempReportItem.Opportunity_Amount__c,
                    Opportunity_Id__c = tempReportItem.Opportunity_Id__c,
                    Opportunity_Name__c = tempReportItem.Opportunity_Name__c,
                    Opportunity_Owner__c = tempReportItem.Opportunity_Owner__c,
                    Opportunity_Owner_Manager__c = tempReportItem.Opportunity_Owner_Manager__c,
                    Sales_Segment__c = tempReportItem.Sales_Segment__c,
                    Opportunity_Stage__c = tempReportItem.Opportunity_Stage__c,
                    Opportunity__c = tempReportItem.Opportunity__c,
                    Opportunity_Margin__c = tempReportItem.Opportunity_Margin__c,
                    Opportunity_Quarter__c = tempReportItem.Opportunity_Quarter__c,
                    Solution_Type__c = oli.SolutionType,
                    Technology_Domain__c = oli.TdName,
                	Vendor__c = oli.VendorName,
                    Technology_Domain_Group__c = tdGroup,
                    Solution_Responsible_Manager__c = solutionManager
                );
                
                for(Customer_Billing__c cb : orl.customerBillingList)
                {
                    Decimal orderAmount = tempReportItem.Opportunity_Amount__c == 0 ? 0 : ((oli.TotalUnitPrice / tempReportItem.Opportunity_Amount__c) * cb.N_Billing_Amount_USD__c);
                    Decimal revenue = tempReportItem.Opportunity_Amount__c == 0 ? 0 : ((oli.TotalUnitPrice / tempReportItem.Opportunity_Amount__c) * cb.N_Billing_Amount_USD__c);
                    Decimal margin = revenue * (tempReportItem.Opportunity_Margin__c / 100);
                    
                    //quarter bazlı order ekleme
                    if(reportItem.Opportunity_Quarter__c == 'Q1')
                    {
                        reportItem.Order_Q1__c = reportItem.Order_Q1__c == null ? orderAmount : (reportItem.Order_Q1__c + orderAmount);
                    }
                    else if(reportItem.Opportunity_Quarter__c == 'Q2')
                    {
                        reportItem.Order_Q2__c = reportItem.Order_Q2__c == null ? orderAmount : (reportItem.Order_Q2__c + orderAmount);
                    }
                    else if(reportItem.Opportunity_Quarter__c == 'Q3')
                    {
                        reportItem.Order_Q3__c = reportItem.Order_Q3__c == null ? orderAmount : (reportItem.Order_Q3__c + orderAmount);
                    }
                    else if(reportItem.Opportunity_Quarter__c == 'Q4')
                    {
                        reportItem.Order_Q4__c = reportItem.Order_Q4__c == null ? orderAmount : (reportItem.Order_Q4__c + orderAmount);
                    } 
                    
                    //quarter bazlı revenue-margin ekleme
                    if(cb.Billing_Date__c >= solutionReport.Start_Date__c && cb.Billing_Date__c <= solutionReport.End_Date__c)
                    {
                        String billingQueue = FindQuarter(cb.Billing_Date__c);
                        if(billingQueue == 'Q1')
                        {
                            reportItem.Revenue_Q1__c = reportItem.Revenue_Q1__c == null ? revenue : (reportItem.Revenue_Q1__c + revenue);
                            reportItem.Margin_Q1__c = reportItem.Margin_Q1__c == null ? margin : (reportItem.Margin_Q1__c + margin);
                        }
                        else if(billingQueue == 'Q2')
                        {
                            reportItem.Revenue_Q2__c = reportItem.Revenue_Q2__c == null ? revenue : (reportItem.Revenue_Q2__c + revenue);
                            reportItem.Margin_Q2__c = reportItem.Margin_Q2__c == null ? margin : (reportItem.Margin_Q2__c + margin);
                        }
                        else if(billingQueue == 'Q3')
                        {
                            reportItem.Revenue_Q3__c = reportItem.Revenue_Q3__c == null ? revenue : (reportItem.Revenue_Q3__c + revenue);
                            reportItem.Margin_Q3__c = reportItem.Margin_Q3__c == null ? margin : (reportItem.Margin_Q3__c + margin);
                        }
                        else if(billingQueue == 'Q4')
                        {
                            reportItem.Revenue_Q4__c = reportItem.Revenue_Q4__c == null ? revenue : (reportItem.Revenue_Q4__c + revenue);
                            reportItem.Margin_Q4__c = reportItem.Margin_Q4__c == null ? margin : (reportItem.Margin_Q4__c + margin);
                        }     
                    }                  
                }
                
                insertReportItemList.add(reportItem);  
            }
        }
        
        ///***** DB INSERT *****//
        if(insertReportItemList.size() > 0)
        {
            insert insertReportItemList;
        }
    }
    
    //********************************************
    //********************************************
    //Sales Visible Report
    //********************************************
    //********************************************
    public static void SalesVisibleReportInit(){
        
        ///***** find report type  *****///
        Report_Setting__c salesReport = [SELECT Id, Start_Date__c, End_Date__c, StageList__c FROM Report_Setting__c Where Name = 'SalesVisibleReport' LIMIT 1];
        String[] stageList = salesReport.StageList__c.split(';');
        
        ///***** delete all report *****///
        List<SalesVisibleReport__c> reportItemList = [SELECT Id FROM SalesVisibleReport__c];
        if(reportItemList.size() > 0)
        {
            delete reportItemList;
        }
         
        ///***** insert all report *****///
        List<SalesVisibleReport__c> insertReportItemList = new List<SalesVisibleReport__c>();
        Map<Id, SalesVisibleReport__c> oppReportItemMap = new Map<Id, SalesVisibleReport__c>();
        Set<Id> oppIdList = new Set<Id>();
        
        //1. orderları oluştur
        List<Opportunity> opportunityList = [SELECT Id, Name, 
                                                    StageName,
                                                    Opportunity_Probability__c,
                                                    Sales_Visible_LKP__c,
                                                    Estimated_Solution_Segment__c,
                                                    Total_Margin__c, 
                                                    Total_Product_Margin__c, 
                                                    Opportunity_ID__c, 
                                                    Amount, 
                                                    CurrencyIsoCode, 
                                                    Amount_USD__c, 
                                                    Account.Name, 
                                                    Account.SAP_Account_No__c, 
                                                    F_Business_Unit__c, 
                                                    Owner.Name, 
                                                    Owner.Manager.Name, 
                                                    Sales_Segment__r.Name, 
                                                    CloseDate  
                                             FROM Opportunity 
                                             WHERE CloseDate >=: salesReport.Start_Date__c AND 
                                                   CloseDate <=: salesReport.End_Date__c AND 
                                                   StageName in:stageList];
        for(Opportunity opp : opportunityList)
        {
            oppIdList.add(opp.Id);
            
            SalesVisibleReport__c reportItem = new SalesVisibleReport__c(
                Account_Name__c = opp.Account.Name,
                Account_Sap_Id__c = opp.Account.SAP_Account_No__c,
                Business_Unit__c = opp.F_Business_Unit__c,
                Opportunity_Amount__c = opp.Amount_USD__c,
                Opportunity_Id__c = opp.Opportunity_ID__c,
                Opportunity_Name__c = opp.Name,
                Opportunity_Owner__c = opp.Owner.Name,
                Opportunity_Owner_Manager__c = opp.Owner.Manager.Name,
                Sales_Segment__c = opp.Sales_Segment__r.Name,
                Opportunity_Stage__c = opp.StageName,
                Opportunity__c = opp.Id,    
                Opportunity_Probability__c = opp.Opportunity_Probability__c,
                Estimated_Solution_Segment__c = opp.Estimated_Solution_Segment__c,
                Opportunity_Margin__c = opp.Total_Product_Margin__c == null ? 0 : opp.Total_Product_Margin__c 
            );
            
            reportItem.Opportunity_Quarter__c = FindQuarter(opp.CloseDate);
            oppReportItemMap.put(opp.Id, reportItem);
            opp.Sales_Visible_LKP__c = salesReport.Id;
        }
        //2. Revenue ve Margin e geldik.
        Map<Id, OppRelatedListModel> oppRelatedListMap = new Map<Id, OppRelatedListModel>();
        
        //2.1. CustomerBilling leri Maple
        List<Customer_Billing__c> customerBillingList = [SELECT Id, N_Billing_Amount_USD__c, Billing_Date__c, Opportunity__c FROM Customer_Billing__c Where Opportunity__c in: oppIdList];
        for(Customer_Billing__c cb : customerBillingList)
        {
            OppRelatedListModel oppRelatedList = new OppRelatedListModel();
            if(oppRelatedListMap.get(cb.Opportunity__c) != null)
            {
                oppRelatedList = oppRelatedListMap.get(cb.Opportunity__c);   
            }
            oppRelatedList.opportunityId = cb.Opportunity__c;
            oppRelatedList.customerBillingList.add(cb);
            oppRelatedListMap.put(cb.Opportunity__c, oppRelatedList);
        }
        
        //2.3 Listeler içerisinde dönelim ve eklemeye başlayalım...
        insertReportItemList.clear();
        for(OppRelatedListModel orl : oppRelatedListMap.values())
        {
            SalesVisibleReport__c reportItem = oppReportItemMap.get(orl.opportunityId);
            for(Customer_Billing__c cb : orl.customerBillingList)
            {
                Decimal revenue = cb.N_Billing_Amount_USD__c == null ? 0 : cb.N_Billing_Amount_USD__c;
                Decimal margin = revenue * (reportItem.Opportunity_Margin__c/100);

                //order toplamları
                if(reportItem.Opportunity_Quarter__c == 'Q1')
                {
                    reportItem.Order_Q1__c = reportItem.Order_Q1__c == null ? revenue : (reportItem.Order_Q1__c+revenue);
                }
                else if(reportItem.Opportunity_Quarter__c == 'Q2')
                {
                    reportItem.Order_Q2__c = reportItem.Order_Q2__c == null ? revenue : (reportItem.Order_Q2__c+revenue);
                }
                else if(reportItem.Opportunity_Quarter__c == 'Q3')
                {
                    reportItem.Order_Q3__c = reportItem.Order_Q3__c == null ? revenue : (reportItem.Order_Q3__c+revenue);
                }
                else if(reportItem.Opportunity_Quarter__c == 'Q4')
                {
                    reportItem.Order_Q4__c = reportItem.Order_Q4__c == null ? revenue : (reportItem.Order_Q4__c+revenue);
                }
                
                //revenues
                if(cb.Billing_Date__c >= salesReport.Start_Date__c && cb.Billing_Date__c <= salesReport.End_Date__c)
                {
                    String billingQueue = FindQuarter(cb.Billing_Date__c);                    
                    if(billingQueue == 'Q1')
                    {
                        reportItem.Revenue_Q1__c = reportItem.Revenue_Q1__c == null ? revenue : (reportItem.Revenue_Q1__c + revenue);
                        reportItem.Margin_Q1__c = reportItem.Margin_Q1__c == null ? margin : (reportItem.Margin_Q1__c + margin);
                    }
                    else if(billingQueue == 'Q2')
                    {
                        reportItem.Revenue_Q2__c = reportItem.Revenue_Q2__c == null ? revenue : (reportItem.Revenue_Q2__c + revenue);
                        reportItem.Margin_Q2__c = reportItem.Margin_Q2__c == null ? margin : (reportItem.Margin_Q2__c + margin);
                    }
                    else if(billingQueue == 'Q3')
                    {
                        reportItem.Revenue_Q3__c = reportItem.Revenue_Q3__c == null ? revenue : (reportItem.Revenue_Q3__c + revenue);
                        reportItem.Margin_Q3__c = reportItem.Margin_Q3__c == null ? margin : (reportItem.Margin_Q3__c + margin);
                    }
                    else if(billingQueue == 'Q4')
                    {
                        reportItem.Revenue_Q4__c = reportItem.Revenue_Q4__c == null ? revenue : (reportItem.Revenue_Q4__c + revenue);
                        reportItem.Margin_Q4__c = reportItem.Margin_Q4__c == null ? margin : (reportItem.Margin_Q4__c + margin);
                    }     
                }    
            }
            
            insertReportItemList.add(reportItem);
        }
        
        
        
		Map<Id,Opportunity> oppMap=new Map<Id,Opportunity>([select id ,Sales_Visible_LKP__c from Opportunity]);        
        ///***** DB INSERT *****//
        if(insertReportItemList.size() > 0)
        {
            insert insertReportItemList;
            for(SalesVisibleReport__c svr: insertReportItemList)
       		{
                CheckExecuteAnonymous.changeRun(false);
                oppMap.get(svr.Opportunity__c).Sales_Visible_LKP__c=svr.Id;
            }
        }
        
        update oppMap.values();
         
    }
    
    //Find Quarter
    public static String FindQuarter(Date itemDate){
        
        Integer month = itemDate.month();
        if(month == 1 || month == 2 || month == 3)
        {
            return 'Q1';
        }
        else if(month == 4 || month == 5 || month == 6)
        {
            return 'Q2';
        }
        else if(month == 7 || month == 8 || month == 9)
        {
            return 'Q3';
        }
        
        return 'Q4';
    }
    
  /*  webservice static String callReports(boolean solution){ 
        ReportUtilities.SalesVisibleReportInit();
        ReportUtilities.SolutionVisibleReportInit(); 
        return 'Success'; 
    }*/
  webservice static void callReports(){ 
      	CheckExecuteAnonymous.changeRun(false);
     	Report_Setting__c solutionReport = [SELECT Id, Start_Date__c, End_Date__c, StageList__c FROM Report_Setting__c Where Name = 'SolutionVisibleReport' LIMIT 1];
        Report_Setting__c salesReport = [SELECT Id, Start_Date__c, End_Date__c, StageList__c FROM Report_Setting__c Where Name = 'SalesVisibleReport' LIMIT 1];

        String[] stageList = solutionReport.StageList__c.split(';');
    	String[] stageListSales = salesReport.StageList__c.split(';');
        List<SolutionVisibleReport__c> reportItemList = [SELECT Id FROM SolutionVisibleReport__c];
        if(reportItemList.size() > 0)
        {
            delete reportItemList;
        }
              ///***** delete all report *****///
        List<SalesVisibleReport__c> reportItemListSales = [SELECT Id FROM SalesVisibleReport__c];
        if(reportItemListSales.size() > 0)
        {
            delete reportItemListSales;
        }
		Database.executeBatch(new BatchReportUtilities(stageList, 'Solution')); 
		Database.executeBatch(new BatchReportUtilities(stageListSales, 'Sales')); 
    }
 
        //********************************************
    public static void SolutionVisibleReportBatch(Set<Id> oppIds){
        CheckExecuteAnonymous.changeRun(false);
        ///***** find report type  *****///
        Report_Setting__c solutionReport = [SELECT Id, Start_Date__c, End_Date__c, StageList__c FROM Report_Setting__c Where Name = 'SolutionVisibleReport' LIMIT 1];
        String[] stageList = solutionReport.StageList__c.split(';');
        

        ///***** insert all report *****///
        List<SolutionVisibleReport__c> insertReportItemList = new List<SolutionVisibleReport__c>();
        Map<Id, SolutionVisibleReport__c> oppReportItemMap = new Map<Id, SolutionVisibleReport__c>();
        Set<Id> oppIdList = new Set<Id>();
        
        //1. orderları oluştur
        List<Opportunity> opportunityList = [SELECT Id, Name, 
                                                    StageName,
                                                    Total_Margin__c,
                                                    Total_Product_Margin__c,  
                                                    Opportunity_ID__c, 
                                                    Amount, 
                                                    CurrencyIsoCode, 
                                                    Amount_USD__c, 
                                                    Account.Name, 
                                                    Account.SAP_Account_No__c, 
                                                    F_Business_Unit__c, 
                                                    Owner.Name, 
                                                    Owner.Manager.Name, 
                                                    Sales_Segment__r.Name, 
                                                    CloseDate  
                                             FROM Opportunity 
                                             WHERE CloseDate >=: solutionReport.Start_Date__c AND 
                                                   CloseDate <=: solutionReport.End_Date__c AND 
                                                   StageName in:stageList AND Id in: oppIds];
        for(Opportunity opp : opportunityList)
        {
            oppIdList.add(opp.Id);
            
            SolutionVisibleReport__c reportItem = new SolutionVisibleReport__c(
                Account_Name__c = opp.Account.Name,
                Account_Sap_Id__c = opp.Account.SAP_Account_No__c,
                Business_Unit__c = opp.F_Business_Unit__c,
                Opportunity_Amount__c = opp.Amount_USD__c,
                Opportunity_Id__c = opp.Opportunity_ID__c,
                Opportunity_Name__c = opp.Name,
                Opportunity_Owner__c = opp.Owner.Name,
                Opportunity_Owner_Manager__c = opp.Owner.Manager.Name,
                Sales_Segment__c = opp.Sales_Segment__r.Name,
                Opportunity_Stage__c = opp.StageName,
                Opportunity__c = opp.Id,
                Opportunity_Margin__c = opp.Total_Product_Margin__c == null ? 0 : opp.Total_Product_Margin__c 
            );
            reportItem.Opportunity_Quarter__c = FindQuarter(opp.CloseDate);
            oppReportItemMap.put(opp.Id, reportItem);
        }
        
        //2. Revenue ve Margin e geldik.
        Map<Id, OppRelatedListModel> oppRelatedListMap = new Map<Id, OppRelatedListModel>();
        
        //2.1. CustomerBilling leri Maple
        List<Customer_Billing__c> customerBillingList = [SELECT Id, N_Billing_Amount_USD__c, Billing_Date__c, Opportunity__c FROM Customer_Billing__c Where Opportunity__c in: oppIdList];
        for(Customer_Billing__c cb : customerBillingList)
        {
            OppRelatedListModel oppRelatedList = new OppRelatedListModel();
            if(oppRelatedListMap.get(cb.Opportunity__c) != null)
            {
                oppRelatedList = oppRelatedListMap.get(cb.Opportunity__c);   
            }
            oppRelatedList.opportunityId = cb.Opportunity__c;
            oppRelatedList.customerBillingList.add(cb);
            oppRelatedListMap.put(cb.Opportunity__c, oppRelatedList);
        }
        
        //2.2. OpportunityLineItem ları Maple
        AggregateResult[] groupedResults = [SELECT OpportunityId, SUM(Sales_Price_USD__c) TotalUnitPrice, MAX(Product2.Name) ProductName, MAX(Vendor__r.Name) VendorName, Solution_Type__c, 
                                            MAX(Technology_Domain__r.Name) TdName, MAX(Originated_TD__r.Completed_by_User__r.Name) CompletedUserName FROM OpportunityLineItem 
                                            WHERE Opportunity.IsDeleted = False AND OpportunityId in:oppIdList Group By OpportunityId, Technology_Domain__c, Solution_Type__c, Vendor__c];
		
        for(AggregateResult ar : groupedResults)
        {
            OpportunityProductModel oPM = new OpportunityProductModel();
            oPM.OpportunityId  = (Id)ar.get('OpportunityId');
            oPM.TotalUnitPrice = (Decimal)ar.get('TotalUnitPrice');
            oPM.ProductName = (String)ar.get('ProductName');
            oPM.VendorName = (String)ar.get('VendorName');
            oPM.SolutionType = (String)ar.get('Solution_Type__c');
            oPM.TdName = (String)ar.get('TdName');
            oPM.CompletedUserName = (String)ar.get('CompletedUserName');
                
            OppRelatedListModel oppRelatedList = new OppRelatedListModel();
            if(oppRelatedListMap.get(oPM.OpportunityId) != null)
            {
                oppRelatedList = oppRelatedListMap.get(oPM.OpportunityId);   
            }            
            oppRelatedList.opportunityId = oPM.OpportunityId;
            oppRelatedList.oppLineItemList.add(oPM);
            oppRelatedListMap.put(oPM.OpportunityId, oppRelatedList);
        }
        
        //2.3 Listeler içerisinde dönelim ve eklemeye başlayalım...
        insertReportItemList.clear();
        for(OppRelatedListModel orl : oppRelatedListMap.values())
        {
            SolutionVisibleReport__c tempReportItem = oppReportItemMap.get(orl.opportunityId);
            
            for(OpportunityProductModel oli : orl.oppLineItemList)
            {
                String tdGroup = '';
                String solutionManager = '';
                if(oli.TdName == 'Business Applications - Other' || oli.TdName == 'Business Applications - Microsoft Solutions' ||
                  	oli.TdName == 'Business Applications - Microsoft Licensing' || oli.TdName == 'Business Intelligence')
                {
                    tdGroup = 'MICROSOFT SOLUTIONS';
                    solutionManager = 'Selda Parın';
                }
                else if(oli.TdName == 'Mobility & Multimedia Solutions' || oli.TdName == 'BSS')
                {
                    tdGroup = 'ENTERPRISE MOBILITY & MULTIMEDIA SOLUTIONS';
                    solutionManager = 'Atınç Baytan';
                }
                else if(oli.TdName == 'Datacenter & Cloud' || oli.TdName == 'OSS' ||
                       	 oli.TdName == 'IoT' || oli.TdName == 'Broadband Networking')
                {
                    tdGroup = 'DATACENTER & INFRAST. NETWORK SOLUTIONS';
                    solutionManager = 'Cevdet Üresin';
                }
                else if(oli.TdName == 'CyberSecurity')
                {
                    tdGroup = 'SECURITY SOLUTIONS';
                    solutionManager = 'Cevdet Üresin';
                }
                else if(oli.TdName == 'System')
                {
                    tdGroup = 'DATACENTER SYSTEM SOLUTIONS';
                    solutionManager = 'Cevdet Üresin';
                }
                else if(oli.TdName == 'Business Applications - Salesforce')
                {
                    tdGroup = 'SALESFORCE';
                    solutionManager = 'Selda Parın';
                }
                else if(oli.TdName == 'Multi Technology')
                {
                    tdGroup = 'Multi Technology';
                    solutionManager = 'ALL SOLUTION';
                }
                else if(oli.TdName == 'SI')
                {
                    tdGroup = 'SI';
                    solutionManager = 'ALL SOLUTION';
                }
                
                SolutionVisibleReport__c  reportItem = new SolutionVisibleReport__c(
                    Account_Name__c = tempReportItem.Account_Name__c,
                    Account_Sap_Id__c = tempReportItem.Account_Sap_Id__c,
                    Business_Unit__c = tempReportItem.Business_Unit__c,
                    Opportunity_Amount__c = tempReportItem.Opportunity_Amount__c,
                    Opportunity_Id__c = tempReportItem.Opportunity_Id__c,
                    Opportunity_Name__c = tempReportItem.Opportunity_Name__c,
                    Opportunity_Owner__c = tempReportItem.Opportunity_Owner__c,
                    Opportunity_Owner_Manager__c = tempReportItem.Opportunity_Owner_Manager__c,
                    Sales_Segment__c = tempReportItem.Sales_Segment__c,
                    Opportunity_Stage__c = tempReportItem.Opportunity_Stage__c,
                    Opportunity__c = tempReportItem.Opportunity__c,
                    Opportunity_Margin__c = tempReportItem.Opportunity_Margin__c,
                    Opportunity_Quarter__c = tempReportItem.Opportunity_Quarter__c,
                    Solution_Type__c = oli.SolutionType,
                    Technology_Domain__c = oli.TdName,
                	Vendor__c = oli.VendorName,
                    Technology_Domain_Group__c = tdGroup,
                    Solution_Responsible_Manager__c = solutionManager
                );
                
                for(Customer_Billing__c cb : orl.customerBillingList)
                {
                    Decimal orderAmount = tempReportItem.Opportunity_Amount__c == 0 ? 0 : ((oli.TotalUnitPrice / tempReportItem.Opportunity_Amount__c) * cb.N_Billing_Amount_USD__c);
                    Decimal revenue = tempReportItem.Opportunity_Amount__c == 0 ? 0 : ((oli.TotalUnitPrice / tempReportItem.Opportunity_Amount__c) * cb.N_Billing_Amount_USD__c);
                    Decimal margin = revenue * (tempReportItem.Opportunity_Margin__c / 100);
                    
                    //quarter bazlı order ekleme
                    if(reportItem.Opportunity_Quarter__c == 'Q1')
                    {
                        reportItem.Order_Q1__c = reportItem.Order_Q1__c == null ? orderAmount : (reportItem.Order_Q1__c + orderAmount);
                    }
                    else if(reportItem.Opportunity_Quarter__c == 'Q2')
                    {
                        reportItem.Order_Q2__c = reportItem.Order_Q2__c == null ? orderAmount : (reportItem.Order_Q2__c + orderAmount);
                    }
                    else if(reportItem.Opportunity_Quarter__c == 'Q3')
                    {
                        reportItem.Order_Q3__c = reportItem.Order_Q3__c == null ? orderAmount : (reportItem.Order_Q3__c + orderAmount);
                    }
                    else if(reportItem.Opportunity_Quarter__c == 'Q4')
                    {
                        reportItem.Order_Q4__c = reportItem.Order_Q4__c == null ? orderAmount : (reportItem.Order_Q4__c + orderAmount);
                    } 
                    
                    //quarter bazlı revenue-margin ekleme
                    if(cb.Billing_Date__c >= solutionReport.Start_Date__c && cb.Billing_Date__c <= solutionReport.End_Date__c)
                    {
                        String billingQueue = FindQuarter(cb.Billing_Date__c);
                        if(billingQueue == 'Q1')
                        {
                            reportItem.Revenue_Q1__c = reportItem.Revenue_Q1__c == null ? revenue : (reportItem.Revenue_Q1__c + revenue);
                            reportItem.Margin_Q1__c = reportItem.Margin_Q1__c == null ? margin : (reportItem.Margin_Q1__c + margin);
                        }
                        else if(billingQueue == 'Q2')
                        {
                            reportItem.Revenue_Q2__c = reportItem.Revenue_Q2__c == null ? revenue : (reportItem.Revenue_Q2__c + revenue);
                            reportItem.Margin_Q2__c = reportItem.Margin_Q2__c == null ? margin : (reportItem.Margin_Q2__c + margin);
                        }
                        else if(billingQueue == 'Q3')
                        {
                            reportItem.Revenue_Q3__c = reportItem.Revenue_Q3__c == null ? revenue : (reportItem.Revenue_Q3__c + revenue);
                            reportItem.Margin_Q3__c = reportItem.Margin_Q3__c == null ? margin : (reportItem.Margin_Q3__c + margin);
                        }
                        else if(billingQueue == 'Q4')
                        {
                            reportItem.Revenue_Q4__c = reportItem.Revenue_Q4__c == null ? revenue : (reportItem.Revenue_Q4__c + revenue);
                            reportItem.Margin_Q4__c = reportItem.Margin_Q4__c == null ? margin : (reportItem.Margin_Q4__c + margin);
                        }     
                    }                  
                }
                
                insertReportItemList.add(reportItem);  
            }
        }
        
        ///***** DB INSERT *****//
        if(insertReportItemList.size() > 0)
        {
            Database.SaveResult[] srList = Database.insert(insertReportItemList, false);
        }
    }
    
    //********************************************
    //********************************************
    //Sales Visible Report
    //********************************************
    //********************************************
    public static void SalesVisibleReportBatch(Set<Id> oppIds){
        CheckExecuteAnonymous.changeRun(false);
        ///***** find report type  *****///
        Report_Setting__c salesReport = [SELECT Id, Start_Date__c, End_Date__c, StageList__c FROM Report_Setting__c Where Name = 'SalesVisibleReport' LIMIT 1];
        String[] stageList = salesReport.StageList__c.split(';');
        

         
        ///***** insert all report *****///
        List<SalesVisibleReport__c> insertReportItemList = new List<SalesVisibleReport__c>();
        Map<Id, SalesVisibleReport__c> oppReportItemMap = new Map<Id, SalesVisibleReport__c>();
        Set<Id> oppIdList = new Set<Id>();
        
        //1. orderları oluştur
        List<Opportunity> opportunityList = [SELECT Id, Name, 
                                                    StageName,
                                                    Opportunity_Probability__c,
                                                    Sales_Visible_LKP__c,
                                                    Estimated_Solution_Segment__c,
                                                    Total_Margin__c, 
                                                    Total_Product_Margin__c, 
                                                    Opportunity_ID__c, 
                                                    Amount, 
                                                    CurrencyIsoCode, 
                                                    Amount_USD__c, 
                                                    Account.Name, 
                                                    Account.SAP_Account_No__c, 
                                                    F_Business_Unit__c, 
                                                    Owner.Name, 
                                                    Owner.Manager.Name, 
                                                    Sales_Segment__r.Name, 
                                                    CloseDate  
                                             FROM Opportunity 
                                             WHERE CloseDate >=: salesReport.Start_Date__c AND 
                                                   CloseDate <=: salesReport.End_Date__c AND 
                                                   StageName in:stageList AND Id in : oppIds];
        for(Opportunity opp : opportunityList)
        {
            oppIdList.add(opp.Id);
            
            SalesVisibleReport__c reportItem = new SalesVisibleReport__c(
                Account_Name__c = opp.Account.Name,
                Account_Sap_Id__c = opp.Account.SAP_Account_No__c,
                Business_Unit__c = opp.F_Business_Unit__c,
                Opportunity_Amount__c = opp.Amount_USD__c,
                Opportunity_Id__c = opp.Opportunity_ID__c,
                Opportunity_Name__c = opp.Name,
                Opportunity_Owner__c = opp.Owner.Name,
                Opportunity_Owner_Manager__c = opp.Owner.Manager.Name,
                Sales_Segment__c = opp.Sales_Segment__r.Name,
                Opportunity_Stage__c = opp.StageName,
                Opportunity__c = opp.Id,    
                Opportunity_Probability__c = opp.Opportunity_Probability__c,
                Estimated_Solution_Segment__c = opp.Estimated_Solution_Segment__c,
                Opportunity_Margin__c = opp.Total_Product_Margin__c == null ? 0 : opp.Total_Product_Margin__c 
            );
            
            reportItem.Opportunity_Quarter__c = FindQuarter(opp.CloseDate);
            oppReportItemMap.put(opp.Id, reportItem);
            opp.Sales_Visible_LKP__c = salesReport.Id;
        }
        //2. Revenue ve Margin e geldik.
        Map<Id, OppRelatedListModel> oppRelatedListMap = new Map<Id, OppRelatedListModel>();
        
        //2.1. CustomerBilling leri Maple
        List<Customer_Billing__c> customerBillingList = [SELECT Id, N_Billing_Amount_USD__c, Billing_Date__c, Opportunity__c FROM Customer_Billing__c Where Opportunity__c in: oppIdList];
        for(Customer_Billing__c cb : customerBillingList)
        {
            OppRelatedListModel oppRelatedList = new OppRelatedListModel();
            if(oppRelatedListMap.get(cb.Opportunity__c) != null)
            {
                oppRelatedList = oppRelatedListMap.get(cb.Opportunity__c);   
            }
            oppRelatedList.opportunityId = cb.Opportunity__c;
            oppRelatedList.customerBillingList.add(cb);
            oppRelatedListMap.put(cb.Opportunity__c, oppRelatedList);
        }
        
        //2.3 Listeler içerisinde dönelim ve eklemeye başlayalım...
        insertReportItemList.clear();
        for(OppRelatedListModel orl : oppRelatedListMap.values())
        {
            SalesVisibleReport__c reportItem = oppReportItemMap.get(orl.opportunityId);
            for(Customer_Billing__c cb : orl.customerBillingList)
            {
                Decimal revenue = cb.N_Billing_Amount_USD__c == null ? 0 : cb.N_Billing_Amount_USD__c;
                Decimal margin = revenue * (reportItem.Opportunity_Margin__c/100);

                //order toplamları
                if(reportItem.Opportunity_Quarter__c == 'Q1')
                {
                    reportItem.Order_Q1__c = reportItem.Order_Q1__c == null ? revenue : (reportItem.Order_Q1__c+revenue);
                }
                else if(reportItem.Opportunity_Quarter__c == 'Q2')
                {
                    reportItem.Order_Q2__c = reportItem.Order_Q2__c == null ? revenue : (reportItem.Order_Q2__c+revenue);
                }
                else if(reportItem.Opportunity_Quarter__c == 'Q3')
                {
                    reportItem.Order_Q3__c = reportItem.Order_Q3__c == null ? revenue : (reportItem.Order_Q3__c+revenue);
                }
                else if(reportItem.Opportunity_Quarter__c == 'Q4')
                {
                    reportItem.Order_Q4__c = reportItem.Order_Q4__c == null ? revenue : (reportItem.Order_Q4__c+revenue);
                }
                
                //revenues
                if(cb.Billing_Date__c >= salesReport.Start_Date__c && cb.Billing_Date__c <= salesReport.End_Date__c)
                {
                    String billingQueue = FindQuarter(cb.Billing_Date__c);                    
                    if(billingQueue == 'Q1')
                    {
                        reportItem.Revenue_Q1__c = reportItem.Revenue_Q1__c == null ? revenue : (reportItem.Revenue_Q1__c + revenue);
                        reportItem.Margin_Q1__c = reportItem.Margin_Q1__c == null ? margin : (reportItem.Margin_Q1__c + margin);
                    }
                    else if(billingQueue == 'Q2')
                    {
                        reportItem.Revenue_Q2__c = reportItem.Revenue_Q2__c == null ? revenue : (reportItem.Revenue_Q2__c + revenue);
                        reportItem.Margin_Q2__c = reportItem.Margin_Q2__c == null ? margin : (reportItem.Margin_Q2__c + margin);
                    }
                    else if(billingQueue == 'Q3')
                    {
                        reportItem.Revenue_Q3__c = reportItem.Revenue_Q3__c == null ? revenue : (reportItem.Revenue_Q3__c + revenue);
                        reportItem.Margin_Q3__c = reportItem.Margin_Q3__c == null ? margin : (reportItem.Margin_Q3__c + margin);
                    }
                    else if(billingQueue == 'Q4')
                    {
                        reportItem.Revenue_Q4__c = reportItem.Revenue_Q4__c == null ? revenue : (reportItem.Revenue_Q4__c + revenue);
                        reportItem.Margin_Q4__c = reportItem.Margin_Q4__c == null ? margin : (reportItem.Margin_Q4__c + margin);
                    }     
                }    
            }
            
            insertReportItemList.add(reportItem);
        }
        
        
        
		Map<Id,Opportunity> oppMap=new Map<Id,Opportunity>([select id ,Sales_Visible_LKP__c from Opportunity WHERE Id in :oppIds FOR UPDATE]);        
        ///***** DB INSERT *****//
        if(insertReportItemList.size() > 0)
        {
            Database.SaveResult[] srList = Database.insert(insertReportItemList, false);
            CheckExecuteAnonymous.changeRun(false);
            for(SalesVisibleReport__c svr: insertReportItemList)
       		{
                oppMap.get(svr.Opportunity__c).Sales_Visible_LKP__c=svr.Id;
            }
            update oppMap.values();
        }         
    }    
}