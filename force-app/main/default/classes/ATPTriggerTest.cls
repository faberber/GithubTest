@isTest
public class ATPTriggerTest {
static testMethod void testATPTrigger()
     {
         TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Business_Unit__c bu=[select id from Business_Unit__c];
        Sales_Segments__c ss=[select id from Sales_Segments__c];
        Account ven = [select id from Account where Recordtype.Name='Vendor'];
        Account cus = [select id from Account where Recordtype.Name='Customer'];
        Technology_Domain__c td=[select id from Technology_Domain__c];
        TD_BU_QUEUE__c tdbqc=[select id from TD_BU_QUEUE__c];
        Opportunity opp=[select id,StageName,CurrencyIsoCode,Pricebook2Id,Count_Of_TDWI__c from opportunity];
        Pricebook2 salPb=[select id,name from Pricebook2 where Name='Sales Price Book'];
        Pricebook2 solPb=[select id,name from Pricebook2 where Name='Solution Price Book'];
        Product2 salProd=[select id from Product2 where ProductCode='SALES'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        PricebookEntry pbeSol=[select id,name from PricebookEntry where Pricebook2.Name='Solution Price Book'];
        
        
        System.RunAs(testUser)
             {
                 
                //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
                OpportunityLineItem oli=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12,
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200);
                insert oli;
                OpportunityLineItemUtilities.DeleteOpportunityLineItemsByOppId(opp.Id);
                 
                opp.Pricebook2Id=solPb.Id;
                opp.Business_Unit__c='Enterprise';

                update opp;
        
        Authorization_to_Proceed__c atp=new Authorization_to_Proceed__c();
         atp.ATP_Amount__c=10;
         atp.ATP_Currency__c='USD';
         atp.Businness_case_Sales_Amount__c=10;
         atp.Description__c='test';
         atp.Opportunity__c=opp.Id;
         insert atp;
         

         delete atp;
             }
     }
}