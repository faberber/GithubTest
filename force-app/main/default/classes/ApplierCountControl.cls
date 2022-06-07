public class ApplierCountControl {
    public static void ApplierCountUp(List<Applier_Form__c> NewTriggernew){
        set<Id> IdSet=new set<Id>(); 
        For(Applier_Form__c newApplier : NewTriggernew){
            if(newApplier.Appiler_Status__c=='Activate'){
            IdSet.add(newApplier.Job_Offer2__c); }
        }
        List<Job_Offer__c> jobOfferList=[SELECT Id,Applier_Count__c,Name FROM Job_Offer__c WHERE Id =:IdSet]; 
        List<Job_Offer__c> updateJobOfferList =new List<Job_Offer__c>();
        For(Job_Offer__c jo:jobOfferList){ 
            jo.Applier_Count__c=(jo.Applier_Count__c == null ? 0 : jo.Applier_Count__c)+1;
            updateJobOfferList.add(jo);
        }
        
        if(updateJobOfferList.size() > 0)
        {
            update updateJobOfferList;
        }
    }
    public static void ApplierCountDown(List<Applier_Form__c> NewTriggerold){
        set<Id> IdSet=new set<Id>(); 
        For(Applier_Form__c newApplier : NewTriggerold){
            IdSet.add(newApplier.Job_Offer2__c); 
        }
        List<Job_Offer__c> jobOfferList=[SELECT Id,Applier_Count__c FROM Job_Offer__c WHERE Id =:IdSet]; 
        List<Job_Offer__c> updateJobOfferList =new List<Job_Offer__c>();
        For(Job_Offer__c jo:jobOfferList){
            jo.Applier_Count__c=(jo.Applier_Count__c == null ? 0 : jo.Applier_Count__c>0 ? jo.Applier_Count__c-1 : 0);
            updateJobOfferList.add(jo);
        }
        if(updateJobOfferList.size() > 0)
        {
            update updateJobOfferList;
        }
    }
    public static void updateDuplicateName(List<Applier_Form__c> appNewList){
        set<Id> IdSet=new set<Id>(); 
        For(Applier_Form__c newApplier : appNewList){
            IdSet.add(newApplier.Job_Offer2__c); 
        }
        List<Applier_Form__c> applier=new List<Applier_Form__c> ();
        List<Job_Offer__c> jobnewlist = [SELECT Id, Name FROM Job_Offer__c WHERE Id IN :IdSet];
        
        for(Applier_Form__c appForm : appNewList)
        {
            for(Job_Offer__c joboffer2:jobnewlist)
            {
                if(appForm.Job_Offer2__c==joboffer2.id){
                    appForm.DuplicateControl__c = joboffer2.Name;
                }
            }
        }        
    }
    public static void updateStatus(Map<Id,Applier_Form__c> ApplierOldMap,List<Applier_Form__c> updateStatusListnew){
        List<Applier_Form__c> CountUp=new List<Applier_Form__c>();
        List<Applier_Form__c> CountDown=new List<Applier_Form__c>();
        Applier_Form__c control=new Applier_Form__c();
        Applier_Form__c control2=new Applier_Form__c();
        Applier_Form__c newApplierOld=new Applier_Form__c();
        For(Applier_Form__c newApplier : updateStatusListnew){
            newApplierOld=ApplierOldMap.get(newApplier.Id);
            if(newApplier.Appiler_Status__c<>newApplierOld.Appiler_Status__c){
                if(newApplier.Appiler_Status__c=='Activate'){
                    control.Id=newApplier.Id;
                    control.Job_Offer2__c=newApplier.Job_Offer2__c;
                    CountUp.add(control); 
                }
                else{
                    control2.Id=newApplier.Id;
                    control2.Job_Offer2__c=newApplier.Job_Offer2__c;
                    CountDown.add(control2);
                }            
            } 
        }
        if(CountUp.size()>0){
            ApplierCountControl.ApplierCountUp(CountUp);
        }
        else if(CountDown.size()>0){
            ApplierCountControl.ApplierCountDown(CountDown);
        }
    }
}