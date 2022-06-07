@isTest
public class TDWICountTest {

    static testMethod void testTDWICountUtilities()
    {
       TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        TD_BU_QUEUE__c tdbqc=[select id from TD_BU_QUEUE__c];
        Opportunity opp=[select id,StageName,CurrencyIsoCode,Pricebook2Id from opportunity];
        Pricebook2 salPb=[select id,name from Pricebook2 where Name='Sales Price Book'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 salProd=[select id from Product2 where ProductCode='SALES'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        Business_Unit__c bu=[select id from Business_Unit__c];
        
        System.RunAs(testUser)
             {
             	opp.Pricebook2Id=solPb.Id;
             	update opp;
         
		        OpportunityLineItem oli=new OpportunityLineItem();
		        oli.Cost__c=100;
		        oli.Expected_Reply_Date_From_Solution__c= system.today();
		        oli.OpportunityId=opp.Id;
		        oli.Vendor__c=ven.Id;
		        oli.Quantity=12;
		        oli.TotalPrice=200;
		        oli.PricebookEntryId=pbeSol.Id;
		        oli.Technology_Domain__c = td.Id;
		        insert oli;
		
		        Vendor__c vendorBilling = new Vendor__c();
					vendorBilling.N_Billing_Amount__c =200;
					vendorBilling.Currency__c = opp.CurrencyIsoCode;
					vendorBilling.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
					vendorBilling.Due_Upon__c =20;
					vendorBilling.Opportunity__c = oli.OpportunityId;
					vendorBilling.Vendor__c = oli.Vendor__c;
		        insert vendorBilling;
		        
		        TD_Work_Item__c tdc =new TD_Work_Item__c();
		        TD_Work_Item__c tdc2 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc3 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc4 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc5 =new TD_Work_Item__c();
		        
		        tdc.OpptyLineID__c=oli.Id;
		        tdc.Related_Opportunity__c=opp.Id;
		        tdc.Status__c='Waiting Sale Actions';
		        tdc.Work_Item_Closed_Date__c=system.today();
		        tdc.ChildCount__c=0;
		        tdc.ClosedChildCount__c=0;
		        tdc.Custom_Duration__c=10;
		        tdc.SubQueue__c = tdbqc.Id;
		        tdc.Solution_Request_Type__c = 'Product consultancy';
		        tdc.Parent_TD_Work_Item__c = null;
		        insert tdc;
		        
		        tdc2.Parent_TD_Work_Item__c=tdc.Id;
		        tdc2.OpptyLineID__c=oli.Id;
		        tdc2.Related_Opportunity__c=opp.Id;
		        tdc2.Status__c='Waiting Sale Actions';
		        tdc2.Work_Item_Closed_Date__c=system.today();
		        tdc2.ChildCount__c=0;
		        tdc2.ClosedChildCount__c=0;
		        tdc2.Custom_Duration__c=10;
		        tdc3.Parent_TD_Work_Item__c=tdc.Id;
		        
		        tdc3.OpptyLineID__c=oli.Id;
		        tdc3.Related_Opportunity__c=opp.Id;
		        tdc3.Status__c='Cancelled';
		        tdc3.Work_Item_Closed_Date__c=system.today();
		        tdc3.ChildCount__c=0;
		        tdc3.ClosedChildCount__c=0;
		        tdc3.Custom_Duration__c=10;
		        
		        
		        tdc4.OpptyLineID__c=oli.Id;
		        tdc4.Related_Opportunity__c=opp.Id;
		        tdc4.Status__c='Completed';
		        tdc4.Work_Item_Closed_Date__c=system.today();
		        tdc4.ChildCount__c=0;
		        tdc4.ClosedChildCount__c=0;
		        tdc4.Custom_Duration__c=10;
		        tdc4.Parent_TD_Work_Item__c=tdc.Id;
		        tdc4.ChangePriceBook__c = true;
		        tdc4.Completion_Description__c = 'Test';
		        tdc4.Suggested_Cost__c = 1000;
		        tdc4.Suggested_Manufacturer__c = ven.Id;
		        tdc4.SuggestedSolutionProduct__c = solProd.Id;
		        tdc4.Suggested_Vendor__c = ven.Id;
		        tdc4.Insert_Product__c = 'Approve product insert';
		        
		        tdc5.OpptyLineID__c=oli.Id;
		        tdc5.Related_Opportunity__c=opp.Id;
		        tdc5.Status__c='Completed';
		        tdc5.Work_Item_Closed_Date__c=system.today();
		        tdc5.ChildCount__c=0;
		        tdc5.ClosedChildCount__c=0;
		        tdc5.Custom_Duration__c=10;
		        tdc5.Parent_TD_Work_Item__c=tdc.Id;
		        tdc5.ChangePriceBook__c = true;
		        tdc5.Completion_Description__c = 'Test';
		        tdc5.Suggested_Cost__c = 1000;
		        tdc5.Suggested_Manufacturer__c = ven.Id;
		        tdc5.SuggestedSolutionProduct__c = solProd.Id;
		        tdc5.Suggested_Vendor__c = ven.Id;
		        tdc5.Insert_Product__c = 'Approve product insert';
		        
		        insert tdc2;
		        insert tdc3;
		        insert tdc4;
		        insert tdc5;
		        
		        set<Id> oppSetId = new set<Id>();
		        oppSetId.add(opp.Id);
		        
		        TDWICountUtilities.updateTDWICounts(oppSetId);
             }
       
    } 
}