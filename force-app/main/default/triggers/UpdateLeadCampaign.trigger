trigger UpdateLeadCampaign on Lead (after update, after insert) {
       	  for(Lead lead : Trigger.New)
      	  {

                Id leadId = lead.Id;
                Id newRelatedCampaign = lead.Related_Campaign__c;
    
                if(Trigger.oldMap != null)
                {
                    Id oldRelatedCampaign = Trigger.oldMap.get(leadId).Related_Campaign__c;
    
                    //Eger Campaign Degistiyse
                    if(oldRelatedCampaign != newRelatedCampaign){
    
                        //Daha once bir campaign var mi??
                        if(oldRelatedCampaign != null)
                        {
                            CampaigNetas__c oldCampaign = [SELECT Id, Campaign__c FROM CampaigNetas__c Where Id  =:oldRelatedCampaign LIMIT 1];
                            if(oldCampaign.Campaign__c != null)
                            {
                                List<CampaignMember> campaignMemberByOldCampaign = [SELECT CampaignId FROM CampaignMember WHERE CampaignId =: oldCampaign.Campaign__c and LeadId =:leadId LIMIT 1];
                                if(campaignMemberByOldCampaign.size() > 0)
                                {
                                    delete campaignMemberByOldCampaign;
                                }
                            }
                        }
                    }
                }
    
                //yeni lead icin campaign member i ekle
                if(newRelatedCampaign != null)
                {
                    CampaigNetas__c newCampaign = [SELECT Id, Campaign__c FROM CampaigNetas__c Where Id  =:newRelatedCampaign LIMIT 1];
                    if(newCampaign.Campaign__c != null)
                    {
                        List<CampaignMember> campaignMemberByNewCampaign = [SELECT CampaignId FROM CampaignMember WHERE CampaignId =: newCampaign.Campaign__c and LeadId =:leadId LIMIT 1];
                        if(campaignMemberByNewCampaign.size() == 0)
                        {
                            CampaignMember newMember = new CampaignMember();
                            newMember.CampaignId = newCampaign.Campaign__c;
                            newMember.LeadId = leadId;
                            insert newMember;
                        }
                    }
                }
            }
}