trigger FCST_OpportunityAfterTrigger on Opportunity (after insert, after update,before delete) {
    set<Id> setOppIds = new set<Id>();
    set<Id> setNewOppAddIds = new set<Id>();
    set<Id> setNewOppRemoveIds = new set<Id>();
    MappingFieldUtility mfu = new MappingFieldUtility();
    List<Opportunity> oppList=new List<Opportunity>();
    List<Opportunity> oppRegionChangeList;
    
    Boolean triggerActive =false;
    FCST_Trigger__c mapCustomObjActive=FCST_Trigger__c.getValues('TriggerMapping');
    if(mapCustomObjActive!=null && mapCustomObjActive.FCST_Opportunity_Trigger__c!=null && mapCustomObjActive.FCST_Opportunity_Trigger__c==true && FCST_InsertProductModel.RecursionHandler) {
    	FCST_InsertProductModel.RecursionHandler=false;
         triggerActive=mapCustomObjActive.FCST_Opportunity_Trigger__c;
        
    if(Trigger.isAfter && Trigger.isUpdate && triggerActive){ 
    	
    	oppRegionChangeList = new List<Opportunity>();
    	Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
    	string GeoLabelName='';
	    	GeoLabelName = mapCustomObj.Geo__c;
	    	    
        for(Opportunity opp: trigger.new){ 
        	
        	System.debug('>>opp>>>'+opp);
        	
            if(opp.ForecastCategory=='Closed' && opp.StageName <> trigger.oldmap.get(opp.Id).StageName){
                oppList.add(opp);
                System.debug('>>oppList>>>'+oppList);
            }
            if(
               // mfu.getRevenueType(opp) <> mfu.getRevenueType(trigger.oldmap.get(opp.Id)) || 
                opp.StageName <> trigger.oldmap.get(opp.Id).StageName || opp.FCST_Script__c==True ||
                opp.CloseDate <> trigger.oldmap.get(opp.Id).CloseDate || 
                mfu.getProjectStartDate(opp) <> mfu.getProjectStartDate(trigger.oldmap.get(opp.Id)) || 
                mfu.getProjectEndDate(opp) <> mfu.getProjectEndDate(trigger.oldmap.get(opp.Id)) 
            ){
            	System.debug('>Sta  opp >>>'+opp);
            	
                if(opp.StageName != 'Closed Lost' || opp.StageName !='No Action')setNewOppAddIds.add(opp.id);
                if(opp.StageName == 'Closed Lost' || opp.StageName == 'Closed/No Action' || opp.StageName =='No Action')
                {	setNewOppRemoveIds.add(opp.id);
                	System.debug('>StageName>setNewOppRemoveIds>>>'+setNewOppRemoveIds);
                }
            }
            
            if( ((String) opp.get(GeoLabelName)) <> ((String) trigger.oldmap.get(opp.Id).get(GeoLabelName))){
	    			oppRegionChangeList.add(opp);
	    	}
        }
        
        
    }
    if(setNewOppAddIds.size()>0){    
        
        List<OpportunityLineItem> lstAddLine = database.query('select Id,Risk_Factor__c,TotalPrice ,opportunityId,ServiceDate,Product2Id from OpportunitylineItem where OpportunityId IN: setNewOppAddIds');
        if(lstAddLine.size() > 0){
            System.debug('HS Debug:'+lstAddLine.size()+'::'+lstAddLine);
        
            FCST_InsertProductModel.AddModels(lstAddLine);
        }
    }
    if(setNewOppRemoveIds.size()>0 && Schema.sObjectType.FCST_Product_Model__c.fields.Id.isAccessible()){
    	System.debug('>>setNewOppRemoveIds>>>'+setNewOppRemoveIds);
        List<FCST_Product_Model__c> models =[select id from FCST_Product_Model__c where Opportunity__c IN:setNewOppRemoveIds];
        System.debug('>>models>>>'+models);
       if (FCST_Product_Model__c.sObjectType.getDescribe().isDeletable())
            delete models;
    }
     
    if(oppList!=null && oppList.size()>0)
        FCST_Insert_Contract_Util.createContracts(oppList);
        
    
    if(oppRegionChangeList!=null && oppRegionChangeList.size()>0)
        FCST_Insert_Contract_Util.updateCPMRegionOfContract(oppRegionChangeList);  
        
    }   
}