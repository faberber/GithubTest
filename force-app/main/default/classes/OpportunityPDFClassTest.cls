@isTest(seeAllData= true)

public class OpportunityPDFClassTest {static testMethod void testOpportunityLineItemSolutionSegment()
     {
         
        Opportunity opp = [Select id from Opportunity where Name = 'AKFEN ISPARTA PPP HOSPITAL IT INFRASTRUCTURE']; 
         
        ApexPages.currentPage().getParameters().put('id',opp.Id); 
        OpportunityPDFClass objctrl = new OpportunityPDFClass(new Apexpages.standardcontroller(opp));
        Apexpages.currentpage().getparameters().put('lineindex','0');
        
        
        objctrl.init();
        objctrl.LoadOpportunity(opp.Id);
        OpportunityPDFClass.body = blob.valueOf('TEST'); 
        OpportunityPDFClass.CreateOrderPDF(opp.Id);
     
     }      
}