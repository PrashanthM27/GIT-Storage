trigger FCST_AccountTrigger on Account (after insert, after update) {
    
    List<Account> cpmChangeAccountList = new List<Account>();
    List<FCST_Product_Model__c> productModelList = new List<FCST_Product_Model__c>();
    
    Boolean triggerActive =false;
    FCST_Trigger__c mapCustomObjActive=FCST_Trigger__c.getValues('TriggerMapping');
    system.debug('mapCustomObjActive '+mapCustomObjActive);
    if(mapCustomObjActive!=null && mapCustomObjActive.Account_Trigger__c!=null && mapCustomObjActive.Account_Trigger__c==true && FCST_AccountTriggerHandler.RecursionHandler ) {
         triggerActive=mapCustomObjActive.Account_Trigger__c;
         FCST_AccountTriggerHandler.RecursionHandler=false;
        system.debug('triggerActive  '+triggerActive);
         system.debug('Trigger.isAfter  '+Trigger.isAfter);
        system.debug('Trigger.isUpdate  '+Trigger.isUpdate);
    if(triggerActive && (Trigger.isAfter && Trigger.isUpdate) ){
        Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        string cpmRegionLabelName='',PMLabelName='',PELabelName='',GeoCodesLableName='';
            cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
            PMLabelName = mapCustomObj.FCST_ProgramManager__c;
            PELabelName = mapCustomObj.FCST_Program_Executive__c;
            GeoCodesLableName = mapCustomObj.FCST_GeoCodes__c;
            for(Account  accObj: trigger.new){ 
                
                if( ((String) accObj.get(cpmRegionLabelName)) <> ((String) trigger.oldmap.get(accObj.Id).get(cpmRegionLabelName)) || ((String) accObj.get(PMLabelName)) <> ((String) trigger.oldmap.get(accObj.Id).get(PMLabelName)) || ((String) accObj.get(PELabelName)) <> ((String) trigger.oldmap.get(accObj.Id).get(PELabelName)) || ((String) accObj.get(GeoCodesLableName)) <> ((String) trigger.oldmap.get(accObj.Id).get(GeoCodesLableName))){
                    cpmChangeAccountList.add(accObj);
                  }
            }
        } 
           
            
        if(cpmChangeAccountList!=null && cpmChangeAccountList.size()>0){
            FCSTBatchToHandleAccountTrigger uca = new FCSTBatchToHandleAccountTrigger(cpmChangeAccountList);
            Database.executeBatch(uca,4000);
         }
         
         Date currentYear=Date.newInstance(2019, 1, 1);
         String oppStageCloseLost='Closed Lost',noaction='No Action',closeNoaction='Closed/No Action';
         
         if(cpmChangeAccountList!=null && cpmChangeAccountList.size()>0){
             if(Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.FCST_Script__c.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.OpportunityId.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.Fcst_Auto_Script__c.isAccessible()){
	         String OppQuery='Select Id,FCST_Script__c,(Select OpportunityId,Fcst_Auto_Script__c from OpportunityLineItems) from Opportunity where AccountId IN:cpmChangeAccountList and CloseDate>=:currentYear and StageName!=:noaction and StageName!=:closeNoaction  and StageName!=:oppStageCloseLost and  Id NOT IN(Select Opportunity__c from FCST_Product_Model__c where Account__c IN:cpmChangeAccountList )  and Id NOT IN(Select Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c   ) ';
	         List<Opportunity> oppList =database.query(OppQuery);
	         
	         if(oppList!=null && oppList.size()>0){
	            FCST_AccountTriggerHandler.updateMOdelCPM(oppList);
	         }
                 }
         }
                 
     }
      System.debug('>>>>>>>');
}