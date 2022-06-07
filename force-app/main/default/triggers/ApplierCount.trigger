trigger ApplierCount on Applier_Form__c (before insert,after delete,after update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        ApplierCountControl.updateDuplicateName(Trigger.new);
        ApplierCountControl.ApplierCountUp(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isDelete){
        ApplierCountControl.ApplierCountDown(Trigger.old);
    }    
    
    if(Trigger.isAfter && Trigger.isUpdate){
        ApplierCountControl.updateStatus(Trigger.oldMap,Trigger.new);
    }
}