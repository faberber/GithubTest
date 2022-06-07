@isTest
public class CurrencyUpdaterTest {

   static testMethod void testCurrencyUpdater()
    {
       
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        TD_BU_QUEUE__c tdbqc=[select id from TD_BU_QUEUE__c];
        Opportunity opp=[select id,StageName,CurrencyIsoCode from opportunity];        
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        CheckExecuteAnonymous.changeRun(false);
        System.RunAs(testUser)
             {
                //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
                OpportunityLineItem oli=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Need_Assistance_For__c='Product consultancy');
                insert oli;
                 
                opp.StageName = 'Value Proposition';
                update opp;
                
                Set<Id> testOppId=new Set<Id>();
                testOppId.add(opp.Id);
                
                Vendor__c vendorBilling = new Vendor__c(N_Billing_Amount__c =200,Currency__c = opp.CurrencyIsoCode,
                                                       Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c,
                                                       Due_Upon__c =20,Opportunity__c = oli.OpportunityId,
                                                       Vendor__c = oli.Vendor__c);
                insert vendorBilling;
                    //  List<TD_Work_Item__c> tdWorkItemList = [SELECT Id,Status__c,Work_Item_Closed_Date__c,ChildCount__c,ClosedChildCount__c FROM TD_Work_Item__c Where Related_Opportunity__c=:oppId AND Parent_TD_Work_Item__c=null AND Status__c != 'Cancelled'];
                    //TD_Work_Item__c parentWorkItem = [SELECT Id,Custom_Duration__c,Std_Duration_In_Minutes__c,Total_Duration__c,Parent_TD_Work_Item__c  FROM TD_Work_Item__c Where Id =:workItem.Parent_TD_Work_Item__c LIMIT 1];
            	opp.StageName = 'Solution & Proposal Development';
                update opp;
        
                TD_Work_Item__c tdc2 =new TD_Work_Item__c();
                TD_Work_Item__c tdc3 =new TD_Work_Item__c();
                TD_Work_Item__c tdc4 =new TD_Work_Item__c();
              
        
                 
                 
                tdc2.OpptyLineID__c=oli.Id;
                tdc2.Related_Opportunity__c=opp.Id;
                tdc2.Status__c = 'Open';
                tdc2.Insert_Product__c = 'Approve product insert';
                tdc2.Completion_Description__c= 'test';
                tdc2.Suggested_Cost__c = 1000;
                tdc2.SuggestedSolutionProduct__c = solProd.Id;
                tdc2.Suggested_Manufacturer__c = oli.Vendor__c;
                tdc2.Suggested_Vendor__c = oli.Vendor__c;
                tdc2.Is_Product_Created__c = false;
                tdc2.Price_Book__c = solPb.Id;
                tdc2.Technology_Domain__c = td.Id;
                tdc2.SubQueue__c=tdbqc.Id;
                tdc2.Sales_Price__c = 1000;          
                insert tdc2;
                tdc2.Status__c = 'Work In Progress';
                tdc2.Engagement_Type__c = 'Self'; 
                update tdc2;
                
                tdc2.Status__c = 'Completed';
                tdc2.Work_Item_Closed_Date__c=System.today();
                update tdc2;
                 
                
                Test.setCreatedDate(tdc2.Id, DateTime.newInstance(2012,12,12));
                OpportunityLineItemUtilities.AddOpportunityLineItemByTDWorkItem(tdc2, solPb.Id);
                PaymentUtilities.SyncPaymentsFromVendorBillings(testOppId);
                
                Set<Id> oppIdList = new Set<Id>();
                 oppIdList.add(opp.Id);
                VendorBillingUtilities.SyncVendorBillingsFromOppLineItems(oppIdList);
        
                 Customer_Billing__c cb = new Customer_Billing__c();
                    cb.N_Billing_Amount__c =200;
                    cb.Billing_Currency__c = opp.CurrencyIsoCode;
                    cb.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
                    cb.Due_Upon_c__c =20;
                    cb.Opportunity__c = oli.OpportunityId;
                insert cb;
                 
                 CustomerBillingUtilities.SyncCustomerBillings(oppIdList);
                 CollectionUtilities.SyncCollectionsFromCustomerBillings(opp.Id);

                 
                 Revenue__c col=new Revenue__c();
                 col.Amount__c =200;
                    col.Currency__c = opp.CurrencyIsoCode;
                    col.Revenue_Date__c = oli.Expected_Reply_Date_From_Solution__c;
                    col.Opportunity__c = oli.OpportunityId;
                 insert col;        
                
            
            
            
            ScheduledCBCurrencyUpdate SCU1 = new ScheduledCBCurrencyUpdate();
            SCU1.execute(NULL);
                
            ScheduledVBCurrencyUpdate SCU2 = new ScheduledVBCurrencyUpdate();
            SCU2.execute(NULL);
                
            ScheduledCurrencyUpdater SCU3 = new ScheduledCurrencyUpdater();
            SCU3.execute(NULL);    
             }       
	}
}