public class OpportunityMassEditController {
    
    public String oppId{get;set;}
    
    //Product Variables    
    public String objectType{get;set;}
    public String operationType{get;set;}
    public String daysCustomerBilling{get;set;}
    public String daysRevenue{get;set;}
    public String daysVendorBilling{get;set;}
    public String daysPayment{get;set;}
    
    public Customer_Billing__c tempCustomer{get;set;}
    public Integer customerUnit{get;set;}
    public Integer customerPeriod{get;set;}
    public Decimal totalCustomerAmount{get;set;}
    public Decimal totalCustomerAmountUSD{get;set;}
    
    public Revenue__c tempRevenue{get;set;}
    public Integer revenueUnit{get;set;}
    public Integer revenuePeriod{get;set;}
    public Decimal totalReveneuAmount{get;set;}
    public Decimal totalRevenueAmountUSD{get;set;}
    
    public Vendor__c tempVendor{get;set;}
    public Integer vendorUnit{get;set;}
    public Integer vendorPeriod{get;set;}
    public Decimal totalVendorAmount{get;set;}
    public Decimal totalVendorAmountUSD{get;set;}
    
    public Payment__c tempPayment{get;set;}
    public Integer paymentUnit{get;set;}
    public Integer paymentPeriod{get;set;}
    public Decimal totalPayment{get;set;}
    public Decimal totalPaymentUSD{get;set;}
    
    public List<Customer_Billing__c> customerBillingList{get;set;}
    public List<Revenue__c> reveuneList{get;set;}
    public List<Vendor__c> vendorBillingList{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public Map<String,Boolean> deleteRecordsMap{get;set;}
    
    public OpportunityMassEditController(ApexPages.StandardController stdController){
        Opportunity tempOpp = new Opportunity();
        tempOpp = (Opportunity) stdController.getRecord();
        oppId = tempOpp.id;
        init();
    }
    
    private void init(){
        tempCustomer = new Customer_Billing__c(Opportunity__c = oppId);
        customerUnit = null;
        customerPeriod = null;
        totalCustomerAmount = 0;
        totalCustomerAmountUSD = 0;
        
        tempRevenue = new Revenue__c();
        revenueUnit = null;
        revenuePeriod = null;
        totalReveneuAmount = 0;
        totalRevenueAmountUSD = 0;
        
        tempVendor = new Vendor__c();
        vendorUnit = null;
        vendorPeriod = null;
        totalVendorAmount = 0;
        totalVendorAmountUSD = 0;
        
        tempPayment = new Payment__c();
        paymentUnit = null;
        paymentPeriod = null;
        totalPayment = 0;
        totalPaymentUSD = 0;
        
        objectType = '';
        operationType = '';
        daysCustomerBilling = '';
        daysRevenue = '';
        daysVendorBilling = '';
        daysPayment = '';
        
        customerBillingList = new List<Customer_Billing__c>();
        reveuneList = new List<Revenue__c>();
        vendorBillingList = new List<Vendor__c>();
        paymentList = new List<Payment__c>();
        deleteRecordsMap = new Map<String,Boolean>();
        
        customerBillingList = [SELECT Name, Billing_Date__c, Due_Upon_c__c, Payment_Date__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM 
                                    Customer_Billing__c WHERE Opportunity__c =: oppId];
        fillMap(customerBillingList);
        
        reveuneList = [SELECT Name, Revenue_Date__c, Revenue_Amount__c, Currency__c, Revenue_Amount_Usd__c FROM Revenue__c WHERE Opportunity__c =: oppId];
        fillMap(reveuneList);
        
        vendorBillingList = [SELECT Name, Billing_Date__c, Due_Upon__c, Payment_Date__c, Vendor__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM 
                                Vendor__c WHERE Opportunity__c =: oppId];
        fillMap(vendorBillingList);
        
        paymentList = [SELECT Name, Date__c , Amount__c, Payment_Amount_USD__c, Currency__c FROM Payment__c WHERE Opportunity__c =: oppId];
        fillMap(paymentList);
                
        for(Customer_Billing__c customer : customerBillingList){
            if(customer.N_Billing_Amount__c != null) totalCustomerAmount += customer.N_Billing_Amount__c;
            if(customer.N_Billing_Amount_USD__c != null) totalCustomerAmountUSD += customer.N_Billing_Amount_USD__c;
        }
        
        for(Revenue__c revenue : reveuneList){
            if(revenue.Revenue_Amount__c != null) totalReveneuAmount += revenue.Revenue_Amount__c;
            if(revenue.Revenue_Amount_Usd__c != null) totalRevenueAmountUSD += revenue.Revenue_Amount_Usd__c;
        }
        
        for(Vendor__c vendor : vendorBillingList){
            if(vendor.N_Billing_Amount__c != null) totalVendorAmount += vendor.N_Billing_Amount__c;
            if(vendor.N_Billing_Amount_USD__c != null) totalVendorAmountUSD += vendor.N_Billing_Amount_USD__c;
        }
        
        for(Payment__c pay : paymentList){
            if(pay.Amount__c != null) totalPayment += pay.Amount__c;
            if(pay.Payment_Amount_USD__c != null) totalPaymentUSD += pay.Payment_Amount_USD__c;
        }
    }
    
    private void fillMap(List<sObject> sObjList){
        for(sObject sObj : sObjList){
            deleteRecordsMap.put(sObj.id,false);
        }
    }
    
    public void addRow(){
        /*if(objectType.equalsIgnoreCase('CustomerBilling')){
            while(customerUnit > 0){
                customerBillingList.add(new Customer_Billing__c(Opportunity__c = oppId,Billing_Date__c=tempCustomer.Billing_Date__c,Due_Upon_c__c=tempCustomer.Due_Upon_c__c,
                                            N_Billing_Amount__c=tempCustomer.N_Billing_Amount__c,CurrencyIsoCode=tempCustomer.CurrencyIsoCode));
                if(tempCustomer.Billing_Date__c != null && customerPeriod > 0) tempCustomer.Billing_Date__c = tempCustomer.Billing_Date__c.addMonths(customerPeriod);
                customerUnit--;
            }
            tempCustomer = new Customer_Billing__c(Opportunity__c = oppId);
            customerUnit = null;
            customerPeriod = null;        
        }*/
        
        if(objectType.equalsIgnoreCase('CustomerBilling')){
                  if(customerUnit==0 || customerUnit == null)
                  {
                      customerUnit=1;
                      system.debug(customerUnit);
                  }
                  if(customerPeriod==0 || customerPeriod== null)
                  {
                      customerPeriod=1;
                  }
              while(customerUnit > 0){  
                 
                  
                customerBillingList.add(new Customer_Billing__c(Opportunity__c = oppId,Billing_Date__c=tempCustomer.Billing_Date__c,Due_Upon_c__c=tempCustomer.Due_Upon_c__c,
                                            N_Billing_Amount__c=tempCustomer.N_Billing_Amount__c,CurrencyIsoCode=tempCustomer.CurrencyIsoCode));
                       
                
                  
                if(tempCustomer.Billing_Date__c != null && customerPeriod > 0) tempCustomer.Billing_Date__c = tempCustomer.Billing_Date__c.addMonths(customerPeriod);
                customerUnit--;
                   }
                  	
                  
            //tempCustomer = new Customer_Billing__c(Opportunity__c = oppId);
            customerUnit = null;
            customerPeriod = null;
              
        }
    
       else if(objectType.equalsIgnoreCase('Revenue')){
            while(revenueUnit > 0){
                reveuneList.add(new Revenue__c(Opportunity__c=oppId,Revenue_Date__c=tempRevenue.Revenue_Date__c,Currency__c=tempRevenue.Currency__c,
                                                Revenue_Amount__c=tempRevenue.Revenue_Amount__c));
                if(tempRevenue.Revenue_Date__c != null && revenuePeriod > 0) tempRevenue.Revenue_Date__c = tempRevenue.Revenue_Date__c.addMonths(revenuePeriod);
                revenueUnit--;
            }
            tempRevenue = new Revenue__c();
            revenueUnit = null;
            revenuePeriod = null;
        }
        
        
        /*else if(objectType.equalsIgnoreCase('VendorBilling')){
            while(vendorUnit > 0){
                vendorBillingList.add(new Vendor__c(Opportunity__c=oppId,Billing_Date__c=tempVendor.Billing_Date__c,Due_Upon__c=tempVendor.Due_Upon__c,
                                        Vendor__c=tempVendor.Vendor__c,N_Billing_Amount__c=tempVendor.N_Billing_Amount__c,CurrencyIsoCode=tempVendor.CurrencyIsoCode));
                if(tempVendor.Billing_Date__c != null && vendorPeriod > 0) tempVendor.Billing_Date__c = tempVendor.Billing_Date__c.addMonths(vendorPeriod);
                vendorUnit--;
            }
            tempVendor = new Vendor__c();
            vendorUnit = null;
            vendorPeriod = null;
        }*/
        else if(objectType.equalsIgnoreCase('VendorBilling')){
            
           
                   
                  if(vendorUnit==0 || vendorUnit==null )
                  {
                      vendorUnit=1;
                  }
                  if(vendorPeriod==0 || vendorPeriod==null )
                  {
                      vendorPeriod=1;
                  }
                  
            while(vendorUnit > 0){
                vendorBillingList.add(new Vendor__c(Opportunity__c=oppId,Billing_Date__c=tempVendor.Billing_Date__c,Due_Upon__c=tempVendor.Due_Upon__c,
                                        Vendor__c=tempVendor.Vendor__c,N_Billing_Amount__c=tempVendor.N_Billing_Amount__c,CurrencyIsoCode=tempVendor.CurrencyIsoCode));
                if(tempVendor.Billing_Date__c != null && vendorPeriod > 0) tempVendor.Billing_Date__c = tempVendor.Billing_Date__c.addMonths(vendorPeriod);
                vendorUnit--;
                   }
                  
            //tempVendor = new Vendor__c();
            vendorUnit = null;
            vendorPeriod = null;
        }
    
        
        
        else if(objectType.equalsIgnoreCase('Payment')){
            while(paymentUnit > 0){
                paymentList.add(new Payment__c(Opportunity__c=oppId,Date__c=tempPayment.Date__c,Amount__c=tempPayment.Amount__c,Currency__c=tempPayment.Currency__c));
                if(tempPayment.Date__c != null && paymentPeriod > 0) tempPayment.Date__c = tempPayment.Date__c.addMonths(paymentPeriod);
                paymentUnit--;
            }
            tempPayment = new Payment__c();
            paymentUnit = null;
            paymentPeriod = null;
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
            if(objectType.equalsIgnoreCase('CustomerBilling')){
                List<Customer_Billing__c> tempList = new List<Customer_Billing__c>();
                for(Customer_Billing__c customerBilling : [SELECT Name, Opportunity__c, Billing_Date__c, Due_Upon_c__c, Payment_Date__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM Customer_Billing__c WHERE ID =: selectedRecords('Customer_Billing__c')]){
                    Customer_Billing__c tempcustomerBilling = customerBilling.clone(false, true, false, false);
                    tempList.add(tempcustomerBilling);
                }
                insert tempList;
            }else if(objectType.equalsIgnoreCase('Revenue')){
                List<Revenue__c> tempList = new List<Revenue__c>();
                for(Revenue__c revenue : [SELECT Name, Opportunity__c, Revenue_Date__c, Revenue_Amount__c, Currency__c, Revenue_Amount_Usd__c FROM Revenue__c WHERE ID =: selectedRecords('Revenue__c')]){
                    Revenue__c tempRevenue = revenue.clone(false, true, false, false);
                    tempList.add(tempRevenue);
                }
                insert tempList;
            }else if(objectType.equalsIgnoreCase('VendorBilling')){
                List<Vendor__c> tempList = new List<Vendor__c>();
                for(Vendor__c vendor : [SELECT Name, Opportunity__c, Billing_Date__c, Due_Upon__c, Payment_Date__c, Vendor__c, N_Billing_Amount__c, CurrencyIsoCode, N_Billing_Amount_USD__c FROM Vendor__c WHERE ID =: selectedRecords('Vendor__c')]){
                    Vendor__c tempVendor = vendor.clone(false, true, false, false);
                    tempList.add(tempVendor);
                }
                insert tempList;
            }else if(objectType.equalsIgnoreCase('Payment')){
                List<Payment__c> tempList = new List<Payment__c>();
                for(Payment__c payment : [SELECT Name, Opportunity__c, Date__c , Amount__c, Payment_Amount_USD__c FROM Payment__c WHERE ID =: selectedRecords('Payment__c')]){
                    Payment__c tempPayment = payment.clone(false, true, false, false);
                    tempList.add(tempPayment);
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
            if(objectType.equalsIgnoreCase('CustomerBilling')){
                Database.delete(selectedRecords('Customer_Billing__c'), true);
            }else if(objectType.equalsIgnoreCase('Revenue')){
                Database.delete(selectedRecords('Revenue__c'), true);
            }else if(objectType.equalsIgnoreCase('VendorBilling')){
                Database.delete(selectedRecords('Vendor__c'), true);
            }else if(objectType.equalsIgnoreCase('Payment')){
                Database.delete(selectedRecords('Payment__c'), true);
            }
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        init();
    }
    
    public void savePartial(){
        try{
            if(objectType.equalsIgnoreCase('CustomerBilling')){
                upsert customerBillingList;
            }else if(objectType.equalsIgnoreCase('Revenue')){
                upsert reveuneList;
            }else if(objectType.equalsIgnoreCase('VendorBilling')){
                upsert vendorBillingList;
            }else if(objectType.equalsIgnoreCase('Payment')){
                upsert paymentList;
            }
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        init();
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
        }else if(objectType.equalsIgnoreCase('Revenue')){
            if(daysRevenue == null || daysRevenue.trim() == '') return null;
            Integer numberOfDays = Integer.valueOf(daysRevenue);
            if(operationType.equalsIgnoreCase('Prepone')) numberOfDays = numberOfDays - (numberOfDays * 2);
            for(Revenue__c revenue : reveuneList){
                if(revenue.Revenue_Date__c != null) revenue.Revenue_Date__c = revenue.Revenue_Date__c.addDays(numberOfDays);
            }
            upsert reveuneList;
        }else if(objectType.equalsIgnoreCase('VendorBilling')){
            if(daysVendorBilling == null || daysVendorBilling.trim() == '') return null;
            Integer numberOfDays = Integer.valueOf(daysVendorBilling);
            if(operationType.equalsIgnoreCase('Prepone')) numberOfDays = numberOfDays - (numberOfDays * 2);
            for(Vendor__c vendor : vendorBillingList){
                if(vendor.Billing_Date__c != null) vendor.Billing_Date__c = vendor.Billing_Date__c.addDays(numberOfDays);
            }
            upsert vendorBillingList;
        }else if(objectType.equalsIgnoreCase('Payment')){
            if(daysPayment == null || daysPayment.trim() == '') return null;
            Integer numberOfDays = Integer.valueOf(daysPayment);
            if(operationType.equalsIgnoreCase('Prepone')) numberOfDays = numberOfDays - (numberOfDays * 2);
            for(Payment__c payment : paymentList){
                if(payment.Date__c != null) payment.Date__c = payment.Date__c.addDays(numberOfDays);
            }
            upsert paymentList;
        }
        init();
        return null;
    }
    
    public void saveDetails(){
        try{
            upsert customerBillingList;
            upsert reveuneList;
            upsert vendorBillingList;
            upsert paymentList;
            init();
        }catch(Exception e){
            system.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
    }
}