@isTest
public class TestQuoteComponentController {
    public static testmethod void test(){
        
         Pricebook2 pb = new pricebook2();
        pb.Name = 'Standard Price Book 2009';
        pb.description = 'Price Book 2009 Products';
        pb.isActive = True;
        insert pb;
        
        Opportunity Opp1 = new Opportunity();
        Opp1.Name = 'testOpp';
        Opp1.StageName = 'Closed Won';
        Opp1.Pricebook2Id=pb.Id;        
        Opp1.CloseDate = system.Today();
        insert Opp1;        
        system.debug('insert opp1 success');
        
        Product2 Pro1 = new Product2();
        Pro1.Name = 'SLA: Bronze';
        pro1.isActive = True;
        Insert pro1;
        system.debug('insert pro1 is success');        
        
       
        system.debug('pb value is'+ pb.Id);
        system.debug('insert pricebook2 is success');
        
        Id pricebookId = Test.getStandardPricebookId();        
        
        PricebookEntry StandardPriceBookEntry = new PricebookEntry();
        StandardPriceBookEntry.Pricebook2Id = pricebookId;
        StandardPriceBookEntry.Product2Id = pro1.Id;
        StandardPriceBookEntry.UnitPrice = 10000;
        StandardPriceBookEntry.IsActive =True;        
        insert StandardPriceBookEntry;
        system.debug('insert StandardPriceBookEntry');
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=pro1.id, unitprice=10000, isActive = True);
        insert pbe;
        system.debug('insert pbe is success');
        
        Quote Quo1 = new Quote(); 
        Quo1.OpportunityId = Opp1.Id;
        Quo1.Pricebook2Id = pb.Id;
        Quo1.Name = 'test Quo1';      
        insert Quo1;       
        system.debug('insert Quo1 success');
        Quote Quote1 = [SELECT Id FROM Quote WHERE Name= 'test Quo1'];
        
        QuoteLineItem QLI  = new QuoteLineItem();
        QLI.Product2Id = pro1.Id;
        QLI.QuoteId = Quote1.Id;
        QLI.PricebookEntryId = Pbe.Id;
        QLI.Quantity = 2;
        QLI.UnitPrice = 150000.0; 
        QLI.Discount = 3; 
        insert QLI;    
        QuoteLineItem QLI1 = new QuoteLineItem();
        QLI1.Product2Id = pro1.Id;
        QLI1.QuoteId = Quote1.Id;
        QLI1.PricebookEntryId = Pbe.Id;
        QLI1.Quantity = 2;
        QLI1.UnitPrice = 150000.0; 
        QLI1.Discount = 3; 
        insert QLI1;    
        system.debug('insert QLI is success');
        
        System.debug(Quote1);
        
        List<sObject> a = new List<sObject>();
        
        QuoteLineItemComponentController.getQuotelist(Quote1.Id);   
        QuoteLineItemComponentController.editQuotelineItemList(Quote1.Id);
        QuoteLineItemComponentController.QuotelineItemName(QLI1.Id);
        QuoteLineItemComponentController.deleteQuotelineItem(Quote1.Id,QLI1); 
        QuoteLineItemComponentController.getProductlist(Quote1.Id,5,0);
        QuoteLineItemComponentController.getsearchProductlist('a',Quote1.Id,0,1);
        
    }
}