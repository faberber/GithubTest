@isTest
private class TestUpdateLeadCampaign {
	
	@isTest static void insertNewLead() {
		TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account cust = [select id, Name from Account where Recordtype.Name='Customer'];
        Account ven = [select id, Name from Account where Recordtype.Name='Vendor'];
        Opportunity opp=[select id,StageName,CurrencyIsoCode from opportunity];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        
        System.RunAs(testUser)
             {
		Campaign camp = new Campaign();
		camp.Name = 'new campaign';
		insert camp;

		CampaigNetas__c campaign = new CampaigNetas__c();
		campaign.Name = 'Campaign1';
		campaign.Campaign__c = camp.Id;
		insert campaign;

		Lead ld = new Lead();
		ld.FirstName = 'Eren';
		ld.LastName ='Aygun';
		ld.Business_Unit__c = 'BDH';
		ld.Business_Unit_Detail__c='Other';
		ld.Opportunity_Description__c = 'opp desc.';
		ld.Status = 'Open';
		ld.Company = cust.Id;
		ld.Related_Campaign__c = campaign.Id;
        insert ld;
             }
	}

	@isTest static void updateNewLead() {
		TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Account cust = [select id, Name from Account where Recordtype.Name='Customer'];
        Account ven = [select id, Name from Account where Recordtype.Name='Vendor'];
        Opportunity opp=[select id,StageName,CurrencyIsoCode from opportunity];
        Product2 solProd=[select id from Product2 where ProductCode=''];
        PricebookEntry pbeSal=[select id,name from PricebookEntry where Pricebook2.Name='Sales Price Book'];
        
        System.RunAs(testUser)
             {
		CampaigNetas__c campaign = new CampaigNetas__c();
		campaign.Name = 'Campaign1';
		insert campaign;

		CampaigNetas__c campaign2 = new CampaigNetas__c();
		campaign2.Name = 'Campaign1';
		insert campaign2;


		Lead ld = new Lead();
		ld.LastName ='Aygun';
		ld.Company = cust.Id;
		ld.Business_Unit__c = 'Enterprise';
		ld.Business_Unit_Detail__c='GI';
		ld.Opportunity_Description__c = 'opp desc.';
		ld.Status = 'Open';
		ld.Related_Campaign__c = campaign.Id;
    	insert ld;

    	ld.Related_Campaign__c = campaign2.Id;
    	update ld;
             }
	}	
}