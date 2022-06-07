@isTest
public class TaxIdAlgorithmTest {

    static testMethod void testTaxIdAlgorithm()
	{
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Profile.Name != 'System Administrator' LIMIT 1];
        Sales_Segments__c ss=[select id from Sales_Segments__c];
        Account Customer = [select id from Account where Recordtype.Name='Customer'];   
        Account Vendor = [select id from Account where Recordtype.Name='Vendor'];  
        CheckExecuteAnonymous.changeRun(true);
        
        System.RunAs(testUser)
             {
                 Customer.Tax_Id__c = '8400392081';  
                 update Customer; 
                 
                 Vendor.Vendor_Tax_Id__c = '8400392081';  
                 update Vendor;
                 
                 Customer.Tax_Id__c = '40946931310'; 
                 update Customer;
                 
                 Vendor.Vendor_Tax_Id__c = '40946931310'; 
                 update Vendor;
             }
    
  }
}