@RestResource(urlMapping='/showATP/*')
global  class ATPWebService {
    static List<ATPForm> result;
    //static List<Authorization_to_Proceed__c> updateResult;

    /* /services/apexrest/showATP */
     global class ATPForm 
     {
          global String SfATPId;
          global String SfOpportunityId;
          global String OpportunityId;
          global String SAPAccountNo;
          global String Description;
          global Decimal ATPAmount;
          global Decimal BusinessCaseSalesAmount;
          global String Justification; 
          global String ATPApprovalStatus;
          global String ATPAmountCurrency;
          global String BusinessCaseSalesAmountCurrency;
          global String PublicTender;
          global String Vendor;
          global String ATPId;
          global String ATPStatus;
          //global Boolean SentToSAP;
         

          public ATPForm() {}

          public ATPForm(Authorization_to_Proceed__c ATP) 
          {
               this.SfATPId = ATP.Id;
               this.ATPId = ATP.Name;
               this.SAPAccountNo = ATP.Vendor_SAP_No__c;
               this.Vendor = ATP.Vendor__r.Name;
               this.SfOpportunityId = ATP.Opportunity_Id__c; 
               this.OpportunityId = ATP.Opportunity__c;
               this.Description = ATP.Description__c;
               this.ATPAmount = ATP.ATP_Amount__c;
               this.BusinessCaseSalesAmount = ATP.Businness_case_Sales_Amount__c;
               this.Justification = ATP.Justification__c;
               this.ATPApprovalStatus = ATP.ATP_Approval_Status__c;
               this.ATPAmountCurrency = ATP.ATP_Currency__c;
               this.BusinessCaseSalesAmountCurrency = ATP.Business_Case_Sales_Currency__c;
               //this.SentToSAP = ATP.Sent_To_SAP__c;
               this.ATPStatus = ATP.ATP_Status__c;
               this.PublicTender = ATP.Public_Tender__c;
               
          }
     }

    @HttpGet
     webservice static List<ATPForm> getATPForm() 
     {
          result = new List<ATPForm>();
          //updateResult = new List<Authorization_to_Proceed__c>();
 		  List<Authorization_to_Proceed__c> ATPList = [SELECT 	Id,
                                                                Name,                              
                                                                Vendor_SAP_No__c,
                                                       			Vendor__r.Name,
                                                                Opportunity_Id__c,
                                                                Opportunity__c,
                                                                Description__c,
                                                                ATP_Amount__c,
                                                                Businness_case_Sales_Amount__c,
                                                                Justification__c,
                                                                ATP_Approval_Status__c,
                                                                ATP_Currency__c,
                                                       			ATP_Status__c,
                                                                Public_Tender__c,
                                                                Business_Case_Sales_Currency__c
                                                       FROM Authorization_to_Proceed__c];      
         
         for (Authorization_to_Proceed__c ATP:ATPList ) 
          {         
                  result.add(new ATPForm(ATP)); 
          } 

         /* for (Authorization_to_Proceed__c ATP:ATPList ) 
          {
                 
                 ATP.Sent_To_SAP__c = true; 
                 updateResult.add(ATP); 
          }
              update updateResult;*/
         	  return result;
     }
       
}