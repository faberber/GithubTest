//Barış Arslan 7.11.2016-16:27
// Scheduled class for approval reminders
global class ScheduledApprovalReminder implements schedulable {
    private transient Messaging.SingleEmailMessage[] mailList;
    private Set<String> targetObjectTypes;
    public ScheduledApprovalReminder(){
		targetObjectTypes =new Set<String>();
        targetObjectTypes.add('Account');
        targetObjectTypes.add('Opportunity');
        targetObjectTypes.add('TD_Work_Item__c');
        targetObjectTypes.add('Authorization_to_Proceed__c');
    }
    global void execute(SchedulableContext SC) {
		mailList=new Messaging.SingleEmailMessage[]{};        
        //get ProcessInstanceWorkItems(Pending Approval Requests ) 
        List<ProcessInstanceWorkItem> pwiList = [select ActorId,ElapsedTimeInDays,OriginalActorId,ProcessInstanceId,
                                                 ProcessInstance.Status, ProcessInstance.TargetObjectId,
                                                 ProcessInstance.TargetObject.Type,
                                                 CreatedById
                                                 FROM ProcessInstanceWorkItem 
                                                 where ProcessInstance.TargetObject.Type in :targetObjectTypes
                                                 and ProcessInstance.Status='Pending' ];
          if(!pwiList.isEmpty())
          {
              	//Related Users mail addresses and their Managers mail addresses
              	//Put users in maps to get them with ProcessInstanceWorkItem.ActorId
                Set<Id> userIds = new Set<Id>();
                Map<Id,User> userMap = new Map<Id,User>();
                for(ProcessInstanceWorkItem pwi : pwiList)
                {
                    userIds.add(pwi.ActorId);
                }      
                List<User> pendingUsers = [select id,Email,ManagerId from user where id in : userIds];
                for(User u : pendingUsers)
                {
                    userMap.put(u.Id,u);
                }
                 List<String> toAddresses=new List<String>();
              for(Id i : userIds)
              {  
                  if(userMap.containsKey(i))
                  {
                
                     
                      User approver=userMap.get(i);
                      toAddresses.add(approver.Email);
                      
                  }
              }
              prepareMail( toAddresses);
              sendAll();
      	  }   
    }
    //add mails to mailList
    private void prepareMail(List<String> toAddresses)
    {
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setToAddresses(toAddresses);
        mail.setbccAddresses(toAddresses);
        mail.setccAddresses(new String[] {'baygun@netas.com.tr'});
        mail.setSubject('Onayınızda bekleyen kayıtlar var!');       
        mail.setHtmlBody('Merhaba; <br/> Onayınızda bekleyen kayıtlar bulunmaktadır. <br/>Kayıtlara gitmek için lütfen '+ +'<a href="https://netas.lightning.force.com/one/one.app#/n/MyApprovals" >buraya</a>&nbsptıklayınız <br/>Bilginize.' ); 
        //https://netas.lightning.force.com/one/one.app#/n/MyApprovals
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setSaveAsActivity(false);
		mailList.add(mail);
    }
    private void sendAll()
    {
       system.debug('MailList '+mailList);
       List<Messaging.SendEmailResult> results = Messaging.sendEmail(mailList);
       system.debug('Result - ' + results);
    }
}