@isTest
public class CustomSharingTDWorkItemTest {
    
     static testMethod void testCustomSharingTDWorkItem()
    {
        
        
        
       TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus1'];
        User testApp=[select id from user where Alias='testapp'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        TD_BU_QUEUE__c tdbqc=[select id, Type__c from TD_BU_QUEUE__c];
        Opportunity opp=[select id,StageName,CurrencyIsoCode,Pricebook2Id,Business_Unit_A__c from opportunity WHERE Name = 'TestDataFactory1'];
        Pricebook2 salPb=[select id,name from Pricebook2 where Name='Sales Price Book'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 salProd=[select id from Product2 where ProductCode='SALES'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        Business_Unit__c bu=[select id from Business_Unit__c];
        CheckExecuteAnonymous.changeRun(false);
        
        System.RunAs(testUser)
             {
                 tdbqc.Business_Unit__c=opp.Business_Unit_A__c;
                 tdbqc.Technology_Domain__c=td.id;
                 //tdbqc.OwnerId=testApp.Id; 
                 update tdbqc;  
                 
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
		        
		        CustomSharingObject__c CSO = new CustomSharingObject__c();
                CSO.Name = 'testName';
                CSO.Technology_Domain__c = td.id;
                CSO.User_Role__c = 'Enterprise Solution Security Solutions Manager';
                insert CSO; 
                 
                CustomSharingObject__c CSO2 = new CustomSharingObject__c();
                CSO2.Name = 'testName';
                CSO2.Technology_Domain__c = td.id;
                CSO2.User_Role__c = 'Enterprise CyberSecurity Director';
                insert CSO2;  
                 
                
                 
                TD_Work_Item__c tdc =new TD_Work_Item__c();
                 
		        
		        tdc.OpptyLineID__c=oli.Id;
                tdc.Technology_Domain__c = td.id; 
		        tdc.Related_Opportunity__c=opp.Id;
		        tdc.Status__c='Waiting Sale Actions';
		        tdc.Work_Item_Closed_Date__c=system.today();
		        tdc.ChildCount__c=0;
		        tdc.ClosedChildCount__c=0;
		        tdc.Custom_Duration__c=10;
		        tdc.SubQueue__c = tdbqc.Id;
		        tdc.Solution_Request_Type__c = tdbqc.Type__c;
		        tdc.Engagement_Type__c = 'Self';
		        tdc.Assigned__c = true;
		        insert tdc;
                 
                tdc.Assigned__c = false;
                tdc.Engaged__c = true; 
				update tdc;
             }
    }
}