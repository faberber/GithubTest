public class CVPopupEditController {
    Public Attachment ImageProfil {get; set;}
    Public Attachment file{get; set;}
    public CV__c Cv{get; set;}
    Public Id MS_Item {get; set;}
    Public Id MS_Item2 {get; set;}
    Public Id MS_Itemj {get; set;}
    Public Id MS_Item2j {get; set;}
    Public Id MS_Itemsc {get; set;}
    Public Id MS_Item2sc {get; set;}
    public Boolean displayPopup {get;set;}
    public Boolean displayPopup2 {get;set;}
    public Boolean displayPopupcomp {get;set;}
    public Boolean test {get;set;}
    public string PopUpDeleteCer{get; set;}
    public string PopUpEditCer{get; set;}
    public string PopUpDeleteSC{get; set;}
    public string PopUpEditSC{get; set;}
    public string PopUpDeleteJ{get; set;}
    public string PopUpEditJ{get; set;}
    public Integer goster{get; set;}
    ///////add edit list object//////////// 
    public CVInformation__c CvInformationCertificatePopUp{get; set;}
    public CVInformation__c CvInformationCertificatePopUpEdit{get; set;}
    public List<CVInformation__c> CvInformationListCertificate{get; set;}
    public CVInformation__c CvInformationSchoolPopUp{get; set;}
    public CVInformation__c CvInformationSchoolPopUpEdit{get; set;}
    public List<CVInformation__c> CvInformationListSchool{get; set;}
    public CVInformation__c CvInformationCompanyPopUp{get; set;}
    public CVInformation__c CvInformationCompanyPopUpEdit{get; set;}
    public List<CVInformation__c> CvInformationListCompany{get; set;}
    /////Record Type///////
    Id devRecordTypeIdc = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
    Id devRecordTypeIdj = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
    Id devRecordTypeIdsc = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
    
    Public CVPopupEditController(ApexPages.StandardController stdController){
        this.Cv = (CV__c) stdController.getRecord();
        ImageProfil = new Attachment();
        Cv=[SELECT Id,E_Mail__c,First_Name__c,Birthday__c,Job_Experience__c,Last_Name__c,Maried_Status__c,Millitary__c,Web_Site__c,Gender__c  FROM CV__c WHERE Id = :Cv.Id];
        CvInformationListCertificate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdc AND CV__c<>NULL];
        CvInformationListSchool=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c =:Cv.Id  AND RecordTypeId =:devRecordTypeIdsc];
        CvInformationListCompany=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c =:Cv.Id  AND RecordTypeId =:devRecordTypeIdj];
        PopUpEditCer='none';
        PopUpDeleteCer='none';
        PopUpEditSC='none';
        PopUpEditJ='none';
         try{
            file=[Select Id,Name,LastModifiedDate from attachment where ParentId=:Cv.Id LIMIT 1 ];
        }catch(Exception e){}
    }
     public void save(){
        try{
            if(Cv.E_Mail__c!=null&&Cv.First_Name__c!=null&&Cv.Last_Name__c!=null&&Cv.Maried_Status__c!=null&&Cv.Gender__c!=null&&((Cv.Gender__c=='Male'&&Cv.Millitary__c!=null)||(Cv.Gender__c!='Male'))){
                Cv.Last_Name__c=(Cv.Last_Name__c).toUpperCase();
                upsert Cv; 
                if (ImageProfil.Name<>null&&Cv.Id<>null&&ImageProfil.body.size()<5242880){
                    System.debug('girdi');
                    List<String> filetype=new List<String>();
                    Boolean cnt=false;
                    filetype=((ImageProfil.Name).split('\\.',3));
                    System.debug('image split'+filetype);
                    ImageProfil.ParentId=Cv.Id;
                    for(String a:filetype ){
                        if(a=='jpeg'||a=='jpg'){
                            try{
                            attachment aa = new attachment();
                            aa=[Select Id,Name,LastModifiedDate from attachment where ParentId=:Cv.Id LIMIT 1 ];
                            if(aa.Id!=null){
                                System.debug('aaa yazdır '+ aa);
                            delete aa;
                            }}catch (exception e){}
                            insert ImageProfil;
                            System.debug('kaydetti');
                            file=[Select Id,Name,LastModifiedDate from attachment where ParentId=:Cv.Id LIMIT 1];
                            System.debug('kaydetti Id'+file.Id );
                            cnt=true;
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Saved');
                            ApexPages.addMessage(msg);
                            goster=6;  
                        }
                    }
                    if(cnt==false){
                        ImageProfil=null;
                        ImageProfil = new Attachment();
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Only Jpeg or Jpg file types are supported for Profile Image ! ');
                        ApexPages.addMessage(msg);
                        goster=6;
                    }
                }                             
                else if (ImageProfil.body.size()>5242880){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'The selected image size can be up to 5 mb. Please kindly check the size of the selected picture ! ');
                    ApexPages.addMessage(msg);
                    ImageProfil=null;
                    ImageProfil = new Attachment();
                    goster=6;
                }
            }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Information Blank !');
                ApexPages.addMessage(msg);
                goster=6;
            }
        }    
        catch(Exception e){}
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////display certificate add information screen/////////////////
    public void showCertificatePopup()
    {  
        if(Cv.Id!=null){
            CvInformationCertificatePopUp =new CVInformation__c();
            displayPopup=true; }
        else{
            ApexPages.Message SaveError = new ApexPages.Message(ApexPages.Severity.Error, 'Information Blank !');
            ApexPages.addMessage(SaveError); 
            goster=6;
        }
    }
    public void closeCertificatePopup() {
        displayPopup=false;
    }
    ///////////////////////////////////////////////////////
    ///Insert certificate
    public void certificateAddButton()
    {
        if(CvInformationCertificatePopUp.Certificate_Name__c!=null && CvInformationCertificatePopUp.Level__c!= null && CvInformationCertificatePopUp.Institution__c!=null){
            CvInformationCertificatePopUp.CV__c=Cv.Id;
            CvInformationCertificatePopUp.RecordTypeId=devRecordTypeIdc;
            CvInformationListCertificate.add(CvInformationCertificatePopUp);
            insert CvInformationCertificatePopUp;
            displayPopup=false;
        }
        else{
            ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'Certificate Information Blank !');
            ApexPages.addMessage(CertificateAddError);
            goster=3;
        }
    }
    ///////////////////////////////////////////////////////
    ///edit delete buttonn certificate
    public void certificateEditButton(){    
        System.debug('MsItem '+MS_Item);
        CvInformationCertificatePopUpEdit = new CVInformation__c();
        CvInformationCertificatePopUpEdit=[Select Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE  Id =:MS_Item];
        if(CvInformationCertificatePopUpEdit.Id!=null)
        {	       
            PopUpEditCer='block';            
        }
    }
    public void  deleteCertificateButton(){
        try{
            CvInformationCertificatePopUpEdit = new CVInformation__c();
            CvInformationCertificatePopUpEdit=[Select Id FROM CVInformation__c WHERE  Id =:MS_Item2];
            delete CvInformationCertificatePopUpEdit;
            CvInformationListCertificate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdc AND CV__c<>NULL];
        }catch(exception e){}
    }
    ///////////////////////////////////////////////////////
    //edit certificate 
    public void closePopupedit() {
        PopUpEditCer='none';
    }
    public void editcertificate()
    {
        if(CvInformationCertificatePopUpEdit.Certificate_Name__c!=null && CvInformationCertificatePopUpEdit.Level__c!= null && CvInformationCertificatePopUpEdit.Institution__c!=null){
            PopUpEditCer='none';   
            upsert CvInformationCertificatePopUpEdit;
            CvInformationListCertificate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdc AND CV__c<>NULL];
        }
        else{
            ApexPages.Message CertificateEditError = new ApexPages.Message(ApexPages.Severity.Error, 'Certificate Information Blank !');
            ApexPages.addMessage(CertificateEditError);
            goster=1;
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////display company add information screen/////////////////
    public void showcompanyPopup()
    {  
        if(Cv.Id!=null){
            CvInformationCompanyPopUp =new CVInformation__c();
            displayPopupcomp=true; }
        else{
            ApexPages.Message SaveError = new ApexPages.Message(ApexPages.Severity.Error, 'Information Blank !');
            ApexPages.addMessage(SaveError); 
            goster=7;
        }
    }
    public void closecompanyPopup() {
        displayPopupcomp=false;
    }
    ///////////////////////////////////////////////////////
    ///Insert company
    public void companyAddButton()
    { 
        if(CvInformationCompanyPopUp.Last_Worked_Company__c!=null && CvInformationCompanyPopUp.Position_in_The_Last_Company__c!=null&&CvInformationCompanyPopUp.Department__c!=null&&CvInformationCompanyPopUp.Years__c!=null){
            CvInformationCompanyPopUp.CV__c=Cv.Id;
            CvInformationCompanyPopUp.RecordTypeId=devRecordTypeIdj;
            CvInformationListCompany.add(CvInformationCompanyPopUp);
            insert CvInformationCompanyPopUp;
            Cv=[SELECT Id,E_Mail__c,First_Name__c,Birthday__c,Job_Experience__c,Last_Name__c,Maried_Status__c,Millitary__c,Web_Site__c  FROM CV__c WHERE Id = :Cv.Id];
            displayPopupcomp=false;
        }
        else{
            ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'Company Information Blank !');
            ApexPages.addMessage(CertificateAddError);
            goster=7;
        }
    }
    ///////////////////////////////////////////////////////
    ///edit delete buttonn company
    public void companyEditButton(){    
        CvInformationCompanyPopUpEdit = new CVInformation__c();
        CvInformationCompanyPopUpEdit=[Select  Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE  Id =:MS_Itemj];
        System.debug('güncelle job'+CvInformationCompanyPopUpEdit);
        if(CvInformationCompanyPopUpEdit.Id!=null)
        {	       
            PopUpEditJ='block';            
        }
    }
    public void  deletecompanyButton(){
        CvInformationCompanyPopUpEdit = new CVInformation__c();
        CvInformationCompanyPopUpEdit=[Select  Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c  FROM CVInformation__c WHERE  Id =:MS_Item2j];
        delete CvInformationCompanyPopUpEdit;
        CvInformationListCompany=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c =:Cv.Id  AND RecordTypeId =:devRecordTypeIdj];
        Cv=[SELECT Id,E_Mail__c,First_Name__c,Birthday__c,Job_Experience__c,Last_Name__c,Maried_Status__c,Millitary__c,Web_Site__c  FROM CV__c WHERE Id = :Cv.Id];
        
    }
    ///////////////////////////////////////////////////////
    //edit company
    public void closePopupeditcompany() {
        PopUpEditJ='none';
    }
    public void editcompany()
    {
        if(CvInformationCompanyPopUpEdit.Last_Worked_Company__c!=null && CvInformationCompanyPopUpEdit.Position_in_The_Last_Company__c!=null&&CvInformationCompanyPopUpEdit.Department__c!=null&&CvInformationCompanyPopUpEdit.Years__c!=null){
            PopUpEditJ='none';   
            upsert CvInformationCompanyPopUpEdit;
            CvInformationListCompany=[SELECT  Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c  FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdj AND CV__c<>NULL];
            Cv=[SELECT Id,E_Mail__c,First_Name__c,Birthday__c,Job_Experience__c,Last_Name__c,Maried_Status__c,Millitary__c,Web_Site__c  FROM CV__c WHERE Id = :Cv.Id];
        }
        else{
            
            ApexPages.Message CertificateEditError = new ApexPages.Message(ApexPages.Severity.Error, 'Company Information Blank !');
            ApexPages.addMessage(CertificateEditError);
            goster=8;
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////display school add information screen/////////////////
    public void showSchoolPopup()
    {  
        if(Cv.Id!=null){
            CvInformationSchoolPopUp =new CVInformation__c();
            displayPopup2=true; }
        else{
            ApexPages.Message SaveError = new ApexPages.Message(ApexPages.Severity.Error, 'Information Blank !');
            ApexPages.addMessage(SaveError); 
            goster=6;
        }
    }
    public void closeSchoolPopup() {
        displayPopup2=false;
    }
    ///////////////////////////////////////////////////////
    ///Insert School
    public void SchoolAddButton()
    {
        if(CvInformationSchoolPopUp.School_Name__c!=null&&CvInformationSchoolPopUp.School_Type__c!=null&&CvInformationSchoolPopUp.City__c!=null&&CvInformationSchoolPopUp.Graduated_Status__c!=null)
        {
            if((CvInformationSchoolPopUp.Graduated_Status__c=='Graduated' &&CvInformationSchoolPopUp.Grade_Average__c!=null) || (CvInformationSchoolPopUp.Graduated_Status__c=='Not Graduated' &&CvInformationSchoolPopUp.Grade_Average__c==null )){
                if(CvInformationSchoolPopUp.School_Type__c!='Master Degree'){
                    CvInformationSchoolPopUp.CV__c=Cv.Id;
                    CvInformationSchoolPopUp.RecordTypeId=devRecordTypeIdsc;
                    CvInformationListSchool.add(CvInformationSchoolPopUp);
                    insert CvInformationSchoolPopUp;
                    displayPopup2=false;
                }
                else{
                    CvInformationListSchool=[Select Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c  FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdsc AND CV__c<>NULL];
                    Boolean cntrl=false;
                    for(CVInformation__c a:CvInformationListSchool){
                        if(a.School_Type__c=='University') {
                            cntrl=true;
                            break;
                        }
                    }
                    if(cntrl==true){
                        CvInformationSchoolPopUp.CV__c=Cv.Id;
                        CvInformationSchoolPopUp.RecordTypeId=devRecordTypeIdsc;
                        System.debug('addd tıklandı '+CvInformationSchoolPopUp);
                        CvInformationListSchool.add(CvInformationSchoolPopUp);
                        insert CvInformationSchoolPopUp;
                        displayPopup2=false;
                    }
                    else{
                        ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'You must add university knowledge to enter master information !');
                        ApexPages.addMessage(CertificateAddError);
                        goster=4;
                    }
                }
            }
            else{
                if(CvInformationSchoolPopUp.Graduated_Status__c=='Graduated'){
                    ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'If you are graduated, you must enter an average !');
                    ApexPages.addMessage(CertificateAddError);
                    goster=4;}
                else if(CvInformationSchoolPopUp.Graduated_Status__c=='Not Graduated'){
                    ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'If you are\'t graduated, you mustn\'t enter an average !');
                    ApexPages.addMessage(CertificateAddError);
                    goster=4;
                }
            }
        }
        else{
            ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'School Information Blank !');
            ApexPages.addMessage(CertificateAddError);
            goster=4;
        }
    }
    ///////////////////////////////////////////////////////
    ///edit delete buttonn School
    public void SchoolEditButton(){    
        System.debug('MsItem '+MS_Itemsc);
        CvInformationSchoolPopUpEdit = new CVInformation__c();
        CvInformationSchoolPopUpEdit=[Select Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c  FROM CVInformation__c WHERE  Id =:MS_Itemsc];
        if(CvInformationSchoolPopUpEdit.Id!=null)
        {	       
            PopUpEditSC='block';            
        }
    }
    public void  deleteSchoolButton(){
        try{
            CvInformationSchoolPopUpEdit = new CVInformation__c();
            CvInformationSchoolPopUpEdit=[Select Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE  Id =:MS_Item2sc];
            delete CvInformationSchoolPopUpEdit;
            CvInformationListSchool=[Select Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c  FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdsc AND CV__c<>NULL];
        }catch(exception e){}
    }
    ///////////////////////////////////////////////////////
    //edit School
    public void closePopupeditSchool(){
        PopUpEditSC='none';
    }
    public void editSchool(){
        
        if(CvInformationSchoolPopUpEdit.School_Name__c!=null&&CvInformationSchoolPopUpEdit.School_Type__c!=null&&CvInformationSchoolPopUpEdit.City__c!=null&&CvInformationSchoolPopUpEdit.Graduated_Status__c!=null)
        {
            if((CvInformationSchoolPopUpEdit.Graduated_Status__c=='Graduated' &&CvInformationSchoolPopUpEdit.Grade_Average__c!=null) || (CvInformationSchoolPopUpEdit.Graduated_Status__c=='Not Graduated' &&CvInformationSchoolPopUpEdit.Grade_Average__c==null )){
                if(CvInformationSchoolPopUpEdit.School_Type__c!='Master Degree'){
                    upsert CvInformationSchoolPopUpEdit;
                    PopUpEditSC='none';
                    CvInformationListSchool=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c =:Cv.Id  AND RecordTypeId =:devRecordTypeIdsc];                }
                else{
                    CvInformationListSchool=[Select Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c  FROM CVInformation__c WHERE CV__c = :Cv.Id  AND RecordTypeId=:devRecordTypeIdsc AND CV__c<>NULL];
                    Boolean cntrl=false;
                    for(CVInformation__c a:CvInformationListSchool){
                        if(a.School_Type__c=='University') {
                            cntrl=true;
                            break;
                        }
                    }
                    if(cntrl==true){
                        upsert CvInformationSchoolPopUpEdit;
                        PopUpEditSC='none';
                        CvInformationListSchool=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c =:Cv.Id  AND RecordTypeId =:devRecordTypeIdsc];                    }
                    else{
                        ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'You must add university knowledge to enter master information !');
                        ApexPages.addMessage(CertificateAddError);
                        goster=5;
                    }
                }
            }
            else{
                if(CvInformationSchoolPopUpEdit.Graduated_Status__c=='Graduated'){
                    ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'If you are graduated, you must enter an average !');
                    ApexPages.addMessage(CertificateAddError);
                    goster=5;}
                else if(CvInformationSchoolPopUpEdit.Graduated_Status__c=='Not Graduated'){
                    ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'If you are\'t graduated, you mustn\'t enter an average !');
                    ApexPages.addMessage(CertificateAddError);
                    goster=5;
                }
            }
        }
        else{
            ApexPages.Message CertificateAddError = new ApexPages.Message(ApexPages.Severity.Error, 'School Information Blank !');
            ApexPages.addMessage(CertificateAddError);
            goster=5;
        }
    }
}