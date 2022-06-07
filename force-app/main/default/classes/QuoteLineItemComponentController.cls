public with sharing class QuoteLineItemComponentController {
    @AuraEnabled
    public static List<display> getQuotelist(Id recordId) {
        
        list<QuoteLineItem> listquote =  new List<QuoteLineItem> ([Select Id,Product2.Name, UnitPrice, Discount, TotalPrice From QuoteLineItem Where QuoteId = :recordId ORDER BY  Product2.Name ASC]);
        list <display> returnlist = new List<display>();
        System.debug(listquote);
        for(QuoteLineItem a: listquote) {
            display newdisplay = new display(a);
            returnlist.add(newdisplay);
        }    
        
        return returnlist;
    }
    @AuraEnabled
    public static List<display> deleteQuotelineItem(Id recordId,QuoteLineItem row) {
        delete row;  
        list<QuoteLineItem> listquote =  new List<QuoteLineItem> ([Select Id,Product2.Name, UnitPrice, Discount, TotalPrice  From QuoteLineItem Where QuoteId = :recordId ORDER BY  Product2.Name ASC]);
        list <display> returnlist = new List<display>();
        for(QuoteLineItem a: listquote) {
            display newdisplay = new display(a);
            
            returnlist.add(newdisplay);
        }    
        return returnlist;
    }
    @AuraEnabled
    public static List<disp> editQuotelineItemList(Id recordId) {
        list<QuoteLineItem> listquote =  new List<QuoteLineItem> ([Select Id,Product2.Name,  Quantity, UnitPrice, Discount From QuoteLineItem Where QuoteId = :recordId ORDER BY  Product2.Name ASC]);
        list <disp> returnlist = new List<disp>();
        for(QuoteLineItem a: listquote) {
            disp newdisp = new disp(a);
            returnlist.add(newdisp);
        }  
        System.debug('Edit lst '+returnlist);
        return returnlist;
    }
    @AuraEnabled
    public static string QuotelineItemName(Id recordId) {
        list<QuoteLineItem> listquote =  new List<QuoteLineItem> ([Select Id,Product2.Name,  Quantity, UnitPrice, Discount From QuoteLineItem Where Id = :recordId LIMIT 1]);
        String returnlist;

        for(QuoteLineItem a: listquote) {
            
            disp newdisplay = new disp(a);
            returnlist=newdisplay.name;
        }    
        return returnlist;
    }
    @AuraEnabled
    public static List<display> getProductlist(Id recordId,Integer limits , Integer offsets) {
        String pricebookId;
        String IsoCode;
        
        Integer intlimits = integer.valueof(limits);
        Integer intoffsets = integer.valueof(offsets);
        
        Quote qt = [SELECT Id, CurrencyIsoCode ,Opportunity.Pricebook2Id FROM Quote WHERE Id =: recordId];
        pricebookId = qt.Opportunity.Pricebook2Id;
        IsoCode=qt.CurrencyIsoCode;    
        List<PricebookEntry> pbe = [Select Id,UnitPrice,Product2.Name,Product2.Description,Product2.Family From PricebookEntry WHERE Pricebook2Id =: pricebookId AND CurrencyIsoCode =: IsoCode ORDER BY  Product2.Name ASC ,Name Limit :intlimits Offset :intoffsets] ;
        System.debug('PRİCEBOOKLİST'+pbe);
        
        list <display> returnlist2 = new List<display>();
        for(PricebookEntry a:pbe){
            display newdisplay2 = new display(a);
            returnlist2.add(newdisplay2);
        }
        System.debug('göstereiliyor'+returnlist2);
        return returnlist2;
        
    }
    
    @AuraEnabled
    public static List<display> getsearchProductlist(String SearchKey,Id recordId,Integer limits , Integer offsets ) {
        Integer intlimits = integer.valueof(limits);
        Integer intoffsets = integer.valueof(offsets);
        
        String pricebookId;
        String IsoCode;
        Quote qt = [SELECT Id, CurrencyIsoCode ,Opportunity.Pricebook2Id FROM Quote WHERE Id =: recordId];
        pricebookId = qt.Opportunity.Pricebook2Id;
        IsoCode=qt.CurrencyIsoCode; 
        
        //List<List<sObject>> newprod2 =new List<List<sObject>>([FIND :Name IN ALL FIELDS RETURNING Product2(Name,Description,Family) LIMIT 10]);
        List<PricebookEntry> pbe2 = [Select Id,UnitPrice,Product2.Name,Product2.Description,Product2.Family  From PricebookEntry WHERE (Product2.Name LIKE: '%'+SearchKey+'%' OR Product2.Description LIKE: '%'+SearchKey+'%' Or Product2.Family LIKE: '%'+SearchKey+'%' )AND Pricebook2Id =: pricebookId AND CurrencyIsoCode =: IsoCode ORDER BY  Product2.Name ASC] ;
        
        list <display> returnlist3 = new List<display>();
        for(PricebookEntry a:pbe2){
            display newdisplay3 = new display(a);
            returnlist3.add(newdisplay3);
        }
        System.debug('Dolu Arama Sonuç'+returnlist3);
        
        return returnlist3;        
        
    }
    public class disp{
        @AuraEnabled
        public string Id{get; set;}
        @AuraEnabled
        public string name{get; set;}
        @AuraEnabled
        public Decimal UnitPrice{get; set;}
        @AuraEnabled
        public Decimal Quantity{get; set;}
        @AuraEnabled
        public Decimal Discount{get; set;}
        @AuraEnabled
        public QuoteLineItem a{get; set;}
        
        public disp(QuoteLineItem a2){
            Id=a2.Id;
            name=a2.Product2.Name;
            UnitPrice=a2.UnitPrice;
            Quantity=a2.Quantity;
            Discount=a2.Discount;
            a=a2;
        }
    }
    public class display{
        @AuraEnabled
        public string Id{get; set;}
        @AuraEnabled
        public string Idprice{get; set;}
        @AuraEnabled
        public string name{get; set;}
        @AuraEnabled
        public string Description{get; set;}
        @AuraEnabled
        public string Family{get; set;}
        @AuraEnabled
        public Decimal UnitPrice{get; set;}
        @AuraEnabled
        public Decimal Discount{get; set;}
        /* @AuraEnabled
public Decimal Discount{get; set;}*/
        @AuraEnabled
        public Decimal TotalPrice{get; set;}
        @AuraEnabled
        public QuoteLineItem a{get; set;}
        public display(QuoteLineItem a2){
            Id=a2.Id;
            name=a2.Product2.Name;
            UnitPrice=a2.UnitPrice;
            Discount=a2.Discount/100;
            TotalPrice=a2.TotalPrice;
            a=a2;
        }
        public display(PricebookEntry a3){
            Idprice=a3.Id;
            Id=a3.Product2Id;
            name=a3.Product2.Name;
            Description=a3.Product2.Description;
            Family=a3.Product2.Family;
        }
    }
}