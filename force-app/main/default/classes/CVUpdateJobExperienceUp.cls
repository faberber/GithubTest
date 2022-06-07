public class CVUpdateJobExperienceUp {
    public static void JobExperience(List<CVInformation__c> CVInformationList){
        CV__c Control=new CV__c();
        Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Map<Id,CV__c> CVMap=new Map<Id,CV__c>([SELECT Id,Gender__c,Job_Experience__c FROM CV__c]);
        For(CVInformation__c CVInfo:CVInformationList){
            if(CVInfo.RecordTypeId==devRecordTypeId){
                Control=CVMap.get(CVInfo.CV__c);
                System.debug('control'+Control+'yıl'+Control.Job_Experience__c+'User id'+CVInfo.CV__c);
                Control.Job_Experience__c=(Control.Job_Experience__c==null ? 0:Control.Job_Experience__c)+ (CVInfo.Years__c==null ? 0:CVInfo.Years__c);
            }
        }
        System.debug('cvmap'+CVMap);
        if(CVMap.values()!=null){
            upsert CVMap.values();
        }
        
        
    }
    public static void JobExperienceDelete(List<CVInformation__c> CVInformationListOld){
        CV__c Control=new CV__c();
        Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Map<Id,CV__c> CVMap=new Map<Id,CV__c>([SELECT Id,Job_Experience__c FROM CV__c]);
        For(CVInformation__c CVInfo:CVInformationListOld){
            if(CVInfo.RecordTypeId==devRecordTypeId){
                Control=CVMap.get(CVInfo.CV__c);
                Control.Job_Experience__c=(Control.Job_Experience__c==null ? 0:Control.Job_Experience__c)- (CVInfo.Years__c==null ? 0:CVInfo.Years__c);
            }
        }
        if(CVMap.values()!=null){
            upsert CVMap.values();
        }
    }
    public static void JobExperienceUpdate(List<CVInformation__c> CVInformationListNew,List<CVInformation__c> CVInformationListOld,Map<Id,CVInformation__c> CVInformationOldMap){
        CV__c Control=new CV__c();
        CVInformation__c ControlYear=new CVInformation__c();
        Id devRecordTypeId = Schema.SObjectType.CVInformation__c.getRecordTypeInfosByName().get('Job Information').getRecordTypeId();
        Map<Id,CV__c> CVMap=new Map<Id,CV__c>([SELECT Id,Job_Experience__c FROM CV__c]);
        For(CVInformation__c CVInfo:CVInformationListNew){
            if(CVInfo.RecordTypeId==devRecordTypeId){
                Control=CVMap.get(CVInfo.CV__c);
                Control.Job_Experience__c=(Control.Job_Experience__c==null ? 0:Control.Job_Experience__c)+ (CVInfo.Years__c==null ? 0:CVInfo.Years__c);
                ControlYear= CVInformationOldMap.get(CVInfo.Id); 
                Control.Job_Experience__c=(Control.Job_Experience__c==null ? 0:Control.Job_Experience__c)- (ControlYear.Years__c==null ? 0:ControlYear.Years__c);
            }
        }
        if(CVMap.values()!=null){
            upsert CVMap.values();
        }
    }
}