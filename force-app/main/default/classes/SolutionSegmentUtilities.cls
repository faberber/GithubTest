public class SolutionSegmentUtilities {
    private List<Opportunity> oppList;
    private List<Pricebook2> pricebooks;
    private List<OpportunityLineItem> allOli;
    private Map<String,Id> pricebookMap;
    private Map<Id,List<OpportunityLineItem>> oppOliMap;
    
    public SolutionSegmentUtilities(Set<Id> opportunityIdList){
        pricebookMap=new Map<String,Id>();
        oppOliMap=new Map<Id,List<OpportunityLineItem>>();
        
        oppList=[SELECT Id,Estimated_Solution_Segment__c, Sales_Segment__r.Name,Pricebook2Id,StageName,Count_Of_Completed_TDWI__c,Count_Of_TDWI__c,Pricebook2.Name from Opportunity where Id in :opportunityIdList];
        for(Integer i=0;i<oppList.size();i++)
        {
            Opportunity opp=oppList.get(i);
            if((opp.Count_Of_Completed_TDWI__c>0 && opp.Count_Of_Completed_TDWI__c!=null) 
                && opp.Count_Of_Completed_TDWI__c==opp.Count_Of_TDWI__c  && opp.Pricebook2.Name=='Solution Price Book')
            {
                oppOliMap.put(opp.Id, new List<OpportunityLineItem>());
            }
            else
            {
                oppList.remove(i);
                opportunityIdList.remove(opp.Id);
            }
            
        }
        allOli=[SELECT ID, Solution_Type__c ,Vendor__r.Name,OpportunityId FROM OpportunityLineItem WHERE Opportunity.Id in :opportunityIdList];
       	for(OpportunityLineItem oli: allOli)
        {
            List<OpportunityLineItem> oliList;
            if(oppOliMap.get(oli.OpportunityId)==null)
            {
                oliList=new List<OpportunityLineItem>();
                oppOliMap.put(oli.Id, oliList);
            }
            else
            {
                oliList=oppOliMap.get(oli.OpportunityId);
            }
         	
            oliList.add(oli);
            oppOliMap.put(oli.OpportunityId, oliList);
        }
        pricebooks=[select id,name from pricebook2];

        for(Pricebook2 pb:pricebooks)
        {
            pricebookMap.put(pb.Name,pb.Id);
        }
        updateOpportunities();
    }
    
   private Opportunity setEstimatedSolutionSegment(Opportunity opp)
    {
        String estimatedSolutionSegment='';
        Integer microsoftVendorCount=0;
        Set<String> oplSolutionTypes=new Set<String>();
        String salesSegment=opp.Sales_Segment__r.Name;
        List<OpportunityLineItem> allOPL=oppOliMap.get(opp.Id);
        if(allOPL.size()!=0 && opp.Pricebook2Id==pricebookMap.get('Solution Price Book'))
        {
            for(OpportunityLineItem opl: allOPL)
            {
                oplSolutionTypes.add(opl.Solution_Type__c);
            }
            System.debug(oplSolutionTypes);
            System.debug(oplSolutionTypes.size());
            if(oplSolutionTypes.size()==1 && oplSolutionTypes.contains('Product consultancy'))//Estimated Solution Segment=Product Resell
            {
                estimatedSolutionSegment='Product Resell';
            }
            else if(oplSolutionTypes.size()==1 && oplSolutionTypes.contains('Service consultancy'))//Estimated Solution Segment=Service
            {
                estimatedSolutionSegment='Service';
            }
            else if(oplSolutionTypes.size()==1 && oplSolutionTypes.contains('R&D consultancy') && salesSegment.equals('P&D-Defense'))//Estimated Solution Segment=Defense
            {
               estimatedSolutionSegment='Defense'; 
            }
            else if(oplSolutionTypes.size()==1 && oplSolutionTypes.contains('R&D consultancy') && !salesSegment.equals('P&D-Defense'))//Estimated Solution Segment=Technology
            {
               estimatedSolutionSegment='Technology'; 
            }
            else if(oplSolutionTypes.size()!=1)//Estimated Solution Segment=SI
            {
               estimatedSolutionSegment='SI'; 
            }
            for(OpportunityLineItem opl: allOPL)
            {
                if(opl.Vendor__r.Name.containsIgnoreCase('microsoft'))
                {
                    microsoftVendorCount++;
                }
            }
            if(microsoftVendorCount==allOPL.size())
            {
                estimatedSolutionSegment='Microsoft'; 
            }
            opp.Estimated_Solution_Segment__c=estimatedSolutionSegment;
            return opp;
        }
        return null;
    }
    
    private void updateOpportunities()
    {
        List<Opportunity> opportunities=new List<Opportunity>();
        for(Opportunity o : oppList)
        {
            Opportunity opp=setEstimatedSolutionSegment(o);
            if(opp!=null && !opp.StageName.containsIgnoreCase('closed'))
            {
                opportunities.add(opp);
            }
        }
        if(opportunities.size()>0)
        {update opportunities;}
    }
}