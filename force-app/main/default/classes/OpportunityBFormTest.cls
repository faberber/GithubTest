@isTest(seeAllData= true)
public class OpportunityBFormTest {
    
    public static testMethod void unitTest(){    
        
        Opportunity opp = [Select id from Opportunity where Name = 'AKFEN ISPARTA PPP HOSPITAL IT INFRASTRUCTURE']; 
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityBFormController bformController = new OpportunityBFormController(sc);
    }
    
}