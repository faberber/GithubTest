@isTest
public class NNDProjectIntegrationTest {
    
    static testMethod void testPrjInteg()
        
    {        
         TestDataFactory.createBaseTestData();
                User testUser=[select id from user where Alias='testus1'];
         List<Account> accList = [Select Id, Name, SAP_Account_No__c 
                                  From Account where SAP_Account_No__c = '0000012345'];
         List<Opportunity> oppList = [Select Id, Name, AccountId, Opportunity_ID__c from Opportunity where AccountId IN:accList ];
        System.RunAs(testUser)
             {
         Project__c newProject = new Project__c();
                    newProject.Name = 'Test Name';
                    newProject.Account__c = accList.get(0).Id;
                    newProject.Opportunity__c =oppList.get(0).Id;
                    newProject.Project_Name__c = 'Test Project Name';
                    newProject.Project_Owner__c = 'Test Owner';
                    newProject.Opportunity_Code__c='Test Opportunity Code';
                    
        insert newProject;
             }
                            
        NNDProjectIntegration.SendAccountToSAP(accList);
        
        BatchProjectIntegration BPI = new BatchProjectIntegration();
        Database.executeBatch(BPI,10);
        
        ScheduledProjectIntegration SPI = new ScheduledProjectIntegration();
        SPI.execute(NULL);
      
    }
}