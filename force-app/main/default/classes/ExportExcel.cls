public without sharing class  ExportExcel {
   
    public List<OpportunityWrapper> oppWrapper{get; set;}
    public String xmlheader {get;set;}
    public String endfile{get;set;}
    public String accoundId ;
    public boolean useReportAccountNameCheckbox ;
    public String selectedCurrencyISOCode ;
    public date rangeDateTo ;
    public date rangeDateFrom ;
    public String regionValue ;
  
    
    public static List<Map<string,Object>> oppList{get;set;}
    public static List<Map<string,Object>> oppList2{get;set;}
    public static List<Map<string,Object>> oppList3{get;set;}
    public static List<Map<string,Object>> casesList{get;set;}
    public static List<Map<string,Object>> casesList2{get;set;}
    public static List<Map<string,Object>> casesList3{get;set;}
    public static List<Map<string,Object>> oppContactsList{get;set;}
    public static List<Map<string,Object>> oppContactsList2{get;set;}
    public static List<Map<string,Object>> oppContactsList3{get;set;}
    public static List<Map<string,Object>> meetingList{get;set;}
    public static List<Map<string,Object>> meetingList2{get;set;}
    public static List<Map<string,Object>> meetingList3{get;set;}
    public static List<Map<string,Object>> meetingReportList{get;set;}
    public static List<Map<string,Object>> meetingReportList2{get;set;}
    public static List<Map<string,Object>> meetingReportList3{get;set;}
    public static List<Map<string,Object>> projectList{get;set;}
    public static List<Map<string,Object>> projectList2{get;set;}
    public static List<Map<string,Object>> projectList3{get;set;}
    public static List<Map<string,Object>> summaryList{get;set;}
    public static List<Map<string,Object>> summaryList2{get;set;}
    public static List<Map<string,Object>> summaryList3{get;set;}

    //Deserialize values 
    public static List<Map<string,Object>> oppListDeserialize{get;set;}
    public static List<Map<string,Object>> oppList2Deserialize{get;set;}
    public static List<Map<string,Object>> oppList3Deserialize{get;set;}
      public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    public ExportExcel(){
        System.debug('ExportExcel');
        System.debug('test'+Limits.getCpuTime());
        System.debug(ApexPages.currentPage().getParameters().get('selectedCurrencyISOCode'));
        System.debug(ApexPages.currentPage().getParameters() );
        System.debug(ApexPages.currentPage().getParameters().get('test2'));
        String test = ApexPages.currentPage().getParameters().get('oppSerialize');
        System.debug('test.length() '+test.length());
        Map<string,Object> csMap= ( Map<string,Object> )JSON.deserializeUntyped(test);
        
        for(string key : csMap.keyset()){
            
            List<Map<String,Sobject>> csInfos= ( List<Map<String,Sobject>>)JSON.deserialize((String)csMap.get(key),  List<Map<String,Sobject>>.class);
            System.debug(key+'.size() '+csInfos.size());
        }
        
         xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        endfile = '</Workbook>';
        
        oppWrapper = new List<OpportunityWrapper>();
        
        try {
            for(Opportunity oppty : [SELECT Id, Name, Amount, StageName , CloseDate FROM Opportunity limit 1]){
                OpportunityWrapper oppWrp = new OpportunityWrapper();
                oppWrp.Name = oppty.Name;
                oppWrp.Amount = Oppty.Amount;
                oppWrp.StageName = Oppty.StageName;
                oppWrp.CloseDate = Oppty.CloseDate;
                oppWrapper.add(oppWrp);
            }
        } catch(Exception ex){
            System.debug('Error : ' + ex.getMessage() +' '+ ex.getCause() + ' '+  ex.getLineNumber());
        }
        System.debug('test'+Limits.getCpuTime());
        
    }
    public void resetEmp() {
                System.debug('resetEmp');

        System.debug('test'+Limits.getCpuTime());
        
        System.debug('test'+Limits.getCpuTime());
        
    }
    public class OpportunityWrapper{
        public String Name{get; set;}
        public Decimal Amount{get; set;}
        public String StageName{get; set;}
        public Date CloseDate {get; set;}
    }
}