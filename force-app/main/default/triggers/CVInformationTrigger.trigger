trigger CVInformationTrigger on CVInformation__c (after insert,before delete, after update) {
    if( Trigger.isInsert){CVUpdateJobExperienceUp.JobExperience(Trigger.new);}
    else if(Trigger.isDelete){CVUpdateJobExperienceUp.JobExperienceDelete(Trigger.old);}
    else if (Trigger.isUpdate){CVUpdateJobExperienceUp.JobExperienceUpdate(Trigger.new,Trigger.old,Trigger.oldMap);}
}