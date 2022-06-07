public class SalesforceToSAPUtilities {
    
    //Properties
    private final static String url = 'http://217.78.97.135:8080/api/sapservice';
    private static Http http = new Http();
    private static HttpRequest req = new HttpRequest();
    
    

    //Send Oppty to SAP
    public static void SendOpportunityToSAP(List<Id> oppIds){
        
        System.debug('OPP IDS' + oppIds);
        Id oppId = null;
        
        if(oppIds.size() > 0){
            for (Id oppIdToSend: oppIds){
                oppId = oppIdToSend;
            
                Opportunity opp = [SELECT Opportunity_ID__c,CurrencyIsoCode, AccountId,
                                   Account_Sap_Id__c, Account_Record_Type__c,Companyy__c,
                                   Opportunity_Type__c,Amount,Amount_USD__c,F_Business_Unit__c,
                                   F_Sales_Segment__c,Description,StageName FROM Opportunity
                                   WHERE  Id =: oppId];
                
                
                //Mapping Opportunity 
                Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
                //for(Opportunity opp : oppList)
                //{
                oppMap.put(opp.Opportunity_ID__c, opp);
                System.debug('oppMap' + oppMap);
                //}
                
                //Prepare Request Details
                List<OpportunityVM> oppVmList = new List<OpportunityVM>();
                //for(Opportunity opp : oppList)
                //{
                oppVmList.add(new OpportunityVM(opp));
                System.debug('oppVmList' + oppVmList);
                
                //}
                
                String requestBody = JSON.serialize(oppVmList);
                req.setEndpoint(url);
                req.setMethod('POST');
                req.setHeader('Content-Type','application/json');
                req.setBody(requestBody);
                
                System.debug('requestBody' + req.getBody());
                
                
                try
                {
                    HTTPResponse resp = new HTTPResponse();
                    if(!Test.isRunningTest())
                    {               
                        //Run Service
                        resp = http.send(req);
                    }
                    //Get Response
                    //
                    System.debug('Response ' + resp);
                    String result = resp.getBody().replace('\\','');
                    result = result.substring(1, result.length()-1);
                    
                    
                    //Update Opportunity Details
                    List<ResultVM> resultList = (List<ResultVM>)JSON.deserialize(result, List<ResultVM>.class);
                    List<Opportunity> updateOppList = new List<Opportunity>();
                    for(ResultVM resultVM : resultList)
                    {
                        Opportunity opp2 = oppMap.get(resultVM.OpportunityId);
                        opp2.Sent_to_SAP__c = resultVM.ResultCode == 'S' ? true : false;
                        opp2.Sent_to_SAP_Message__c = resultVM.ResultDescription;
                        
                        updateOppList.add(opp2);
                    }
                    
                    //***** DB UPDATE *****
                    if(updateOppList.size() > 0)
                    {
                        update updateOppList;
                    }
                }
                catch(Exception e)
                {
                    System.debug('Exception: ' + e.getMessage());
                }
       //burası
            }
        }
    }
    
    //ViewModel for Opportunity Model
    private class OpportunityVM{
        
       
        String OpportunityId {get;set;}
        String AccountId {get;set;}
        String AccountSapId {get;set;}
        String AccountType {get;set;}
        String CompanyCode {get;set;}
        String SfOpportunityId {get;set;}
        String OpportunityType {get;set;}
        Decimal Amount {get;set;}
        Decimal AmountUsd {get;set;}
        String OpportunityCurreny {get;set;}
        String BusinessUnit {get;set;}
        String SalesSegment {get;set;}
        String Description {get;set;}
        
        public OpportunityVM(Opportunity opp)
        {
            
       
            this.OpportunityId = opp.Opportunity_ID__c;
            this.AccountId = opp.AccountId;
            this.AccountSapId = opp.Account_Sap_Id__c;
            this.AccountType = opp.Account_Record_Type__c;
            this.CompanyCode = opp.Companyy__c;
            this.SfOpportunityId = opp.Id;
            this.OpportunityType = opp.Opportunity_Type__c;
            this.Amount = opp.Amount;
            this.AmountUsd = opp.Amount_USD__c;
            this.OpportunityCurreny = opp.CurrencyIsoCode;
            this.BusinessUnit = opp.F_Business_Unit__c;
            this.SalesSegment = opp.F_Sales_Segment__c;
            this.Description = opp.Description;
        }
    
    }
    
    //ViewModel for Result 
   @TestVisible private class ResultVM
    {
       public String OpportunityId { get; set; }
       public String ResultCode { get; set; }
       public String ResultDescription { get; set; }
    }
        
}