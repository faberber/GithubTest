public class OrderFormController{
    
    public Opportunity oppObj{get;set;}
    
    public OrderFormController(){
        oppObj = new Opportunity();
        
        init();
    }
    
    public void init(){
        string oid = ApexPages.currentPage().getParameters().get('id');
        if( oid != null ){
            List<Opportunity> lstOpp = database.Query(' select '+ fieldsList('Opportunity') +' from Opportunity Where id = \'' +oid+ '\'' );
            if( lstOpp.size() > 0 ){
                oppObj = lstOpp[0];
            }
        }
    
    }
    
    private string fieldsList(string selectedObject){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
        string fieldsStr = 'Account.AccountNumber,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry,Account.Tax_Office__c, Account.Tax_Id__c , '+
                           'Account.Phone,Account.Name,Owner.FirstName,Owner.LastName,';
        for(Schema.SObjectField sfield : fieldMap.Values()){
            fieldsStr += sfield.getDescribe().getname() + ' , ';
        }
        
        return fieldsStr.removeEnd(', ');
    }
}