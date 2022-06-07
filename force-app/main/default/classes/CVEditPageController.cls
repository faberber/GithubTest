public class CVEditPageController {
    private final CV__c cvRecord;
    public List<schoolCheckbox> schoolInformationCheckboxList{get; set;}
    public List<companyCheckbox> companyInformationCheckboxList{get; set;}
    public List<CertificateCheckbox> certificateInformationCheckboxList{get; set;}   
    Id devRecordTypeIdC = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
    Id devRecordTypeIdSC = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
    Id devRecordTypeIdJ = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
    public CV__c Cv{get; set;}
    Integer updateCompanysize=0;
    Integer updateSchoolsize=0;
    Integer updateCertificatesize=0;
    public CVEditPageController(ApexPages.StandardController stdController){
        this.cvRecord = (CV__c) stdController.getRecord();
        Cv =new CV__c();  
        Cv=[SELECT Id,First_Name__c,Last_Name__c,E_Mail__c,Birthday__c,Web_Site__c,Maried_Status__c,Millitary__c FROM CV__c WHERE Id =:cvRecord.Id];
        schoolInformationCheckboxList=new List<schoolCheckbox>();
        companyInformationCheckboxList=new List<companyCheckbox>();
        certificateInformationCheckboxList=new List<CertificateCheckbox>();
        List<CVInformation__c> schoolInformationList=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c =:cvRecord.Id AND RecordTypeId =:devRecordTypeIdSC];
        for(CVInformation__c sc: schoolInformationList){
            schoolInformationCheckboxList.add(new schoolCheckbox(sc));
        }
        List<CVInformation__c> companyInformationList=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c =:cvRecord.Id AND RecordTypeId =:devRecordTypeIdC];
        for(CVInformation__c c: companyInformationList){
            companyInformationCheckboxList.add(new companyCheckbox(c));
        }
        List<CVInformation__c> certificateInformationList=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c =:cvRecord.Id AND RecordTypeId =:devRecordTypeIdJ];
        for(CVInformation__c cer: certificateInformationList){
            certificateInformationCheckboxList.add(new CertificateCheckbox(cer));
        }
    }
    Public void addSchool(){
        if(updateSchoolsize>0){
            CVInformation__c SchoolControl = new CVInformation__c();
            SchoolControl=schoolInformationCheckboxList.get(schoolInformationCheckboxList.size()-1).cvSchoolInfo;
            if(SchoolControl.School_Name__c!=null&&SchoolControl.School_Type__c!=null&&SchoolControl.City__c!=null
               &&SchoolControl.Graduated_Status__c!=null){
                   if(SchoolControl.Graduated_Status__c=='Graduated'){
                       if(SchoolControl.Grade_Average__c!=null){
                           updateSchoolsize--;  
                       }
                   }
                   else{
                       updateSchoolsize--;  
                   }
               }
        }
        if(updateSchoolsize==0){
            CVInformation__c CvInformationCompany = new CVInformation__c();
            CvInformationCompany.CV__c=Cv.Id;
            CvInformationCompany.RecordTypeId=devRecordTypeIdSC;
            schoolInformationCheckboxList.add(new schoolCheckbox(CvInformationCompany));
            updateSchoolsize++;
        }
    }
    Public void addCompany() {
        if(updateCompanysize>0){
            CVInformation__c companyControl =new CVInformation__c();
            companyControl=companyInformationCheckboxList.get(companyInformationCheckboxList.size()-1).cvCompanyInfo;
            if(companyControl.Years__c!=null&&companyControl.Department__c!=null&&companyControl.Position_in_The_Last_Company__c!=null
               &&companyControl.Last_Worked_Company__c!=null){
                   updateCompanysize--;
               }
        }        
        if(updateCompanysize==0){
            CVInformation__c CvInformationCompany = new CVInformation__c();
            CvInformationCompany.CV__c=Cv.Id;
            CvInformationCompany.RecordTypeId=devRecordTypeIdC;
            companyInformationCheckboxList.add(new companyCheckbox(CvInformationCompany));
            updateCompanysize++;
        }
    }
    Public void addCertificate(){
        if(updateCertificatesize>0){
            CVInformation__c certificateControl =new CVInformation__c();
            certificateControl=certificateInformationCheckboxList.get(certificateInformationCheckboxList.size()-1).cvCertificateInfo;
            certificateInformationCheckboxList.get(certificateInformationCheckboxList.size()-1).selected=true;
            if(certificateControl.Certificate_Name__c!=null&&certificateControl.Level__c!=null&&certificateControl.Institution__c!=null){
                updateCertificatesize--;
            }
        }
        if(updateCertificatesize==0){
            CVInformation__c CvInformationCertificate = new CVInformation__c();
            CvInformationCertificate.CV__c=Cv.Id;
            CvInformationCertificate.RecordTypeId=devRecordTypeIdJ;
            certificateInformationCheckboxList.add(new CertificateCheckbox(CvInformationCertificate));
            updateCertificatesize++;
        }
    }
    public void Cvupdate(){
        if(companyInformationCheckboxList.size()>0){
            List<CVInformation__c> CvInformationCompanyUpdate = new List<CVInformation__c>();
            CVInformation__c CvInformationCompanycontrol = new CVInformation__c();
            for(companyCheckbox a  :companyInformationCheckboxList ){
                if(a.cvCompanyInfo.Years__c!=null&&a.cvCompanyInfo.Department__c!=null&&a.cvCompanyInfo.Position_in_The_Last_Company__c!=null
                   &&a.cvCompanyInfo.Last_Worked_Company__c!=null){
                       CvInformationCompanyUpdate.add(a.cvCompanyInfo);
                   }
            }
            if(CvInformationCompanyUpdate.size()>0){
                upsert CvInformationCompanyUpdate;
            }
        }
        if(certificateInformationCheckboxList.size()>0){
            List<CVInformation__c> CvInformationCertificateUpdate = new List<CVInformation__c>();
            CVInformation__c CvInformationCertificatecontrol = new CVInformation__c();
            for(CertificateCheckbox a:certificateInformationCheckboxList){
                if(a.cvCertificateInfo.Certificate_Name__c!=null&&a.cvCertificateInfo.Level__c!=null&&a.cvCertificateInfo.Institution__c!=null){
                    CvInformationCertificateUpdate.add(a.cvCertificateInfo);
                }
            }
            if(CvInformationCertificateUpdate.size()>0){
                upsert CvInformationCertificateUpdate;
            }
        }
        if(schoolInformationCheckboxList.size()>0){
            List<CVInformation__c> CvInformationSchoolUpdate = new List<CVInformation__c>();
            CVInformation__c CvInformationSchoolcontrol = new CVInformation__c();
            for(schoolCheckbox a:schoolInformationCheckboxList){
                if(a.cvSchoolInfo.School_Name__c!=null&&a.cvSchoolInfo.School_Type__c!=null&&a.cvSchoolInfo.City__c!=null
                   &&a.cvSchoolInfo.Graduated_Status__c!=null){
                       if(a.cvSchoolInfo.School_Type__c!='Master Degree'){
                       if(a.cvSchoolInfo.Graduated_Status__c=='Graduated'){
                           if(a.cvSchoolInfo.Grade_Average__c!=null){
                               CvInformationSchoolUpdate.add(a.cvSchoolInfo);
                           }
                       }
                       else{
                           CvInformationSchoolUpdate.add(a.cvSchoolInfo);
                       }
                       }
                       else{
                           for(schoolCheckbox ab:schoolInformationCheckboxList){
                               if(ab.cvSchoolInfo.School_Type__c=='University'){
                                   CvInformationSchoolUpdate.add(a.cvSchoolInfo);
                                   break;
                               }
                           }
                       }
                   }
            }
            if(CvInformationSchoolUpdate.size()>0){
                upsert CvInformationSchoolUpdate;
            }
        }
    }
    public PageReference CvInfoSCDelete(){
        List<CVInformation__c> lstSchoolInfoToDelete = new List<CVInformation__c>();
        for(schoolCheckbox sc: schoolInformationCheckboxList)
        {
            if(sc.selected == true)
            {
                lstSchoolInfoToDelete.add(sc.cvSchoolInfo);
            }
            if(sc.selected == true&&sc.cvSchoolInfo.School_Type__c=='Master Degree'){
                for(schoolCheckbox scc: schoolInformationCheckboxList)
                {
                    if(scc.cvSchoolInfo.School_Type__c=='University'){
                        if(!lstSchoolInfoToDelete.contains(scc.cvSchoolInfo)){
                        lstSchoolInfoToDelete.add(scc.cvSchoolInfo);}
                    } 
                }
            }
        }
        if(lstSchoolInfoToDelete.size() > 0 )
        {
            Delete lstSchoolInfoToDelete;
        }
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    public PageReference CvInfoCDelete(){
        List<CVInformation__c> lstCompanyInfoToDelete = new List<CVInformation__c>();
        for(companyCheckbox c: companyInformationCheckboxList)
        {
            if(c.selected == true)
            {
                lstCompanyInfoToDelete.add(c.cvCompanyInfo);
            }
        }
        if(lstCompanyInfoToDelete.size() > 0 )
        {
            Delete lstCompanyInfoToDelete;
        }
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    public PageReference CvInfoCerDelete(){
        List<CVInformation__c> lstCertificateInfoToDelete = new List<CVInformation__c>();
        for(CertificateCheckbox cer: certificateInformationCheckboxList)
        {
            if(cer.selected == true)
            {
                lstCertificateInfoToDelete.add(cer.cvCertificateInfo);
            }
        }
        if(lstCertificateInfoToDelete.size() > 0 )
        {
            Delete lstCertificateInfoToDelete;
        }
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    public class schoolCheckbox{
        public CVInformation__c cvSchoolInfo{get; set;}
        public Boolean selected { get; set;}
        public schoolCheckbox(CVInformation__c a){
            cvSchoolInfo=a;
            selected=false;
        }
    }
    public class companyCheckbox{
        public CVInformation__c cvCompanyInfo{get; set;}
        public Boolean selected { get; set;}
        public companyCheckbox(CVInformation__c a){
            cvCompanyInfo=a;
            selected=false;
        }
    }
    public class CertificateCheckbox{
        public CVInformation__c cvCertificateInfo{get; set;}
        public Boolean selected { get; set;}
        public CertificateCheckbox(CVInformation__c a){
            cvCertificateInfo=a;
            selected=false;
        }
    }
}