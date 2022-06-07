global class TCMBCurrency implements schedulable {
    global void execute(SchedulableContext SC) {
        updateDatedConversionRates();
    }
    // Pass in the URL for the request
    // For the purposes of this sample,assume that the URL
    // returns the XML shown above in the response body
    //  @future (callout=true)
    //  
     @future (callout=true)
    private static void updateDatedConversionRates(){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        // url that returns the XML in the response body
        req.setEndpoint('http://www.tcmb.gov.tr/kurlar/today.xml');
        req.setMethod('GET');
        HttpResponse res = new HttpResponse();
        Dom.Document doc = new Dom.Document();
        if(!Test.isRunningTest())
        {
            res = h.send(req);
            doc = res.getBodyDocument();
        }
        else
        {
            doc.load('<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="isokur.xsl"?><Tarih_Date Tarih="16.11.2016" Date="11/16/2016"  Bulten_No="2016/217" >	<Currency CrossOrder="0" Kod="USD" CurrencyCode="USD">			<Unit>1</Unit>			<Isim>ABD DOLARI</Isim>			<CurrencyName>US DOLLAR</CurrencyName>			<ForexBuying>3.3055</ForexBuying>			<ForexSelling>3.3115</ForexSelling>			<BanknoteBuying>3.3032</BanknoteBuying>			<BanknoteSelling>3.3165</BanknoteSelling>			<CrossRateUSD/>			<CrossRateOther/>			</Currency>	<Currency CrossOrder="9" Kod="EUR" CurrencyCode="EUR">			<Unit>1</Unit>			<Isim>EURO</Isim>			<CurrencyName>EURO</CurrencyName>			<ForexBuying>3.5421</ForexBuying>			<ForexSelling>3.5485</ForexSelling>			<BanknoteBuying>3.5397</BanknoteBuying>			<BanknoteSelling>3.5538</BanknoteSelling>				<CrossRateUSD/>				<CrossRateOther>1.0716</CrossRateOther>			</Currency></Tarih_Date>');
        }
        //Retrieve the root element for this document.
        Dom.XMLNode tcmbCurrency = doc.getRootElement();
        
        List<DatedConversionRate> currencyList=[select id,conversionrate,isocode from DatedConversionRate];
        Map<String,DatedConversionRate> newCurrencyMap =new Map<String,DatedConversionRate>();
        Set<String> isoCodes=new Set<String>();
        for(DatedConversionRate dcr:currencyList)
        {
            isoCodes.add(dcr.isocode);
        }
        System.debug(isoCodes);
        for (DOM.XMLNode xmlnodeobj:tcmbCurrency.getChildElements())
        {
            if(isoCodes.contains(xmlnodeobj.getAttributeValue('CurrencyCode',null)))
            {
                DatedConversionRate tempVariable=new DatedConversionRate();
                tempVariable.isocode=xmlnodeobj.getAttributeValue('CurrencyCode',null);
                String tempCurrency=xmlnodeobj.getChildElement('BanknoteSelling',null).getText();
                tempVariable.ConversionRate=Double.valueof(tempCurrency);
                newCurrencyMap.put(tempVariable.isocode,tempVariable);
            }
        }
        DatedConversionRate usd = newCurrencyMap.get('USD');
        DatedConversionRate eur = newCurrencyMap.get('EUR');
        DatedConversionRate tl = new DatedConversionRate();
        tl.isocode='TRY';
        tl.ConversionRate=usd.ConversionRate;
        eur.ConversionRate=(usd.ConversionRate/eur.ConversionRate);
        usd.ConversionRate=1;
        List<DatedConversionRate> newConversionRates=new List<DatedConversionRate>();
        tl.StartDate=system.today()+1;
        usd.StartDate=system.today()+1;
        eur.StartDate=system.today()+1;
        newConversionRates.add(tl);
        newConversionRates.add(eur);

        List<TCMBClass> jsonList=new List<TCMBClass>();
        for(DatedConversionRate dcr:newConversionRates)
        {
           jsonList.add(new TCMBClass(dcr));
        }
        System.debug(System.JSON.serialize(jsonList));
        System.debug(System.JSON.serialize(jsonList.get(0)));
        //   req.setBody('{ "IsoCode" : "ADP", "ConversionRate" : 1.5, "StartDate" : "2013-06-26" }');
        //   
/*
15:08:07:380 USER_DEBUG [62]|DEBUG|[{"StartDate":"2016-11-18","IsoCode":"TRY","ConversionRate":3.32},{"StartDate":"2016-11-18","IsoCode":"USD","ConversionRate":1.00},{"StartDate":"2016-11-18","IsoCode":"EUR","ConversionRate":0.94}]
    
    */
        String authToken='';
        if(!Test.isRunningTest() && !jsonList.isEmpty())
        {
            Login l =new Login();
            authToken=l.login();
            System.debug('AuthToken '+authToken);
        }
        else if(Test.isRunningTest())
        {
            Login l =new Login();
            authToken=l.login();
        }
        h = new Http();
        req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm().toLowerCase()+ '/services/data/v28.0/sobjects/DatedConversionRate/');
        req.setHeader('Authorization', 'OAuth ' + authToken);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        if(!Test.isRunningTest() && !jsonList.isEmpty())
        {
        	for(TCMBClass tcmb:jsonList)
            {
        		req.setBody(System.JSON.serialize(tcmb));
            	res = h.send(req);
            }
        }
        
        
    }
    private class TCMBClass 
    {
        public Decimal ConversionRate;
        public String IsoCode;
        public String StartDate;
        TCMBClass(SObject sob) {
           this.IsoCode = (String) sob.get('IsoCode');
           this.StartDate = String.valueOf((Date) sob.get('StartDate'));
           Decimal myDecimal = (Decimal) sob.get('ConversionRate');
           this.ConversionRate = myDecimal.divide(1, 2, System.RoundingMode.UP);
        }
	}
    public with sharing class Login {

    private String login()
    {
        IntegrationUser__c iu=IntegrationUser__c.getInstance();
        String  user=iu.UserName__c;
        String password=iu.Password__c+iu.Token__c;
        system.debug(User+'---'+ password );
        String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
		String NS_SF = 'urn:partner.soap.sforce.com';
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');   
        req.setTimeout(60000);
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm().toLowerCase()+'/services/Soap/u/37.0');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('SOAPAction', '""');
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +user+ '</username><password>' + password + '</password></login></Body></Envelope>');        
        if(!Test.isRunningTest())
        {
        HttpResponse res =  new Http().send(req);
        if(res.getStatusCode() != 200)
        {
            Dom.Document responseDocument = res.getBodyDocument();
            Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
            Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
            Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
            Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); // faultstring          
            throw new LoginException(faultStringElm.getText()); 
        }
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        Dom.Document responseDocument = res.getBodyDocument();
        Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
        Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
        Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
        Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
        Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
        return sessionIdElm.getText();
        }
        return '';
    }
    
    
    } 
    
    public class LoginException extends Exception {}
}