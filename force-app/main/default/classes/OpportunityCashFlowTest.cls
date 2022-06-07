@isTest(seeAllData= true)
public class OpportunityCashFlowTest {
	@isTest
    public static void UnitTest(){      
         
        Opportunity oppObj = [Select id from Opportunity where Name = 'AKFEN ISPARTA PPP HOSPITAL IT INFRASTRUCTURE']; 
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(oppObj);
        OpportunityCashFlowController ocf = new OpportunityCashFlowController(sc1);
        ocf.init();
        
        ApexPages.StandardController sc2 = new ApexPages.standardController(oppObj);
        OpportunityCashFlowQuarterController ocfq = new OpportunityCashFlowQuarterController(sc2); 
        ocfq.init();
    }
}