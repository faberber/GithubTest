trigger TaxIdCheckAlgorithm on Account (before insert,before update) {

if(CheckExecuteAnonymous.getRun())
{ 
    Id profileId=userinfo.getProfileId();
    //Id AdminId=[Select Id from Profile where Name = 'System Administrator'].Id;  
    Id CustomerAccountId = [Select id from RecordType where sObjectType = 'Account' and developerName ='Customer' ].Id;
    Id VendorAccountId = [Select id from RecordType where sObjectType = 'Account' and developerName ='Vendor' ].Id;      
        
    //if(profileId != AdminId)
    //{    
        
     for(Account acc : Trigger.new){
        String TaxId = acc.Tax_Id__c;
        String VendorTaxId = acc.Vendor_Tax_Id__c;
        //String Country = acc.Country__c;
    
      // Customer TaxID Check Starts
      if(acc.RecordTypeId == CustomerAccountId) 
      {    
        system.debug('TAX ID : ' + TaxId); 
         
         if(TaxId != null /*&& Country == 'TR'*/)
         {  
              Integer TaxIdLength = acc.Tax_Id__c.length();
    
              if(!TaxId.isNumeric())
             {
                 acc.addError('Girdiğiniz vergi numarası sadece numaradan oluşmalıdır. Harf boşluk veya özel karakter içermemelidir.Lütfen kontrol ediniz!');
             }
         
         
        system.debug('TAX ID Length : ' + TaxIdLength); 
        
        /////VKN Control    
        if (TaxIdLength == 10 ) {
            
        Integer v1 = 0;
        Integer v2 = 0;
        Integer v3 = 0;
        Integer v4 = 0;
        Integer v5 = 0;
        Integer v6 = 0;
        Integer v7 = 0;
        Integer v8 = 0;
        Integer v9 = 0;
        Integer v11 = 0;
        Integer v22 = 0;
        Integer v33 = 0;
        Integer v44 = 0;
        Integer v55 = 0;
        Integer v66 = 0;
        Integer v77 = 0;
        Integer v88 = 0;
        Integer v99 = 0;
        Integer v_last_digit = 0;
        Integer total = 0; 
            
    
            v1 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(0,1)) + 9),10);
            v2 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(1,2)) + 8),10);
            v3 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(2,3)) + 7),10);
            v4 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(3,4)) + 6),10);
            v5 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(4,5)) + 5),10);
            v6 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(5,6)) + 4),10);
            v7 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(6,7)) + 3),10);
            v8 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(7,8)) + 2),10);
            v9 = math.mod((Integer.valueOf(String.valueOf(TaxId).Substring(8,9)) + 1),10);
            v_last_digit = Integer.valueOf(String.valueOf(TaxId).Substring(9,10));
    
            v11 = math.mod((v1 * 512), 9);
            v22 = math.mod((v2 * 256), 9);
            v33 = math.mod((v3 * 128), 9);
            v44 = math.mod((v4 * 64), 9);
            v55 = math.mod((v5 * 32), 9);
            v66 = math.mod((v6 * 16), 9);
            v77 = math.mod((v7 * 8), 9);
            v88 = math.mod((v8 * 4), 9);
            v99 = math.mod((v9 * 2), 9);
    
            if (v1 != 0 && v11 == 0) v11 = 9;
            if (v2 != 0 && v22 == 0) v22 = 9;
            if (v3 != 0 && v33 == 0) v33 = 9;
            if (v4 != 0 && v44 == 0) v44 = 9;
            if (v5 != 0 && v55 == 0) v55 = 9;
            if (v6 != 0 && v66 == 0) v66 = 9;
            if (v7 != 0 && v77 == 0) v77 = 9;
            if (v8 != 0 && v88 == 0) v88 = 9;
            if (v9 != 0 && v99 == 0) v99 = 9;
            total = v11 + v22 + v33 + v44 + v55 + v66 + v77 + v88 + v99;
            
            system.debug('TOTAL :'+TOTAL);
    
            if (math.mod(total, 10) == 0)
            {
              total = 0;   
            }
                
            else 
                total = (10 - (math.mod(total, 10)));
    
            system.debug('TOTAL :'+total);
            system.debug('LAST DIGIT :'+v_last_digit);
            if (total == v_last_digit) {
    
           system.debug('Success');
                continue;
            } 
            else
            acc.addError('Girdiğiniz vergi numarası uygun değildir! Lütfen kontrol ediniz!');
        } 
             /////TCKN Control
             else if (TaxIdLength == 11)
             { 
                 if(Integer.valueOf(String.valueOf(TaxId).Substring(0,1)) == 0) 
                 {
                     acc.addError('TCKN Numaraları 0 ile başlayamaz! Lütfen kontrol ediniz! Line : 114');
                 }
                 
                Integer TOTAL = 0; 
                Integer LastDigit = 0; 
                Integer TotalOdd = 0;
                Integer TotalEven = 0;
                Integer Check = 0;
                Integer Counter = 0; 
                Integer Value = 0; 
                //total odd & total even
                 for( Integer i=1; i<11; i++ )
                 {
                     Counter = i-1;
                     Value = Integer.valueOf(String.valueOf(TaxId).Substring(Counter,Counter+1)); 
                     system.debug('Counter : '+Counter);
                     system.debug('VALUE : ' + Value);
                    
                     //even
                     if(math.mod(Counter,2) == 0)
                     {                      
                         TotalEven+= Value;
                     }   
                          
                      //odd    
                     else 
                     {   
                        if(i==10)
                        {
                            break;
                        }
                      TotalOdd+= Value;
                     }
                 }             
                 
                 TOTAL = TotalEven + TotalOdd + Integer.valueOf(String.valueOf(TaxId).Substring(9,10));
                 
                 system.debug('TOTAL : ' + TOTAL);
                 system.debug('TotalEven : ' + TotalEven);
                 system.debug('TotalOdd : ' +TotalOdd);
                 
                 LastDigit = math.mod(Total,10);        
                  system.debug('Last Digit : '+LastDigit);
                 
                if( Integer.valueOf(String.valueOf(TaxId).Substring(10,11)) == LastDigit )
                { 
                    //Check = math.mod(((TotalEven * 7) - TotalOdd),10);
                    Check = (TotalEven * 7)-TotalOdd;
                    if(Check < 0)
                    {
                        Check = Check * -1;
                        String tempCheck = String.valueOf(Check);
                        system.debug('tempCheck : '+ tempCheck);
                        Integer tempCheckLength = tempCheck.length();
                        system.debug('tempCheckLength : '+ tempCheckLength);
                        Integer tempLastDigit = Integer.valueOf(String.valueOf(tempCheck).Substring(tempCheckLength-1,tempCheckLength));
                        system.debug('tempLastDigit : '+ tempLastDigit);
                        Check = (tempLastDigit*-1)+10;
                        
                        
                    } 
                    else
                    {
                      Check = math.mod(Check,10);
                    }
                    
                    system.debug('Check : '+Check);  
                    
                    if(Integer.valueOf(String.valueOf(TaxId).Substring(9,10))== Check)
                    {
                     system.debug('Success');   
                     continue;   
                    }
                    else
                        acc.addError('Girdiğiniz TCKN numarası uygun değildir! Lütfen kontrol ediniz! Line : 152');
                }
                
                else
                        acc.addError('Girdiğiniz TCKN numarası uygun değildir! Lütfen kontrol ediniz! Line : 156');              
                             
             }   
            }
           }
      //Customer Tax Id Check Ends
         
     //Vendor Tax Id Check Starts    
      if(acc.RecordTypeId == VendorAccountId) 
      {    
        system.debug('TAX ID : ' + VendorTaxId); 
         
         if(VendorTaxId != null /*&& Country == 'TR'*/)
         {  
              Integer VendorTaxIdLength = acc.Vendor_Tax_Id__c.length();
    
              if(!VendorTaxId.isNumeric())
             {
                 acc.addError('Girdiğiniz vergi numarası sadece numaradan oluşmalıdır. Harf boşluk veya özel karakter içermemelidir.Lütfen kontrol ediniz!');
             }
         
         
        system.debug('TAX ID Length : ' + VendorTaxIdLength); 
       
        
        /////VKN Control    
        if (VendorTaxIdLength == 10 ) {
            
        Integer v1 = 0;
        Integer v2 = 0;
        Integer v3 = 0;
        Integer v4 = 0;
        Integer v5 = 0;
        Integer v6 = 0;
        Integer v7 = 0;
        Integer v8 = 0;
        Integer v9 = 0;
        Integer v11 = 0;
        Integer v22 = 0;
        Integer v33 = 0;
        Integer v44 = 0;
        Integer v55 = 0;
        Integer v66 = 0;
        Integer v77 = 0;
        Integer v88 = 0;
        Integer v99 = 0;
        Integer v_last_digit = 0;
        Integer total = 0; 
            
    
            v1 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(0,1)) + 9),10);
            v2 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(1,2)) + 8),10);
            v3 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(2,3)) + 7),10);
            v4 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(3,4)) + 6),10);
            v5 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(4,5)) + 5),10);
            v6 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(5,6)) + 4),10);
            v7 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(6,7)) + 3),10);
            v8 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(7,8)) + 2),10);
            v9 = math.mod((Integer.valueOf(String.valueOf(VendorTaxId).Substring(8,9)) + 1),10);
            v_last_digit = Integer.valueOf(String.valueOf(VendorTaxId).Substring(9,10));
    
            v11 = math.mod((v1 * 512), 9);
            v22 = math.mod((v2 * 256), 9);
            v33 = math.mod((v3 * 128), 9);
            v44 = math.mod((v4 * 64), 9);
            v55 = math.mod((v5 * 32), 9);
            v66 = math.mod((v6 * 16), 9);
            v77 = math.mod((v7 * 8), 9);
            v88 = math.mod((v8 * 4), 9);
            v99 = math.mod((v9 * 2), 9);
    
            if (v1 != 0 && v11 == 0) v11 = 9;
            if (v2 != 0 && v22 == 0) v22 = 9;
            if (v3 != 0 && v33 == 0) v33 = 9;
            if (v4 != 0 && v44 == 0) v44 = 9;
            if (v5 != 0 && v55 == 0) v55 = 9;
            if (v6 != 0 && v66 == 0) v66 = 9;
            if (v7 != 0 && v77 == 0) v77 = 9;
            if (v8 != 0 && v88 == 0) v88 = 9;
            if (v9 != 0 && v99 == 0) v99 = 9;
            total = v11 + v22 + v33 + v44 + v55 + v66 + v77 + v88 + v99;
            
            system.debug('TOTAL :'+TOTAL);
    
            if (math.mod(total, 10) == 0)
            {
              total = 0;   
            }
                
            else 
                total = (10 - (math.mod(total, 10)));
    
            system.debug('TOTAL :'+total);
            system.debug('LAST DIGIT :'+v_last_digit);
            if (total == v_last_digit) {
    
           system.debug('Success');
                continue;
            } 
            else
            acc.addError('Girdiğiniz vergi numarası uygun değildir! Lütfen kontrol ediniz!');
        } 
             /////TCKN Control
             else if (VendorTaxIdLength == 11)
             { 
                 if(Integer.valueOf(String.valueOf(VendorTaxId).Substring(0,1)) == 0) 
                 {
                     acc.addError('TCKN Numaraları 0 ile başlayamaz! Lütfen kontrol ediniz! Line : 114');
                 }
                 
                Integer TOTAL = 0; 
                Integer LastDigit = 0; 
                Integer TotalOdd = 0;
                Integer TotalEven = 0;
                Integer Check = 0;
                Integer Counter = 0; 
                Integer Value = 0; 
                //total odd & total even
                 for( Integer i=1; i<11; i++ )
                 {
                     Counter = i-1;
                     Value = Integer.valueOf(String.valueOf(VendorTaxId).Substring(Counter,Counter+1)); 
                     system.debug('Counter : '+Counter);
                     system.debug('VALUE : ' + Value);
                    
                     //even
                     if(math.mod(Counter,2) == 0)
                     {                      
                         TotalEven+= Value;
                     }   
                          
                      //odd    
                     else 
                     {   
                        if(i==10)
                        {
                            break;
                        }
                      TotalOdd+= Value;
                     }
                 }             
                 
                 TOTAL = TotalEven + TotalOdd + Integer.valueOf(String.valueOf(VendorTaxId).Substring(9,10));
                 
                 system.debug('TOTAL : ' + TOTAL);
                 system.debug('TotalEven : ' + TotalEven);
                 system.debug('TotalOdd : ' +TotalOdd);
                 
                 LastDigit = math.mod(Total,10);        
                 system.debug('Last Digit : '+LastDigit);
                 
                if( Integer.valueOf(String.valueOf(VendorTaxId).Substring(10,11)) == LastDigit )
                { 
                   Check = (TotalEven * 7)-TotalOdd;
                    if(Check < 0)
                    {
                        Check = Check * -1;
                        String tempCheck = String.valueOf(Check);
                        system.debug('tempCheck : '+ tempCheck);
                        Integer tempCheckLength = tempCheck.length();
                        system.debug('tempCheckLength : '+ tempCheckLength);
                        Integer tempLastDigit = Integer.valueOf(String.valueOf(tempCheck).Substring(tempCheckLength-1,tempCheckLength));
                        system.debug('tempLastDigit : '+ tempLastDigit);
                        Check = (tempLastDigit*-1)+10;
                        
                        
                    } 
                    else
                    {
                      Check = math.mod(Check,10);
                    }
                    system.debug('Check : '+Check);
                    if(Integer.valueOf(String.valueOf(VendorTaxId).Substring(9,10))== Check)
                    {
                     system.debug('Success');   
                     continue;   
                    }
                    else
                        acc.addError('Girdiğiniz TCKN numarası uygun değildir! Lütfen kontrol ediniz! Line : 350');
                }
                
                else
                        acc.addError('Girdiğiniz TCKN numarası uygun değildir! Lütfen kontrol ediniz! Line : 354');              
                             
             }   
            }
           }
    
    
     }
 
//}
}
}