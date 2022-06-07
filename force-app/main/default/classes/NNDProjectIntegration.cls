public class NNDProjectIntegration 
{
        
    //Properties
    private final static String url = 'http://217.78.97.135:8080/api/NNDProjectByCustomerId';
    private static Http http = new Http();
    private static HttpRequest req = new HttpRequest();
    
    //Send Account to SAP
    public static void SendAccountToSAP(List<Account> accList)
    {
        //Mapping Account 
        Map<String, Account> accMap = new Map<String, Account>();
        for(Account acc : accList)
        {			            
            accMap.put(acc.SAP_Account_No__c.leftpad(10,'0'), acc);             
        }
       
        //Prepare Request Details
        List<ResultVM> accVmList = new List<ResultVM>();
        for(Account acc : accList)
        {
            accVmList.add(new ResultVM(acc));
        }
        
        String requestBody = JSON.serialize(accVmList);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(requestBody);
        
        try
        {
            HTTPResponse resp = new HTTPResponse();
            if(!Test.isRunningTest())
            {               
                //Run Service
                resp = http.send(req);
            }
            //Get Response
            
            String result = resp.getBody();
            if(Test.isRunningTest())
            {
                result='[{"PSPID":"Test Name","MUSTERI_NO":"0000901085","ISIM_1":"MEGA TEKST?L SAN.T?C.A.?.","ISIM_2":"","PROJE_ADI":"MEGA TEKST?L SAN.T?C.A.?.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B01880 000","MUSTERI_NO":"0000901085","ISIM_1":"MEGA TEKST?L SAN.T?C.A.?.","ISIM_2":"","PROJE_ADI":"MEGA TEKST?L SAN.T?C.A.?.","SORUMLU":"Selmin Sarg?n"},{"PSPID":"B01864 000","MUSTERI_NO":"0000901087","ISIM_1":"KAYNAK B?L???M KURUMSAL","ISIM_2":"T?C. VE SAN.A.?.","PROJE_ADI":"KAYNAK B?L???M KURUMSAL T?C. VE SAN.A.?.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B01735 000","MUSTERI_NO":"0000900988","ISIM_1":"?ZM?R ANKA ?ZEL SA?L.","ISIM_2":"H?ZM.VE MALZ.SAN.T?C.LTD.?T?.","PROJE_ADI":"?ZM?R ANKA ?ZEL SA?L.H?ZM.VE MALZ.SAN.T?","SORUMLU":"Selmin Sarg?n"},{"PSPID":"B01752 000","MUSTERI_NO":"0000901002","ISIM_1":"KOS?FLER SAMSUN OTO T?C.A.?.","ISIM_2":"","PROJE_ADI":"KOS?FLER SAMSUN OTO T?C.A.?.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B03156 000","MUSTERI_NO":"0000901004","ISIM_1":"T?BET ?THALAT","ISIM_2":"?HRACAT VE KOZM.SAN.A.?.","PROJE_ADI":"T?BET ?THALAT ?HRACAT VE KOZMET?K SAN.A.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B01755 000","MUSTERI_NO":"0000901004","ISIM_1":"T?BET ?THALAT","ISIM_2":"?HRACAT VE KOZM.SAN.A.?.","PROJE_ADI":"T?BET ?THALAT ?HRACAT VE KOZM.SAN.A.?.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B01754 000","MUSTERI_NO":"0000901005","ISIM_1":"ATA?EL?K YAPI ?RET?M A.?","ISIM_2":"","PROJE_ADI":"ATA?EL?K YAPI ?RET?M A.?","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B01758 000","MUSTERI_NO":"0000901006","ISIM_1":"CRM TANITIM H?ZM.LTD.?T?.","ISIM_2":"","PROJE_ADI":"CRM TANITIM H?ZM.LTD.?T?.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"B01757 000","MUSTERI_NO":"0000901007","ISIM_1":"KASAR DUAL TEKST?L SAN.A.?.","ISIM_2":"","PROJE_ADI":"KASAR DUAL TEKST?L SAN.A.?.","SORUMLU":"MUGE YILMAZ"},{"PSPID":"N08684 000","MUSTERI_NO":"0000800547","ISIM_1":"KARGAZ,Kars Ardahan Do?al Gaz","ISIM_2":"Da?.Paz.Taah.San.veTic.Ltd.?ti.","PROJE_ADI":"Kargaz Fortinet Al?m?_Kas?m2015","SORUMLU":"Gokcen Kamis"},{"PSPID":"B01869 000","MUSTERI_NO":"0000901089","ISIM_1":"N?L B?LG?SAYAR","ISIM_2":"","PROJE_ADI":"N?L B?LG?SAYAR","SORUMLU":"SENOL ISIK"}]';
            }
            //Update Opportunity Details
            List<ResultVM> resultList = (List<ResultVM>)JSON.deserialize(result, List<ResultVM>.class);
            Set<String> resultProjectId=new Set<String>();
            Set<String> resultOppId = new Set<String>();
            
			for(ResultVM avm:resultList) 
            {
                resultProjectId.add(avm.PROJE_TANIMI);
                resultOppId.add(avm.FIRSAT_KODU);
            }
            
            List<Project__c> projectListCheck = [Select Id, Name, Account__c, Opportunity__c,Project_Name__c, Project_Owner__c from Project__c where Name IN :resultProjectId];
            List<Opportunity> opportunityListCheck = [Select Id, Name, Opportunity_ID__c from Opportunity where Opportunity_ID__c IN : resultOppId];
            
            Map<String,Project__c> projectMap = new Map<String,Project__c>();
			for(Project__c p:projectListCheck)
            {
                projectMap.put(p.Name,p);
            }
            
            Map<String,Opportunity> oppMap = new Map<String, Opportunity>();
            for(Opportunity opp: opportunityListCheck)
            {
                oppMap.put(opp.Opportunity_ID__c, opp);
            }
                
            List<Project__c> prList=new List<Project__c>();
            for(ResultVM resultVM : resultList)
            {
                Account acc = accMap.get(resultVM.MUSTERI_NO);
                Project__c prj = projectMap.get(resultVM.PROJE_TANIMI);
                Opportunity Opp = oppMap.get(resultVM.FIRSAT_KODU);
                
                if(prj == NULL) //Add New Project
                { 
                    Project__c newProject = new Project__c();
                    newProject.Name =resultVM.PROJE_TANIMI;
                    if(acc!=NULL)
                    {
                    newProject.Account__c = acc.Id;
                    }
                    if(Opp!=NULL)
                    {
                    	newProject.Opportunity__c = Opp.Id;
                    }
                    newProject.Project_Name__c = resultVM.PROJE_ADI;
                    newProject.Project_Owner__c = resultVM.SORUMLU;
                    newProject.Opportunity_Code__c=resultVM.FIRSAT_KODU;
                    prList.add(newProject);   
                }
                else if(resultVM.SORUMLU!=prj.Project_Owner__c || resultVM.PROJE_ADI!=prj.Project_Name__c || resultVM.PROJE_TANIMI != prj.Name || resultVM.FIRSAT_KODU != prj.Opportunity_Code__c) //update project
                {
                    prj.Name =resultVM.PROJE_TANIMI;
                    if(acc!=NULL)
                    {
                    	prj.Account__c = acc.Id;
                    }
                    if(Opp!=NULL)
                    {
                    	prj.Opportunity__c = Opp.Id;
                    }
                    prj.Project_Name__c = resultVM.PROJE_ADI;
                    prj.Project_Owner__c = resultVM.SORUMLU;
                    prj.Opportunity_Code__c=resultVM.FIRSAT_KODU;
                    prList.add(prj);
                }
            }
            
            //****** DB UPSERT *******
            if(prList.size() > 0)
            {
                upsert prList;
            }
        }
        catch(Exception e) 
        {
        }
    }
   
    //ViewModel for Account Model
	private class ResultVM
    {
        String AccountId {get;set;}
        String PROJE_TANIMI {get;set;}
        String MUSTERI_NO {get;set;}
        String ISIM_1 {get;set;}
        String ISIM_2 {get;set;}
        String PROJE_ADI{get;set;}
        String SORUMLU{get;set;}
        String FIRSAT_KODU{get;set;}
        
        public ResultVM(Account acc)
        {
            this.MUSTERI_NO = acc.SAP_Account_No__c;
        }
    }
}