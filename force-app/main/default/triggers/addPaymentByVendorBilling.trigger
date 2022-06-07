trigger addPaymentByVendorBilling on Vendor__c (after insert,after update , after delete) {
    if(CheckExecuteAnonymous.getRun())
    {
         if(Trigger.isInsert)
            {
                List<Payment__c> paymentList=new List<Payment__c>();
                for(Vendor__c vend : trigger.new)
                {
                    paymentList.add(PaymentUtilities.AddPaymentByVendorBilling(vend));
                }
                insert paymentList;
            }
            else if(Trigger.isUpdate || Trigger.isDelete)
            {
                Set<Id> oppListUpdate=new Set<Id>();
                for(Vendor__c vend : trigger.old)
                {
                    oppListUpdate.add(vend.Opportunity__c);
                }
                PaymentUtilities.SyncPaymentsFromVendorBillings(oppListUpdate);
            }
    }
    else
    {
        System.debug('ANONYMOUS');
    }
}