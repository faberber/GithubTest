public  class CurrencyUtilities {
    
    private static List<DatedConversionRate> conversionRates;
    public static void setConversionRates()
    {
        if(conversionRates==null && CheckRecursive.runOnceCurrency())
        {
       		conversionRates=new List<DatedConversionRate>();
            conversionRates = [SELECT Id, ConversionRate,IsoCode,StartDate,NextStartDate FROM DatedConversionRate];
        }
    }
    
    public static DatedConversionRate getConversionRate(String currencyCode,Date closeDate)
    {
        DatedConversionRate dcr=new DatedConversionRate();
        for(DatedConversionRate cr:conversionRates)
        {
            if(cr.IsoCode.equals(currencyCode) && cr.StartDate<=closeDate && cr.NextStartDate>closeDate)
            {
                dcr=cr;
                break;                
            }
        }
        return dcr;
    }
    
    //Convert value according to DatedExchangeRate
    public static Decimal ConvertAmount(Decimal Amount, String currencyCode, Date closeDate)
    {
        DatedConversionRate currentCurrency = getConversionRate(currencyCode,closeDate);
        if(currentCurrency != null && Amount != null && Amount != 0 && currentCurrency.ConversionRate != 0)
        {
            if(!Test.isRunningTest())
            {   
                System.debug(Amount);
                System.debug(currencyCode);
                System.debug(closeDate);
                System.debug(currentCurrency);
                System.debug(currentCurrency.ConversionRate);
                System.debug((Decimal)Amount/currentCurrency.ConversionRate);
                return (Decimal)(Amount/currentCurrency.ConversionRate).setScale(2);
            }
        }
        
        return 0;
    }
}