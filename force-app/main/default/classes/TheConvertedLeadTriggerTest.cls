@isTest(SeeAllData = True)
public class TheConvertedLeadTriggerTest {

    static testMethod void validateTheConvertedLeadTrigger() {

	    Profile p = [SELECT Id FROM Profile WHERE Name='Final_Solution_User'];
        UserRole r = [Select Id FROM UserRole where Name ='CXO'];     
        List<User> users=new List<User>();
        User testUser=new User(LastName='TestName',UserName='test2@testuser.com'
                                  	   ,Email='testtest2@test.com',Alias='testus2', UserRoleId = r.Id
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                  	   ,ProfileId=p.Id,isActive=TRUE);
        	
        	users.add(testUser);
        	insert users;
        
        
        //Lead ld = [Select Id, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId FROM Lead where isConverted = true LIMIT 1];
        
        System.RunAs(testUser)
       {  
            Lead testLead = new Lead();
            testLead.RecordTypeId = [Select Id, SobjectType, Name From RecordType Where Name ='Enterprise' and SobjectType ='Lead'  limit 1].Id;
            testLead.FirstName = 'TestName';
            testLead.LastName = 'TestLastName';
            testLead.Company = 'Company';
            testLead.CurrencyIsoCode= 'USD';
            testLead.Business_Unit__c = 'test';
            testLead.Opportunity_Description__c = 'Test Desc';
            testLead.Status = 'Open';
            insert  testLead; 
       }
	}
}