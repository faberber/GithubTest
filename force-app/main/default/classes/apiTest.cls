public class apiTest {
    public static void requestTest(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.publicapis.org/entries');
        req.setMethod('GET');
        req.setTimeout(120000);
        HTTPResponse res = http.send(req);
        System.debug(res.getbody());
        JSON2Apex parsedValue = (JSON2Apex)JSON.deserialize(res.getbody(), JSON2Apex.class);
        System.debug(parsedValue.count);
        List<test__c> appInsertList = new List<test__c>();
        for(JSON2Apex.entries prs :parsedValue.entries){
            appInsertList.add(new test__c(name = prs.API));
            
            system.debug(prs);
            
        }
        if(!appInsertList.isEmpty()){
            insert appInsertList;
        }
    }
}