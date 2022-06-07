public class CVApexPageController {
    public List<CVInformation__c> CvInformationListSchool{get; set;}
    public List<CVInformation__c> CvInformationListCompany{get; set;}
    public List<CVInformation__c> CvInformationListCertificate{get; set;}
    public List<CVInformation__c> CvInformationListSchoolUpdate{get; set;}
    public List<CVInformation__c> CvInformationListCompanyUpdate{get; set;}
    public List<CVInformation__c> CvInformationListCertificateUpdate{get; set;}
    Public Attachment objCaseAtt {get; set;}
    public String VisibleSchool{get;set;}
    public String VisibleCompany{get;set;}
    public String VisibleCertificate{get;set;}
    Integer Schoolsize=0;
    Integer Schoolsizeupdate=0;
    Integer Companysize=0;
    Integer Companysizeupdate=0;
    Integer Certificatesize=0;
    Integer Certificatesizeupdate=0;
    Id devRecordTypeIds = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
    Id devRecordTypeIdj = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
    Id devRecordTypeIdc = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();


    public CV__c Cv{get; set;}
    public CVApexPageController(){
        Cv =new CV__c();  
        CvInformationListSchool=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c = :Cv.Id AND RecordTypeId=:devRecordTypeIds AND CV__c<>NULL];
        CvInformationListSchoolUpdate=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c = :Cv.Id AND RecordTypeId=:devRecordTypeIds AND CV__c<>NULL];
        CvInformationListCompany=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c = :Cv.Id AND RecordTypeId=:devRecordTypeIdj AND CV__c<>NULL] ;
        CvInformationListCompanyUpdate=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c = :Cv.Id AND RecordTypeId=:devRecordTypeIdj AND CV__c<>NULL];
        CvInformationListCertificate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdc AND CV__c<>NULL];
        CvInformationListCertificateUpdate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdc AND CV__c<>NULL];
        objCaseAtt = new Attachment();
        System.debug(+'yazdır'+CvInformationListCompany);
        if(Cv.Id<>null){
            addSchool();
            addCompany();
            addCertificate();
        }
    }
    Public void addSchool(){
        if(Schoolsize>0){
            CVInformation__c CvInformationSchoolControl = new CVInformation__c();
            CvInformationSchoolControl=CvInformationListSchool.get(CvInformationListSchool.size()-1);
            System.debug('size'+Schoolsize+'school_Name__c'+CvInformationSchoolControl.School_Name__c);
            if(CvInformationSchoolControl.School_Name__c!=null&&CvInformationSchoolControl.School_Type__c!=null&&CvInformationSchoolControl.City__c!=null
               &&CvInformationSchoolControl.Graduated_Status__c!=null){
                   //mezun durumundaysa mezuniyet ortalaması girmek zorunda
                   if(CvInformationSchoolControl.Graduated_Status__c=='Graduated' && CvInformationSchoolControl.School_Type__c!='Master Degree'){
                       if(CvInformationSchoolControl.Grade_Average__c!=null){
                           CvInformationListSchoolUpdate.add(CvInformationSchoolControl);
                           Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
                           VisibleSchool='göster';
                           CVInformation__c CvInformationSchool = new CVInformation__c();
                           CvInformationSchool.CV__c=Cv.Id;
                           CvInformationSchool.RecordTypeId=devRecordTypeId;
                           CvInformationListSchool.add(CvInformationSchool);           
                           Schoolsize++;
                           Schoolsizeupdate++;
                       }
                       else{
                           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'If you are graduated, you must enter an average !');
                           ApexPages.addMessage(msg);
                       }
                   }
                   //master seçilirse lisans bitmeden eklenemeyecek
                   else if(CvInformationSchoolControl.School_Type__c=='Master Degree'){
                       Boolean Cntrl=False;
                       For(CVInformation__c CvInformationLoop:CvInformationListSchool){
                           if(CvInformationLoop.School_Type__c=='University'){
                               if(CvInformationLoop.Graduated_Status__c=='Graduated'){
                                   Cntrl=True;
                               }
                           }
                       }
                       //üniversiteyi bitirmiş ise master kaydı yapabilecek
                       if(Cntrl==True){
                           //mezun seçmiş ise not ortalaması girmek zorunda
                           System.debug('mezuniyet'+CvInformationSchoolControl.Graduated_Status__c+'ortalama'+CvInformationSchoolControl.Grade_Average__c);
                           
                           if(CvInformationSchoolControl.Graduated_Status__c=='Graduated'&&CvInformationSchoolControl.Grade_Average__c!=null)
                           {
                               CvInformationListSchoolUpdate.add(CvInformationSchoolControl);
                               Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
                               VisibleSchool='göster';
                               CVInformation__c CvInformationSchool = new CVInformation__c();
                               CvInformationSchool.CV__c=Cv.Id;
                               CvInformationSchool.RecordTypeId=devRecordTypeId;
                               CvInformationListSchool.add(CvInformationSchool);           
                               Schoolsize++;
                               Schoolsizeupdate++;
                           }
                           else if(CvInformationSchoolControl.Graduated_Status__c!='Graduated'){
                               CvInformationListSchoolUpdate.add(CvInformationSchoolControl);
                               Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
                               VisibleSchool='göster';
                               CVInformation__c CvInformationSchool = new CVInformation__c();
                               CvInformationSchool.CV__c=Cv.Id;
                               CvInformationSchool.RecordTypeId=devRecordTypeId;
                               CvInformationListSchool.add(CvInformationSchool);           
                               Schoolsize++;
                               Schoolsizeupdate++;
                           }
                           else{
                               ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'If you are graduated, you must enter an average !');
                               ApexPages.addMessage(msg);
                           }
                       }
                       else{
                           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'You must add university knowledge to enter master information !');
                           ApexPages.addMessage(msg);
                       }
                   }
                   else{CvInformationListSchoolUpdate.add(CvInformationSchoolControl);
                        Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
                        VisibleSchool='göster';
                        CVInformation__c CvInformationSchool = new CVInformation__c();
                        CvInformationSchool.CV__c=Cv.Id;
                        CvInformationSchool.RecordTypeId=devRecordTypeId;
                        CvInformationListSchool.add(CvInformationSchool);           
                        Schoolsize++;
                        Schoolsizeupdate++;
                       }
               }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'School information blank !');
                ApexPages.addMessage(msg);
            }
        } 
        //ilk girişte satır eklemek  ve daha sonrasında satır eklememesi için 
        if(Cv.Id<>null&&Schoolsize==0 ){
            Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
            VisibleSchool='göster';
            CVInformation__c CvInformationSchool = new CVInformation__c();
            CvInformationSchool.CV__c=Cv.Id;
            CvInformationSchool.RecordTypeId=devRecordTypeId;//static ıd değiştirilecek
            CvInformationListSchool.add(CvInformationSchool);           
            Schoolsize++;
            
        }
        else if(Schoolsize<=0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Information blank !');
            ApexPages.addMessage(msg);
            
        }
    }
    Public void addCompany() {
        if(Companysize>0){
            System.debug('yazdır2'+CvInformationListCompany);
            CVInformation__c CvInformationCompanyControl = new CVInformation__c();
            CvInformationCompanyControl=CvInformationListCompany.get(CvInformationListCompany.size()-1);
            if(CvInformationCompanyControl.Years__c!=null&&CvInformationCompanyControl.Department__c!=null&&CvInformationCompanyControl.Position_in_The_Last_Company__c!=null
               &&CvInformationCompanyControl.Last_Worked_Company__c!=null){
                   CvInformationListCompanyUpdate.add(CvInformationCompanyControl);    
                   Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
                   VisibleCompany='göster';
                   CVInformation__c CvInformationCompany = new CVInformation__c();
                   CvInformationCompany.CV__c=Cv.Id;
                   CvInformationCompany.RecordTypeId=devRecordTypeId;//static ıd değiştirilecek
                   CvInformationListCompany.add(CvInformationCompany);
                   Companysize++;
                   Companysizeupdate++;
               }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Company information blank !');
                ApexPages.addMessage(msg);
            }
        }        
        //ilk girişte satır eklemek  ve daha sonrasında satır eklememesi için 
        if(Cv.Id<>null && Companysize==0){
            System.debug('yazdır3'+CvInformationListCompany);
            Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
            VisibleCompany='göster';
            CVInformation__c CvInformationCompany = new CVInformation__c();
            CvInformationCompany.CV__c=Cv.Id;
            CvInformationCompany.RecordTypeId=devRecordTypeId;
            CvInformationListCompany.add(CvInformationCompany);
            Companysize++;
        }
        else if(Companysize==0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Information blank !');
            ApexPages.addMessage(msg);
            
        }
    }
    Public void addCertificate() {
        if(Certificatesize>0){
            CVInformation__c CvInformationCertificateControl = new CVInformation__c();
            CvInformationCertificateControl=CvInformationListCertificate.get(CvInformationListCertificate.size()-1);
            
            System.debug('LIST: '+CvInformationListCertificate);
            System.debug('LIST: '+CvInformationCertificateControl);
            System.debug('size'+Certificatesize+'Certificate_Name__c'+CvInformationCertificateControl.Certificate_Name__c);
            if(CvInformationCertificateControl.Certificate_Name__c!=null&&CvInformationCertificateControl.Level__c!=null&&CvInformationCertificateControl.Institution__c!=null){
                CvInformationListCertificateUpdate.add(CvInformationCertificateControl);
                Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
                VisibleCertificate='göster';
                CVInformation__c CvInformationCertificate = new CVInformation__c();
                CvInformationCertificate.CV__c=Cv.Id;
                CvInformationCertificate.RecordTypeId=devRecordTypeId;
                CvInformationListCertificate.add(CvInformationCertificate);
                Certificatesize++;
                Certificatesizeupdate++;                
            }
            else {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Certificate information blank !');
                ApexPages.addMessage(msg);
            }
        }
        //ilk girişte satır eklemek  ve daha sonrasında satır eklememesi için 
        if(Cv.Id<>null && Certificatesize==0){
            Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
            VisibleCertificate='göster';
            CVInformation__c CvInformationCertificate = new CVInformation__c();
            CvInformationCertificate.CV__c=Cv.Id;
            CvInformationCertificate.RecordTypeId=devRecordTypeId;
            CvInformationListCertificate.add(CvInformationCertificate);
            Certificatesize++;
        }
        else if(Certificatesize==0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Information blank !');
            ApexPages.addMessage(msg);
            
        }
    }
    public void  save(){
        if (objCaseAtt.Name<>null&&Cv.Id<>null){
            objCaseAtt.ParentId=Cv.Id;
            insert objCaseAtt;
        }
        if(Certificatesize!=Certificatesizeupdate){
            if(CvInformationListCertificateUpdate.size()==Certificatesize){
                upsert CvInformationListCertificateUpdate;}
            else{
                addCertificate();
                upsert CvInformationListCertificateUpdate;
            }
        }
        if(Companysize!=Companysizeupdate){
            if(CvInformationListCompanyUpdate.size()==Companysize){
                upsert CvInformationListCompanyUpdate;}
            else{
                addCompany();
                upsert CvInformationListCompanyUpdate;
            }
        }
        if(Schoolsize!=Schoolsizeupdate){
            if(CvInformationListSchoolUpdate.size()==Schoolsize){
                upsert CvInformationListSchoolUpdate;}
            else{
                addSchool();
                upsert CvInformationListSchoolUpdate;
            }
        }
        try{
            if(Cv.E_Mail__c!=null&&Cv.First_Name__c!=null&&Cv.Last_Name__c!=null&&Cv.Maried_Status__c!=null&&Cv.Millitary__c!=null){
                upsert Cv; 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Saved');
                ApexPages.addMessage(msg);
            }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Information Blank !');
                ApexPages.addMessage(msg);
            }
        }    
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Error: '+e.getMessage());
            ApexPages.addMessage(msg);
        }
    }
    
    
    
    public Boolean displayPopup {get;set;}

 
    
    public void showPopup()
    {
        
    displayPopup = true;

    
    }
    
    public void closePopup() {
        displayPopup = false;
        
    }
    
    public void redirectPopup()
    {
    displayPopup = false;
       // PageReference p=new Pagereference('/'+YourObjectId);
       //  p.setRedirect(true);
       //  return p;
        
    }
    
}