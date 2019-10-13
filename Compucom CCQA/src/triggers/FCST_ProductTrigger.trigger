trigger FCST_ProductTrigger on Product2 (after update) {
	
	List<Product2> revenueChangeProductList = new List<Product2>();
	List<FCST_Product_Model__c> productModelList = new List<FCST_Product_Model__c>();
	Boolean triggerActive=false;
    FCST_Trigger__c mapCustomObj=FCST_Trigger__c.getValues('TriggerMapping');
    if(mapCustomObj!=null && mapCustomObj.Product_Trigger__c!=null && mapCustomObj.Product_Trigger__c==true){
    	 triggerActive=mapCustomObj.Product_Trigger__c;
    	
    if(triggerActive && (Trigger.isAfter && Trigger.isUpdate) ){
    	Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
    	string revenueLabelName='';
	    	revenueLabelName = mapCustomObj.Fcst_Revenue_Type__c;
	    		
	    	for(Product2  productObj: trigger.new){ 
	    		
	    		if( ((String) productObj.get(revenueLabelName)) <> ((String) trigger.oldmap.get(productObj.Id).get(revenueLabelName))){
	    			revenueChangeProductList.add(productObj);
	    		  }
	    	}
	     }	
	    	//String modelQuery='Select FCST_Revenue_Types__c,Product__r.'+revenueLabelName+'	 from FCST_Product_Model__c where Product__c IN:revenueChangeProductList';
	    	//List<FCST_Product_Model__c> productModelList =database.query(revenueChangeProductList); 
	    Date currentYear=Date.newInstance(2019, 1, 1);
             String oppStageCloseLost='Closed Lost',noaction='No Action',closeNoaction='Closed/No Action',closewon='Closed Won';	
        
		List<Opportunity> opplistAll = new List<Opportunity>();
        
        if(Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.FCST_Script__c.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.OpportunityId.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.Fcst_Auto_Script__c.isAccessible()  && Schema.sObjectType.FCST_Opportunity_Initial_Forecast__c.fields.Fcst_Opportunity__c.isAccessible()){
		 String OppWonQuery='Select Id,FCST_Script__c,(Select OpportunityId,Fcst_Auto_Script__c from OpportunityLineItems) from Opportunity where  CloseDate>=:currentYear and StageName!=:noaction and StageName!=:closeNoaction  and StageName!=:oppStageCloseLost and StageName=:closewon  and Id NOT IN(Select Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c   ) and Id IN(Select OpportunityId from OpportunityLineItem where Product2Id IN:revenueChangeProductList)';
		List<Opportunity> oppList1 =database.query(OppWonQuery);
            opplistAll.addAll(oppList1);
        }
        if(Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.FCST_Script__c.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.OpportunityId.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.Fcst_Auto_Script__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Opportunity__c.isAccessible()){
		 String OppOpenQuery='Select Id,FCST_Script__c,(Select OpportunityId,Fcst_Auto_Script__c from OpportunityLineItems) from Opportunity where  CloseDate>=:currentYear and StageName!=:noaction and StageName!=:closeNoaction  and StageName!=:oppStageCloseLost and StageName!=:closewon and  Id NOT IN(Select Opportunity__c from FCST_Product_Model__c )  and Id IN(Select OpportunityId from OpportunityLineItem where Product2Id IN:revenueChangeProductList)';
		List<Opportunity> oppList2 =database.query(OppOpenQuery);
            opplistAll.addAll(oppList2);
        }
		
		
		
		
		
		
		
		if(opplistAll!=null && opplistAll.size()>0){
                FCST_AccountTriggerHandler.updateMOdelCPM(opplistAll);
             }
             
        if(revenueChangeProductList!=null && revenueChangeProductList.size()>0){
	     	FCSTBatchToHandleProductTrigger tes = new FCSTBatchToHandleProductTrigger(revenueChangeProductList);
	        Database.executeBatch(tes,4000); 
	     } 
    }        
     System.debug('>>>>>>>');
     
     
    
}