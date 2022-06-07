@isTest
private class MassEditOrderControllerTest {

  static testMethod void myUnitTest() {
       
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus1'];
        Account cust = [select id, Name from Account where Recordtype.Name='Customer'];
        Account ven = [select id, Name from Account where Recordtype.Name='Vendor'];
        Opportunity opp=[select id,StageName,CurrencyIsoCode from opportunity where Name = 'TestDataFactory1'];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        CheckExecuteAnonymous.changeRun(false);
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
                                                       N_Billing_Amount_USD__c = 200, 
                                                       Vendor__c = oli.Vendor__c);
                insert vendorBilling;                
                Set<Id> oppIdList = new Set<Id>();
                 oppIdList.add(opp.Id);        
                 Customer_Billing__c cb = new Customer_Billing__c();
                    cb.N_Billing_Amount__c =200;
                    cb.N_Billing_Amount_USD__c = 200;
                    cb.Billing_Currency__c = opp.CurrencyIsoCode;
                    cb.Billing_Date__c = oli.Expected_Reply_Date_From_Solution__c;
                    cb.Due_Upon_c__c =20;
                    cb.Opportunity__c = oli.OpportunityId;
                insert cb;    
                 
                 
                 
        apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(opp);
        MassEditOrderController MOFC = new MassEditOrderController(sc1);
                 
        MOFC.tempOpportunityProduct=new OpportunityLineItem(   Cost__c=150,
                                                               Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,
                                                               Vendor__c=ven.Id,
                                                               Quantity=1,
                                                               Solution_Type__c = 'Product consultancy',      
                                                               PricebookEntryId=pbeSal.Id,
                                                               UnitPrice=250,
                                                               Rebate_USD__c=10,
                                                               Product2New__c=solProd.Id,
                                                               ProductByPass__c=solProd.Id);     
                 
        
        
        MOFC.customerUnit = 0;
        MOFC.customerPeriod =0;
        MOFC.vendorPeriod = 0;
        MOFC.vendorUnit = 0;         
                 
                 
        MOFC.objectType='OpportunityProduct';
        MOFC.addRow();
        
        MOFC.objectType='CustomerBilling';
        MOFC.addRow();  
        MOFC.changeDate();
        MOFC.clonePartial();         
        MOFC.daysCustomerBilling = '3';         
        
        MOFC.objectType='VendorBilling';
        MOFC.addRow();
        MOFC.changeDate();
        MOFC.clonePartial();
                 
                 
        MOFC.objectType='OpportunityProduct';
        MOFC.savePartial();
        MOFC.clonePartial();
        MOFC.deletePartial();
        MOFC.deleteRecords();
                 
        MOFC.tempOpportunityProduct=new OpportunityLineItem(   Cost__c=150,
                                                               Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,
                                                               Vendor__c=ven.Id,
                                                               Quantity=1,
                                                               Manufacturer__c = cust.Id,
                                                               Solution_Type__c = 'Product consultancy',      
                                                               PricebookEntryId=pbeSal.Id,
                                                               UnitPrice=250,
                                                               Rebate_USD__c=10,
                                                               Product2New__c=solProd.Id,
                                                               ProductByPass__c=solProd.Id);
        
                 
       MOFC.tempCustomer = new Customer_Billing__c ( 	Opportunity__c = opp.Id,
                                                     	Billing_Date__c = system.today(),
                                                   		Due_Upon_c__c = 1,
                                                   		N_Billing_Amount__c = 250); 
                 
       MOFC.tempVendor = new Vendor__c ( Opportunity__c = opp.Id,
                                         Billing_Date__c = system.today(),
                                         Due_Upon__c = 1,
                                         N_Billing_Amount__c = 150,
                                         Vendor__c = ven.Id );             
        
        
        MOFC.customerUnit = 0;
        MOFC.customerPeriod =0;
        MOFC.vendorPeriod = 0;
        MOFC.vendorUnit = 0;         
                 
                 
        MOFC.objectType='OpportunityProduct';
        MOFC.addRow();
        
        MOFC.objectType='CustomerBilling';
        MOFC.addRow();
        MOFC.changeDate();         
        
        MOFC.objectType='VendorBilling';
        MOFC.addRow();
        MOFC.changeDate();         
        
        MOFC.objectType='OpportunityProduct';
        MOFC.savePartial();         
        MOFC.clonePartial();
        MOFC.deletePartial();
        MOFC.deleteRecords(); 
        MOFC.saveDetails();
        
                 
                 
        
        apexpages.currentpage().getparameters().put('id',opp.id);
        sc1 = new ApexPages.standardController(opp);
        MOFC = new MassEditOrderController(sc1);
        MOFC.tempOpportunityProduct=new OpportunityLineItem(   Cost__c=26000,Expected_Reply_Date_From_Solution__c= system.today(),
                                                               OpportunityId=opp.Id,Vendor__c=ven.Id,Quantity=1,
                                                               Solution_Type__c = 'Product consultancy', 
                                                               Manufacturer__c = cust.Id, 
                                                               Product2New__c=solProd.Id,
                                                               PricebookEntryId=pbeSal.Id,
                                                               UnitPrice=26000,
                                                               Rebate_USD__c=10,
                                                               ProductByPass__c=solProd.Id);
        
        MOFC.customerUnit = 1;
        MOFC.customerPeriod =1;
        MOFC.vendorPeriod = 1;
        MOFC.vendorUnit = 1;         
                 
                
        MOFC.objectType='OpportunityProduct';
        MOFC.addRow();
        
        MOFC.objectType='CustomerBilling';
        MOFC.addRow();
        
        MOFC.objectType='VendorBilling';
        MOFC.addRow();
        
        MOFC.objectType='OpportunityProduct';
        MOFC.savePartial();
        MOFC.clonePartial();
        MOFC.deletePartial();
        
      }        
    }
  }