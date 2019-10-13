trigger FCST_ProductModel_Trigger on FCST_Product_Model__c (after insert,after update) {
    
    set<Id> setOppIds = new set<Id>();
    Set<Id> SetfiscalPeriodId =new set<Id>();
    Set<Id> SetPlanningVersionId =new set<Id>();
    List<FCST_Product_Model__c> forecastClosedModelList =new List<FCST_Product_Model__c>();
    
    for(FCST_Product_Model__c proObj: trigger.new){
    if(proObj.Opportunity_StageName__c=='Closed Won'){
            forecastClosedModelList.add(proObj);
            if(proObj.Opportunity__c!=null)
                setOppIds.add(proObj.Opportunity__c);
            if(proObj.Fiscal_Period__c!=null)
                SetfiscalPeriodId.add(proObj.Fiscal_Period__c);
            if(proObj.Planning_Version__c!=null)
                SetPlanningVersionId.add(proObj.Planning_Version__c);
        }
    } 
     
    FCST_Product_Model_Trigger_Util.AddOpporunityInitailModels(setOppIds,SetfiscalPeriodId,SetPlanningVersionId,forecastClosedModelList);
    System.debug('>>>forecastClosedModelList>>>>>'+forecastClosedModelList);
          
}