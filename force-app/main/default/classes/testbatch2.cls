public class testbatch2 implements Database.Batchable<string>, Database.Stateful, Database.AllowsCallouts   {
//database.executeBatch(new testbatch2('test',true,'test','test',system.today(),system.today()));    
    public string accoundId;
    public Boolean useReportAccountNameCheckbox;
    public string selectedCurrencyISOCode;
    public string regionValue;
    public date rangeDateTo;
    public date rangeDateFrom;
    
    public string oppSerialize ;
    public string oppSerialize2;
    public string oppSerialize3;
    
    
    
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
     public testbatch2 (String accoundId,
    boolean useReportAccountNameCheckbox,
    String selectedCurrencyISOCode,
    String regionValue,
    date rangeDateTo, 
    date rangeDateFrom)
    {
        this.accoundId= accoundId;
        this.useReportAccountNameCheckbox= useReportAccountNameCheckbox;
        this.selectedCurrencyISOCode= selectedCurrencyISOCode;
        this.regionValue= regionValue;
        this.rangeDateTo= rangeDateTo;
        this.rangeDateFrom= rangeDateFrom;
    }
    public List<string> start(Database.BatchableContext BC){
        return new List<string>{'test'};
    }
    public void execute(Database.BatchableContext bc, List<string> queryList){
        List<CVInformation__c> csInfos=[SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, 
                                        LastModifiedById,  School_Name__c, School_Type__c, City__c, Graduated_Status__c,
                                        Grade_Average__c, CV__c, Last_Worked_Company__c, Department__c, 
                                        Position_in_The_Last_Company__c, Certificate_Name__c, Level__c, Institution__c, 
                                        Years__c FROM CVInformation__c
                                       ];
        List<Map<String,Object>> returnExportList = new List<Map<String,Object>> ();
        Map<String,Object>  returnExportMapTemp;
       /* for(CVInformation__c cv7 : csInfos){
            for(CVInformation__c cv21 : csInfos){
                for(CVInformation__c cv341: csInfos){
                    for(CVInformation__c cv41: csInfos){
                        for(CVInformation__c cv51 : csInfos){
                            for(CVInformation__c cv611 : csInfos){
                                for(CVInformation__c cv71 : csInfos){*/
                                    for(CVInformation__c cv : csInfos){
                                        returnExportMapTemp = new Map<String,Object>();
                                        returnExportMapTemp.putAll(cv.getPopulatedFieldsAsMap());
                                        returnExportList.add(returnExportMapTemp);
                                    }
                               /* }
                            }
                        }
                    }
                }
            }
        }*/
        system.debug(returnExportList);
        this.oppSerialize =  JSON.serialize(returnExportList);
        this.oppSerialize2 =  JSON.serialize(returnExportList);
        this.oppSerialize3 =  JSON.serialize(returnExportList);
    }    
    public void finish(Database.BatchableContext bc){
        PageReference excelPage = Page.oppexcel;
        excelPage.getParameters().put('accoundId',accoundId);
         excelPage.getParameters().put('useReportAccountNameCheckbox',string.valueOf(useReportAccountNameCheckbox));
        excelPage.getParameters().put('selectedCurrencyISOCode',selectedCurrencyISOCode);
        excelPage.getParameters().put('rangeDateTo',string.valueOf(rangeDateTo));
        excelPage.getParameters().put('rangeDateFrom',string.valueOf(rangeDateFrom));
        excelPage.getParameters().put('regionValue',regionValue);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + excelPage.getUrl());
        req.setMethod('POST');
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        //req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        Map<String,String> listMap = new Map<String,String>();
        listMap.put('oppSerialize',oppSerialize);
        listMap.put('oppSerialize2',oppSerialize2);
        listMap.put('oppSerialize3',oppSerialize3);
        System.debug(listMap);
        // Rather than including the data in the GET header we put it into a POST request body.
        req.setBody('listWrapper=' + JSON.serialize(listMap));
        
        req.setTimeout(120000);
        HTTPResponse res = http.send(req);
        while (res.getStatusCode() != 200) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        
        Blob excelBlob = res.getBodyAsBlob();
        
    }  
    
}