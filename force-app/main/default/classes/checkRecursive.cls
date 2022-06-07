public Class checkRecursive{
    private static boolean run = true;
    private static boolean runLast = true;
    private static boolean runOnceCurrency = true;
    private static boolean runLastOli = true;
    private static Integer count=0;
 	private static boolean runOnceApprovers= true;
    private static boolean runOnceTDOpp= true;
    private static boolean runFinanceCostCalculator= true;
    private static boolean runOnceforLead;
    public static boolean isFirstTime = true;
    public static boolean runOnce(){
        if(run)
        {
            run=false;
            return true;
        }
        else{
            return run;
        }
    }
    public static boolean runOnceforLead(){
		return isFirstTime;

    }
    public static boolean runFinanceCostCalculator(){
        if(runFinanceCostCalculator)
        {
            runFinanceCostCalculator=false;
            return true;
        }
        else{
            return runFinanceCostCalculator;
        }
    }
    public static boolean runOnceTDOpp(){
        if(runOnceTDOpp)
        {
            runOnceTDOpp=false;
            return true;
        }
        else{
            return runOnceTDOpp;
        }
    }
    public static boolean runOnceCurrency(){
        if(runOnceCurrency)
        {
            runOnceCurrency=false;
            return true;
        }
        else{
            return runOnceCurrency;
        }
    }
    public static boolean runOnceApprovers(){
        if(runOnceApprovers)
        {
            runOnceApprovers=false;
            return true;
        }
        else{
            return runOnceApprovers;
        }
    }
    public static boolean runLast(){
        if(runLast)
        {
            runLast=false;
            return true;
        }
        else{
            return runLast;
        }
    }
    public static boolean runLastOli(){
        if(runLastOli)
        {
            runLastOli=false;
            return true;
        }
        else{
            return runLastOli;
        }
    }
    
    public static boolean testRun(){
        if(Test.isRunningTest() && count==0)
            {run=true;
            count++;
            if(run)
            {
                run=false;
                return true;
            }
            else{
                return run;
            }
        }
        return false;
    }
}