public class OpportunityBFormController {

    public Opportunity oppName{get;set;}
    
    public Map<String,Decimal> smMap{get;set;}
    public Map<String,Decimal> gmMap{get;set;}
    
    //Total Variables
    public Decimal totalProductAmount{get;set;}
    
    //Product Variables
    public List<OpportunityLineItem> productList{get;set;}
    public Decimal totalProductRevenue{get;set;}
    public Decimal totalProductCost{get;set;}
    public Decimal totalProductSM{get;set;}
    public Decimal totalProductIndirectCost{get;set;}
    public Decimal totalProductGM{get;set;}
    public Decimal totalProductOpex{get;set;}
    public Decimal totalProductEBIT{get;set;}
    public Decimal smProductRevenuePercentage{get;set;}
    public Decimal gmProductRevenuePercentage{get;set;}
    
    //Service Variables
    public List<OpportunityLineItem> serviceList{get;set;}
    public Decimal totalServiceRevenue{get;set;}
    public Decimal totalServiceCost{get;set;}
    public Decimal totalServiceSM{get;set;}
    public Decimal totalServiceIndirectCost{get;set;}
    public Decimal totalServiceGM{get;set;}
    public Decimal totalServiceOpex{get;set;}
    public Decimal totalServiceEBIT{get;set;}
    public Decimal smServiceRevenuePercentage{get;set;}
    public Decimal gmServiceRevenuePercentage{get;set;}
    
    //Service Variables
    public List<OpportunityLineItem> rndList{get;set;}
    public Decimal totalRnDRevenue{get;set;}
    public Decimal totalRnDCost{get;set;}
    public Decimal totalRnDSM{get;set;}
    public Decimal totalRnDIndirectCost{get;set;}
    public Decimal totalRnDGM{get;set;}
    public Decimal totalRnDOpex{get;set;}
    public Decimal totalRnDEBIT{get;set;}
    public Decimal smRnDRevenuePercentage{get;set;}
    public Decimal gmRnDRevenuePercentage{get;set;}
    
    //Total of everything
    public Decimal totalRevenue{get;set;}
    public Decimal totalCost{get;set;}
    public Decimal totalSM{get;set;}
    public Decimal totalIndirectCost{get;set;}
    public Decimal totalGM{get;set;}
    public Decimal totalOpex{get;set;}
    public Decimal totalEBIT{get;set;}
    public Decimal totalEBT{get;set;}
    public Decimal totalEBITPer{get;set;}
    public Decimal totalEBTPer{get;set;}
    
    public Decimal smRevenuePercentage{get;set;}
    public Decimal gmRevenuePercentage{get;set;}
    public Decimal ebitRevenuePercentage{get;set;}
    
    public OpportunityBFormController(ApexPages.StandardController stdController){
        oppName = new Opportunity();
        oppName = (Opportunity) stdController.getRecord();
        
        String oppId = oppName.id;
        totalRevenue = 0;
        totalCost = 0;
        totalSM = 0;
        totalIndirectCost = 0;
        totalGM = 0;
        totalOpex = 0;
        totalEBIT = 0;
        totalEBITPer = 0;
        totalEBT = 0;
        totalEBTPer = 0;
        
        totalProductRevenue = 0;
        totalProductCost = 0;
        totalProductSM = 0;
        totalProductIndirectCost = 0;
        totalProductGM = 0;
        totalProductOpex = 0;
        totalProductEBIT = 0;
        
        totalServiceRevenue = 0;
        totalServiceCost = 0;
        totalServiceSM = 0;
        totalServiceIndirectCost = 0;
        totalServiceGM = 0;
        totalServiceOpex = 0;
        totalServiceEBIT = 0;
        
        totalRnDRevenue = 0;
        totalRnDCost = 0;
        totalRnDSM = 0;
        totalRnDIndirectCost = 0;
        totalRnDGM = 0;
        totalRnDOpex = 0;
        totalRnDEBIT = 0;
        
        totalProductAmount = 0;
        
        oppName = [SELECT 
                   Name, 
                   F_Business_Unit__c, 
                   Sales_Segment__r.Name, 
                   Estimated_Solution_Segment__c, 
                   Owner.Name,
                   BForm_EBIT__c,
                   BForm_EBIT_Perc__c,
                   BForm_GM__c,
                   BForm_GM_Perc__c, 
                   BForm_Indirect_Cost__c,
                   BForm_OPEX__c,
                   BForm_SM__c,
                   BForm_OPEX_Ratio__c,
                   BForm_Indirect_Cost_Ratio__c,
                   BForm_EBT__c,
                   BForm_EBT_Perc__c,
                   BForm_SM_Perc__c,
                   Total_Product_Cost__c,
                   Finance_Cost__c,
                   Total_Sales_Price__c,
                   Amount_USD__c,
                   Total_Product_Cost_USD__c
                   FROM Opportunity where id =: oppId];
        
        productList = new List<OpportunityLineItem>();
        serviceList = new List<OpportunityLineItem>();
        rndList = new List<OpportunityLineItem>();
        smMap = new Map<String,Decimal>();
        gmMap = new Map<String,Decimal>();
        
        productList = [SELECT Id, Product2.Name, UnitPrice, Sales_Price_USD__c, Cost__c, Cost_USD__c, Vendor__r.Name, Manufacturer__r.Name, Technology_Domain__r.Name, Originated_TD__r.Completed_by_User__r.Name, SM__c, SM_Perc__c, Indirect_Cost__c, GM__c, Opex__c, EBIT__c, Solution_Type__c FROM OpportunityLineItem WHERE OpportunityId =: oppId AND Solution_Type__c = 'Product consultancy'];
        serviceList = [SELECT Id, Product2.Name, UnitPrice, Sales_Price_USD__c, Cost__c, Cost_USD__c, Vendor__r.Name, Manufacturer__r.Name, Technology_Domain__r.Name, Originated_TD__r.Completed_by_User__r.Name, SM__c, SM_Perc__c, Indirect_Cost__c, GM__c, Opex__c, EBIT__c, Solution_Type__c FROM OpportunityLineItem WHERE OpportunityId =: oppId AND Solution_Type__c = 'Service consultancy'];
        rndList = [SELECT Id, Product2.Name, UnitPrice, Sales_Price_USD__c, Cost__c, Cost_USD__c, Vendor__r.Name, Manufacturer__r.Name, Technology_Domain__r.Name, Originated_TD__r.Completed_by_User__r.Name, SM__c, SM_Perc__c, Indirect_Cost__c, GM__c, Opex__c, EBIT__c, Solution_Type__c FROM OpportunityLineItem WHERE OpportunityId =: oppId AND Solution_Type__c = 'R&D consultancy'];
                
        for(OpportunityLineItem product : productList){
            
            if(product.Sales_Price_USD__c != null) totalProductRevenue += product.Sales_Price_USD__c;
            if(product.Cost__c != null) totalProductCost += product.Cost__c;
            if(product.SM__c != null) totalProductSM += product.SM__c;
            if(product.Indirect_Cost__c != null) totalProductIndirectCost += product.Indirect_Cost__c;
            if(product.GM__c != null) totalProductGM += product.GM__c;
            if(product.Opex__c != null) totalProductOpex += product.Opex__c;
            if(product.EBIT__c != null) totalProductEBIT += product.EBIT__c;
            Decimal tempSMPer = 0.00;
            if(product.Sales_Price_USD__c > 0){
                tempSMPer = (product.SM__c / product.Sales_Price_USD__c) * 100;
                tempSMPer = tempSMPer != null?tempSMPer.setScale(2):tempSMPer;
            }
            smMap.put(product.id,tempSMPer);
            
            Decimal tempGMPer = 0.00;
            if(product.Sales_Price_USD__c > 0){
                tempGMPer = (product.GM__c / product.Sales_Price_USD__c) * 100;
                tempGMPer = tempGMPer != null?tempGMPer.setScale(2):tempGMPer;
            }
            gmMap.put(product.id,tempGMPer);
        }
        
        for(OpportunityLineItem service:serviceList){
            if(service.Sales_Price_USD__c != null) totalServiceRevenue += service.Sales_Price_USD__c;
            if(service.Cost__c != null) totalServiceCost += service.Cost__c;
            if(service.SM__c != null) totalServiceSM += service.SM__c;
            if(service.Indirect_Cost__c != null) totalServiceIndirectCost += service.Indirect_Cost__c;
            if(service.GM__c != null) totalServiceGM += service.GM__c;
            if(service.Opex__c != null) totalServiceOpex += service.Opex__c;
            if(service.EBIT__c != null) totalServiceEBIT += service.EBIT__c;
            Decimal tempSMPer = 0.00;
            if(service.Sales_Price_USD__c > 0){
                tempSMPer = (service.SM__c / service.Sales_Price_USD__c) * 100;
                tempSMPer = tempSMPer != null?tempSMPer.setScale(2):tempSMPer;
            }
            smMap.put(service.id,tempSMPer);
            
            Decimal tempGMPer = 0.00;
            if(service.Sales_Price_USD__c > 0){
                tempGMPer = (service.GM__c / service.Sales_Price_USD__c) * 100;
                tempGMPer = tempGMPer != null?tempGMPer.setScale(2):tempGMPer;
            }
            gmMap.put(service.id,tempGMPer);
        }
        
        for(OpportunityLineItem rnd:rndList){
            if(rnd.Sales_Price_USD__c != null) totalrndRevenue += rnd.Sales_Price_USD__c;
            if(rnd.Cost__c != null) totalrndCost += rnd.Cost__c;
            if(rnd.SM__c != null) totalrndSM += rnd.SM__c;
            if(rnd.Indirect_Cost__c != null) totalrndIndirectCost += rnd.Indirect_Cost__c;
            if(rnd.GM__c != null) totalrndGM += rnd.GM__c;
            if(rnd.Opex__c != null) totalrndOpex += rnd.Opex__c;
            if(rnd.EBIT__c != null) totalrndEBIT += rnd.EBIT__c;
            Decimal tempSMPer = 0.00;
            if(rnd.Sales_Price_USD__c > 0){
                tempSMPer = (rnd.SM__c / rnd.Sales_Price_USD__c) * 100;
                tempSMPer = tempSMPer != null?tempSMPer.setScale(2):tempSMPer;
            }
            smMap.put(rnd.id,tempSMPer);
            
            Decimal tempGMPer = 0.00;
            if(rnd.Sales_Price_USD__c > 0){
                tempGMPer = (rnd.GM__c / rnd.Sales_Price_USD__c) * 100;
                tempGMPer = tempGMPer != null?tempGMPer.setScale(2):tempGMPer;
            }
            gmMap.put(rnd.id,tempGMPer);
        }
        
        if(totalProductRevenue > 0){
            smProductRevenuePercentage = (totalProductSM / totalProductRevenue) * 100;
            smProductRevenuePercentage = smProductRevenuePercentage != null?smProductRevenuePercentage.setScale(2):smProductRevenuePercentage;
            gmProductRevenuePercentage = (totalProductGM / totalProductRevenue) * 100;
            gmProductRevenuePercentage = gmProductRevenuePercentage != null?gmProductRevenuePercentage.setScale(2):gmProductRevenuePercentage;
        }
        
        if(totalServiceRevenue > 0){ 
            smServiceRevenuePercentage = (totalServiceSM / totalServiceRevenue) * 100;
            smServiceRevenuePercentage = smServiceRevenuePercentage != null?smServiceRevenuePercentage.setScale(2):smServiceRevenuePercentage;
            gmServiceRevenuePercentage = (totalServiceGM / totalServiceRevenue) * 100;
            gmServiceRevenuePercentage = gmServiceRevenuePercentage != null?gmServiceRevenuePercentage.setScale(2):gmServiceRevenuePercentage;
        }
        
        if(totalrndRevenue > 0){ 
            smrndRevenuePercentage = (totalrndSM / totalrndRevenue) * 100;
            smrndRevenuePercentage = smrndRevenuePercentage != null?smrndRevenuePercentage.setScale(2):smrndRevenuePercentage;
            gmrndRevenuePercentage = (totalrndGM / totalrndRevenue) * 100;
            gmrndRevenuePercentage = gmrndRevenuePercentage != null?gmrndRevenuePercentage.setScale(2):gmrndRevenuePercentage;
        }
        
        totalRevenue = totalProductRevenue + totalServiceRevenue + totalrndRevenue;
        totalCost = totalProductCost + totalServiceCost + totalrndCost + totalProductAmount;
        totalSM = (totalProductRevenue  + totalServiceRevenue + totalRnDRevenue) - (totalProductCost + totalServiceCost  + totalRndCost + totalProductAmount);
        totalIndirectCost = totalProductIndirectCost + totalServiceIndirectCost + totalRndIndirectCost + (totalProductAmount * .02);
        totalGM = totalSM - totalIndirectCost;
        totalOpex = totalProductOpex + totalServiceOpex + totalRndOpex;
        totalEBIT = totalProductEBIT + totalServiceEBIT + totalRndEBIT;
        totalEBT = totalEBIT;
        
        if( totalRevenue > 0 ){
            totalEBTPer = (totalEBT / totalRevenue) * 100;
            totalEBTPer = totalEBTPer != null?totalEBTPer.setScale(2):totalEBTPer;
            totalEBITPer = (totalEBIT / totalRevenue) * 100;
            totalEBITPer = totalEBITPer != null?totalEBITPer.setScale(2):totalEBITPer;
            smRevenuePercentage = (totalSM / totalRevenue) * 100;
            smRevenuePercentage = smRevenuePercentage != null?smRevenuePercentage.setScale(2):smRevenuePercentage;
            gmRevenuePercentage = (totalGM / totalRevenue) * 100;
            gmRevenuePercentage = gmRevenuePercentage != null?gmRevenuePercentage.setScale(2):gmRevenuePercentage;
            ebitRevenuePercentage = (totalEBIT / totalRevenue) * 100;
            ebitRevenuePercentage = ebitRevenuePercentage != null?ebitRevenuePercentage.setScale(2):ebitRevenuePercentage;
        }
    }
}