@isTest
public class OpportunityMassEditTest {
    
	public static testMethod void unitTest1(){
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
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Vendor__c = ven.Id , Billing_Date__c=system.Today(), Due_Upon__c =30, Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        massEditControllerObj.objectType = 'CustomerBilling';
        massEditControllerObj.customerUnit = 2;
        massEditControllerObj.customerPeriod = 2;
        massEditControllerObj.addRow();
        massEditControllerObj.objectType = 'Revenue';
        massEditControllerObj.revenueUnit = 2;
        massEditControllerObj.revenuePeriod = 2;
        massEditControllerObj.addRow();
        massEditControllerObj.objectType = 'VendorBilling';
        massEditControllerObj.vendorUnit = 2;
        massEditControllerObj.vendorPeriod = 2;
        massEditControllerObj.addRow();
        massEditControllerObj.objectType = 'Payment';
        massEditControllerObj.paymentUnit = 2;
        massEditControllerObj.paymentPeriod = 2;
        massEditControllerObj.addRow();
        
        massEditControllerObj.saveDetails();
             }
    }
    
    public static testMethod void unitTest2(){
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
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        //apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.deleteRecords();
             }
    }
    
    public static testMethod void unitTest3(){
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
        
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        //apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        
        //Prepone
        massEditControllerObj.daysCustomerBilling = '1'; 
        massEditControllerObj.objectType = 'CustomerBilling';
        massEditControllerObj.operationType = 'Prepone';
        massEditControllerObj.changeDate();
        
        massEditControllerObj.daysRevenue = '1'; 
        massEditControllerObj.objectType = 'Revenue';
        massEditControllerObj.operationType = 'Prepone';
        massEditControllerObj.changeDate();
        
        massEditControllerObj.daysVendorBilling = '1'; 
        massEditControllerObj.objectType = 'VendorBilling';
        massEditControllerObj.operationType = 'Prepone';
        massEditControllerObj.changeDate();
        
        massEditControllerObj.daysPayment = '1'; 
        massEditControllerObj.objectType = 'Payment';
        massEditControllerObj.operationType = 'Prepone';
        massEditControllerObj.changeDate();
             }
    }
    
    public static testMethod void unitTest4(){
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
        
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        //apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        //Postpone
        massEditControllerObj.daysCustomerBilling = '1'; 
        massEditControllerObj.objectType = 'CustomerBilling';
        massEditControllerObj.operationType = 'Postpone';
        massEditControllerObj.changeDate();
        
        massEditControllerObj.daysRevenue = '1'; 
        massEditControllerObj.objectType = 'Revenue';
        massEditControllerObj.operationType = 'Postpone';
        massEditControllerObj.changeDate();
        
        massEditControllerObj.daysVendorBilling = '1'; 
        massEditControllerObj.objectType = 'VendorBilling';
        massEditControllerObj.operationType = 'Postpone';
        massEditControllerObj.changeDate();
        
        massEditControllerObj.daysPayment = '1'; 
        massEditControllerObj.objectType = 'Payment';
        massEditControllerObj.operationType = 'Postpone';
        massEditControllerObj.changeDate();
             }
    }
    
    public static testMethod void unitTest5(){
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
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        //apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        massEditControllerObj.objectType = 'CustomerBilling';
        massEditControllerObj.savePartial();
        massEditControllerObj.objectType = 'Revenue';
        massEditControllerObj.savePartial();
        massEditControllerObj.objectType = 'VendorBilling';
        massEditControllerObj.savePartial();
        massEditControllerObj.objectType = 'Payment';
        massEditControllerObj.savePartial();
             }
    }
    
    public static testMethod void unitTest6(){
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
        
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        //apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'CustomerBilling';
        massEditControllerObj.deletePartial();
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'Revenue';
        massEditControllerObj.deletePartial();
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'VendorBilling';
        massEditControllerObj.deletePartial();
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'Payment';
        massEditControllerObj.deletePartial();
             }
        
    }
    
    public static testMethod void unitTest7(){
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
        
        
        Customer_Billing__c billing = new Customer_Billing__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert billing;
        Revenue__c revenue = new Revenue__c(revenue_Amount__c=500,Revenue_Date__c=system.today(),Opportunity__c=opp.id);
        insert revenue;
        Vendor__c vendor = new Vendor__c(Billing_Amount__c=500, Billing_Date__c=system.Today(), Opportunity__c=opp.id);
        insert vendor;
        Payment__c payment = new Payment__c(Amount__c=500,Opportunity__c=opp.id);
        insert payment;
        
        //apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        
        OpportunityMassEditController massEditControllerObj = new OpportunityMassEditController(sc);
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'CustomerBilling';
        massEditControllerObj.clonePartial();
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'Revenue';
        massEditControllerObj.clonePartial();
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'VendorBilling';
        massEditControllerObj.clonePartial();
        
        for(String recId : massEditControllerObj.deleteRecordsMap.keyset()){
            massEditControllerObj.deleteRecordsMap.put(recId, true);
        }
        massEditControllerObj.objectType = 'Payment';
        massEditControllerObj.clonePartial();
             }
    }
}