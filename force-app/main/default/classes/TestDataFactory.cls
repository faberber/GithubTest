@isTest
public class TestDataFactory {
    //Creates test Opportunity
    public static void createBaseTestData() {
        	//CheckExecuteAnonymous.changeRun(false);
        	//Create Test Users
        	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        	UserRole userRole = new UserRole(Name = 'Cyber');
        	insert userRole;
        

        	List<User> users=new List<User>();
        	User testApprover=new User(LastName='TestApp',UserName='approver@testapprover.co'
                                       ,Email='approver@test.com',Alias='testapp'
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                       ,ProfileId=p.Id,Functional_Title_Group__c='CFO',isActive=TRUE);
        	User testUser=new User(LastName='TestName',UserName='erntest@testuser.com'
                                  	   ,Email='erntest@test.com',Alias='testus1'
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                  	   ,ProfileId=p.Id,ManagerId=testApprover.Id, UserRoleId = userRole.Id,isActive=TRUE);
        	
        	users.add(testApprover);
        	users.add(testUser);
        	insert users;
        
        	testUser.Upper_Manager__c=testApprover.Id;
        	testUser.FI_APP_ACCT__c=testApprover.Id;
        	update testUser;
        
          /*  System.RunAs(testUser)
             {*/
               	    //Create Test Business Unit
                    Business_Unit__c bu=new Business_Unit__c();
                    bu.Name='Enterprise';
                 	bu.OwnerId=testApprover.Id;
                    insert bu;
                 
                 	//Create Test Sales Segment
                    Sales_Segments__c ss=new Sales_Segments__c(Name='Finance',Business_Unit__c=bu.Id);      
                    insert ss;        
                 
                 	SS_Members__c ssm=new SS_Members__c(Name=testuser.lastname,Member__c=testuser.Id,Sales_Segments__c=ss.Id);
                 	insert ssm;
                 
                 	//Create Test Technology Domain
                	Technology_Domain__c td=new Technology_Domain__c();
                    td.Name='Test';
                    insert td;
                 
                 	//Create TDBU Queue
                 	TD_BU_QUEUE__c tdbqc=new TD_BU_QUEUE__c();
                    tdbqc.Business_Unit__c=bu.Id;
                    tdbqc.Technology_Domain__c=td.Id;
                    tdbqc.Name='TEST';
                    tdbqc.Type__c='Service consultancy';
                    insert tdbqc;
                 
                    //Create Test Accounts
                    List<Account> accts = new List<Account>();
                    //Test Customer Account
                    Account cus = new Account(OwnerId=testUser.Id,Name='TestAccount',Commercial_Title__c='TestAccount',Account_Description__c='Test Description'
                                           ,CurrencyIsoCode='USD',AccountNumber='123', SAP_Account_No__c='0000012345'/*,Tax_Id__c='40946931310' */
                                           ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()
                                           ,Sales_Segments__c=ss.Id,Business_Unit_Map__c=bu.Id,Tax_Id__c = '8400392081'
                                           ,Payment_Term__c=1,Estimated_Installments__c=2,Estimated_Invoice_Monthly_Term__c=2
                                           ,Due_Upon__c=1);
                    accts.add(cus);
                    //Test Vendor Account
                    Account ven = new Account(OwnerId=testUser.Id,Name='TestAccount',Commercial_Title__c='TestAccount',Account_Description__c='Test Description'
                                           ,CurrencyIsoCode='USD',AccountNumber='123',Vendor_Tax_Id__c = '8400392081'
                                           ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId()
                                           ,Payment_Term__c=1,Estimated_Installments__c=2,Estimated_Invoice_Monthly_Term__c=2
                                           ,Due_Upon__c=1);
                    accts.add(ven);
                    insert accts;
                 
                 List<ProcessInstanceWorkItem> pwiList=[select id from ProcessInstanceWorkItem];
                 for(ProcessInstanceWorkItem pwi : pwiList)
                 {
                    // Instantiate the new ProcessWorkitemRequest object and populate it
                    Approval.ProcessWorkitemRequest req2 = 
                        new Approval.ProcessWorkitemRequest();
                    req2.setComments('Approving request.');
                    req2.setAction('Approve');
                    req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    
                    // Use the ID from the newly created item to specify the item to be worked
                    req2.setWorkitemId(pwi.Id);
                    
                    // Submit the request for approval
                    Approval.ProcessResult result2 =  Approval.process(req2);
                 }
                 //Create Products
                Product2 salProd = new Product2(Name = 'Laptop X200',
                                     Family = td.Name,Technology_Domain__c=td.Id,ProductCode='SALES',isActive=true);
                Product2 solProd = new Product2(Name = 'Laptop X200',
                                     Family = td.Name,Technology_Domain__c=td.Id,ProductCode='',isActive=true);
				List<Product2> proList=new List<Product2>();
                 proList.add(salProd);
                 proList.add(solProd);
                 insert proList;
                 
                 //Create Pricebooks
                Id pricebookId = Test.getStandardPricebookId();
                
                Pricebook2 salesPB = new Pricebook2(Name='Sales Price Book',isActive = true);
                Pricebook2 solutionPB = new Pricebook2(Name='Solution Price Book', isActive=true);
                Pricebook2 solutionPB2 = new Pricebook2(Name='Public Solution Price Book', isActive = true);
                 List<Pricebook2> pbList=new List<Pricebook2>();
                 pbList.add(salesPB);
                 pbList.add(solutionPB);
                 pbList.add(solutionPB2);
				insert pbList;
                 
                 //Create PricebookEntries
                 PricebookEntry standardPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = pricebookId, Product2Id = salProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                 PricebookEntry standardSolPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = pricebookId, Product2Id = solProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                PricebookEntry salesPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = salesPB.Id, Product2Id = salProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                PricebookEntry solutionPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = solutionPB.Id, Product2Id = solProd.Id,
                                                                    UnitPrice = 12000, IsActive = true);
				List<PricebookEntry> pbeList=new List<PricebookEntry>();
                 pbeList.add(standardPrice);
                 pbeList.add(standardSolPrice);
                 pbeList.add(salesPrice);
                 pbeList.add(solutionPrice);
                 insert pbeList;
                 
                 List<Opportunity> addOppList = new List<Opportunity>();
                 //Create Opportunity
                 Opportunity opp = new Opportunity(
                     							  OwnerId=testUser.Id,
                     							  Name='TestDataFactory1',
                                                  Account = cus,
                                                  NextStep='test',
                                                  PriceBook2 = salesPB,
                                                  CloseDate = System.today(),
                                                  AccountId=cus.Id,
                                                  StageName='Prospecting',
                                                  Probability=100,
                                                  My_Forecast__c='Pipeline',
                                                  Count_Of_TDWI__c=0,
                                                  Count_Of_Completed_TDWI__c=0,
                                                  CurrencyIsoCode='USD',
                     							  Opportunity_Probability__c = 60,
                                                  Estimated_Installments__c=3,
                                                  Estimated_Invoice_Date__c=system.today(),
                                                  Estimated_Invoice_Monthly_Term__c=1,
                                                  Amount=1000,
                                                  Business_Unit_A__c=bu.Id,
                     							  Sales_Segment__c=ss.Id,
                                                  Approval_Status__c='N/A',
                     							  Approver_Opportunity_Manager__c=null,
                     							  Approver_Opportunity_Upper_Manager_c__c=null,
                     							  Approvers_for_BU_General_Manager__c=null,
                     							  Approvers_for_CFO__c=null,
                     							  Approver_TDWI_Owner_Manager_1__c=null,
                     							  Approver_TDWI_Owner_Manager_2__c=null,
                     							  Approver_TDWI_Owner_Manager_3__c=null,
                     							  Approvers_For_Account__c=null,
                     							  Approvers_For_Supplier__c=null, 
                     							  Approvers_For_Finance__c=null,
                     							  Sent_to_SAP__c = false,
                                                  RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EB_GI').getRecordTypeId());
				addOppList.add(opp);
                 
                 
                 
                 
                 Opportunity opp2 = new Opportunity(
                     							  OwnerId=testUser.Id,
                     							  Name='TestDataFactory2',
                                                  Account = cus,
                                                  NextStep='test',
                                                  PriceBook2 = salesPB,
                                                  CloseDate = System.today(),
                                                  AccountId=cus.Id,
                                                  StageName='Prospecting',
                                                  Probability=100,
                                                  My_Forecast__c='Pipeline',
                                                  Count_Of_TDWI__c=0,
                                                  Count_Of_Completed_TDWI__c=0,
                                                  CurrencyIsoCode='USD',
                     							  Opportunity_Probability__c = 60,
                                                  Estimated_Installments__c=3,
                                                  Estimated_Invoice_Date__c=system.today(),
                                                  Estimated_Invoice_Monthly_Term__c=1,
                                                  Amount=1000,
                                                  Business_Unit_A__c=null,
                     							  Sales_Segment__c=null,
                                                  Approval_Status__c='N/A',
                     							  Approver_Opportunity_Manager__c=null,
                     							  Approver_Opportunity_Upper_Manager_c__c=null,
                     							  Approvers_for_BU_General_Manager__c=null,
                     							  Approvers_for_CFO__c=null,
                     							  Approver_TDWI_Owner_Manager_1__c=null,
                     							  Approver_TDWI_Owner_Manager_2__c=null,
                     							  Approver_TDWI_Owner_Manager_3__c=null,
                     							  Approvers_For_Account__c=null,
                     							  Approvers_For_Supplier__c=null, 
                     							  Approvers_For_Finance__c=null,
                     							  Sent_to_SAP__c = false,
                                                  RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GENERIC_SALESRT').getRecordTypeId());
				addOppList.add(opp2);
                insert addOppList;
                 
                 opp.Approver_Opportunity_Manager__c = testApprover.Id;
                 update opp;
                 
                List<Opportunity> updateOppList = new List<Opportunity>();
                 
               opp2.Business_Unit_A__c = NULL;
               opp2.Sales_Segment__c = NULL;
               updateOppList.add(opp2);  
                 
            /*   opp.StageName = 'Closed Won';
               updateOppList.add(opp);
                 
                 update updateOppList;
                 
               opp2.StageName = 'Closed Won';
               update opp2;  */

             }

   // }
    
    public static void createBaseTestDataInternational() {
        	CheckExecuteAnonymous.changeRun(false);
        	//Create Test Users
        	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        	List<User> users=new List<User>();
        	User testApprover=new User(LastName='TestApp',UserName='approver@testapprover.co'
                                       ,Email='approver@test.com',Alias='testapp'
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                       ,ProfileId=p.Id,Functional_Title_Group__c='CFO',isActive=TRUE);
        	User testUser=new User(LastName='TestName',UserName='erntest@testuser.com'
                                  	   ,Email='erntest@test.com',Alias='testus1'
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                  	   ,ProfileId=p.Id,ManagerId=testApprover.Id,isActive=TRUE);
        	
        	users.add(testApprover);
        	users.add(testUser);
        	insert users;
        
        	testUser.Upper_Manager__c=testApprover.Id;
        	testUser.FI_APP_ACCT__c=testApprover.Id;
        	update testUser;
        
            System.RunAs(testUser)
             {
               	    //Create Test Business Unit
                    Business_Unit__c bu=new Business_Unit__c();
                    bu.Name='International';
                 	bu.OwnerId=testApprover.Id;
                    insert bu;
                 
                 	//Create Test Sales Segment
                    Sales_Segments__c ss=new Sales_Segments__c(Name='APAC',Business_Unit__c=bu.Id);      
                    insert ss;        
                 
                 	SS_Members__c ssm=new SS_Members__c(Name=testuser.lastname,Member__c=testuser.Id,Sales_Segments__c=ss.Id);
                 	insert ssm;
                 
                 	//Create Test Technology Domain
                	Technology_Domain__c td=new Technology_Domain__c();
                    td.Name='Test';
                    insert td;
                 
                 	//Create TDBU Queue
                 	TD_BU_QUEUE__c tdbqc=new TD_BU_QUEUE__c();
                    tdbqc.Business_Unit__c=bu.Id;
                    tdbqc.Technology_Domain__c=td.Id;
                    tdbqc.Name='TEST';
                    tdbqc.Type__c='Service consultancy';
                    insert tdbqc;
                 
                    //Create Test Accounts
                    List<Account> accts = new List<Account>();
                    //Test Customer Account
                    Account cus = new Account(OwnerId=testUser.Id,Name='TestAccount',Commercial_Title__c='TestAccount',Account_Description__c='Test Description'
                                           ,CurrencyIsoCode='USD',AccountNumber='123', SAP_Account_No__c='0000012345'/*,Tax_Id__c='40946931310' */
                                           ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()
                                           ,Sales_Segments__c=ss.Id,Business_Unit_Map__c=bu.Id,Tax_Id__c = '8400392081'
                                           ,Payment_Term__c=1,Estimated_Installments__c=2,Estimated_Invoice_Monthly_Term__c=2
                                           ,Due_Upon__c=1);
                    accts.add(cus);
                    //Test Vendor Account
                    Account ven = new Account(OwnerId=testUser.Id,Name='TestAccount',Commercial_Title__c='TestAccount',Account_Description__c='Test Description'
                                           ,CurrencyIsoCode='USD',AccountNumber='123',Vendor_Tax_Id__c = '8400392081'
                                           ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId()
                                           ,Payment_Term__c=1,Estimated_Installments__c=2,Estimated_Invoice_Monthly_Term__c=2
                                           ,Due_Upon__c=1);
                    accts.add(ven);
                    insert accts;
                 
                 List<ProcessInstanceWorkItem> pwiList=[select id from ProcessInstanceWorkItem];
                 for(ProcessInstanceWorkItem pwi : pwiList)
                 {
                    // Instantiate the new ProcessWorkitemRequest object and populate it
                    Approval.ProcessWorkitemRequest req2 = 
                        new Approval.ProcessWorkitemRequest();
                    req2.setComments('Approving request.');
                    req2.setAction('Approve');
                    req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    
                    // Use the ID from the newly created item to specify the item to be worked
                    req2.setWorkitemId(pwi.Id);
                    
                    // Submit the request for approval
                    Approval.ProcessResult result2 =  Approval.process(req2);
                 }
                 //Create Products
                Product2 salProd = new Product2(Name = 'Laptop X200',
                                     Family = td.Name,Technology_Domain__c=td.Id,ProductCode='SALES',isActive=true);
                Product2 solProd = new Product2(Name = 'Laptop X200',
                                     Family = td.Name,Technology_Domain__c=td.Id,ProductCode='',isActive=true);
				List<Product2> proList=new List<Product2>();
                 proList.add(salProd);
                 proList.add(solProd);
                 insert proList;
                 
                 //Create Pricebooks
                Id pricebookId = Test.getStandardPricebookId();
                
                Pricebook2 salesPB = new Pricebook2(Name='Sales Price Book',isActive = true);
                Pricebook2 solutionPB = new Pricebook2(Name='Solution Price Book', isActive=true);
                Pricebook2 solutionPB2 = new Pricebook2(Name='Public Solution Price Book', isActive = true);
                 List<Pricebook2> pbList=new List<Pricebook2>();
                 pbList.add(salesPB);
                 pbList.add(solutionPB);
                 pbList.add(solutionPB2);
				insert pbList;
                 
                 //Create PricebookEntries
                 PricebookEntry standardPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = pricebookId, Product2Id = salProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                 PricebookEntry standardSolPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = pricebookId, Product2Id = solProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                PricebookEntry salesPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = salesPB.Id, Product2Id = salProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                PricebookEntry solutionPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = solutionPB.Id, Product2Id = solProd.Id,
                                                                    UnitPrice = 12000, IsActive = true);
				List<PricebookEntry> pbeList=new List<PricebookEntry>();
                 pbeList.add(standardPrice);
                 pbeList.add(standardSolPrice);
                 pbeList.add(salesPrice);
                 pbeList.add(solutionPrice);
                 insert pbeList;
                 
                 List<Opportunity> addOppList = new List<Opportunity>();
                 //Create Opportunity
                 Opportunity opp = new Opportunity(
                     							  OwnerId=testUser.Id,
                     							  Name='TestDataFactory1',
                                                  Account = cus,
                                                  NextStep='test',
                                                  PriceBook2 = salesPB,
                                                  CloseDate = System.today(),
                                                  AccountId=cus.Id,
                                                  StageName='Prospecting',
                                                  Probability=100,
                                                  My_Forecast__c='Pipeline',
                                                  Count_Of_TDWI__c=0,
                                                  Count_Of_Completed_TDWI__c=0,
                                                  CurrencyIsoCode='USD',
                     							  Opportunity_Probability__c = 60,
                                                  Estimated_Installments__c=3,
                                                  Estimated_Invoice_Date__c=system.today(),
                                                  Estimated_Invoice_Monthly_Term__c=1,
                                                  Amount=1000,
                                                  Business_Unit_A__c=bu.Id,
                     							  Sales_Segment__c=ss.Id,
                                                  Approval_Status__c='N/A',
                     							  Approver_Opportunity_Manager__c=null,
                     							  Approver_Opportunity_Upper_Manager_c__c=null,
                     							  Approvers_for_BU_General_Manager__c=null,
                     							  Approvers_for_CFO__c=null,
                     							  Approver_TDWI_Owner_Manager_1__c=null,
                     							  Approver_TDWI_Owner_Manager_2__c=null,
                     							  Approver_TDWI_Owner_Manager_3__c=null,
                     							  Approvers_For_Account__c=null,
                     							  Approvers_For_Supplier__c=null, 
                     							  Approvers_For_Finance__c=null,
                     							  Sent_to_SAP__c = false,
                                                  RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EB_GI').getRecordTypeId());
				addOppList.add(opp);
                 
                 
                 
                 
                 Opportunity opp2 = new Opportunity(
                     							  OwnerId=testUser.Id,
                     							  Name='TestDataFactory2',
                                                  Account = cus,
                                                  NextStep='test',
                                                  PriceBook2 = salesPB,
                                                  CloseDate = System.today(),
                                                  AccountId=cus.Id,
                                                  StageName='Prospecting',
                                                  Probability=100,
                                                  My_Forecast__c='Pipeline',
                                                  Count_Of_TDWI__c=0,
                                                  Count_Of_Completed_TDWI__c=0,
                                                  CurrencyIsoCode='USD',
                     							  Opportunity_Probability__c = 60,
                                                  Estimated_Installments__c=3,
                                                  Estimated_Invoice_Date__c=system.today(),
                                                  Estimated_Invoice_Monthly_Term__c=1,
                                                  Amount=1000,
                                                  Business_Unit_A__c=null,
                     							  Sales_Segment__c=null,
                                                  Approval_Status__c='N/A',
                     							  Approver_Opportunity_Manager__c=null,
                     							  Approver_Opportunity_Upper_Manager_c__c=null,
                     							  Approvers_for_BU_General_Manager__c=null,
                     							  Approvers_for_CFO__c=null,
                     							  Approver_TDWI_Owner_Manager_1__c=null,
                     							  Approver_TDWI_Owner_Manager_2__c=null,
                     							  Approver_TDWI_Owner_Manager_3__c=null,
                     							  Approvers_For_Account__c=null,
                     							  Approvers_For_Supplier__c=null, 
                     							  Approvers_For_Finance__c=null,
                     							  Sent_to_SAP__c = false,
                                                  RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GENERIC_SALESRT').getRecordTypeId());
				addOppList.add(opp2);
                insert addOppList;
                 
                 
                List<Opportunity> updateOppList = new List<Opportunity>();
                 
               opp2.Business_Unit_A__c = NULL;
               opp2.Sales_Segment__c = NULL;
               updateOppList.add(opp2);  
                 
               opp.StageName = 'Closed Won';
               updateOppList.add(opp);
                 
                 update updateOppList;
                 
               opp2.StageName = 'Closed Won';
               update opp2;  

             }

    }    
    public static void createBaseTestDataPublic() {
            CheckExecuteAnonymous.changeRun(false);
        	//Create Test Users
        	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        	List<User> users=new List<User>();
        	User testApprover=new User(LastName='TestApp',UserName='approver@testapprover.co'
                                       ,Email='approver@test.com',Alias='testapp'
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                       ,ProfileId=p.Id,Functional_Title_Group__c='CFO',isActive=TRUE);
        	User testUser=new User(LastName='TestName',UserName='erntest@testuser.co'
                                  	   ,Email='erntest@test.com',Alias='testus1'
                                       ,TimeZoneSidKey='GMT',LocaleSidKey='tr_TR'
                                       ,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
                                  	   ,ProfileId=p.Id,ManagerId=testApprover.Id,isActive=TRUE);
        	
        	users.add(testApprover);
        	users.add(testUser);
        	insert users;
        
        	testUser.Upper_Manager__c=testApprover.Id;
        	testUser.FI_APP_ACCT__c=testApprover.Id;
        	update testUser;
            
            System.RunAs(testUser)
             {
                
               	    //Create Test Business Unit
                    Business_Unit__c bu=new Business_Unit__c();
                    bu.Name='Public';
                 	bu.OwnerId=testApprover.Id;
                    insert bu;
                 	//Create Test Sales Segment
                    Sales_Segments__c ss=new Sales_Segments__c(Name='Defense',Business_Unit__c=bu.Id);      
                    insert ss;
                 	SS_Members__c ssm=new SS_Members__c(Name=testuser.lastname,Member__c=testuser.Id,Sales_Segments__c=ss.Id);
                 	insert ssm;
                 	//Create Test Technology Domain
                	Technology_Domain__c td=new Technology_Domain__c();
                    td.Name='Test';
                    insert td;
                 	//Create TDBU Queue
                 	TD_BU_QUEUE__c tdbqc=new TD_BU_QUEUE__c();
                    tdbqc.Business_Unit__c=bu.Id;
                    tdbqc.Technology_Domain__c=td.Id;
                    tdbqc.Name='TEST';
                    tdbqc.Type__c='Service consultancy';
                    insert tdbqc;
                    //Create Test Accounts
                    List<Account> accts = new List<Account>();
                    //Test Customer Account
                    Account cus = new Account(OwnerId=testUser.Id,Name='TestAccount',Commercial_Title__c='TestAccount',Account_Description__c='Test Description'
                                           ,CurrencyIsoCode='USD',AccountNumber='123'
                                           ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()
                                           ,Sales_Segments__c=ss.Id,Business_Unit_Map__c=bu.Id
                                           ,Payment_Term__c=1,Estimated_Installments__c=2,Estimated_Invoice_Monthly_Term__c=2
                                           ,Due_Upon__c=1);
                    accts.add(cus);
                    //Test Vendor Account
                    Account ven = new Account(OwnerId=testUser.Id,Name='TestAccount',Commercial_Title__c='TestAccount',Account_Description__c='Test Description'
                                           ,CurrencyIsoCode='USD',AccountNumber='123'
                                           ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId()
                                           ,Payment_Term__c=1,Estimated_Installments__c=2,Estimated_Invoice_Monthly_Term__c=2
                                           ,Due_Upon__c=1);
                    accts.add(ven);
                    insert accts;
                 List<ProcessInstanceWorkItem> pwiList=[select id from ProcessInstanceWorkItem];
                 for(ProcessInstanceWorkItem pwi : pwiList)
                 {
                    // Instantiate the new ProcessWorkitemRequest object and populate it
                    Approval.ProcessWorkitemRequest req2 = 
                        new Approval.ProcessWorkitemRequest();
                    req2.setComments('Approving request.');
                    req2.setAction('Approve');
                    req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    
                    // Use the ID from the newly created item to specify the item to be worked
                    req2.setWorkitemId(pwi.Id);
                    
                    // Submit the request for approval
                    Approval.ProcessResult result2 =  Approval.process(req2);
                 }
                 //Create Products
                Product2 salProd = new Product2(Name = 'Laptop X200',
                                     Family = td.Name,Technology_Domain__c=td.Id,ProductCode='SALES',isActive=true);
                Product2 solProd = new Product2(Name = 'Laptop X200',
                                     Family = td.Name,Technology_Domain__c=td.Id,ProductCode='',isActive=true);
				List<Product2> proList=new List<Product2>();
                 proList.add(salProd);
                 proList.add(solProd);
                 insert proList;
                 //Create Pricebooks
                Id pricebookId = Test.getStandardPricebookId();
                
                Pricebook2 salesPB = new Pricebook2(Name='Public Sales Price Book',isActive = true);
                 
                Pricebook2 solutionPB = new Pricebook2(Name='Public Solution Price Book', isActive = true);
                 
                Pricebook2 solutionPB2 = new Pricebook2(Name='Solution Price Book', isActive=true);

                 
                 System.debug('selam cocuklar');
                 
                List<Pricebook2> pbList=new List<Pricebook2>();
                pbList.add(salesPB);
                pbList.add(solutionPB);
                pbList.add(solutionPB2);
				insert pbList;
                 
                 //Create PricebookEntries
                 PricebookEntry standardPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = pricebookId, Product2Id = salProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                 PricebookEntry standardSolPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = pricebookId, Product2Id = solProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                PricebookEntry salesPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = salesPB.Id, Product2Id = salProd.Id,
                                                                    UnitPrice = 10000, IsActive = true);
                PricebookEntry solutionPrice = new PricebookEntry(
                                                                    CurrencyIsoCode='USD',
                                                                    Pricebook2Id = solutionPB.Id, Product2Id = solProd.Id,
                                                                    UnitPrice = 12000, IsActive = true);
				List<PricebookEntry> pbeList=new List<PricebookEntry>();
                 pbeList.add(standardPrice);
                 pbeList.add(standardSolPrice);
                 pbeList.add(salesPrice);
                 pbeList.add(solutionPrice);
                 insert pbeList;
                 //Create Opportunity
                 Opportunity opp = new Opportunity(
                     							  OwnerId=testUser.Id,
                     							  Name='TestDataFactory1',
                                                  Account = cus,
                                                  NextStep='test',
                                                  PriceBook2 = salesPB,
                                                  CloseDate = System.today(),
                                                  AccountId=cus.Id,
                                                  StageName='Prospecting',
                                                  Probability=100,
                     							  Opportunity_Probability__c = 60,
                                                  My_Forecast__c='Pipeline',
                                                  Count_Of_TDWI__c=0,
                                                  Count_Of_Completed_TDWI__c=0,
                                                  CurrencyIsoCode='USD',
                                                  Estimated_Installments__c=3,
                                                  Estimated_Invoice_Date__c=system.today(),
                                                  Estimated_Invoice_Monthly_Term__c=1,
                                                  Amount=1000,
                                                  Business_Unit_A__c=bu.Id,
                     							  Sales_Segment__c=ss.Id,
                                                  Approval_Status__c='N/A',
                     							  Approver_Opportunity_Manager__c=null,
                     							  Approver_Opportunity_Upper_Manager_c__c=null,
                     							  Approvers_for_BU_General_Manager__c=null,
                     							  Approvers_for_CFO__c=null,
                     							  Approver_TDWI_Owner_Manager_1__c=null,
                     							  Approver_TDWI_Owner_Manager_2__c=null,
                     							  Approver_TDWI_Owner_Manager_3__c=null,
                     							  Approvers_For_Account__c=null,
                     							  Approvers_For_Supplier__c=null,
                     							  Approvers_For_Finance__c=null,
                     							  Sent_to_SAP__c = false,
                                                  RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EB_GI').getRecordTypeId());
				insert opp;
                 
                 
                   Opportunity opp2 = new Opportunity(
                     							  OwnerId=testUser.Id,
                     							  Name='TestDataFactory2',
                                                  Account = cus,
                                                  NextStep='test',
                                                  PriceBook2 = salesPB,
                                                  CloseDate = System.today(),
                                                  AccountId=cus.Id,
                                                  StageName='Prospecting',
                                                  Probability=100,
                                                  My_Forecast__c='Pipeline',
                                                  Count_Of_TDWI__c=0,
                                                  Count_Of_Completed_TDWI__c=0,
                                                  CurrencyIsoCode='USD',
                     							  Opportunity_Probability__c = 60,
                                                  Estimated_Installments__c=3,
                                                  Estimated_Invoice_Date__c=system.today(),
                                                  Estimated_Invoice_Monthly_Term__c=1,
                                                  Amount=1000,
                                                  Business_Unit_A__c=null,
                     							  Sales_Segment__c=null,
                                                  Approval_Status__c='N/A',
                     							  Approver_Opportunity_Manager__c=null,
                     							  Approver_Opportunity_Upper_Manager_c__c=null,
                     							  Approvers_for_BU_General_Manager__c=null,
                     							  Approvers_for_CFO__c=null,
                     							  Approver_TDWI_Owner_Manager_1__c=null,
                     							  Approver_TDWI_Owner_Manager_2__c=null,
                     							  Approver_TDWI_Owner_Manager_3__c=null,
                     							  Approvers_For_Account__c=null,
                     							  Approvers_For_Supplier__c=null, 
                     							  Approvers_For_Finance__c=null,
                     							  Sent_to_SAP__c = false,
                                                  RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EB_GI').getRecordTypeId());
				insert opp2; 
                 
                 opp.StageName = 'Closed Won';
                 update opp;
                 
                 opp2.StageName = 'Closed Lost';
                 update opp2;  
             
             }
 
    }
    
    //usage example
    /*
     static testmethod void test1() {
        TestDataFactory.createBaseTestData();
        User testUser=[select id from user where Alias='testus'];
        Business_Unit__c bu=[select id from Business_Unit__c];
        Sales_Segments__c ss=[select id from Sales_Segments__c];
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
        
        
         
         
         
    }
	*/

}