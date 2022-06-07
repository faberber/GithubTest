public class FinancialCostCalculator {
    	public static List<Opportunity> oppListAfterUpdate;
    
    	public static Map<Id,List<Payment__c>> oppIdPaymentMap;
    	public static Map<Id,List<Revenue__c>> oppIdRevenueMap;
    	public static Map<Date,Decimal> pMap;
        public static Map<Date,Decimal> rMap;
        public static Map<Date,Decimal> netMap;
        public static Map<Date,Decimal> cumMap;
        public static Decimal financeCost=0;
	    public static Date lastDate=Date.newInstance(2010, 1, 1);
        public static Date firstDate=Date.newInstance(2010, 1, 1);
    public List<Opportunity> getOppList()
    {
        return oppListAfterUpdate;
    }
    public static void updateOpportunities(Set<Id> opportunityIdSet)
    {
        Map<Id,Opportunity> oppMap=new Map<Id,Opportunity>([select id,Finance_Cost__c,Interest_Rate__c from opportunity where id in:opportunityIdSet]);
            FinancialCostCalculator fcc=new FinancialCostCalculator(oppMap,opportunityIdSet);
            update fcc.getOppList();       
    }
    public FinancialCostCalculator(Map<Id,Opportunity> oppMap,Set<Id> opportunityIdSet)
    {
        oppListAfterUpdate=new List<Opportunity>();
        oppIdPaymentMap=new Map<Id,List<Payment__c>>();
        oppIdRevenueMap=new Map<Id,List<Revenue__c>>();
        List<Payment__c> pList=[select 
                                id,
                                N_Payment_Amount_USD__c,
                                Date__c,
                                CurrencyIsoCode,
                                Advance_Payment__c,
                                Opportunity__c
                                from Payment__c 
                                where Opportunity__c in :opportunityIdSet];
         List<Revenue__c> rList=[select 
                                id,
                                N_Revenue_Amount_USD__c,
                                Revenue_Date__c,
                                CurrencyIsoCode,
                                Advance_Payment__c,
                                Opportunity__c
                                from Revenue__c 
                                where Opportunity__c in :opportunityIdSet];
        for(Payment__c p:pList)
        {
            if(oppIdPaymentMap.get(p.Opportunity__c)==null)
            {
                List<Payment__c> tempList=new List<Payment__c>();
                tempList.add(p);
                oppIdPaymentMap.put(p.Opportunity__c, tempList);
            }
            else
            {
                List<Payment__c> tempList=oppIdPaymentMap.get(p.Opportunity__c);
                tempList.add(p);
                oppIdPaymentMap.put(p.Opportunity__c, tempList);
            }
        }
        for(Revenue__c r:rList)
        {
            if(oppIdRevenueMap.get(r.Opportunity__c)==null)
            {
                List<Revenue__c> tempList=new List<Revenue__c>();
                tempList.add(r);
                oppIdRevenueMap.put(r.Opportunity__c, tempList);
            }
            else
            {
                List<Revenue__c> tempList=oppIdRevenueMap.get(r.Opportunity__c);
                tempList.add(r);
                oppIdRevenueMap.put(r.Opportunity__c, tempList);
            }
        }
        
        for(Id oppId:opportunityIdSet)
        {
            if(oppIdRevenueMap.get(oppId)!=null && oppIdPaymentMap.get(oppId)!=null)
            {
                Decimal o=calculate(oppMap.get(oppId),oppId);
                oppListAfterUpdate.add(new Opportunity(Id=oppId,Finance_Cost__c=o));
            }
            else
            {
                Decimal o=0;
                oppListAfterUpdate.add(new Opportunity(Id=oppId,Finance_Cost__c=0));
            }
        }
    }
	
    public Decimal calculate(Opportunity o,Id opportunityId)
    {
        pMap=new Map<Date,Decimal>();
        rMap=new Map<Date,Decimal>();
        netMap=new Map<Date,Decimal>();
        cumMap=new Map<Date,Decimal>();
        financeCost=0;
        lastDate=Date.newInstance(2010, 1, 1);
        firstDate=Date.newInstance(2010, 1, 1);
        List<Payment__c> pList=oppIdPaymentMap.get(opportunityId);
         List<Revenue__c> rList=oppIdRevenueMap.get(opportunityId);
        for(Payment__c p:pList)
        {
            Date d=Date.newInstance(p.Date__c.year(), p.Date__c.month(), 1);
            if(d>lastDate)
            {
                lastDate=d;
                if(firstDate==Date.newInstance(2010, 1, 1))
                {firstDate=d;}
            }
            if(d<firstDate)
            {
                firstDate=d;
            }
            
            if(pMap.get(d)==null)
            {
                pMap.put(d,p.N_Payment_Amount_USD__c);
            }
            else
            {
                Decimal tempDec=pMap.get(d);
                tempDec+=p.N_Payment_Amount_USD__c;
                pMap.put(d,tempDec);
            }
        }
        for(Revenue__c r:rList)
        {
            Date d=Date.newInstance(r.Revenue_Date__c.year(), r.Revenue_Date__c.month(), 1);
            if(d>lastDate)
            {
                lastDate=d;
                if(firstDate==Date.newInstance(2010, 1, 1))
                {firstDate=d;}
            }
            if(d<firstDate)
            {
                firstDate=d;
            }
            if(rMap.get(d)==null)
            {
                rMap.put(d,r.N_Revenue_Amount_USD__c);
            }
            else
            {
                Decimal tempDec=rMap.get(d);
                tempDec+=r.N_Revenue_Amount_USD__c;
                rMap.put(d,tempDec);
            }
        }
        
        for(Date d=firstDate;d<=lastDate;d=d.addMonths(1))
        {
            
            Decimal rAmount= rMap.get(d)==null ? 0 : rMap.get(d);
            Decimal pAmount= pMap.get(d)==null ? 0 : pMap.get(d);

         
                Decimal tempDec=0;
                if(cumMap.get(d.addMonths(-1))!=null)
                {
                    tempDec=cumMap.get(d.addMonths(-1));
                }
                netMap.put(d,(rAmount-pAmount));
                cumMap.put(d,(rAmount-pAmount)+ tempDec);
            	System.debug(netMap.get(d));
            	System.debug(cumMap.get(d));
                if(cumMap.get(d)<0)
                {
                   financeCost+=cumMap.get(d)*(o.Interest_Rate__c/100)/360*30;
                }   
              
            
        }
        financeCost=financeCost*-1;
   
        System.debug(financeCost);
        
        Decimal bsmv=financeCost*1.05-financeCost;
        Decimal kkdf=bsmv*0.15;
        financeCost=financeCost+bsmv+kkdf;
		financeCost=financeCost.setScale(2);
        System.debug(financeCost);
		return financeCost;
   
    }

}