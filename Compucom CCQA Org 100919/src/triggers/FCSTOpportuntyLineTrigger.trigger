trigger FCSTOpportuntyLineTrigger on OpportunityLineItem (after insert,after update, after delete) {
    set<Id> setOppIds = new set<Id>();
    set<string> setExistingModel = new set<string>();
    
    Boolean triggerActive =false;
    FCST_Trigger__c mapCustomObjActive=FCST_Trigger__c.getValues('TriggerMapping');
    if(mapCustomObjActive!=null && mapCustomObjActive.FCST_LineItem_Trigger__c!=null && mapCustomObjActive.FCST_LineItem_Trigger__c==true && FCST_InsertProductModel.HandlerMethod2()) {
    	FCST_InsertProductModel.RecursionHandler2=false;
         triggerActive=mapCustomObjActive.FCST_LineItem_Trigger__c;
         
    if(trigger.isAfter && triggerActive){
       
        List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem>();
        
        
        
        if(!trigger.isdelete){    
            
            for(OpportunityLineItem line : trigger.New){
                
                if(trigger.isInsert  ){
                    lstOppLineItem.add(line);
                }
                else if(trigger.isUpdate){
                	if(   line.TotalPrice <> trigger.oldmap.get(line.Id).TotalPrice || line.Fcst_Auto_Script__c==True)
                		lstOppLineItem.add(line);
                }
            }
            
        }
        
        if(trigger.isdelete){
            
            for(OpportunityLineItem line: trigger.old){
                setOppIds.add(line.opportunityId);
                setExistingModel.add(line.opportunityId+'#'+line.Product2Id+'#'+line.id);
            }

        } 
        
        

        
       
        if(lstOppLineItem.size() > 0 ){
        	System.debug('>>>>>FCSTOpportuntyLineTrigger   >>>>'+lstOppLineItem.size()+'>>>>>'+lstOppLineItem);
            FCST_InsertProductModel.AddModels(lstOppLineItem);
        }
    }
     if(setOppIds.size()>0){
        List<FCST_Product_Model__c> lstModel = new List<FCST_Product_Model__c>();
        
        if(Schema.sObjectType.FCST_Product_Model__c.fields.Id.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Model_Name__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Product__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Opportunity__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.FCST_Product_Line_ID__c.isAccessible() ){
            for(FCST_Product_Model__c m : [select Id,Model_Name__c,Product__c,Opportunity__c,FCST_Product_Line_ID__c from FCST_Product_Model__c where Opportunity__c IN: setOppIds]){
                if(setExistingModel.contains(m.Opportunity__c +'#'+ m.Product__c+'#'+m.FCST_Product_Line_ID__c))
                lstModel.add(m);
            }
        }
        
        if(FCST_Product_Model__c.sObjectType.getDescribe().isDeletable())
        	delete lstModel;
     }
    }
}