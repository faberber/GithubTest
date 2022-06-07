@isTest
public class ReportTest {
	
    public static testMethod void TestVisibleReportUtilities(){
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus1'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Opportunity opp=[select id,Amount,StageName,CurrencyIsoCode,Pricebook2Id,Count_Of_TDWI__c,Count_Of_Completed_TDWI__c,Approval_Status__c from opportunity where Name ='TestDataFactory1'];
        PricebookEntry pbeSol=[select id,name,Pricebook2Id from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        
        CheckExecuteAnonymous.changeRun(false);
        System.RunAs(testUser)
             {
                opp.Amount=30000;
                opp.StageName='Solution & Proposal Development';
                opp.Approval_Status__c='Need Approval';
                opp.Count_Of_TDWI__c=1;
                opp.Count_Of_Completed_TDWI__c=1;
                opp.Pricebook2Id = pbeSol.Pricebook2Id;
                update opp;
                //Create ReportSetting
                Report_Setting__c solReportSetting = new Report_Setting__c(
                    Name = 'SolutionVisibleReport',
                    StageList__c = 'Solution & Proposal Development;Proposal & Price Quote;Negotiation & Review',
                    Start_Date__c = date.ValueOf('2018-01-01'),
                    End_Date__c= date.ValueOf('2018-12-31')
                );
                insert solReportSetting;
                 
                 solReportSetting.Run_Report__c = true;
                 update solReportSetting;
                 
                Report_Setting__c salReportSetting = new Report_Setting__c(
                    Name = 'SalesVisibleReport',
                    StageList__c = 'Value Proposition;Solution & Proposal Development;Proposal & Price Quote;Negotiation & Review',
                    Start_Date__c = date.ValueOf('2018-01-01'),
                    End_Date__c= date.ValueOf('2018-12-31')
                );
                insert salReportSetting;
                         
                OpportunityLineItem oli=new OpportunityLineItem();
                oli.Cost__c=100;
                oli.Expected_Reply_Date_From_Solution__c= system.today();
                oli.OpportunityId=opp.Id;
                oli.Vendor__c=ven.Id;
                oli.Quantity=12;
                oli.TotalPrice=200;
                oli.PricebookEntryId=pbeSol.Id;
                oli.Solution_Type__c='Product consultancy';
                insert oli;
        
                Vendor__c vendorBilling = new Vendor__c();
                vendorBilling.N_Billing_Amount__c =200;
                vendorBilling.Currency__c = opp.CurrencyIsoCode;
                vendorBilling.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
                vendorBilling.Due_Upon__c =20;
                vendorBilling.Opportunity__c = oli.OpportunityId;
                vendorBilling.Vendor__c = oli.Vendor__c;
                insert vendorBilling;
                  
                
                
                Set<Id> oppId = new Set<Id>();
                oppId.add(opp.Id);
                PaymentUtilities.SyncPaymentsFromVendorBillings(oppId);
                VendorBillingUtilities.SyncVendorBillingsFromOppLineItems(oppId);
        
                Customer_Billing__c cb = new Customer_Billing__c();
                cb.N_Billing_Amount__c =200;
                cb.Billing_Currency__c = opp.CurrencyIsoCode;
                cb.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
                cb.Due_Upon_c__c =20;
                cb.Opportunity__c = oli.OpportunityId;
                insert cb;
                
                Customer_Billing__c cb2 = new Customer_Billing__c();
                cb2.N_Billing_Amount__c =200;
                cb2.Billing_Currency__c = opp.CurrencyIsoCode;
                cb2.Billing_Date__c = date.ValueOf('2018-08-31');
                cb2.Due_Upon_c__c =20;
                cb2.Opportunity__c = oli.OpportunityId;
                insert cb2;
                
                Customer_Billing__c cb3 = new Customer_Billing__c();
                cb3.N_Billing_Amount__c =200;
                cb3.Billing_Currency__c = opp.CurrencyIsoCode;
                cb3.Billing_Date__c = date.ValueOf('2018-12-31');
                cb3.Due_Upon_c__c =20;
                cb3.Opportunity__c = oli.OpportunityId;
                insert cb3;
                 
                Set<Id> opplist=new Set<Id>();
                opplist.add(opp.Id);
                CustomerBillingUtilities.SyncCustomerBillings(opplist);
                ReportUtilities.SolutionVisibleReportBatch(opplist);
                ReportUtilities.SalesVisibleReportBatch(opplist); 
                ReportUtilities.SolutionVisibleReportInit();   
                ReportUtilities.SalesVisibleReportInit();
				 // Create an approval request for the opportunity
                Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(opp.id);
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(testUser.Id);
                req1.setProcessDefinitionNameOrId('PAF_Approval_Process_By_Pass_v2');
                req1.setSkipEntryCriteria(true);
                // Submit the approval request for the opportunity
                Approval.ProcessResult result = Approval.process(req1);
                 String[] stringList = new List<String>{'Solution & Proposal Development'}; 
                BatchReportUtilities BRU = new BatchReportUtilities(stringList,'Solutionıhgıylhygoulıyguo');
 				Database.executeBatch(BRU);
                
                 /*String[] stringList = new List<String>();
                 Database.executeBatch(new BatchReportUtilities(stringList));*/
                 
                // ScheduledApprovalReminder SAR = new ScheduledApprovalReminder();
                // SAR.execute(null);
                 ScheduledReportUtilities SRU = new ScheduledReportUtilities();
                 SRU.execute(null);
         	 }      
    }
}