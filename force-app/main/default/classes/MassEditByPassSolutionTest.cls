@isTest
private class MassEditByPassSolutionTest {

    static testMethod void myUnitTest() {
       
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account ven = [select id, Name from Account where Recordtype.Name='Vendor'];
        Opportunity opp=[select id,StageName,CurrencyIsoCode from opportunity];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        
        System.RunAs(testUser)
             {
                //Id,Cost__c,Expected_Reply_Date_From_Solution__c,OpportunityId,Vendor__c
                OpportunityLineItem oli=new OpportunityLineItem(Cost__c=100,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=12, 
                                                               Solution_Type__c = 'Product consultancy',
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=200,Rebate_USD__c=100);
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
                Set<Id> oppIdList = new Set<Id>();
                 oppIdList.add(opp.Id);        
                 Customer_Billing__c cb = new Customer_Billing__c();
                    cb.N_Billing_Amount__c =200;
                    cb.Billing_Currency__c = opp.CurrencyIsoCode;
                    cb.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
                    cb.Due_Upon_c__c =20;
                    cb.Opportunity__c = oli.OpportunityId;
                insert cb;    

                 apexpages.currentpage().getparameters().put('id',opp.id);
                 ApexPages.StandardController sc1 = new ApexPages.standardController(opp);
                 MassEditByPassSolutionController MOFC = new MassEditByPassSolutionController(sc1);
                 

                 opp.By_Pass_Solution__c='Yes';
                 update opp;
                 
                 apexpages.currentpage().getparameters().put('id',opp.id);
                 sc1 = new ApexPages.standardController(opp);
                 MOFC = new MassEditByPassSolutionController(sc1);
                 MOFC.tempOpportunityProduct=new OpportunityLineItem(Cost__c=150,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=1,
                                                               Solution_Type__c = 'Product consultancy',      
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=250,Rebate_USD__c=10,ProductByPass__c=solProd.Id);
                 MOFC.objectType='OpportunityProduct';
                 MOFC.addRow();
                 MOFC.savePartial();
                 
                 MOFC.objectType='CustomerBilling';
                 MOFC.addRow();
                 MOFC.savePartial();
                 
                 MOFC.objectType='VendorBilling';
                 MOFC.addRow();
                 MOFC.savePartial();
                 
                 MOFC.objectType='OpportunityProduct';
                 MOFC.clonePartial();                
                 MOFC.deletePartial();
                 MOFC.deleteRecords(); 
                 
                 opp.By_Pass_Solution__c='Yes';
                 opp.Estimated_Solution_Segment__c = 'Product Resell';
                 update opp;
                 
                 
                 apexpages.currentpage().getparameters().put('id',opp.id);
                 sc1 = new ApexPages.standardController(opp);
                 MOFC = new MassEditByPassSolutionController(sc1);
                 MOFC.tempOpportunityProduct=new OpportunityLineItem(Cost__c=150,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=1,
                                                               Solution_Type__c = 'Service consultancy',      
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=250,Rebate_USD__c=10,ProductByPass__c=solProd.Id);
                 MOFC.CurrencyCode='USD';
                 MOFC.objectType='OpportunityProduct';
                 MOFC.addRow();
              

                 
                 
                 
                 opp.By_Pass_Solution__c='Yes';
                 opp.Estimated_Solution_Segment__c = 'Microsoft';
                 update opp;
                 
                 
                 ven.name = 'TEST VENDOR';
                 update ven;
                 
                 apexpages.currentpage().getparameters().put('id',opp.id);
                 sc1 = new ApexPages.standardController(opp);
                 MOFC = new MassEditByPassSolutionController(sc1);
                 MOFC.tempOpportunityProduct=new OpportunityLineItem(Cost__c=150,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=1,
                                                               Solution_Type__c = 'Product consultancy',      
                                                               PricebookEntryId=pbeSal.Id,UnitPrice=250,Rebate_USD__c=10,ProductByPass__c=solProd.Id);
                 MOFC.CurrencyCode='USD';
                 MOFC.objectType='OpportunityProduct';
                 MOFC.addRow();

                 
                 MOFC.objectType='CustomerBilling';
                 MOFC.daysCustomerBilling='30';
                 MOFC.operationType='Prepone';
                 MOFC.changeDate();

                 MOFC.objectType='VendorBilling';
                 MOFC.daysVendorBilling='30';
                 MOFC.operationType='Prepone';
      //           MOFC.changeDate();

          
                 MOFC.saveDetails();
                 
                 
             }
        
        
    }
}