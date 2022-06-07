@isTest
public class TheTDWorkItemTriggerTest {

    static testMethod void testTDWorkItemUtilities()
    {
        
        
        
       TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        User testApp=[select id from user where Alias='testapp'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        TD_BU_QUEUE__c tdbqc=[select id, Type__c from TD_BU_QUEUE__c];
        Opportunity opp=[select id,StageName,CurrencyIsoCode,Pricebook2Id,Business_Unit_A__c from opportunity];
        Pricebook2 salPb=[select id,name from Pricebook2 where Name='Sales Price Book'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 salProd=[select id from Product2 where ProductCode='SALES'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        Business_Unit__c bu=[select id from Business_Unit__c];
        
        
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
		        
		        TD_Work_Item__c tdc =new TD_Work_Item__c();
		        TD_Work_Item__c tdc2 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc3 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc4 =new TD_Work_Item__c();
                TD_Work_Item__c tdc5 =new TD_Work_Item__c();
                TD_Work_Item__c tdc6 =new TD_Work_Item__c();
                TD_Work_Item__c tdc7 =new TD_Work_Item__c(); 
		        
		        tdc.OpptyLineID__c=oli.Id;
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
                 
                tdc2.OwnerId = testApp.Id; 
		        tdc2.Parent_TD_Work_Item__c=tdc.Id;
		        tdc2.OpptyLineID__c=oli.Id;
		        tdc2.Related_Opportunity__c=opp.Id;
		        tdc2.Status__c='Waiting Sale Actions';
		        tdc2.Work_Item_Closed_Date__c=system.today();
		        tdc2.ChildCount__c=0;
		        tdc2.ClosedChildCount__c=0;
		        tdc2.Custom_Duration__c=10;
		        tdc2.Engagement_Type__c = 'Self';
                tdc2.Solution_Request_Type__c = tdbqc.Type__c; 
		        
                 
                tdc3.Parent_TD_Work_Item__c=tdc.Id;
		        tdc3.OpptyLineID__c=oli.Id;
		        tdc3.Related_Opportunity__c=opp.Id;
		        tdc3.Status__c='Waiting Sale Actions';
		        tdc3.Work_Item_Closed_Date__c=system.today();
		        tdc3.ChildCount__c=0;
		        tdc3.ClosedChildCount__c=0;
		        tdc3.Custom_Duration__c=10;
		        tdc3.Engagement_Type__c = 'Self';
                tdc3.Solution_Request_Type__c = tdbqc.Type__c;  
		        tdc4.Parent_TD_Work_Item__c=tdc.Id;
		        
		        tdc4.OpptyLineID__c=oli.Id;
		        tdc4.Related_Opportunity__c=opp.Id;
		        tdc4.Status__c='Waiting Sale Actions';
		        tdc4.Work_Item_Closed_Date__c=system.today();
		        tdc4.ChildCount__c=0;
		        tdc4.ClosedChildCount__c=0;
		        tdc4.Engagement_Type__c = 'Self';
                tdc4.Solution_Request_Type__c = tdbqc.Type__c;  
		        tdc4.Custom_Duration__c=10;
		        
		        insert tdc2;
		        insert tdc3;
		        insert tdc4;
		        Set<Id> is=new Set<Id>();
		    
		        delete tdc;
		        delete tdc2;
		        delete tdc3;
		        delete tdc4;
		     
		       
		        List<TD_Work_Item__c> tdList = new List<TD_Work_Item__c>();
		        tdList.add(tdc);
                set<Id> oppSetId = new Set<Id>();
                oppSetId.add(opp.Id); 
		        TD_BU_QUEUE__c tdbqc2=new TD_BU_QUEUE__c();
		        tdbqc.Business_Unit__c=bu.Id;
		             tdbqc2.Technology_Domain__c=td.Id;
		             tdbqc2.Name='TEST';
		             tdbqc2.Type__c='Service consultancy';
		             insert tdbqc2;
		        
		        
		        
		        
		        tdc2=new TD_Work_Item__c();
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
                tdc2.Solution_Request_Type__c = tdbqc.Type__c;  
		        tdc2.Sales_Price__c = 1000;          
		        insert tdc2;
                 
                Technology_Domain__c TDNOC = new Technology_Domain__c();
                TDNOC.Name = 'NOC';
                insert TDNOC; 
                 
                tdc5=new TD_Work_Item__c();
		        tdc5.OpptyLineID__c=oli.Id;
		        tdc5.Related_Opportunity__c=opp.Id;
		        tdc5.Status__c = 'On Approval';
		        tdc5.Insert_Product__c = 'Approve product insert';
		        tdc5.Completion_Description__c= 'test'; 
		        tdc5.Suggested_Cost__c = 1000;
		        tdc5.SuggestedSolutionProduct__c = solProd.Id;
		        tdc5.Suggested_Manufacturer__c = oli.Vendor__c;
		        tdc5.Suggested_Vendor__c = oli.Vendor__c;
		        tdc5.Is_Product_Created__c = false;
		        tdc5.Price_Book__c = solPb.Id;
		        tdc5.Technology_Domain__c = TDNOC.Id;
		        tdc5.SubQueue__c=tdbqc.Id;
                tdc5.Solution_Request_Type__c ='R&D consultancy';  
		        tdc5.Sales_Price__c = 1000;          
		        insert tdc5; 
		        
		        tdc2.Engagement_Type__c = 'Self'; 
		        tdc2.Status__c = 'Completed';
		        tdc2.Work_Item_Closed_Date__c=System.today();
		        update tdc2;
		        List<TD_Work_Item__c> tis=new List<TD_Work_Item__c>();
		        tis.add(tdc2);
                Map<Id,TD_Work_Item__c> tmap = new Map<Id,TD_Work_Item__c>();
                tmap.put(tdc5.Id,tdc5); 
                 
             }
    }

    
}