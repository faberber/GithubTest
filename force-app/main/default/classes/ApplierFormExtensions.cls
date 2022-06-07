public class ApplierFormExtensions {
    private final Applier_Form__c applier;
    public List<CVInformation__c> CvInformationListSchool{get; set;}
    public List<CVInformation__c> CvInformationListCompany{get; set;}
    public List<CVInformation__c> CvInformationListCertificate{get; set;}
    public ApplierFormExtensions(ApexPages.StandardController stdController) {
        this.applier = (Applier_Form__c)stdController.getRecord();
        CV__c acct = new CV__c();
        Applier_Form__c applierCvId=[SELECT CV__c FROM Applier_Form__c WHERE  Id =:applier.Id];
        acct.Id=applierCvId.CV__c;
        System.debug('id '+acct.Id+'applier id '+applierCvId.CV__c+'diğeri');
        Id devRecordTypeIdSchool = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
        Id devRecordTypeIdCompany = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Id devRecordTypeIdCertificate = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
        CvInformationListSchool=[SELECT Id,School_Name__c,School_Type__c,City__c,Graduated_Status__c,Grade_Average__c FROM CVInformation__c WHERE CV__c = :acct.Id AND RecordTypeId = :devRecordTypeIdSchool];
        System.debug('School '+CvInformationListSchool);
        CvInformationListCompany=[SELECT Id,Last_Worked_Company__c,Position_in_The_Last_Company__c,Department__c,Years__c FROM CVInformation__c WHERE CV__c = :acct.Id AND RecordTypeId = :devRecordTypeIdCompany ] ;
        CvInformationListCertificate=[SELECT Id,Certificate_Name__c,Level__c,Institution__c FROM CVInformation__c WHERE CV__c = :acct.Id AND RecordTypeId = :devRecordTypeIdCertificate ];
    }
}