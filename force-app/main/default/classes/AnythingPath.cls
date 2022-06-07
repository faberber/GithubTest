public class AnythingPath {

    @AuraEnabled
    public static string query(String soql) {
        return JSON.serialize(Database.query(soql));
    }

    @AuraEnabled
    public static void updateField(id recordId, string Field, string newValue){
        system.debug(' in the update function');
        Schema.SObjectType sobjectType = recordId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
		if(sobjectName=='TD_Work_Item__c' && !Test.isRunningTest())
        {
        TD_Work_Item__c td=[select id,engaged__c from TD_Work_Item__c where id =:recordId];   
        System.debug(td);    
        }
        SObject record = Database.query('Select Id, ' + Field + ' From ' + sobjectName + ' Where Id = \'' + recordId + '\'');
        record.put(Field, newValue);
        update record;
    }

    //returns the object itself with the correct fields
    @AuraEnabled
    public static string getCurrentValue(string recordId, string picklistField, string sObjectName){
        string soql = 'select Id, ' + picklistField + ' from ' + SobjectName + ' where id = \'' + recordId + '\'';
        list<sobject> records = Database.query(soql);
        return (string)records[0].get(picklistField);
    }
    
    //updates the record
    @AuraEnabled
    public static String setNewValue(string recordId, string picklistField, string newValue){
        sobject o1 = id.valueOf(recordId).getSobjectType().newSobject(id.valueOf(recordId));
        system.debug(o1);
            o1.put(picklistField, newValue);
        try{
            system.debug('trying to update');
            update o1;  
 			return JSON.serialize(new AnythingPathErrorMessage('Success'));
        }
        catch(exception e)
        {
            system.debug('Caught');
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
                String message =e.getMessage();
                String regex = '.*FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*).\\[\\]';
                Pattern regexPattern = Pattern.compile(regex);
                Matcher regexMatcher = regexPattern.matcher(message);
                if(regexMatcher.find())
                {
                    String errorMessage = regexMatcher.group(1).replaceAll(':','');
                    System.debug(errorMessage);
                    return JSON.serialize(new AnythingPathErrorMessage(errorMessage));
                }
            }
            return JSON.serialize(new AnythingPathErrorMessage('Unknown Error Contact System Administrator'));
        }         
    }

    //returns the picklist options as a list of (value, label)
    @AuraEnabled
    public static map<String, string> getPicklistOptions(string recordId, string picklistField, string sObjectName){
        map<string, string> output = new map<string, string>();
        Schema.sobjectType objType;
        //what an ugly hack this is, in the name of reusability!
        if (recordId == null){
            string query = 'Select Id from ' + sObjectName + ' limit 1';
            system.debug(query);
            list<sobject> example = Database.query(query);
            recordId = string.valueOf(example[0].get('Id'));
        } 

        objType = Id.valueOf(recordId).getSobjectType();  
        if(!Test.isRunningTest()){  
			string query = 'Select Id,RecordType.Name from ' + sObjectName + ' where Id=:recordId limit 1';
	        system.debug(query);
	        list<sobject> example = Database.query(query);
	        System.debug(example);
	        
	        Schema.DescribeSObjectResult dsr  = objType.getDescribe();
	        map<string, Schema.SObjectField> fieldMap = dsr.fields.getMap();
	        Schema.DescribeFieldResult dfr = fieldmap.get(picklistField).getDescribe();
	        list<Schema.PicklistEntry> results = dfr.getPicklistValues();
	            
	        for (Schema.PicklistEntry pe:results){
	            if(sObjectName=='TD_Work_Item__c')
	            {
	                TD_Work_Item__c td=(TD_Work_Item__c)example.get(0);
	                if(td.RecordType.Name=='TD_WIRECTYPE' && pe.getValue()!='On Approval' && pe.getValue()!='Rejected') 
	                {
	                   if (pe.isActive()) output.put(pe.getValue(), pe.getLabel());
	                }
                    else
                    {
	                   if (pe.isActive()) output.put(pe.getValue(), pe.getLabel());
                    }
	            }
	            else
	            {
	                if (pe.isActive()) output.put(pe.getValue(), pe.getLabel());
	            }
	        }
        }
        System.debug(output);
        return output;
    }


    //for using the streaming API
    //returns the topic name for this component, creating it if necessary
    @AuraEnabled
    public static String dynamicTopic(String WhichObject, String Field) {

        string DynamicQuery = 'Select Id, ' + Field + ' from ' + WhichObject;

        //does it exist?
        List<Pushtopic> topicList = [SELECT Id, ApiVersion, Name, Description, Query FROM Pushtopic WHERE Query = :DynamicQuery];

        if (topicList.isEmpty()) {
            PushTopic newTopic = new PushTopic();
            newTopic.ApiVersion = 36.0;
            newTopic.Name = (WhichObject+Field).left(25);
            newTopic.Description = 'Autogenerated by AnythingPath Component';
            newTopic.Query = DynamicQuery;
            try {
                insert newTopic;
                return newTopic.Name;
            } catch (DMLException e) {
                System.debug(e);
                return e.getMessage();
            }
        } else {
            return topicList[0].Name;            
        }
    }
    public class AnythingPathErrorMessage
    {
        public String errorMsg;
        public AnythingPathErrorMessage(String errorMsg)
        {
            this.errorMsg=errorMsg;
        }
    }

}