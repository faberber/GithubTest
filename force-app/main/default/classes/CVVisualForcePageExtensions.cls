public class CVVisualForcePageExtensions {
    private final CV__c acct;
    Public Attachment file{get; set;}
    public List<CVInformation__c> CvInformationListSchool{get; set;}
    public List<CVInformation__c> CvInformationListCompany{get; set;}
    public List<CVInformation__c> CvInformationListCertificate{get; set;}
    public List<Attachment> CvInformationAttachment{get; set;}
    public String TitleSchool{get;set;}
    public String TitleCompany{get;set;}
    public String TitleCertificate{get;set;}
    public String test{get;set;}
     public CVVisualForcePageExtensions(ApexPages.StandardController stdController) {
        this.acct = (CV__c)stdController.getRecord();
        Id devRecordTypeIdSchool = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
        Id devRecordTypeIdCompany = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Id devRecordTypeIdCertificate = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
        CvInformationListSchool=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c = :acct.Id AND RecordTypeId = :devRecordTypeIdSchool];
        CvInformationListCompany=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c = :acct.Id AND RecordTypeId = :devRecordTypeIdCompany ] ;
        CvInformationListCertificate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :acct.Id AND RecordTypeId = :devRecordTypeIdCertificate ];
        CvInformationAttachment=[SELECT Id,Name FROM Attachment WHERE ParentId = :acct.Id];
        try{
            file=[Select Id,Name,LastModifiedDate from attachment where ParentId=:acct.Id ];
        }catch(Exception e){}
        
        if(CvInformationListSchool.size()>0){
           TitleSchool='Certificate Information'; 
        }
        else{
            TitleSchool=''; 
        }
        if(CvInformationListCompany.size()>0){
           TitleCompany='Certificate Information'; 
        }
        else{
            TitleCompany=''; 
        }
        if(CvInformationListCertificate.size()>0){
           TitleCertificate='Certificate Information'; 
        }
        else{
            TitleCertificate=''; 
        }
    }
    
}