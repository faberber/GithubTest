@isTest
public class DragAndDropChatterFileControllerTest {
	@isTest
    static void ControllerConstructorTest(){
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
             System.RunAs(testUser)
             {
                System.currentPageReference().getParameters().put('id', cus.Id);
         
                DragAndDropChatterFileController controller = new DragAndDropChatterFileController();
                System.assertEquals(cus.Id, controller.myId); 
             }
    }
    
    @isTest
    static void DragAndUploadFileSuccessTest() {
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
             System.RunAs(testUser)
             {
            string err = DragAndDropChatterFileController.saveFile('test.txt', 'aGVsbG8=', cus.Id);
            
            FeedItem item = [select Id, ParentId, ContentData, ContentFileName from FeedItem where ParentId=:cus.Id];
            System.assert(item != null);
            System.assert(err == null);
            String decodedData = EncodingUtil.base64Encode(item.ContentData);
            System.assertEquals('aGVsbG8=', decodedData);
            System.assertEquals('test.txt', item.ContentFileName);
             }
    }
    
    
    @isTest
    static void DragAndUploadFileFailureTest() {
        string err = DragAndDropChatterFileController.saveFile('test.txt', 'aGVsbG8=', 'invalid');
        System.assert(err != null);
    }
    
    @isTest
    static void DragAndUploadFileTDWITest() {
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        TD_BU_QUEUE__c tdbqc=[select id from TD_BU_QUEUE__c];
        Opportunity opp=[select id,StageName,CurrencyIsoCode from opportunity];
        Pricebook2 salPb=[select id,name from Pricebook2 where Name='Sales Price Book'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 salProd=[select id from Product2 where ProductCode='SALES'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        
        System.RunAs(testUser)
             {
		        //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
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
		
		        //List<Vendor__c> vendorList = [SELECT Id, N_Billing_Amount__c FROM Vendor__c Where Vendor__c  =:oli.Vendor__c AND Opportunity__c=:oli.OpportunityId];
		        Vendor__c vendorBilling = new Vendor__c();
		        vendorBilling.N_Billing_Amount__c =200;
		        vendorBilling.Currency__c = opp.CurrencyIsoCode;
		        vendorBilling.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
		        vendorBilling.Due_Upon__c =20;
		        vendorBilling.Opportunity__c = oli.OpportunityId;
		        vendorBilling.Vendor__c = oli.Vendor__c;
		        insert vendorBilling;
		            //  List<TD_Work_Item__c> tdWorkItemList = [SELECT Id,Status__c,Work_Item_Closed_Date__c,ChildCount__c,ClosedChildCount__c FROM TD_Work_Item__c Where Related_Opportunity__c=:oppId AND Parent_TD_Work_Item__c=null AND Status__c != 'Cancelled'];
		            //TD_Work_Item__c parentWorkItem = [SELECT Id,Custom_Duration__c,Std_Duration_In_Minutes__c,Total_Duration__c,Parent_TD_Work_Item__c  FROM TD_Work_Item__c Where Id =:workItem.Parent_TD_Work_Item__c LIMIT 1];
		
		
		        TD_Work_Item__c tdc =new TD_Work_Item__c();
		        TD_Work_Item__c tdc2 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc3 =new TD_Work_Item__c();
		        TD_Work_Item__c tdc4 =new TD_Work_Item__c();
		        tdc.OpptyLineID__c=oli.Id;
		        tdc.Related_Opportunity__c=opp.Id;
		        tdc.Status__c='Waiting Sale Actions';
		        tdc.Work_Item_Closed_Date__c=system.today();
		        tdc.ChildCount__c=0;
		        tdc.ClosedChildCount__c=0;
		        tdc.Custom_Duration__c=10;
		        tdc.Technology_Domain__c=td.Id;
		        tdc.SuggestedSolutionProduct__c=solProd.Id;
		        insert tdc;
		        
		         string err = DragAndDropChatterFileController.saveFile('test.txt', 'aGVsbG8=', tdc.Id);
		        
		        FeedItem item = [select Id, ParentId, ContentData, ContentFileName from FeedItem where ParentId=:tdc.Id];
		        System.assert(item != null);
		        System.assert(err == null);
		        String decodedData = EncodingUtil.base64Encode(item.ContentData);
		        System.assertEquals('aGVsbG8=', decodedData);
		        System.assertEquals('test.txt', item.ContentFileName);
             }

    }
    
}