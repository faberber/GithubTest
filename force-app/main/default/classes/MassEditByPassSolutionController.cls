public class MassEditByPassSolutionController {
    
    public String oppId{get;set;}
    
    //Product Variables    
    public String objectType{get;set;}
    public String operationType{get;set;}
    public String daysCustomerBilling{get;set;}
    public String daysVendorBilling{get;set;}
    
    public OpportunityLineItem tempOpportunityProduct{get;set;}
    public Decimal totalOpportunityProductAmount{get;set;}
    public Decimal totalOpportunityProductAmountUSD{get;set;}
    public Decimal totalOpportunityProductCost{get;set;}
    public Decimal totalOpportunityProductRebate {get;set;}
    public Boolean tempProductError{get;set;}
    
    public Customer_Billing__c tempCustomer{get;set;}
    public Integer customerUnit{get;set;}
    public Integer customerPeriod{get;set;}
    public Decimal totalCustomerAmount{get;set;}
    public Decimal totalCustomerAmountUSD{get;set;}
    public Boolean tempCustomerError{get;set;}
    
    public Vendor__c tempVendor{get;set;}
    public Integer vendorUnit{get;set;}
    public Integer vendorPeriod{get;set;}
    public Decimal totalVendorAmount{get;set;}
    public Decimal totalVendorAmountUSD{get;set;}
    public Boolean tempVendorError{get;set;}
    
    public List<OpportunityLineItem> opportunityProductList{get;set;}
    public List<Customer_Billing__c> customerBillingList{get;set;}
    public List<Vendor__c> vendorBillingList{get;set;}
    public Map<String,Boolean> deleteRecordsMap{get;set;}
    public Opportunity tempOpp{get;set;}
    public string CurrencyCode;
    public MassEditByPassSolutionController(ApexPages.StandardController stdController){
        tempOpp = new Opportunity();
        tempOpp = (Opportunity) stdController.getRecord();
        tempOpp=[select id,Estimated_Solution_Segment__c, By_Pass_Solution__c, CurrencyIsoCode from Opportunity where id=:tempOpp.Id LIMIT 1];
        oppId = tempOpp.id;
        CurrencyCode = tempOpp.CurrencyIsoCode;
        init();
    }
    
    private void init(){
        
        tempOpportunityProduct = new OpportunityLineItem(OpportunityId = oppId);
        totalOpportunityProductAmount = 0;
        totalOpportunityProductAmountUSD = 0;
        totalOpportunityProductCost = 0;
        totalOpportunityProductRebate = 0;
        tempProductError = false;
        
        
        tempCustomer = new Customer_Billing__c(Opportunity__c = oppId);
        customerUnit = null;
        customerPeriod = null;
        totalCustomerAmount = 0;
        totalCustomerAmountUSD = 0;
        tempCustomerError = false;
            
        tempVendor = new Vendor__c();
        vendorUnit = null;
        vendorPeriod = null;
        totalVendorAmount = 0;
        totalVendorAmountUSD = 0;
        tempVendorError = false;
        
        objectType = '';
        operationType = '';
        daysCustomerBilling = '';
        daysVendorBilling = '';
        
      
        opportunityProductList = new List<OpportunityLineItem>();
        customerBillingList = new List<Customer_Billing__c>();
        vendorBillingList = new List<Vendor__c>();
        deleteRecordsMap = new Map<String,Boolean>();
        
        
        
        opportunityProductList  = [SELECT id,Product2Id,Product2.Name,ProductByPass__c,ProductByPass__r.Name,PricebookEntryId, Cost__c, UnitPrice, Solution_Type__c,Rebate_USD__c,Vendor__c, Manufacturer__c FROM OpportunityLineItem WHERE OpportunityId =: oppId];
        fillMap(opportunityProductList);
        
        customerBillingList = [SELECT Name, Billing_Date__c, Due_Upon_c__c, Payment_Date__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM 
                                    Customer_Billing__c WHERE Opportunity__c =: oppId];
        fillMap(customerBillingList);
        
        
        vendorBillingList = [SELECT Name, Billing_Date__c, Due_Upon__c, Payment_Date__c, Vendor__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM 
                                Vendor__c WHERE Opportunity__c =: oppId];
        fillMap(vendorBillingList);
        
         for(OpportunityLineItem OpportunityProduct : opportunityProductList){
            if(OpportunityProduct.Cost__c != null)
            { 
                totalOpportunityProductCost += OpportunityProduct.Cost__c;
            } 
            if(OpportunityProduct.UnitPrice != null)
            {
                totalOpportunityProductAmountUSD += OpportunityProduct.UnitPrice;                
            }           
            if(OpportunityProduct.Rebate_USD__c != null)
            {
                totalOpportunityProductRebate += OpportunityProduct.Rebate_USD__c; 
            }
        }
                
        for(Customer_Billing__c customer : customerBillingList){
            if(customer.N_Billing_Amount__c != null) totalCustomerAmount += customer.N_Billing_Amount__c;
            if(customer.N_Billing_Amount_USD__c != null) totalCustomerAmountUSD += customer.N_Billing_Amount_USD__c;
        }      
        
        
        for(Vendor__c vendor : vendorBillingList){
            if(vendor.N_Billing_Amount__c != null) totalVendorAmount += vendor.N_Billing_Amount__c;
            if(vendor.N_Billing_Amount_USD__c != null) totalVendorAmountUSD += vendor.N_Billing_Amount_USD__c;
        }
        
    }
    
    private void fillMap(List<sObject> sObjList){
        for(sObject sObj : sObjList){
            deleteRecordsMap.put(sObj.id,false);
        }
    }
    
    public void addRow(){
        
        PricebookEntry tempPricebookEntry;
        
        if(objectType.equalsIgnoreCase('OpportunityProduct')){
            if(tempOpportunityProduct!= NULL)
            {
                 
                if( tempOpp.By_Pass_Solution__c != 'Yes' && (tempOpportunityProduct.UnitPrice == NULL || tempOpportunityProduct.Cost__c == NULL || tempOpportunityProduct.Solution_Type__c == NULL || tempOpportunityProduct.Vendor__c == NULL ))
                {	
                    tempCustomerError = false;
                    tempVendorError = false;
                    tempProductError = true;
                    tempOpportunityProduct.addError('All Product fields must be filled except Rebate & Manufacturer !');
                   
                } 
                else
                { 
                    Account vnd=[select Id,Name from Account where Id=:tempOpportunityProduct.Vendor__c LIMIT 1];
                    System.debug(vnd);
                    System.debug(tempOpp);
                    System.debug(tempOpportunityProduct);
                    if( tempOpp.By_Pass_Solution__c == 'Yes' && tempOpp.Estimated_Solution_Segment__c =='Product Resell' && tempOpportunityProduct.Solution_Type__c != 'Product consultancy' )
                    {
                      system.debug(totalOpportunityProductAmountUSD);
                      tempOpportunityProduct.addError('You should choose "Product Consultancy" for Solution Type !');
                        tempCustomerError = false;
                        tempProductError = false;
                        tempProductError = true;  
                    }
                    else if( tempOpp.By_Pass_Solution__c == 'Yes' && tempOpp.Estimated_Solution_Segment__c =='Microsoft' && !vnd.Name.containsIgnoreCase('microsoft'))
                    {
                        tempOpportunityProduct.addError('Vendor should be one of Microsoft Accounts !');
                        tempCustomerError = false;
                        tempProductError = false;
                        tempProductError = true;  
                    }
                    else{
                  totalOpportunityProductAmountUSD+=tempOpportunityProduct.UnitPrice;  
                        
                    }   
 
                      
                  tempPricebookEntry = [SELECT Id,IsActive,Product2Id, Product2.Name, CurrencyIsoCode  FROM PricebookEntry WHERE Product2Id=:tempOpportunityProduct.ProductByPass__c  AND CurrencyIsoCode =: CurrencyCode AND Pricebook2.Name='Solution Price Book'];
            	
                  opportunityProductList.add(new OpportunityLineItem(OpportunityId = oppId, ProductByPass__c = tempOpportunityProduct.ProductByPass__c, Quantity=1,PricebookEntryId=tempPricebookEntry.Id, Cost__c = tempOpportunityProduct.Cost__c,UnitPrice=tempOpportunityProduct.UnitPrice,Solution_Type__c = tempOpportunityProduct.Solution_Type__c,
                                            Rebate_USD__c = tempOpportunityProduct.Rebate_USD__c, Vendor__c = tempOpportunityProduct.Vendor__c, Manufacturer__c = tempOpportunityProduct.Manufacturer__c));
                
                }
            }
         
            
        } 
        
          else if(objectType.equalsIgnoreCase('CustomerBilling')){
           if(tempCustomer.N_Billing_Amount__c == NULL || tempCustomer.Billing_Date__c == NULL || tempCustomer.Due_Upon_c__c == NULL)
                {
                    tempVendorError = false;
                    tempProductError = false;
                    tempCustomerError = true;
                    tempCustomer.addError('All Customer Billing fields must be filled except Unit and Peroid'); 
                    
                }
              else{
                  if(customerUnit==0)
                  {
                      customerUnit=1;
                      system.debug(customerUnit);
                  }
                  if(customerPeriod==0)
                  {
                      customerPeriod=1;
                  }
              while(customerUnit > 0){  
                 
                  
                customerBillingList.add(new Customer_Billing__c(Opportunity__c = oppId,Billing_Date__c=tempCustomer.Billing_Date__c,Due_Upon_c__c=tempCustomer.Due_Upon_c__c,
                                            N_Billing_Amount__c=tempCustomer.N_Billing_Amount__c,CurrencyIsoCode=tempCustomer.CurrencyIsoCode));
                       
                
                  
                if(tempCustomer.Billing_Date__c != null && customerPeriod > 0) tempCustomer.Billing_Date__c = tempCustomer.Billing_Date__c.addMonths(customerPeriod);
                customerUnit--;
                   }
                  	
                  }
            //tempCustomer = new Customer_Billing__c(Opportunity__c = oppId);
            customerUnit = null;
            customerPeriod = null;
              
        }else if(objectType.equalsIgnoreCase('VendorBilling')){
            
            if(tempVendor.N_Billing_Amount__c == NULL || tempVendor.Vendor__c== NULL || tempVendor.Billing_Date__c == NULL || tempVendor.Due_Upon__c == NULL)
                {
                    tempProductError = false;
                    tempCustomerError = false;
                    tempVendorError = true;
                    tempCustomer.addError('All Vendor Billing fields must be filled except Unit and Peroid');                      
                }
              else{
                   
                  if(vendorUnit==0)
                  {
                      vendorUnit=1;
                  }
                  if(vendorPeriod==0)
                  {
                      vendorPeriod=1;
                  }
                  
            while(vendorUnit > 0){
                vendorBillingList.add(new Vendor__c(Opportunity__c=oppId,Billing_Date__c=tempVendor.Billing_Date__c,Due_Upon__c=tempVendor.Due_Upon__c,
                                        Vendor__c=tempVendor.Vendor__c,N_Billing_Amount__c=tempVendor.N_Billing_Amount__c,CurrencyIsoCode=tempVendor.CurrencyIsoCode));
                if(tempVendor.Billing_Date__c != null && vendorPeriod > 0) tempVendor.Billing_Date__c = tempVendor.Billing_Date__c.addMonths(vendorPeriod);
                vendorUnit--;
                   }
                  }
            //tempVendor = new Vendor__c();
            vendorUnit = null;
            vendorPeriod = null;
        }
    }
    
    public void deleteRecords(){
        List<Id> deleteList = new List<Id>();
        for(String recId : deleteRecordsMap.keyset()){
            if(deleteRecordsMap.get(recId) == true) deleteList.add(recId);
        }
        try{
            Database.delete(deleteList, true);
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        init();
    }
    
    private List<Id> selectedRecords(String objectName){
        List<Id> deleteList = new List<Id>();
        for(String recId : deleteRecordsMap.keyset()){
            String prefix = Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix()+'';
            if(recId.startsWith(prefix)){
                if(deleteRecordsMap.get(recId) == true) deleteList.add(recId);
            }
        }
        return deleteList;
    }
    
    public void clonePartial(){
        try{
              if(objectType.equalsIgnoreCase('OpportunityProduct')){
                List<OpportunityLineItem> tempList = new List<OpportunityLineItem>();
                for(OpportunityLineItem OpportunityProduct : [SELECT PricebookEntryId, Opportunity.Estimated_Solution_Segment__c, PricebookEntry.Product2Id, ProductByPass__c, OpportunityId, Cost__c, UnitPrice, Solution_Type__c, Rebate_USD__c, Vendor__c, Manufacturer__c FROM OpportunityLineItem WHERE ID =: selectedRecords('OpportunityLineItem')]){
                    OpportunityLineItem tempOpportunityProduct = OpportunityProduct.clone(false, true, false, false);
                    tempList.add(tempOpportunityProduct);
                }
                insert tempList;
              } 
            else if(objectType.equalsIgnoreCase('CustomerBilling')){
                List<Customer_Billing__c> tempList = new List<Customer_Billing__c>();
                for(Customer_Billing__c customerBilling : [SELECT Name, Opportunity__c, Billing_Date__c, Due_Upon_c__c, Payment_Date__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM Customer_Billing__c WHERE ID =: selectedRecords('Customer_Billing__c')]){
                    Customer_Billing__c tempcustomerBilling = customerBilling.clone(false, true, false, false);
                    tempList.add(tempcustomerBilling);
                }
                insert tempList;
            
            }else if(objectType.equalsIgnoreCase('VendorBilling')){
                List<Vendor__c> tempList = new List<Vendor__c>();
                for(Vendor__c vendor : [SELECT Name, Opportunity__c, Billing_Date__c, Due_Upon__c, Payment_Date__c, Vendor__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM Vendor__c WHERE ID =: selectedRecords('Vendor__c')]){
                    Vendor__c tempVendor = vendor.clone(false, true, false, false);
                    tempList.add(tempVendor);
                }
                insert tempList;
            }
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        init();
    }
    
    public void deletePartial(){
        try{ 
            if(objectType.equalsIgnoreCase('OpportunityProduct')){
                Database.delete(selectedRecords('OpportunityLineItem'), true);
            }else if(objectType.equalsIgnoreCase('CustomerBilling')){
                Database.delete(selectedRecords('Customer_Billing__c'), true);
            }else if(objectType.equalsIgnoreCase('VendorBilling')){
                Database.delete(selectedRecords('Vendor__c'), true);
            }
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        init();
    }
    
    public void savePartial(){
        
       boolean isUpserted=false;

        try{
            if (objectType.equalsIgnoreCase('OpportunityProduct')){
                
                boolean opportunityProductHasError=false;
                for(OpportunityLineItem oli:opportunityProductList)
                {
                    Account vnd=[select id,name from Account where id=:oli.Vendor__c LIMIT 1];
                    System.debug(vnd);
                    System.debug(tempOpp);
                    System.debug(oli);
                    if( tempOpp.By_Pass_Solution__c == 'Yes' && tempOpp.Estimated_Solution_Segment__c =='Product Resell' && oli.Solution_Type__c != 'Product consultancy' )
                    {
                      system.debug(totalOpportunityProductAmountUSD);
                      tempOpportunityProduct.addError('You should choose "Product Consultancy" for Solution Type !');
                        tempCustomerError = false;
                        tempVendorError = false;
                        tempProductError = true;  
                        opportunityProductHasError=true;
                        break;
                    }
                	else if( tempOpp.By_Pass_Solution__c == 'Yes' && tempOpp.Estimated_Solution_Segment__c =='Microsoft' && !vnd.Name.containsIgnoreCase('microsoft'))
                    {
                        tempOpportunityProduct.addError('Vendor should be one of Microsoft Accounts !');
                        tempCustomerError = false;
                        tempVendorError = false;
                        tempProductError = true;  
                        opportunityProductHasError=true;
                        break;
                    }
                    
                    
                  system.debug(oli);
                  system.debug(tempOpp);
                  system.debug(vnd);


				
           		}
                if(!opportunityProductHasError)
                {
                     upsert opportunityProductList; 
                    isUpserted=true;
                }
                       
            }else if(objectType.equalsIgnoreCase('CustomerBilling')){
                upsert customerBillingList;
                isUpserted=true;

            }else if(objectType.equalsIgnoreCase('VendorBilling')){
                upsert vendorBillingList;
                isUpserted=true;

            }
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        if(isUpserted)
        {init();}
    }
    
    public pageReference changeDate(){
        if(objectType.equalsIgnoreCase('CustomerBilling')){
            if(daysCustomerBilling == null || daysCustomerBilling.trim() == '') return null;
            Integer numberOfDays = Integer.valueOf(daysCustomerBilling);
            if(operationType.equalsIgnoreCase('Prepone')) numberOfDays = numberOfDays - (numberOfDays * 2);
            for(Customer_Billing__c customerBilling : customerBillingList){
                if(customerBilling.Billing_Date__c != null) customerBilling.Billing_Date__c = customerBilling.Billing_Date__c.addDays(numberOfDays);
            }
            upsert customerBillingList;
       
        }else if(objectType.equalsIgnoreCase('VendorBilling')){
            if(daysVendorBilling == null || daysVendorBilling.trim() == '') return null;
            Integer numberOfDays = Integer.valueOf(daysVendorBilling);
            if(operationType.equalsIgnoreCase('Prepone')) numberOfDays = numberOfDays - (numberOfDays * 2);
            for(Vendor__c vendor : vendorBillingList){
                if(vendor.Billing_Date__c != null) vendor.Billing_Date__c = vendor.Billing_Date__c.addDays(numberOfDays);
            }
            upsert vendorBillingList;
        }
        init();
        return null;
    }
    
    public void saveDetails(){
        try{
             totalOpportunityProductAmountUSD=0;
                for(OpportunityLineItem oli:opportunityProductList)
                {
                    totalOpportunityProductAmountUSD += oli.UnitPrice; 
                }
            upsert opportunityProductList;  
            upsert opportunityProductList;
            upsert customerBillingList;
            upsert vendorBillingList;
            init();
            if(Test.isRunningTest())
            {
                Integer a=10/0;//create exception for test
            }
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
    }    
    
}