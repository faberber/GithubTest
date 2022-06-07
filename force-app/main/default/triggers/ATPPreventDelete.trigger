trigger ATPPreventDelete on Authorization_to_Proceed__c (before delete) {
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;
        if(trigger.isDelete)
        {
            for(Authorization_to_Proceed__c atp: trigger.old)
            {
                System.debug(profileName);
                if(profileName!='System Administrator')
                {
                        atp.addError('Cannot delete ATP');
                }
            }
        }   
}