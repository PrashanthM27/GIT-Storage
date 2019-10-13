/****
  Developer Name/Author:  Pritam Gupta
  Created Date: 9-Sep-2019
  Work item number from JIRA:-CRN-173
  Description: we are now creating PM forecast and deleting Product model using Opporunity trigger and util class is-FCST_PM_Forecast_Util.

****/

public with sharing class FCST_Product_Model_Trigger_Util {
    
    
    public static void AddOpporunityInitailModels(set<Id> setOppIds,Set<Id> SetfiscalPeriodId,Set<Id> SetPlanningVersionId,List<FCST_Product_Model__c> planningModelList){
    /*    try{
         Map<String,Double> mapOppPVPPVsWeigthedAmount =new Map<String,Double>();
         Map<String,Double> mapOppPVPPVsUserAdjustedAmount =new Map<String,Double>();
        Map<String,FCST_Opportunity_Initial_Forecast__c> mapintialForecastVsWeigthedAmount =new Map<String,FCST_Opportunity_Initial_Forecast__c>(); 
        List<FCST_Opportunity_Initial_Forecast__c> upsertIntialForecastList = new List<FCST_Opportunity_Initial_Forecast__c>();
        String closedString='Closed Won';
        Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        string planningModelQFieldApi=mapCustomObj.Fcst_Q__c;
        planningModelQFieldApi=planningModelQFieldApi.replace('', '');
        planningModelQFieldApi=planningModelQFieldApi.trim();
        String relatedField='Opportunity__r.'+planningModelQFieldApi;
        
        
        String planningModelQuery='Select User_Adjusted_Revenue__c,'+relatedField+',Name,Fiscal_Period__c,Opportunity__c,Planning_Version__c,Weighted_Revenue__c,Id from FCST_Product_Model__c where Opportunity__c IN:setOppIds and Fiscal_Period__c IN: SetfiscalPeriodId and Planning_Version__c IN:SetPlanningVersionId and Opportunity__r.StageName=:closedString';
        
         List<FCST_Product_Model__c> allPlanningModelList=database.query(planningModelQuery);
        List<FCST_Opportunity_Initial_Forecast__c> allIntialForecast= [Select User_Adjusted_Revenue__c,Id,Fcst_Fiscal_Period__c,Fcst_Q__c,Fcst_Weighted_Revenue__c,Fcst_Opportunity__c,FCST_Planning_Version__c  from FCST_Opportunity_Initial_Forecast__c   where Fcst_Opportunity__c IN:setOppIds and Fcst_Fiscal_Period__c IN: SetfiscalPeriodId and FCST_Planning_Version__c IN:SetPlanningVersionId  ];
        
        
        if(allPlanningModelList!=null && allPlanningModelList.size()>0){
              for(FCST_Product_Model__c planningObj:allPlanningModelList){
                String qNumber=(String)planningObj.getSObject('Opportunity__r').get(planningModelQFieldApi);
                double totalVal=0,userAdjustedAmount=0;
                  if(mapOppPVPPVsWeigthedAmount.containsKey(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber)){ 
                     double amount =mapOppPVPPVsWeigthedAmount.get(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber);
                     totalVal=amount+planningObj.Weighted_Revenue__c;
                     mapOppPVPPVsWeigthedAmount.put(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber,totalVal);
                   }
                  else{
                     mapOppPVPPVsWeigthedAmount.put(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber,planningObj.Weighted_Revenue__c);
                  }
                  
                  if(mapOppPVPPVsUserAdjustedAmount.containsKey(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber)){ 
                     double amount =mapOppPVPPVsUserAdjustedAmount.get(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber);
                     userAdjustedAmount=amount+planningObj.User_Adjusted_Revenue__c;
                     mapOppPVPPVsUserAdjustedAmount.put(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber,totalVal);
                   }
                  else{
                     mapOppPVPPVsUserAdjustedAmount.put(planningObj.Opportunity__c+'#'+planningObj.Planning_Version__c+'#'+planningObj.Fiscal_Period__c+'#'+qNumber,planningObj.User_Adjusted_Revenue__c);
                  }
            }  
         }
        if(allIntialForecast!=null && allIntialForecast.size()>0){
            for(FCST_Opportunity_Initial_Forecast__c intialObj:allIntialForecast){
                mapintialForecastVsWeigthedAmount.put(intialObj.Fcst_Opportunity__c+'#'+intialObj.FCST_Planning_Version__c+'#'+intialObj.Fcst_Fiscal_Period__c+'#'+intialObj.Fcst_Q__c,intialObj);
            }
         }
         
         for(String keyObj:mapOppPVPPVsWeigthedAmount.keyset()){
             double amountVal=mapOppPVPPVsWeigthedAmount.get(keyObj);
             double userAdjustedAmount=mapOppPVPPVsUserAdjustedAmount.get(keyObj);
             
             if(userAdjustedAmount==null) userAdjustedAmount=0;
             if(amountVal==null) amountVal=0;
             
             if(mapintialForecastVsWeigthedAmount.containsKey(keyObj) ){
                FCST_Opportunity_Initial_Forecast__c obj=mapintialForecastVsWeigthedAmount.get(keyObj);
                obj.Fcst_Weighted_Revenue__c=amountVal;
                obj.User_Adjusted_Revenue__c=userAdjustedAmount;
                upsertIntialForecastList.add(obj);
             }
             else{
                FCST_Opportunity_Initial_Forecast__c forecastInitialObj = new FCST_Opportunity_Initial_Forecast__c();
                List<String> idParts = keyObj.split('#');
                forecastInitialObj.Fcst_Opportunity__c=Id.valueOf(idParts[0]);
               forecastInitialObj.FCST_Planning_Version__c=Id.valueOf(idParts[1]);
                forecastInitialObj.Fcst_Fiscal_Period__c=Id.valueOf(idParts[2]);
                forecastInitialObj.Fcst_Q__c=idParts[3];
                forecastInitialObj.Fcst_Weighted_Revenue__c=amountVal;
                forecastInitialObj.User_Adjusted_Revenue__c=userAdjustedAmount;
                upsertIntialForecastList.add(forecastInitialObj);
             }
         }
         
         if(upsertIntialForecastList!=null && upsertIntialForecastList.size()>0){
            upsert upsertIntialForecastList;
         }
         System.debug('Line setOppIds: ' + setOppIds);
         if(setOppIds!=null && setOppIds.size()>0){ 
	         FCST_To_CleanModel uca = new FCST_To_CleanModel(setOppIds);
	         Database.executeBatch(uca);
         }
    	}
    
    
    
          catch(Exception e) {
            System.debug('The following exception has occurred:aa ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber()); 
          }
         */ 
    }
    
    
   
    
    
    
    
}