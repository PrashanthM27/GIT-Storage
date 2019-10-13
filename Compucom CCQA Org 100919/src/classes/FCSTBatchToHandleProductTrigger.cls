global with sharing class FCSTBatchToHandleProductTrigger implements Database.Batchable<sObject>,Database.Stateful{
    	
	string revenueTypeLabel;
	List<Product2> productlistVal;
	global FCSTBatchToHandleProductTrigger(List<Product2> productList) {
		 	
	   Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
	    if(mapCustomObj <> null)
	    	revenueTypeLabel = mapCustomObj.Fcst_Revenue_Type__c;
	    
	    productlistVal = new List<Product2>();	
	    productlistVal.addAll(productList);
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
	       
		return Database.getQueryLocator('Select FCST_Revenue_Types__c,Product__r.'+revenueTypeLabel+'	 from FCST_Product_Model__c where Product__c IN:productlistVal'); 
    }
    
    global void execute(Database.BatchableContext bc, List<FCST_Product_Model__c> productModelListVal){
     	try{
	    	List<FCST_Product_Model__c> modelListCPMUpdate = new List<FCST_Product_Model__c>();
	    	
	    	if(productModelListVal!=null && productModelListVal.size()>0){
	    		for(FCST_Product_Model__c proObj:productModelListVal){
	    			String revenue='';
	    			if((Product2)proObj.getSObject('Product__r')!=null)
	    			   revenue=(String)proObj.getSObject('Product__r').get(revenueTypeLabel);
	    			
	    			proObj.FCST_Revenue_Types__c=revenue;
	    			modelListCPMUpdate.add(proObj);
	    		}
	    	}
    	
	      if(modelListCPMUpdate!=null && modelListCPMUpdate.size()>0)
	       update modelListCPMUpdate;
     		
     	}
        catch(Exception e) {
            System.debug('Exception Message '+e);
            System.debug('Exception Line Number: '+e.getLineNumber());
        
        }
	
    }
    
    global void finish(Database.BatchableContext bc){
    	
    }
}