@isTest
public class CVEditPageControllerTEST {
    public static testmethod void testedit(){
        Id devRecordTypeIdJ = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Id devRecordTypeIdSC = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
        Id devRecordTypeIdC = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
        CV__c testrecord=new CV__c(First_Name__c='test');
        insert testrecord;
        CVInformation__c testrecordcomp=new CVInformation__c(RecordTypeId=devRecordTypeIdJ,CV__c=testrecord.ID,Years__c=2,Department__c='asd',Position_in_The_Last_Company__c='sad',Last_Worked_Company__c='ads');
        insert testrecordcomp;
        CVInformation__c testrecordsc=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID);
        insert testrecordsc;
        CVInformation__c testrecordcer=new CVInformation__c(RecordTypeId=devRecordTypeIdC,CV__c=testrecord.ID);
        insert testrecordcer;
        ApexPages.currentPage().getParameters().put('lc',testrecord.id);
        ApexPages.StandardController stdLead = new ApexPages.StandardController(testrecord);
        CVEditPageController a=new CVEditPageController(stdLead);
        a.addSchool();
        CVInformation__c testrecordsc1=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='Master Degree',City__c='test',Graduated_Status__c='Graduated');
        a.schoolInformationCheckboxList.add(new CVEditPageController.schoolCheckbox(testrecordsc1));
        a.addSchool();
        CVInformation__c testrecordsc2=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='University',City__c='test',Graduated_Status__c='Graduated');
        a.schoolInformationCheckboxList.add(new CVEditPageController.schoolCheckbox(testrecordsc2));
        a.addSchool();
        CVInformation__c testrecordsc3=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='University',City__c='test',Graduated_Status__c='Graduated',Grade_Average__c=22);
        a.schoolInformationCheckboxList.add(new CVEditPageController.schoolCheckbox(testrecordsc3));
        a.addSchool();
        CVInformation__c testrecordsc4=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='University',City__c='test',Graduated_Status__c='Not Graduated');
        a.schoolInformationCheckboxList.add(new CVEditPageController.schoolCheckbox(testrecordsc4));
        a.addSchool();
        CVInformation__c testrecordsc5=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='Master Degree',City__c='test',Graduated_Status__c='Graduated',Grade_Average__c=22);
        a.schoolInformationCheckboxList.add(new CVEditPageController.schoolCheckbox(testrecordsc5));
        a.addSchool();
        a.addCompany();
        //a.companyInformationCheckboxList.add(new CVEditPageController.companyCheckbox(testrecordcomp));
        a.addCompany();
        a.addCertificate();
        CVInformation__c testrecordcer1=new CVInformation__c(RecordTypeId=devRecordTypeIdC,CV__c=testrecord.ID,Certificate_Name__c='Test',Level__c='Beginner',Institution__c='Test');
        a.certificateInformationCheckboxList.add(new CVEditPageController.CertificateCheckbox(testrecordcer1));
        a.addCertificate();
        a.Cvupdate();
        List<CVInformation__c> companyInformationList=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdJ];
        List<CVInformation__c> schoolInformationList=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdSC];
        List<CVInformation__c> certificateInformationList=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdC];
        System.assertEquals(1, companyInformationList.size());
        System.assertEquals(5, schoolInformationList.size());
        System.assertEquals(2, certificateInformationList.size());
        a.schoolInformationCheckboxList.get(a.schoolInformationCheckboxList.size()-4).selected=true;
        upsert a.schoolInformationCheckboxList.get(a.schoolInformationCheckboxList.size()-4).cvSchoolInfo;
        a.Cvupdate();
        a.CvInfoSCDelete();
       	a.companyInformationCheckboxList.get(a.companyInformationCheckboxList.size()-2).selected=true;
        upsert a.companyInformationCheckboxList.get(a.companyInformationCheckboxList.size()-2).cvCompanyInfo;
        a.CvInfoCDelete();
       	a.certificateInformationCheckboxList.get(a.certificateInformationCheckboxList.size()-1).selected=true;
        upsert a.certificateInformationCheckboxList.get(a.certificateInformationCheckboxList.size()-1).cvCertificateInfo;
        a.CvInfoCerDelete();
        List<CVInformation__c> companyInformationList1=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdJ];
        List<CVInformation__c> schoolInformationList1=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdSC];
        List<CVInformation__c> certificateInformationList1=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdC];
        System.assertEquals(0, companyInformationList1.size());
        System.assertEquals(4, schoolInformationList1.size());
        System.assertEquals(1, certificateInformationList1.size());
        
    }
    
}