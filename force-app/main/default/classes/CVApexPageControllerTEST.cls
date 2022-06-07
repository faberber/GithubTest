@isTest
public class CVApexPageControllerTEST {
    public static testmethod void testApex(){
        Id devRecordTypeIdJ = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Id devRecordTypeIdSC = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('School Information').getRecordTypeId();
        Id devRecordTypeIdC = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Certificate Information').getRecordTypeId();
        CVApexPageController a=new CVApexPageController();
        
        CV__c testrecord=new CV__c(First_Name__c='test',E_Mail__c='fatihberber@gmail.com',Last_Name__c='sd',Maried_Status__c='Married',Millitary__c='Done');
        a.Cv=testrecord;
        a.addCompany();       
        a.addSchool();
        a.addCertificate();
        
        
        a.save();
        
        a.addSchool();
        CVInformation__c testrecordsc6=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='Master Degree',City__c='test',Graduated_Status__c='Not Graduated');
        a.CvInformationListSchool.add(testrecordsc6);
        a.addSchool(); 
        CVInformation__c testrecordsc1=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='Master Degree',City__c='test',Graduated_Status__c='Graduated');
        a.CvInformationListSchool.add(testrecordsc1);
        a.addSchool();
        CVInformation__c testrecordsc2=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='University',City__c='test',Graduated_Status__c='Graduated');
        a.CvInformationListSchool.add(testrecordsc2);
        a.addSchool();
        a.CvInformationListSchool.add(testrecordsc6);
        a.addSchool();
        CVInformation__c testrecordsc7=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test2',School_Type__c='Master Degree',City__c='test2',Graduated_Status__c='Graduated',Grade_Average__c=22);
        a.CvInformationListSchool.add(testrecordsc7);
        a.addSchool(); 
        a.addSchool(); 
        CVInformation__c testrecordsc3=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='University',City__c='test',Graduated_Status__c='Graduated',Grade_Average__c=22);
        a.CvInformationListSchool.add(testrecordsc3);
        a.addSchool();
        CVInformation__c testrecordsc4=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='University',City__c='test',Graduated_Status__c='Not Graduated');
        a.CvInformationListSchool.add(testrecordsc4);
        a.addSchool();
        CVInformation__c testrecordsc5=new CVInformation__c(RecordTypeId=devRecordTypeIdSC,CV__c=testrecord.ID,School_Name__c='test',School_Type__c='Master Degree',City__c='test',Graduated_Status__c='Graduated',Grade_Average__c=22);
        a.CvInformationListSchool.add(testrecordsc5);
        a.addSchool();
        a.CvInformationListSchool.add(testrecordsc7);
        a.addSchool();
        
        a.addCertificate();
        CVInformation__c testrecordcer1=new CVInformation__c(RecordTypeId=devRecordTypeIdC,CV__c=testrecord.ID,Certificate_Name__c='Test',Level__c='Beginner',Institution__c='Test');
        a.CvInformationListCertificate.add(testrecordcer1);
        a.addCertificate();
        a.addCompany();
        CVInformation__c testrecordcomp1=new CVInformation__c(RecordTypeId=devRecordTypeIdJ,CV__c=testrecord.ID,Years__c=2,Department__c='asd',Position_in_The_Last_Company__c='sad',Last_Worked_Company__c='ads');
        a.CvInformationListCompany.add(testrecordcomp1);
        a.addCompany();
        a.save();
        List<CVInformation__c> companyInformationList=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdJ];
        List<CVInformation__c> schoolInformationList=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdSC];
        List<CVInformation__c> certificateInformationList=[SELECT Id FROM CVInformation__c WHERE CV__c =:testrecord.ID AND RecordTypeId =:devRecordTypeIdC];
        System.assertEquals(1, companyInformationList.size());
        System.assertEquals(1, certificateInformationList.size());
        System.assertEquals(6, schoolInformationList.size());
        
    }
}