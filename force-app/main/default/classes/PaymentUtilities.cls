public class PaymentUtilities {

    // VendorBilling e göre yeni bir Payment Eklenmesi
    public static Payment__c AddPaymentByVendorBilling(Vendor__c vendorBilling) {

        Payment__c payment = new Payment__c();
        payment.Opportunity__c = vendorBilling.Opportunity__c;
        payment.Date__c = vendorBilling.Payment_Date__c;
        payment.Vendor__c = vendorBilling.Vendor__c;
        payment.Amount__c = vendorBilling.N_Billing_Amount__c;
        payment.N_Payment_Amount_USD__c=vendorBilling.N_Billing_Amount_USD__c;
        payment.CurrencyIsoCode = vendorBilling.CurrencyIsoCode;
        payment.Advance_Payment__c = false;
        return payment;

    }
    
    public static String SyncPaymentsFromVendorBillings(Set<Id> opportunityIdSet)
    {
        //1. Opportunitye ait tüm Payment recordları silinir
        List<Payment__c> paymentList = [SELECT Id FROM Payment__c Where Opportunity__c  in :opportunityIdSet];
        if(paymentList.size() > 0)
        {
            delete paymentList;
        }

        //2. Opportunitye ait tüm VendorBilling listesi alınır ve Paymentlar eklenir.
        List<Vendor__c> vendorBillingList = [SELECT Id,Name,Opportunity__c,Vendor__c,N_Billing_Amount__c,Payment_Date__c,CurrencyIsoCode,
                                             N_Billing_Amount_USD__c
                                                            FROM Vendor__c Where Opportunity__c in :opportunityIdSet];
        paymentList=new List<Payment__c>();
        for(Vendor__c vend : vendorBillingList)
        {
            paymentList.add(AddPaymentByVendorBilling(vend));
        }
        insert paymentList;
        return 'Succeed';
    }
    
    
}