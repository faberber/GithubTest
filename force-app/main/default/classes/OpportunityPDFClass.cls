global class OpportunityPDFClass {



    private ApexPages.StandardController controller;
    
    
    public id OpportunityId  { get; private set; } 
    public id LayoutId { get; private set; } 
    public Opportunity Opportunity { get; set;}
    public Opportunity OpportunityLine { get; set;}
    public OpportunityLineItem[] OpportunityLines { get; private set;} 
    public Customer_Billing__c[] OpportunityCustomerBillings {get; set;}
    public TD_Work_Item__c[] TDWorkItems{get;set;}
    public Vendor__c[] OpportunityVendorBillings{get;set;}
    public Payment__c[] OpportunityExpenses{get;set;}
    public Revenue__c[] OpportunityCollections{get;set;}
   
    
    
    decimal AddtoFreight = 0;  
    decimal Freight = 0;
    public decimal FreightTotal {get;set;}    


     public OpportunityPDFClass(ApexPages.StandardController c) {
        system.debug('Construction  OpportunityPDFClass(ApexPages.StandardController c)');
        controller = c;
        OpportunityId = c.getRecord().id;
        LayoutId = ApexPages.CurrentPage().getParameters().get('LayoutId');
        system.debug('ERHAN BALLI IIIIIIIIDDDDD@'+OpportunityId);
        system.debug('ERHAN BALLI LayoutId@'+LayoutId);
        init();
         
    } 
    
  
    public void init() { 
        LoadOpportunity(OpportunityId);
   
    }
    
    
    
     public void LoadOpportunity(id id) { 
        Opportunity = [SELECT Id, Name, Business_Unit_A__r.Name, 
                       					Opportunity_ID__c, 
                       					Account.Name,
                       					Estimated_Invoice_Date__c,
                       					Estimated_Invoice_Monthly_Term__c,
                       					Estimated_Installments__c,
                       					Estimated_Solution_Segment__c,
                       					Contract_Date__c,
                       					CreatedBy.Name,
                       				    Account.Tax_Office__c,
                       					Account.Tax_Id__c,
                       				    Account.Phone,
                       					Account.BillingStreet,
                       					Account.BillingCity,
                       					Account.BillingCountry,
                       					Account.Owner.Name,
                       					CurrencyIsoCode,
                       					CloseDate,
                       					Total_Sales_Price__c,
                       					Total_Product_Cost__c,
                       					Company__c,
                       					Total_Customer_Billings__c,
                         				Total_Vendor_Billings__c,
                       					StageName,
                       					Sum_Of_Payments_USD__c,
                       					Sum_Of_Collections_USD__c,
                       					Sum_Of_Vendor_Billings_USD__c,
                       					Sum_Of_Customer_Billings_USD__c,
                       					Sales_Segment__r.Name,
                        				RecordType.DeveloperName,
                       					 
                             
                        (SELECT Id,
                         		Product2.Name,
                         		Product2.Description,
                                Solution_Type__c,
                                UnitPrice,                    
                                CurrencyIsoCode
                           FROM OpportunityLineItems
                        ),         
                        ( SELECT Name,
                         		 Billing_Date__c,
                         		 Payment_Date__c,
                         		 N_Billing_Amount_USD__c,
                         		 Currency_Code__c,
                         		 Due_Upon_c__c,
                         		 CurrencyIsoCode
                          FROM Customer_Billings__r                         		 
                        ),
                       	( SELECT Name,
                         		 Billing_Date__c,
                         		 Payment_Date__c,
                         		 Due_Upon__c,
                         		 N_Billing_Amount_USD__c,
                         		 Currency_Code__c,
                         		 CurrencyIsoCode
                         FROM Vendor_Billings__r
                        ),
                       	( SELECT Id,
                         		 Name,
                         		 Revenue_Date__c,
                         		 Revenue_Amount__c,
                         		 CurrencyIsoCode		 
                         FROM Collections__r
                        ),
                        ( SELECT Id,
                         		 Name,
                         		 Date__c,
                         		 Amount__c,
                         		 Vendor__r.Name,
                         		 CurrencyIsoCode                       		 
                         FROM Payments__r
                        )
                 
                    FROM Opportunity
                   WHERE id = :id limit 1];       
          
         
        OpportunityLines = Opportunity.OpportunityLineItems;
        OpportunityCustomerBillings = Opportunity.Customer_Billings__r;
        OpportunityVendorBillings = Opportunity.Vendor_Billings__r;
        OpportunityExpenses = Opportunity.Payments__r;
        OpportunityCollections = Opportunity.Collections__r;
        system.debug('ERHAN BALLI MySize'+OpportunityLines.size());  
  }
    
 
    public static blob body;
    @future(callout=true)
    webService static void CreateOrderPDF(Id IdOpportunity) { 
        
        string strReturnMessage = '';
        PageReference pgRef = Page.OpportunityPDFVfp;
        pgRef.getParameters().put('Id',string.valueof(IdOpportunity));
      if(!Test.isRunningTest()){ 
       body = pgRef.getContentAsPDF();
      }
        Attachment attachmentCS = new Attachment();     
      
        attachmentCS.Name = 'ORDER FORM' + '--'+ System.now().format('ddMMyyyy')+'.pdf';         
        attachmentCS.body = body;
        attachmentCS.ParentId = idOpportunity;
        attachmentCS.isPrivate = false;
      
        insert attachmentCS; 
    }    
  
}