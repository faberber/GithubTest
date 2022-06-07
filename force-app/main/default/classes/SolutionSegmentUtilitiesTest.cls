@isTest
public class SolutionSegmentUtilitiesTest {
         static testMethod void testSolutionSegmentUtilities()
         {
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
                 opp.Count_Of_Completed_TDWI__c = 4;
                 opp.Count_Of_TDWI__c = 4;
                 opp.Pricebook2Id = solPb.Id; 
                 update opp;
        
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

				OpportunityLineItem oli2=new OpportunityLineItem();
                oli2.Cost__c=100;
                oli2.Expected_Reply_Date_From_Solution__c= system.today();
                oli2.OpportunityId=opp.Id;
                oli2.Vendor__c=ven.Id;
                oli2.Quantity=12;
                oli2.TotalPrice=200;
                oli2.PricebookEntryId=pbeSol.Id;
                oli2.Solution_Type__c='Service consultancy';
                insert oli2;
             
             }
             
            
         }
}