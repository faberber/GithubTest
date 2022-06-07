public with sharing class SaveToPDF {

    // Determines whether page is rendered as a PDF or just displayed as HTML
    public String renderAs { get; set; }
    public String textTest { get; set; }

    public SaveToPDF(){
       this.textTest = [Select test__c FROM Job_Offer__c Where ID = 'a0B1j000000TRMSEA4'].test__c;
    }
    
    // Action method to "print" to PDF
    public PageReference print() {
        renderAs = 'PDF';
        return null;
    }

}