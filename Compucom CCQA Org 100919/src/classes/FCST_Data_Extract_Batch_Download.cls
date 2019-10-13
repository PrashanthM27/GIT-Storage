global class FCST_Data_Extract_Batch_Download implements Database.Batchable<sObject>,Database.Stateful {
  private String fromSelectedYear;
    private  string finalSuccessStr;  
    public String selectedYr{get;set;}
    public String planningVersion{get;set;}
    
    public String cpmRegionLabelName;
    public String PMTypeLabelName;
    public String PETypeLabelName;
    public String GeoLabelName;
    
    public String currentFullYear;
    public String nextFullYear;
    public String openAdminVersion;
    public string formattedDate;
    
    public string costCenterAPI;
  public string businessUnitAPI;
  
  public string TCVAPI;
  public string SVCYR1API;
  public string oppGeoLookupAPI;
    
    public Integer currentFullYearInt;
    
    public string serviceStartDateAPI;
  public string serviceEndDateAPI;
  public string transitionDateAPI;
  public string termsInMonthAPI;
  
  public string offeringAmountAPI;
  
  public string oppBslaAPI;
  
  public string oppRecordTypeAPI;
  public map<String,String> mapRecordIdVsName;
  
    
  global FCST_Data_Extract_Batch_Download(String selectedYear,String planningVersionval) {
     fromSelectedYear=selectedYear;
     
     currentFullYear=fromSelectedYear;
     nextFullYear=String.ValueOf(Integer.ValueOf(currentFullYear)+1);
    
     selectedYr=fromSelectedYear.right(2);
       String nextYear=String.ValueOf(Integer.ValueOf(selectedYr)+1);
     openAdminVersion=planningVersionval;
    
     Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
     cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
     PMTypeLabelName=mapCustomObj.FCST_ProgramManager__c;
     PETypeLabelName=mapCustomObj.FCST_Program_Executive__c;
     GeoLabelName=mapCustomObj.FCST_GeoCodes__c;
     
     serviceStartDateAPI=mapCustomObj.Fcst_StartDate__c;
     serviceEndDateAPI=mapCustomObj.Fcst_EndDate__c;
     transitionDateAPI=mapCustomObj.Transition_Date__c;
     termsInMonthAPI=mapCustomObj.Term_In_Months__c;
     offeringAmountAPI=mapCustomObj.Fcst_Product_Amount__c;
     
     costCenterAPI=mapCustomObj.Cost_Center__c;
       businessUnitAPI=mapCustomObj.Fcst_BusinessUnit__c;
       
       TCVAPI=mapCustomObj.Opportunity_TCV__c;
       SVCYR1API=mapCustomObj.Opportunity_SVC_YR1__c;
       oppGeoLookupAPI=mapCustomObj.Geo__c;
       
       oppBslaAPI=mapCustomObj.FCST_BSLA__c;
      
      oppRecordTypeAPI=mapCustomObj.Opportunity_RecordType_Api__c;
     
     date todayDate=date.today();
     formattedDate =todayDate.month()+'/'+todayDate.day()+'/'+todayDate.year();


    string fileHearder= 'Program Name,Region,PE Name,PM Name,Revenue Type,Cost Center,Business Unit,GEO,Assigned Geo,Forecast,Contract #,Contract Line Item Description,Opportunity,Offering Name,Opportunity Stage,Opportunity Type,Opportunity Record Type,BSLA#,TCV,SVC YR1 Amount - Opportunity,Offering Amount,Svc Yr1 & Prod Amt- Opportunity,Product Amount- Opportunity,Service Start Date,Service End Date,Term in Months,Transition date,Planning Version,Date of Data Extraction,Last Modified By,Last modified Date,Jan-'+selectedYr+' ,Feb-'+selectedYr+' ,Mar-'+selectedYr+' ,Apr-'+selectedYr+',May-'+selectedYr+' ,Jun-'+selectedYr+' ,Jul-'+selectedYr+' ,Aug-'+selectedYr+' ,Sep-'+selectedYr+' ,Oct-'+selectedYr+',Nov-'+selectedYr+' ,Dec-'+selectedYr+',Jan-'+nextYear+' ,Feb-'+nextYear+' ,Mar-'+nextYear+' ,Apr-'+nextYear+',May-'+nextYear+' ,Jun-'+nextYear+' ,Jul-'+nextYear+' ,Aug-'+nextYear+' ,Sep-'+nextYear+' ,Oct-'+nextYear+',Nov-'+nextYear+' ,Dec-'+nextYear+' \n';
    finalSuccessStr=fileHearder;
    
    mapRecordIdVsName = new Map<String, String>();
    List<RecordType> recordTypeList=[select Id,Name from RecordType LIMIT 8000];
    if(recordTypeList!=null && recordTypeList.size()>0){
      for(RecordType recordObj:recordTypeList){
        mapRecordIdVsName.put(String.ValueOf(recordObj.Id),recordObj.Name);
      }
    }
    
  }
  
  global Database.QueryLocator start(Database.BatchableContext bc) {
         //String accName='DELL';
    return Database.getQueryLocator('select Id,Name,'+GeoLabelName+','+cpmRegionLabelName+','+PETypeLabelName+','+PMTypeLabelName+' from Account where   '+cpmRegionLabelName+'!=null   order by Name  '); 
    }
    
     global void execute(Database.BatchableContext bc, List<Account> accListVal){
       try{
         Integer currentYear=date.today().Year();
          Map<Id,List<Opportunity>> mapAccountVsOppList =new Map<Id,List<Opportunity>>();
          Map<Id,Opportunity> mapOppIdVsOppObj =new Map<Id,Opportunity>();
          
          String assisgnedGeoAPI=oppGeoLookupAPI.removeEnd('c')+'r';
          String queryAssignGeoApI=oppGeoLookupAPI.removeEnd('c')+'r.Name';
          
         // string testssa='0061U000007wBq1QAE';
          String oppQuery=' Select '+offeringAmountAPI+','+oppBslaAPI+','+oppRecordTypeAPI+',Amount,Type,id,Name,AccountId,StageName,'+serviceStartDateAPI+','+serviceEndDateAPI+','+transitionDateAPI+','+termsInMonthAPI+','+TCVAPI+','+SVCYR1API+','+oppGeoLookupAPI+','+queryAssignGeoApI+'  from Opportunity where AccountId IN:accListVal ';
          
          //System.debug('oppQuery>>>>'+oppQuery);
          List<Opportunity> oppList=database.query(oppQuery);
          
          for(Opportunity oppObj:oppList){
            mapOppIdVsOppObj.put(oppObj.id,oppObj);
             if(mapAccountVsOppList.containsKey(oppObj.AccountId)){ 
                  List<Opportunity> existingList =mapAccountVsOppList.get(oppObj.AccountId);
                  existingList.add(oppObj);
                  mapAccountVsOppList.put(oppObj.AccountId,existingList);
                 }
                 else{
                     List<Opportunity> newOppList = new List<Opportunity>();
                     newOppList.add(oppObj);
                     mapAccountVsOppList.put(oppObj.AccountId,newOppList);
               }
          }
          
          
          Set<Id> pmIdSet = new Set<Id>();
          
          if(accListVal!=null && accListVal.size()>0){
            for(Account acc :accListVal){
              if((String) acc.get(PMTypeLabelName)!=null)
                pmIdSet.add(Id.ValueOf((String) acc.get(PMTypeLabelName)));
                if((String) acc.get(PETypeLabelName)!=null)
                pmIdSet.add(Id.ValueOf((String) acc.get(PETypeLabelName)));
            }
          }
          String pmquery='Select Id,Name from User where Id IN:pmIdSet and isActive=true';
          
          Map<String,String> mapIdVsName = new Map<String,String>();
          
          List<User> pmList=database.query(pmquery);
          if(pmList!=null && pmList.size()>0){
            for(User obj:pmList){
              mapIdVsName.put(obj.Id,obj.Name);
            }
          } 
          
          Map<Id,Set<Id>>  OppVsContractBaselineIdSet = new  Map<Id,Set<Id>>();
          Map<Id,Set<String>>  accIdVsRevenueTypeMapSet = new  Map<Id,Set<String>>();
          Map<String,Set<Id>>  revenueTypeVsOppIdSet = new  Map<String,Set<Id>>();
          Map<String,Set<Id>>  accIdRevenueTypeVsContractBaselineSet = new  Map<String,Set<Id>>();
          Map<Id,Set<Id>>  OppVsContractClosedWonIdSet = new  Map<Id,Set<Id>>();
          Map<String,Set<Id>>  contractVsCloseWonconLineItemIdSet = new  Map<String,Set<Id>>();
          Map<String,Set<Id>>  contractVsBaseLineconLineItemIdSet = new  Map<String,Set<Id>>();
          
          Set<Id> contractIdSet = new Set<Id>();
          
          Map<Id,FCST_Contract__c> mapContractIdVsName = new Map<Id,FCST_Contract__c>();
          Map<Id,String> mapContractLineItemIdVsName = new Map<Id,String>();
          
          Map<Id,List<FCST_Initial_Forecast__c>> mapContractLineItemIdVsIntialForecastList = new Map<Id,List<FCST_Initial_Forecast__c>>();
          
          Map<Id,List<FCST_Product_Model__c>> mapLineItemIdVsListProductModelPipeLine = new Map<Id,List<FCST_Product_Model__c>>();
          Map<Id,List<FCST_Product_Model__c>> mapLineItemIdVsListProductModelFunnel = new Map<Id,List<FCST_Product_Model__c>>();
          
           String baselineQuery ='Select  Contract_LineItem__r.BSLA_Number__c,FCST_Contract__r.Fcst_Service_End_date__c,FCST_Contract__r.Fcst_Service_start_date__c,LastModifiedBy.Name,LastModifiedDate,Contract_LineItem__r.Cost_Center__c,FCST_Contract__r.Contract__c,Contract_LineItem__r.Line_Description__c,Contract_LineItem__r.BU_Level2__c,Contract_LineItem__r.BU_Level1__c,FCST_Contract__r.Contract_Description__c,FCST_Planning_Fiscal_Year__r.Fiscal_Year__c,Contract_LineItem__r.Name,FCST_Contract__c,FCST_Contract__r.Name,Contract_LineItem__c,FCST_Contract__r.Opportunity__c,FCST_Contract__r.Opportunity__r.StageName,FCST_Planning_Fiscal_Year__r.Month_Number__c,Fcst_Amount__c,Forecast_with_Risk__c,Account__r.Id ,Contract_LineItem__r.Fcst_Revenue_Type__c  from  FCST_Initial_Forecast__c where ';
       baselineQuery += ' Planning_Version__r.Name =: openAdminVersion and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c<:currentYear  and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null  and (FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:currentFullYear or FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:nextFullYear)';
       baselineQuery += ' order by Account__r.Id,Contract_LineItem__r.Fcst_Revenue_Type__c';
       
       List<FCST_Initial_Forecast__c> baselineIntialForecastList=database.query(baselineQuery); 
       
       
       if(baselineIntialForecastList!=null && baselineIntialForecastList.size()>0){
         for(FCST_Initial_Forecast__c baseObj:baselineIntialForecastList){
           contractIdSet.add(baseObj.FCST_Contract__c);
           //mapContractIdVsName.put(baseObj.FCST_Contract__c,baseObj.FCST_Contract__c);
           mapContractLineItemIdVsName.put(baseObj.Contract_LineItem__c,baseObj.Contract_LineItem__r.Line_Description__c);
           
            if(mapContractLineItemIdVsIntialForecastList.containsKey(baseObj.Contract_LineItem__c)){
              List<FCST_Initial_Forecast__c> existingModel=mapContractLineItemIdVsIntialForecastList.get(baseObj.Contract_LineItem__c);
              existingModel.add(baseObj);
              mapContractLineItemIdVsIntialForecastList.put(baseObj.Contract_LineItem__c,existingModel);
            }
            else{
              List<FCST_Initial_Forecast__c> newModelList = new List<FCST_Initial_Forecast__c>();
              newModelList.add(baseObj);
              mapContractLineItemIdVsIntialForecastList.put(baseObj.Contract_LineItem__c,newModelList);
            }
            
            
            if(accIdVsRevenueTypeMapSet.containsKey(baseObj.Account__r.Id)){
              Set<String> existingRevenueType=accIdVsRevenueTypeMapSet.get(baseObj.Account__r.Id);
              existingRevenueType.add(baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+baseObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(baseObj.Account__r.Id,existingRevenueType);
            }
            else{
              Set<String> revenueTypeSet = new Set<String>();
              revenueTypeSet.add(baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+baseObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(baseObj.Account__r.Id,revenueTypeSet);
            }
            if(baseObj.FCST_Contract__r.Opportunity__c!=null){  
              if(revenueTypeVsOppIdSet.containsKey(baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+baseObj.Account__r.Id)){
                Set<Id> existingRevenueType=revenueTypeVsOppIdSet.get(baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+baseObj.Account__r.Id);
                existingRevenueType.add(baseObj.FCST_Contract__r.Opportunity__c);
                revenueTypeVsOppIdSet.put(baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+baseObj.Account__r.Id,existingRevenueType);
              }
              else{
                Set<Id> revenueTypeSet = new Set<Id>();
                revenueTypeSet.add(baseObj.FCST_Contract__r.Opportunity__c);
                revenueTypeVsOppIdSet.put(baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+baseObj.Account__r.Id,revenueTypeSet);
              }
            }
            if(baseObj.FCST_Contract__r.Opportunity__c!=null){  
             if(OppVsContractBaselineIdSet.containsKey(baseObj.FCST_Contract__r.Opportunity__c)){
              Set<Id> existingRevenueType=OppVsContractBaselineIdSet.get(baseObj.FCST_Contract__r.Opportunity__c);
              existingRevenueType.add(baseObj.FCST_Contract__c);
              OppVsContractBaselineIdSet.put(baseObj.FCST_Contract__r.Opportunity__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(baseObj.FCST_Contract__c);
              OppVsContractBaselineIdSet.put(baseObj.FCST_Contract__r.Opportunity__c,revenueTypeSet);
            }
          }
          if(baseObj.FCST_Contract__r.Opportunity__c==null){      
            if(accIdRevenueTypeVsContractBaselineSet.containsKey(baseObj.Account__r.Id+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c)){
              Set<Id> existingRevenueType=accIdRevenueTypeVsContractBaselineSet.get(baseObj.Account__r.Id+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c);
              existingRevenueType.add(baseObj.FCST_Contract__c);
              accIdRevenueTypeVsContractBaselineSet.put(baseObj.Account__r.Id+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(baseObj.FCST_Contract__c);
              accIdRevenueTypeVsContractBaselineSet.put(baseObj.Account__r.Id+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c,revenueTypeSet);
            }
          }
            
            if(contractVsBaseLineconLineItemIdSet.containsKey(baseObj.FCST_Contract__c+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c)){
              Set<Id> existingRevenueType=contractVsBaseLineconLineItemIdSet.get(baseObj.FCST_Contract__c+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c);
              existingRevenueType.add(baseObj.Contract_LineItem__c);
              contractVsBaseLineconLineItemIdSet.put(baseObj.FCST_Contract__c+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(baseObj.Contract_LineItem__c);
              contractVsBaseLineconLineItemIdSet.put(baseObj.FCST_Contract__c+'#'+baseObj.Contract_LineItem__r.Fcst_Revenue_Type__c,revenueTypeSet);
            }
            
            
            
            
        
         }
       }
       
      
        
       String closeWonQuery ='Select Contract_LineItem__r.BSLA_Number__c,FCST_Contract__r.Fcst_Service_End_date__c,FCST_Contract__r.Fcst_Service_start_date__c,LastModifiedBy.Name,LastModifiedDate,Contract_LineItem__r.Cost_Center__c,FCST_Contract__r.Contract__c,Contract_LineItem__r.Line_Description__c,Contract_LineItem__r.BU_Level2__c,Contract_LineItem__r.BU_Level1__c,FCST_Contract__r.Contract_Description__c,FCST_Planning_Fiscal_Year__r.Fiscal_Year__c,Contract_LineItem__r.Name,FCST_Contract__c,FCST_Contract__r.Name,Contract_LineItem__c,FCST_Contract__r.Opportunity__c,FCST_Contract__r.Opportunity__r.StageName,FCST_Planning_Fiscal_Year__r.Month_Number__c,Fcst_Amount__c,Forecast_with_Risk__c,Account__r.Id ,Contract_LineItem__r.Fcst_Revenue_Type__c  from  FCST_Initial_Forecast__c   where ';//
       closeWonQuery += ' Planning_Version__r.Name =: openAdminVersion  and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c>=:currentYear  and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null and (FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:currentFullYear or FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:nextFullYear)';
       closeWonQuery += ' order by Account__r.Id,Contract_LineItem__r.Fcst_Revenue_Type__c';
       
       
       List<FCST_Initial_Forecast__c> closeWonIntialForecastList=database.query(closeWonQuery); 
       
      
       if(closeWonIntialForecastList!=null && closeWonIntialForecastList.size()>0){
         for(FCST_Initial_Forecast__c closeWonObj:closeWonIntialForecastList){
           
           contractIdSet.add(closeWonObj.FCST_Contract__c);
           //mapContractIdVsName.put(closeWonObj.FCST_Contract__c,closeWonObj.FCST_Contract__c);
           mapContractLineItemIdVsName.put(closeWonObj.Contract_LineItem__c,closeWonObj.Contract_LineItem__r.Line_Description__c);
           
            if(mapContractLineItemIdVsIntialForecastList.containsKey(closeWonObj.Contract_LineItem__c)){
              List<FCST_Initial_Forecast__c> existingModel=mapContractLineItemIdVsIntialForecastList.get(closeWonObj.Contract_LineItem__c);
              existingModel.add(closeWonObj);
              mapContractLineItemIdVsIntialForecastList.put(closeWonObj.Contract_LineItem__c,existingModel);
            }
            else{
              List<FCST_Initial_Forecast__c> newModelList = new List<FCST_Initial_Forecast__c>();
              newModelList.add(closeWonObj);
              mapContractLineItemIdVsIntialForecastList.put(closeWonObj.Contract_LineItem__c,newModelList);
            }
            
            if(accIdVsRevenueTypeMapSet.containsKey(closeWonObj.Account__r.Id)){
              Set<String> existingRevenueType=accIdVsRevenueTypeMapSet.get(closeWonObj.Account__r.Id);
              existingRevenueType.add(closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+closeWonObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(closeWonObj.Account__r.Id,existingRevenueType);
            }
            else{
              Set<String> revenueTypeSet = new Set<String>();
              revenueTypeSet.add(closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+closeWonObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(closeWonObj.Account__r.Id,revenueTypeSet);
            }
            if(closeWonObj.FCST_Contract__r.Opportunity__c!=null){    
              if(revenueTypeVsOppIdSet.containsKey(closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+closeWonObj.Account__r.Id)){
                Set<Id> existingRevenueType=revenueTypeVsOppIdSet.get(closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+closeWonObj.Account__r.Id);
                existingRevenueType.add(closeWonObj.FCST_Contract__r.Opportunity__c);
                revenueTypeVsOppIdSet.put(closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+closeWonObj.Account__r.Id,existingRevenueType);
              }
              else{
                Set<Id> revenueTypeSet = new Set<Id>();
                revenueTypeSet.add(closeWonObj.FCST_Contract__r.Opportunity__c);
                revenueTypeVsOppIdSet.put(closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c+'#'+closeWonObj.Account__r.Id,revenueTypeSet);
              }
            }  
            if(OppVsContractClosedWonIdSet.containsKey(closeWonObj.FCST_Contract__r.Opportunity__c)){
              Set<Id> existingRevenueType=OppVsContractClosedWonIdSet.get(closeWonObj.FCST_Contract__r.Opportunity__c);
              existingRevenueType.add(closeWonObj.FCST_Contract__c);
              OppVsContractClosedWonIdSet.put(closeWonObj.FCST_Contract__r.Opportunity__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(closeWonObj.FCST_Contract__c);
              OppVsContractClosedWonIdSet.put(closeWonObj.FCST_Contract__r.Opportunity__c,revenueTypeSet);
            }
            
            if(contractVsCloseWonconLineItemIdSet.containsKey(closeWonObj.FCST_Contract__c+'#'+closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c)){
              Set<Id> existingRevenueType=contractVsCloseWonconLineItemIdSet.get(closeWonObj.FCST_Contract__c+'#'+closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c);
              existingRevenueType.add(closeWonObj.Contract_LineItem__c);
              contractVsCloseWonconLineItemIdSet.put(closeWonObj.FCST_Contract__c+'#'+closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(closeWonObj.Contract_LineItem__c);
              contractVsCloseWonconLineItemIdSet.put(closeWonObj.FCST_Contract__c+'#'+closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c,revenueTypeSet);
            }
        
         }
       }
       String oppStageWon='Closed Won',oppStageCloseLost='Closed Lost',abovefunnel='Lead (Above the Funnel)';
           
           Set<String> lineItemIdSet = new Set<String>();
           
       String openOppQuery='select Product__r.Name,LastModifiedBy.Name,LastModifiedDate,Product__r.'+costCenterAPI+',Product__r.'+businessUnitAPI+',FCST_Product_Line_ID__c,Product__c,Opportunity__c,Opportunity__r.StageName,Fiscal_Period__r.Fiscal_Year__c,Account__r.Id,Fiscal_Period__r.Month_Number__c,User_Adjusted_Revenue__c,Weighted_Revenue__c,FCST_Revenue_Types__c , Opportunity__r.AccountId  from FCST_Product_Model__c where Id <> null ';
           openOppQuery+= '  and Planning_Version__r.Name =: openAdminVersion and Account__c IN:accListVal and Opportunity__r.StageName!=:oppStageCloseLost and Opportunity__r.StageName!=:abovefunnel and Opportunity__r.StageName!=:oppStageWon  and  FCST_Revenue_Types__c<>null and Account_CPM_Region__c!=null and (Fiscal_Period__r.Fiscal_Year__c=:nextFullYear or Fiscal_Period__r.Fiscal_Year__c=:currentFullYear)';
        
           openOppQuery += ' order by Opportunity__r.AccountId,FCST_Revenue_Types__c';
           
       List<FCST_Product_Model__c> openProductForecastList=database.query(openOppQuery); 
       
       Map<String,Set<Id>> mapOppIdVsOppLineItemList = new Map<String,Set<Id>>();
       
       if(openProductForecastList!=null && openProductForecastList.size()>0){
         for(FCST_Product_Model__c openObj:openProductForecastList){
           if(mapLineItemIdVsListProductModelPipeLine.containsKey(openObj.FCST_Product_Line_ID__c)){
              List<FCST_Product_Model__c> existingModel=mapLineItemIdVsListProductModelPipeLine.get(openObj.FCST_Product_Line_ID__c);
              existingModel.add(openObj);
              mapLineItemIdVsListProductModelPipeLine.put(openObj.FCST_Product_Line_ID__c,existingModel);
            }
            else{
              List<FCST_Product_Model__c> newModelList = new List<FCST_Product_Model__c>();
              newModelList.add(openObj);
              mapLineItemIdVsListProductModelPipeLine.put(openObj.FCST_Product_Line_ID__c,newModelList);
            }
            
            if(accIdVsRevenueTypeMapSet.containsKey(openObj.Account__r.Id)){
              Set<String> existingRevenueType=accIdVsRevenueTypeMapSet.get(openObj.Account__r.Id);
              existingRevenueType.add(openObj.FCST_Revenue_Types__c+'#'+openObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(openObj.Account__r.Id,existingRevenueType);
            }
            else{
              Set<String> revenueTypeSet = new Set<String>();
              revenueTypeSet.add(openObj.FCST_Revenue_Types__c+'#'+openObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(openObj.Account__r.Id,revenueTypeSet);
            }
            if(openObj.Opportunity__c!=null){    
              if(revenueTypeVsOppIdSet.containsKey(openObj.FCST_Revenue_Types__c+'#'+openObj.Account__r.Id)){
                Set<Id> existingRevenueType=revenueTypeVsOppIdSet.get(openObj.FCST_Revenue_Types__c+'#'+openObj.Account__r.Id);
                existingRevenueType.add(openObj.Opportunity__c);
                revenueTypeVsOppIdSet.put(openObj.FCST_Revenue_Types__c+'#'+openObj.Account__r.Id,existingRevenueType);
              }
              else{
                Set<Id> revenueTypeSet = new Set<Id>();
                revenueTypeSet.add(openObj.Opportunity__c);
                revenueTypeVsOppIdSet.put(openObj.FCST_Revenue_Types__c+'#'+openObj.Account__r.Id,revenueTypeSet);
              }
            }  
            
            if(mapOppIdVsOppLineItemList.containsKey(openObj.Opportunity__c+'#'+openObj.FCST_Revenue_Types__c)){
              Set<Id> existingRevenueType=mapOppIdVsOppLineItemList.get(openObj.Opportunity__c+'#'+openObj.FCST_Revenue_Types__c);
              existingRevenueType.add(openObj.FCST_Product_Line_ID__c);
              mapOppIdVsOppLineItemList.put(openObj.Opportunity__c+'#'+openObj.FCST_Revenue_Types__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(openObj.FCST_Product_Line_ID__c);
              mapOppIdVsOppLineItemList.put(openObj.Opportunity__c+'#'+openObj.FCST_Revenue_Types__c,revenueTypeSet);
            }
            
            if(openObj.FCST_Product_Line_ID__c!=null)
            lineItemIdSet.add(openObj.FCST_Product_Line_ID__c);
        
         }
       }
       
       
       String aboveFunnelOppQuery='select Product__r.Name,LastModifiedBy.Name,LastModifiedDate,Product__r.'+costCenterAPI+',Product__r.'+businessUnitAPI+',FCST_Product_Line_ID__c,Opportunity__c,Opportunity__r.StageName,Fiscal_Period__r.Fiscal_Year__c,Amount__c,Account__r.Id,Fiscal_Period__r.Month_Number__c,User_Adjusted_Revenue__c,Weighted_Revenue__c,FCST_Revenue_Types__c , Opportunity__r.AccountId  from FCST_Product_Model__c where Id <> null ';
           aboveFunnelOppQuery+= '  and Planning_Version__r.Name =: openAdminVersion and Account__c IN:accListVal  and Opportunity__r.StageName=:abovefunnel and  FCST_Revenue_Types__c<>null and Account_CPM_Region__c!=null and (Fiscal_Period__r.Fiscal_Year__c=:nextFullYear or Fiscal_Period__r.Fiscal_Year__c=:currentFullYear)';
           aboveFunnelOppQuery += ' order by Opportunity__r.AccountId,FCST_Revenue_Types__c';
           
       List<FCST_Product_Model__c> aboveFunnelForecastList=database.query(aboveFunnelOppQuery); 
       
       Map<String,Set<Id>> mapOppAboveRevenueTypeVsOppLineItemList = new Map<String,Set<Id>>();
       
       if(aboveFunnelForecastList!=null && aboveFunnelForecastList.size()>0){
         for(FCST_Product_Model__c aboveObj:aboveFunnelForecastList){
           
         
            if(mapLineItemIdVsListProductModelFunnel.containsKey(aboveObj.FCST_Product_Line_ID__c)){
              List<FCST_Product_Model__c> existingModel=mapLineItemIdVsListProductModelFunnel.get(aboveObj.FCST_Product_Line_ID__c);
              existingModel.add(aboveObj);
              mapLineItemIdVsListProductModelFunnel.put(aboveObj.FCST_Product_Line_ID__c,existingModel);
            }
            else{
              List<FCST_Product_Model__c> newModelList = new List<FCST_Product_Model__c>();
              newModelList.add(aboveObj);
              mapLineItemIdVsListProductModelFunnel.put(aboveObj.FCST_Product_Line_ID__c,newModelList);
            }
            
            if(accIdVsRevenueTypeMapSet.containsKey(aboveObj.Account__r.Id)){
              Set<String> existingRevenueType=accIdVsRevenueTypeMapSet.get(aboveObj.Account__r.Id);
              existingRevenueType.add(aboveObj.FCST_Revenue_Types__c+'#'+aboveObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(aboveObj.Account__r.Id,existingRevenueType);
            }
            else{
              Set<String> revenueTypeSet = new Set<String>();
              revenueTypeSet.add(aboveObj.FCST_Revenue_Types__c+'#'+aboveObj.Account__r.Id);
              accIdVsRevenueTypeMapSet.put(aboveObj.Account__r.Id,revenueTypeSet);
            }
          if(aboveObj.Opportunity__c!=null){    
            if(revenueTypeVsOppIdSet.containsKey(aboveObj.FCST_Revenue_Types__c+'#'+aboveObj.Account__r.Id)){
              Set<Id> existingRevenueType=revenueTypeVsOppIdSet.get(aboveObj.FCST_Revenue_Types__c+'#'+aboveObj.Account__r.Id);
              existingRevenueType.add(aboveObj.Opportunity__c);
              revenueTypeVsOppIdSet.put(aboveObj.FCST_Revenue_Types__c+'#'+aboveObj.Account__r.Id,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(aboveObj.Opportunity__c);
              revenueTypeVsOppIdSet.put(aboveObj.FCST_Revenue_Types__c+'#'+aboveObj.Account__r.Id,revenueTypeSet);
            }
          }  
            if(mapOppAboveRevenueTypeVsOppLineItemList.containsKey(aboveObj.Opportunity__c+'#'+aboveObj.FCST_Revenue_Types__c)){
              Set<Id> existingRevenueType=mapOppAboveRevenueTypeVsOppLineItemList.get(aboveObj.Opportunity__c+'#'+aboveObj.FCST_Revenue_Types__c);
              existingRevenueType.add(aboveObj.FCST_Product_Line_ID__c);
              mapOppAboveRevenueTypeVsOppLineItemList.put(aboveObj.Opportunity__c+'#'+aboveObj.FCST_Revenue_Types__c,existingRevenueType);
            }
            else{
              Set<Id> revenueTypeSet = new Set<Id>();
              revenueTypeSet.add(aboveObj.FCST_Product_Line_ID__c);
              mapOppAboveRevenueTypeVsOppLineItemList.put(aboveObj.Opportunity__c+'#'+aboveObj.FCST_Revenue_Types__c,revenueTypeSet);
            }
            
            if(aboveObj.FCST_Product_Line_ID__c!=null)
              lineItemIdSet.add(aboveObj.FCST_Product_Line_ID__c);
        
         }
       }
       
       
       
       List<FCST_Contract__c> listFCSTContract = [Select Id,Contract__c,Fcst_Geo_Name__c,Fcst_Geo_Numbers__c from FCST_Contract__c where Id IN:contractIdSet];
       if(listFCSTContract!=null){
         for(FCST_Contract__c conObj:listFCSTContract){
           mapContractIdVsName.put(conObj.Id,conObj);
         }
         
         
       }
       map<String,Decimal> mapLineIdVsTotalAmount = new map<String,Decimal>();
       List<OpportunityLineItem> lineTemLIst=[Select Id,Name,TotalPrice from OpportunityLineItem where ID IN:lineItemIdSet];
       if(lineTemLIst!=null && lineTemLIst.size()>0){
         for(OpportunityLineItem lineObj:lineTemLIst){
           mapLineIdVsTotalAmount.put(lineObj.Id,lineObj.TotalPrice);
         }
       } 
       
    //   System.debug('>>>mapOppAboveRevenueTypeVsOppLineItemList....'+mapOppAboveRevenueTypeVsOppLineItemList);
       if(accListVal!=null && accListVal.size()>0){
         
         for(Account accObj:accListVal){
                String geoNumber='',cpmRegion='',programName='',peNameId='',pmNameId='',peName='',pmName='';
                if((String) accObj.get(cpmRegionLabelName)!=null)
                  cpmRegion=(String) accObj.get(cpmRegionLabelName);
                
                if(accObj.Name!=null)  
                  programName=accObj.Name; 
                  
               if((String) accObj.get(PMTypeLabelName)!=null)
                  pmNameId=(String) accObj.get(PMTypeLabelName);
               if((String) accObj.get(PETypeLabelName)!=null)
                 peNameId=(String) accObj.get(PETypeLabelName);
             
             
              if((String) accObj.get(GeoLabelName)!=null)
                 geoNumber=(String) accObj.get(GeoLabelName);
               
               
               if(pmNameId!=null && pmNameId!='' && mapIdVsName.containsKey(Id.ValueOf(pmNameId))){
                 pmName=mapIdVsName.get(Id.ValueOf(pmNameId));
               }
               if(peNameId!=null && peNameId!='' && mapIdVsName.containsKey(Id.ValueOf(peNameId))){
                 peName=mapIdVsName.get(Id.ValueOf(peNameId));
               }
              
              if(programName!=null)
              programName=programName.replaceAll(',', '').trim();
              if(cpmRegion!=null)
              cpmRegion=cpmRegion.replaceAll(',', '').trim();
              if(geoNumber!=null)
              geoNumber=geoNumber.replaceAll(',', '').trim();
              if(pmName!=null)
              pmName=pmName.replaceAll(',', '').trim();
              if(peName!=null)
              peName=peName.replaceAll(',', '').trim();
              
              
              
              
              
              //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               
           //System.debug('>>accIdVsRevenueTypeMapSet...'+accIdVsRevenueTypeMapSet);   
             if(accIdVsRevenueTypeMapSet.containsKey(accObj.Id)){
               for(String revenueAccId:accIdVsRevenueTypeMapSet.get(accObj.Id)){
                 String[] revList = revenueAccId.split('#'); 
                 String revenueStr=revList[0];
             //  System.debug('>>revenueStr...'+revenueStr);    
            //   System.debug('>>revenueTypeVsOppIdSet...'+revenueTypeVsOppIdSet);  
               
               //.........................................................................................................
               if(accIdRevenueTypeVsContractBaselineSet.containsKey(accObj.Id+'#'+revenueStr)){
                     //  System.debug('>>oppId...'+oppId);  
                       for(Id contractId:accIdRevenueTypeVsContractBaselineSet.get(accObj.Id+'#'+revenueStr)){
                         String contractName='',assignedGeoContract='',geoNameContract='',geonumContract='';
                         if(mapContractIdVsName.containsKey(contractId)){
                           if(mapContractIdVsName.get(contractId).Contract__c!=null)
                            contractName=mapContractIdVsName.get(contractId).Contract__c;
                           if(mapContractIdVsName.get(contractId).Fcst_Geo_Numbers__c!=null) 
                           geonumContract=mapContractIdVsName.get(contractId).Fcst_Geo_Numbers__c;
                           if(mapContractIdVsName.get(contractId).Fcst_Geo_Name__c!=null)
                           geoNameContract=mapContractIdVsName.get(contractId).Fcst_Geo_Name__c;
                         }
                         if(geonumContract!=null)
                         assignedGeoContract=geonumContract;
                         if(geoNameContract!=null)
                         assignedGeoContract+=' '+geoNameContract;
                          
                         if(contractName!=null)
                         contractName=contractName.replaceAll(',', '');
                         
                         if(assignedGeoContract!=null)
                         assignedGeoContract=assignedGeoContract.replaceAll(',', '');
                         
                     //    System.debug('>>contractId...'+contractId);
                     //    System.debug('>>revenueStr...'+revenueStr);  
                     //    System.debug('>>contractVsBaseLineconLineItemIdSet...'+contractVsBaseLineconLineItemIdSet);
                            
                         if(contractVsBaseLineconLineItemIdSet.containsKey(contractId+'#'+revenueStr)){
                           for(Id conLineItemId:contractVsBaseLineconLineItemIdSet.get(contractId+'#'+revenueStr)){
                             String contractLineItemName='';
                             
                             if(mapContractLineItemIdVsName.containsKey(conLineItemId)){
                               contractLineItemName=mapContractLineItemIdVsName.get(conLineItemId);
                             }
                             if(contractLineItemName!=null)
                             contractLineItemName=contractLineItemName.replaceAll(',', '');
                             List<double> unAdustedBaselineAmountList = new List<double>();
                          List<double> adustedBaseLineAmountList = new List<double>();

                             double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
                             double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
                             String bulevel1='',bulevel2='';
                         //    System.debug('>>conLineItemId...'+conLineItemId);  
                             String costcenter='',businessUnit='';
                             String lastmodifiedby='',lastmodifiedDateStr='',bslanumber='';
                          datetime lastdateMOdified;date ServiceSDate,ServiceEDate;
                          Integer i=0;
                          
                             if(mapContractLineItemIdVsIntialForecastList.containsKey(conLineItemId)){
                               for(FCST_Initial_Forecast__c initialObj:mapContractLineItemIdVsIntialForecastList.get(conLineItemId)){
                                 
                                 i++;
                                 
                              if(i==1){
                                lastdateMOdified=initialObj.LastModifiedDate;
                                lastmodifiedby=initialObj.LastModifiedBy.Name;
                              }
                              
                              if(initialObj.LastModifiedDate!=null && lastdateMOdified<initialObj.LastModifiedDate){
                                lastdateMOdified=initialObj.LastModifiedDate;  
                                lastmodifiedby=initialObj.LastModifiedBy.Name;  
                                
                              }
                              
                              if(initialObj.FCST_Contract__r.Fcst_Service_End_date__c!=null)
                                   ServiceEDate=initialObj.FCST_Contract__r.Fcst_Service_End_date__c;
                                 
                                 if(initialObj.FCST_Contract__r.Fcst_Service_start_date__c!=null)
                                   ServiceSDate=initialObj.FCST_Contract__r.Fcst_Service_start_date__c;
                                 
                                 
                                 if(initialObj.Contract_LineItem__r.BSLA_Number__c!=null)
                                   bslanumber=initialObj.Contract_LineItem__r.BSLA_Number__c;
                                     
                                 
                                 if(initialObj.Contract_LineItem__r.Cost_Center__c!=null)
                                   costcenter=initialObj.Contract_LineItem__r.Cost_Center__c;
                                 
                                 if(initialObj.Contract_LineItem__r.BU_Level1__c!=null)
                                   bulevel1=initialObj.Contract_LineItem__r.BU_Level1__c;
                                   
                                 if(initialObj.Contract_LineItem__r.BU_Level2__c!=null)
                                   bulevel2=initialObj.Contract_LineItem__r.BU_Level2__c;
                                   
                                 if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted1+=initialObj.Forecast_with_Risk__c;
                                unAdjusted1+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted2+=initialObj.Forecast_with_Risk__c;
                                unAdjusted2+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted3+=initialObj.Forecast_with_Risk__c;
                                unAdjusted3+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted4+=initialObj.Forecast_with_Risk__c;
                                unAdjusted4+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted5+=initialObj.Forecast_with_Risk__c;
                                unAdjusted5+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted6+=initialObj.Forecast_with_Risk__c;
                                unAdjusted6+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted7+=initialObj.Forecast_with_Risk__c;
                                unAdjusted7+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted8+=initialObj.Forecast_with_Risk__c;
                                unAdjusted8+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted9+=initialObj.Forecast_with_Risk__c;
                                unAdjusted9+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted10+=initialObj.Forecast_with_Risk__c;
                                unAdjusted10+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted11+=initialObj.Forecast_with_Risk__c;
                                unAdjusted11+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted12+=initialObj.Forecast_with_Risk__c;
                                unAdjusted12+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted13+=initialObj.Forecast_with_Risk__c;
                                unAdjusted13+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted14+=initialObj.Forecast_with_Risk__c;
                                unAdjusted14+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted15+=initialObj.Forecast_with_Risk__c;
                                unAdjusted15+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted16+=initialObj.Forecast_with_Risk__c;
                                unAdjusted16+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted17+=initialObj.Forecast_with_Risk__c;
                                unAdjusted17+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted18+=initialObj.Forecast_with_Risk__c;
                                unAdjusted18+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted19+=initialObj.Forecast_with_Risk__c;
                                unAdjusted19+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted20+=initialObj.Forecast_with_Risk__c;
                                unAdjusted20+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted21+=initialObj.Forecast_with_Risk__c;
                                unAdjusted21+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted22+=initialObj.Forecast_with_Risk__c;
                                unAdjusted22+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted23+=initialObj.Forecast_with_Risk__c;
                                unAdjusted23+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted24+=initialObj.Forecast_with_Risk__c;
                                unAdjusted24+=initialObj.Fcst_Amount__c;
                              }
                              
                              
                              
                              
                               }
                                 adustedBaseLineAmountList.add(ajusted1);
                              adustedBaseLineAmountList.add(ajusted2);
                              adustedBaseLineAmountList.add(ajusted3);
                              adustedBaseLineAmountList.add(ajusted4);
                              adustedBaseLineAmountList.add(ajusted5);
                              adustedBaseLineAmountList.add(ajusted6);
                              adustedBaseLineAmountList.add(ajusted7);
                              adustedBaseLineAmountList.add(ajusted8);
                              adustedBaseLineAmountList.add(ajusted9);
                              adustedBaseLineAmountList.add(ajusted10);
                              adustedBaseLineAmountList.add(ajusted11);
                              adustedBaseLineAmountList.add(ajusted12);
                              
                              adustedBaseLineAmountList.add(ajusted13);
                              adustedBaseLineAmountList.add(ajusted14);
                              adustedBaseLineAmountList.add(ajusted15);
                              adustedBaseLineAmountList.add(ajusted16);
                              adustedBaseLineAmountList.add(ajusted17);
                              adustedBaseLineAmountList.add(ajusted18);
                              adustedBaseLineAmountList.add(ajusted19);
                              adustedBaseLineAmountList.add(ajusted20);
                              adustedBaseLineAmountList.add(ajusted21);
                              adustedBaseLineAmountList.add(ajusted22);
                              adustedBaseLineAmountList.add(ajusted23);
                              adustedBaseLineAmountList.add(ajusted24);
                              
                              
                              
                              unAdustedBaselineAmountList.add(unAdjusted1);
                              unAdustedBaselineAmountList.add(unAdjusted2);
                              unAdustedBaselineAmountList.add(unAdjusted3);
                              unAdustedBaselineAmountList.add(unAdjusted4);
                              unAdustedBaselineAmountList.add(unAdjusted5);
                              unAdustedBaselineAmountList.add(unAdjusted6);
                              unAdustedBaselineAmountList.add(unAdjusted7);
                              unAdustedBaselineAmountList.add(unAdjusted8);
                              unAdustedBaselineAmountList.add(unAdjusted9);
                              unAdustedBaselineAmountList.add(unAdjusted10);
                              unAdustedBaselineAmountList.add(unAdjusted11);
                              unAdustedBaselineAmountList.add(unAdjusted12);
                              
                              unAdustedBaselineAmountList.add(unAdjusted13);
                              unAdustedBaselineAmountList.add(unAdjusted14);
                              unAdustedBaselineAmountList.add(unAdjusted15);
                              unAdustedBaselineAmountList.add(unAdjusted16);
                              unAdustedBaselineAmountList.add(unAdjusted17);
                              unAdustedBaselineAmountList.add(unAdjusted18);
                              unAdustedBaselineAmountList.add(unAdjusted19);
                              unAdustedBaselineAmountList.add(unAdjusted20);
                              unAdustedBaselineAmountList.add(unAdjusted21);
                              unAdustedBaselineAmountList.add(unAdjusted22);
                              unAdustedBaselineAmountList.add(unAdjusted23);
                              unAdustedBaselineAmountList.add(unAdjusted24);
                              
                              
                              if(lastdateMOdified!=null)
                              lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
                              
                                 String serviceStartDate='',ServiceEndDate='';
                              
                              if(ServiceSDate!=null)
                                serviceStartDate=ServiceSDate.month()+'/'+ServiceSDate.day()+'/'+ServiceSDate.year();
                              
                              if(ServiceEDate!=null)
                                ServiceEndDate=ServiceEDate.month()+'/'+ServiceEDate.day()+'/'+ServiceEDate.year();
                     //baseline
                     
                     
                                         
                               finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+bulevel1+','+geoNumber+','+assignedGeoContract+','+'Unadjusted Baseline'+','+contractName+','+contractLineItemName+','+','+','+','+','+','+bslanumber+','+','+','+','+','+','+serviceStartDate+','+ServiceEndDate+','+','+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                               If(unAdustedBaselineAmountList!=null && unAdustedBaselineAmountList.size()>0){
                                      for(Double obj5:unAdustedBaselineAmountList){
                                        finalSuccessStr+=math.round(obj5)+',';
                                      }
                                     
                                  }
                                  finalSuccessStr+='\n';
                               
                               finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+bulevel1+','+geoNumber+','+assignedGeoContract+','+'Adjusted Baseline'+','+contractName+','+contractLineItemName+','+','+','+','+','+','+bslanumber+','+','+','+','+','+','+serviceStartDate+','+ServiceEndDate+','+','+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                               If(adustedBaseLineAmountList!=null && adustedBaseLineAmountList.size()>0){
                                      for(Double obj6:adustedBaseLineAmountList){
                                        finalSuccessStr+=math.round(obj6)+',';
                                      }
                                     
                                  }
                                  finalSuccessStr+='\n';
                             }
                             
                           }
                         }
                       }
                     }
                     //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               
               
                 if(revenueTypeVsOppIdSet.containsKey(revenueAccId)){
                   for(Id oppId:revenueTypeVsOppIdSet.get(revenueAccId)){
                   //  System.debug('>>oppId...'+oppId);
                     String OppName='',StageName='',serviceStartdate='',serviceEnddate='',termsInMonth='',transitionDate='',assignedGeo='',OppType='',OppRecordType='',OppBslaNumber='';
                     double tcvVal=0,SVRYR1Val=0,oppProductAmount=0,oppAmount=0;
                     if(mapOppIdVsOppObj.containsKey(oppId)){
                       OppName=mapOppIdVsOppObj.get(oppId).Name;
                       StageName=mapOppIdVsOppObj.get(oppId).StageName;
                       if(mapOppIdVsOppObj.get(oppId).Type!=null)
                       OppType=mapOppIdVsOppObj.get(oppId).Type;
                       Opportunity oppVal=mapOppIdVsOppObj.get(oppId);
                       
                       if((String) oppVal.get(oppRecordTypeAPI)!=null)
                         OppRecordType=(String) oppVal.get(oppRecordTypeAPI);
                         
                       if(OppRecordType!=null && mapRecordIdVsName.containsKey(OppRecordType))
                         OppRecordType=  mapRecordIdVsName.get(OppRecordType);
                       
                       if((String) oppVal.get(oppBslaAPI)!=null)
                         OppBslaNumber=(String) oppVal.get(oppBslaAPI);
                         
                      if((Decimal) oppVal.get(offeringAmountAPI)!=null)
                         oppProductAmount=(Decimal) oppVal.get(offeringAmountAPI);
                         
                     if(oppVal!=null && oppVal.Amount!=null) 
                      	oppAmount=oppVal.Amount;
                            
                          if(OppBslaNumber=='US')
                            OppBslaNumber='10C363';    
                       if(OppBslaNumber=='Canada')
                            OppBslaNumber='203563';  
                       
                       if((Date) oppVal.get(serviceStartDateAPI)!=null){
                         Date oppserviceStartdate=(Date) oppVal.get(serviceStartDateAPI);
                         serviceStartdate=oppserviceStartdate.month()+'/'+oppserviceStartdate.day()+'/'+oppserviceStartdate.year();
                        }
                        
                       if((Date) oppVal.get(serviceEndDateAPI)!=null){
                         Date oppserviceEnddate=(Date) oppVal.get(serviceEndDateAPI);
                         serviceEnddate=oppserviceEnddate.month()+'/'+oppserviceEnddate.day()+'/'+oppserviceEnddate.year(); 
                       }
                       if((Double) oppVal.get(termsInMonthAPI)!=null)
                       termsInMonth=String.ValueOf(((Double) oppVal.get(termsInMonthAPI)).format());
                       
                       
                       if((Date) oppVal.get(transitionDateAPI)!=null){
                         Date OpptransitionDate=(Date ) oppVal.get(transitionDateAPI);
                         
                         transitionDate=OpptransitionDate.month()+'/'+OpptransitionDate.day()+'/'+OpptransitionDate.year();
                       }
                       if((Double) oppVal.get(TCVAPI)!=null)
                         tcvVal=(Double ) oppVal.get(TCVAPI);
                       if((Double) oppVal.get(SVCYR1API)!=null)
                         SVRYR1Val=(Double ) oppVal.get(SVCYR1API);
                       
                       
                     
                     //  System.debug('assisgnedGeoAPI....'+assisgnedGeoAPI);
                     //  System.debug('test ing ....'+oppVal.getSObject(assisgnedGeoAPI));
                       
                       //if((Id) oppVal.get(oppGeoLookupAPI)!=null)
                       //  assignedGeo=(Id ) oppVal.get(oppGeoLookupAPI);
                       
                       if(oppVal.getSObject(assisgnedGeoAPI)!=null && (String)oppVal.getSObject(assisgnedGeoAPI).get('Name')!=null)
                    assignedGeo=(String)oppVal.getSObject(assisgnedGeoAPI).get('Name');
                       
                       
                       if(assignedGeo!=null)
                     assignedGeo=assignedGeo.replaceAll(',', '').trim();
                     
                     }
                     if(OppName!=null)
                     OppName=OppName.replaceAll(',', '').trim();
                   //  System.debug('>>OppVsContractBaselineIdSet...'+OppVsContractBaselineIdSet);  
                     if(OppVsContractBaselineIdSet.containsKey(oppId)){
                       for(Id contractId:OppVsContractBaselineIdSet.get(oppId)){

                      String contractName='',assignedGeoContract='',geoNameContract='',geonumContract='';
                      
                         if(mapContractIdVsName.containsKey(contractId)){
                           if(mapContractIdVsName.get(contractId).Contract__c!=null)
                             contractName=mapContractIdVsName.get(contractId).Contract__c;
                           if(mapContractIdVsName.get(contractId).Fcst_Geo_Numbers__c!=null) 
                          geonumContract=mapContractIdVsName.get(contractId).Fcst_Geo_Numbers__c;
                        if(mapContractIdVsName.get(contractId).Fcst_Geo_Name__c!=null)
                          geoNameContract=mapContractIdVsName.get(contractId).Fcst_Geo_Name__c;
                           
                         }
                         if(geonumContract!=null)
                         assignedGeoContract=geonumContract;
                      if(geoNameContract!=null)
                        assignedGeoContract+=' '+geoNameContract;

                         if(contractName!=null)
                         contractName=contractName.replaceAll(',', '').trim();
                         if(assignedGeoContract!=null)
                         assignedGeoContract=assignedGeoContract.replaceAll(',', '');
                         
                         
                         if(contractVsBaseLineconLineItemIdSet.containsKey(contractId+'#'+revenueStr)){
                           for(Id conLineItemId:contractVsBaseLineconLineItemIdSet.get(contractId+'#'+revenueStr)){
                             String contractLineItemName='';
                             
                             if(mapContractLineItemIdVsName.containsKey(conLineItemId)){
                               contractLineItemName=mapContractLineItemIdVsName.get(conLineItemId);
                             }
                             if(contractLineItemName!=null)
                             contractLineItemName=contractLineItemName.replaceAll(',', '').trim();
                             List<double> unAdustedBaselineAmountList = new List<double>();
                          List<double> adustedBaseLineAmountList = new List<double>();

                             double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
                             double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
                             String bulevel1='',bulevel2='';String costcenter='',businessUnit='';
                             String lastmodifiedby='',lastmodifiedDateStr='',contractLineBSLA='';
                          datetime lastdateMOdified;date ServiceSDate,ServiceEDate;
                          Integer i=0;decimal lineTotalamount=0;
                          
                          
                             if(mapContractLineItemIdVsIntialForecastList.containsKey(conLineItemId)){
                               for(FCST_Initial_Forecast__c initialObj:mapContractLineItemIdVsIntialForecastList.get(conLineItemId)){
                                 
                                 i++;
                                 
                              if(i==1){
                                lastdateMOdified=initialObj.LastModifiedDate;
                                lastmodifiedby=initialObj.LastModifiedBy.Name;
                              }
                              
                              
                               
                               
                              
                              
                              if(initialObj.Contract_LineItem__r.BSLA_Number__c!=null)
                                   contractLineBSLA=initialObj.Contract_LineItem__r.BSLA_Number__c;
                              
                              if(initialObj.LastModifiedDate!=null && lastdateMOdified<initialObj.LastModifiedDate){
                                lastdateMOdified=initialObj.LastModifiedDate;  
                                lastmodifiedby=initialObj.LastModifiedBy.Name;  
                                
    
                              }
                                 
                                 if(initialObj.FCST_Contract__r.Fcst_Service_End_date__c!=null)
                                   ServiceEDate=initialObj.FCST_Contract__r.Fcst_Service_End_date__c;
                                 
                                 if(initialObj.FCST_Contract__r.Fcst_Service_start_date__c!=null)
                                   ServiceSDate=initialObj.FCST_Contract__r.Fcst_Service_start_date__c;
                                 
                                 if(initialObj.Contract_LineItem__r.Cost_Center__c!=null)
                                   costcenter=initialObj.Contract_LineItem__r.Cost_Center__c;
                                 
                                 if(initialObj.Contract_LineItem__r.BU_Level1__c!=null)
                                   bulevel1=initialObj.Contract_LineItem__r.BU_Level1__c;
                                   
                                 if(initialObj.Contract_LineItem__r.BU_Level2__c!=null)
                                   bulevel2=initialObj.Contract_LineItem__r.BU_Level2__c;
                                   
                                 if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted1+=initialObj.Forecast_with_Risk__c;
                                unAdjusted1+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted2+=initialObj.Forecast_with_Risk__c;
                                unAdjusted2+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted3+=initialObj.Forecast_with_Risk__c;
                                unAdjusted3+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted4+=initialObj.Forecast_with_Risk__c;
                                unAdjusted4+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted5+=initialObj.Forecast_with_Risk__c;
                                unAdjusted5+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted6+=initialObj.Forecast_with_Risk__c;
                                unAdjusted6+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted7+=initialObj.Forecast_with_Risk__c;
                                unAdjusted7+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted8+=initialObj.Forecast_with_Risk__c;
                                unAdjusted8+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted9+=initialObj.Forecast_with_Risk__c;
                                unAdjusted9+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted10+=initialObj.Forecast_with_Risk__c;
                                unAdjusted10+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted11+=initialObj.Forecast_with_Risk__c;
                                unAdjusted11+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted12+=initialObj.Forecast_with_Risk__c;
                                unAdjusted12+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted13+=initialObj.Forecast_with_Risk__c;
                                unAdjusted13+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted14+=initialObj.Forecast_with_Risk__c;
                                unAdjusted14+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted15+=initialObj.Forecast_with_Risk__c;
                                unAdjusted15+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted16+=initialObj.Forecast_with_Risk__c;
                                unAdjusted16+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted17+=initialObj.Forecast_with_Risk__c;
                                unAdjusted17+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted18+=initialObj.Forecast_with_Risk__c;
                                unAdjusted18+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted19+=initialObj.Forecast_with_Risk__c;
                                unAdjusted19+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted20+=initialObj.Forecast_with_Risk__c;
                                unAdjusted20+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted21+=initialObj.Forecast_with_Risk__c;
                                unAdjusted21+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted22+=initialObj.Forecast_with_Risk__c;
                                unAdjusted22+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted23+=initialObj.Forecast_with_Risk__c;
                                unAdjusted23+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted24+=initialObj.Forecast_with_Risk__c;
                                unAdjusted24+=initialObj.Fcst_Amount__c;
                              }
                              
                              
                              
                              
                               }
                                 adustedBaseLineAmountList.add(ajusted1);
                              adustedBaseLineAmountList.add(ajusted2);
                              adustedBaseLineAmountList.add(ajusted3);
                              adustedBaseLineAmountList.add(ajusted4);
                              adustedBaseLineAmountList.add(ajusted5);
                              adustedBaseLineAmountList.add(ajusted6);
                              adustedBaseLineAmountList.add(ajusted7);
                              adustedBaseLineAmountList.add(ajusted8);
                              adustedBaseLineAmountList.add(ajusted9);
                              adustedBaseLineAmountList.add(ajusted10);
                              adustedBaseLineAmountList.add(ajusted11);
                              adustedBaseLineAmountList.add(ajusted12);
                              
                              adustedBaseLineAmountList.add(ajusted13);
                              adustedBaseLineAmountList.add(ajusted14);
                              adustedBaseLineAmountList.add(ajusted15);
                              adustedBaseLineAmountList.add(ajusted16);
                              adustedBaseLineAmountList.add(ajusted17);
                              adustedBaseLineAmountList.add(ajusted18);
                              adustedBaseLineAmountList.add(ajusted19);
                              adustedBaseLineAmountList.add(ajusted20);
                              adustedBaseLineAmountList.add(ajusted21);
                              adustedBaseLineAmountList.add(ajusted22);
                              adustedBaseLineAmountList.add(ajusted23);
                              adustedBaseLineAmountList.add(ajusted24);
                              
                              
                              
                              unAdustedBaselineAmountList.add(unAdjusted1);
                              unAdustedBaselineAmountList.add(unAdjusted2);
                              unAdustedBaselineAmountList.add(unAdjusted3);
                              unAdustedBaselineAmountList.add(unAdjusted4);
                              unAdustedBaselineAmountList.add(unAdjusted5);
                              unAdustedBaselineAmountList.add(unAdjusted6);
                              unAdustedBaselineAmountList.add(unAdjusted7);
                              unAdustedBaselineAmountList.add(unAdjusted8);
                              unAdustedBaselineAmountList.add(unAdjusted9);
                              unAdustedBaselineAmountList.add(unAdjusted10);
                              unAdustedBaselineAmountList.add(unAdjusted11);
                              unAdustedBaselineAmountList.add(unAdjusted12);
                              
                              unAdustedBaselineAmountList.add(unAdjusted13);
                              unAdustedBaselineAmountList.add(unAdjusted14);
                              unAdustedBaselineAmountList.add(unAdjusted15);
                              unAdustedBaselineAmountList.add(unAdjusted16);
                              unAdustedBaselineAmountList.add(unAdjusted17);
                              unAdustedBaselineAmountList.add(unAdjusted18);
                              unAdustedBaselineAmountList.add(unAdjusted19);
                              unAdustedBaselineAmountList.add(unAdjusted20);
                              unAdustedBaselineAmountList.add(unAdjusted21);
                              unAdustedBaselineAmountList.add(unAdjusted22);
                              unAdustedBaselineAmountList.add(unAdjusted23);
                              unAdustedBaselineAmountList.add(unAdjusted24);
                              
                              if(lastdateMOdified!=null)
                                lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
                               
                            
                               
                               String serviceStartContractDate='',ServiceEndContractDate='';
                              
                              if(ServiceSDate!=null)
                                serviceStartContractDate=ServiceSDate.month()+'/'+ServiceSDate.day()+'/'+ServiceSDate.year();
                              
                              if(ServiceEDate!=null)
                                ServiceEndContractDate=ServiceEDate.month()+'/'+ServiceEDate.day()+'/'+ServiceEDate.year();
                                
                            if(StageName!=null)    
                            StageName=StageName.replaceAll(',', '');
             //baseline                  
                               finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+bulevel1+','+geoNumber+','+assignedGeoContract+','+'Unadjusted Baseline'+','+contractName+','+contractLineItemName+','+OppName+','+','+StageName+','+OppType+','+OppRecordType+','+contractLineBSLA+','+tcvVal+','+SVRYR1Val+','+0+','+oppAmount +','+oppProductAmount+','+serviceStartContractDate+','+ServiceEndContractDate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                               If(unAdustedBaselineAmountList!=null && unAdustedBaselineAmountList.size()>0){
                                      for(Double obj5:unAdustedBaselineAmountList){
                                        finalSuccessStr+=math.round(obj5)+',';
                                      }
                                     
                                  }
                                  finalSuccessStr+='\n';
                               
                               finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+bulevel1+','+geoNumber+','+assignedGeoContract+','+'Adjusted Baseline'+','+contractName+','+contractLineItemName+','+OppName+','+','+StageName+','+OppType+','+OppRecordType+','+contractLineBSLA+','+tcvVal+','+SVRYR1Val+','+0+','+oppAmount +','+oppProductAmount+','+serviceStartContractDate+','+ServiceEndContractDate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                               If(adustedBaseLineAmountList!=null && adustedBaseLineAmountList.size()>0){
                                      for(Double obj6:adustedBaseLineAmountList){
                                        finalSuccessStr+=math.round(obj6)+',';
                                      }
                                     
                                  }
                                  finalSuccessStr+='\n';
                             }
                             
                           }
                         }
                       }
                     }
                                          
                     

                     
                     
                     if(OppVsContractClosedWonIdSet.containsKey(oppId)){
                       
                       for(Id contractId:OppVsContractClosedWonIdSet.get(oppId)){
                       

                      String contractName='';
                      
                         if(mapContractIdVsName.containsKey(contractId)){
                           if(mapContractIdVsName.get(contractId).Contract__c!=null)
                             contractName=mapContractIdVsName.get(contractId).Contract__c;
                           
                         }
                         
                   
                         
                         if(contractName!=null)
                         contractName=contractName.replaceAll(',', '').trim();
                         
                         
                         
                         if(contractVsCloseWonconLineItemIdSet.containsKey(contractId+'#'+revenueStr)){
                           for(Id conLineItemId:contractVsCloseWonconLineItemIdSet.get(contractId+'#'+revenueStr)){
                             String contractLineItemName='';
                             
                             if(mapContractLineItemIdVsName.containsKey(conLineItemId)){
                               contractLineItemName=mapContractLineItemIdVsName.get(conLineItemId);
                             }
                             if(contractLineItemName!=null)
                             contractLineItemName=contractLineItemName.replaceAll(',', '').trim();
                             
                             
                             List<double> unAdustedClosedWonAmountList = new List<double>();
                          List<double> adustedClosedWonAmountList = new List<double>();
                          String bulevel1='',bulevel2='';String costcenter='',businessUnit='';
                             double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
                             double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
                             
                             String lastmodifiedby='',lastmodifiedDateStr='',contractLineBSLA='';
                          datetime lastdateMOdified;
                          Integer i=0;
                             
                             if(mapContractLineItemIdVsIntialForecastList.containsKey(conLineItemId)){
                               for(FCST_Initial_Forecast__c initialObj:mapContractLineItemIdVsIntialForecastList.get(conLineItemId)){
                                 
                                 i++;
                                 
                              if(i==1){
                                lastdateMOdified=initialObj.LastModifiedDate;
                                lastmodifiedby=initialObj.LastModifiedBy.Name;
                              }
                              
                              if(initialObj.LastModifiedDate!=null && lastdateMOdified<initialObj.LastModifiedDate){
                                lastdateMOdified=initialObj.LastModifiedDate;  
                                lastmodifiedby=initialObj.LastModifiedBy.Name;  
                                
    
                              }
                              
                              if(initialObj.Contract_LineItem__r.BSLA_Number__c!=null)
                                   contractLineBSLA=initialObj.Contract_LineItem__r.BSLA_Number__c;
                                 
                                 if(initialObj.Contract_LineItem__r.Cost_Center__c!=null)
                                   costcenter=initialObj.Contract_LineItem__r.Cost_Center__c;
                                   
                                 if(initialObj.Contract_LineItem__r.BU_Level1__c!=null)
                                   bulevel1=initialObj.Contract_LineItem__r.BU_Level1__c;
                                 if(initialObj.Contract_LineItem__r.BU_Level2__c!=null)
                                   bulevel2=initialObj.Contract_LineItem__r.BU_Level2__c;
                                   
                                 if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted1+=initialObj.Forecast_with_Risk__c;
                                unAdjusted1+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted2+=initialObj.Forecast_with_Risk__c;
                                unAdjusted2+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted3+=initialObj.Forecast_with_Risk__c;
                                unAdjusted3+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted4+=initialObj.Forecast_with_Risk__c;
                                unAdjusted4+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted5+=initialObj.Forecast_with_Risk__c;
                                unAdjusted5+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted6+=initialObj.Forecast_with_Risk__c;
                                unAdjusted6+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted7+=initialObj.Forecast_with_Risk__c;
                                unAdjusted7+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted8+=initialObj.Forecast_with_Risk__c;
                                unAdjusted8+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted9+=initialObj.Forecast_with_Risk__c;
                                unAdjusted9+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted10+=initialObj.Forecast_with_Risk__c;
                                unAdjusted10+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted11+=initialObj.Forecast_with_Risk__c;
                                unAdjusted11+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==currentFullYear){
                                ajusted12+=initialObj.Forecast_with_Risk__c;
                                unAdjusted12+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted13+=initialObj.Forecast_with_Risk__c;
                                unAdjusted13+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted14+=initialObj.Forecast_with_Risk__c;
                                unAdjusted14+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted15+=initialObj.Forecast_with_Risk__c;
                                unAdjusted15+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted16+=initialObj.Forecast_with_Risk__c;
                                unAdjusted16+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted17+=initialObj.Forecast_with_Risk__c;
                                unAdjusted17+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted18+=initialObj.Forecast_with_Risk__c;
                                unAdjusted18+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted19+=initialObj.Forecast_with_Risk__c;
                                unAdjusted19+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted20+=initialObj.Forecast_with_Risk__c;
                                unAdjusted20+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted21+=initialObj.Forecast_with_Risk__c;
                                unAdjusted21+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted22+=initialObj.Forecast_with_Risk__c;
                                unAdjusted22+=initialObj.Fcst_Amount__c;
                              }
                              
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted23+=initialObj.Forecast_with_Risk__c;
                                unAdjusted23+=initialObj.Fcst_Amount__c;
                              }
                              if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12 && initialObj.FCST_Planning_Fiscal_Year__r.Fiscal_Year__c==nextFullYear){
                                ajusted24+=initialObj.Forecast_with_Risk__c;
                                unAdjusted24+=initialObj.Fcst_Amount__c;
                              }
                              
                              
                              
                              
                               }
                                 adustedClosedWonAmountList.add(ajusted1);
                              adustedClosedWonAmountList.add(ajusted2);
                              adustedClosedWonAmountList.add(ajusted3);
                              adustedClosedWonAmountList.add(ajusted4);
                              adustedClosedWonAmountList.add(ajusted5);
                              adustedClosedWonAmountList.add(ajusted6);
                              adustedClosedWonAmountList.add(ajusted7);
                              adustedClosedWonAmountList.add(ajusted8);
                              adustedClosedWonAmountList.add(ajusted9);
                              adustedClosedWonAmountList.add(ajusted10);
                              adustedClosedWonAmountList.add(ajusted11);
                              adustedClosedWonAmountList.add(ajusted12);
                              
                              adustedClosedWonAmountList.add(ajusted13);
                              adustedClosedWonAmountList.add(ajusted14);
                              adustedClosedWonAmountList.add(ajusted15);
                              adustedClosedWonAmountList.add(ajusted16);
                              adustedClosedWonAmountList.add(ajusted17);
                              adustedClosedWonAmountList.add(ajusted18);
                              adustedClosedWonAmountList.add(ajusted19);
                              adustedClosedWonAmountList.add(ajusted20);
                              adustedClosedWonAmountList.add(ajusted21);
                              adustedClosedWonAmountList.add(ajusted22);
                              adustedClosedWonAmountList.add(ajusted23);
                              adustedClosedWonAmountList.add(ajusted24);
                              
                              
                              
                              unAdustedClosedWonAmountList.add(unAdjusted1);
                              unAdustedClosedWonAmountList.add(unAdjusted2);
                              unAdustedClosedWonAmountList.add(unAdjusted3);
                              unAdustedClosedWonAmountList.add(unAdjusted4);
                              unAdustedClosedWonAmountList.add(unAdjusted5);
                              unAdustedClosedWonAmountList.add(unAdjusted6);
                              unAdustedClosedWonAmountList.add(unAdjusted7);
                              unAdustedClosedWonAmountList.add(unAdjusted8);
                              unAdustedClosedWonAmountList.add(unAdjusted9);
                              unAdustedClosedWonAmountList.add(unAdjusted10);
                              unAdustedClosedWonAmountList.add(unAdjusted11);
                              unAdustedClosedWonAmountList.add(unAdjusted12);
                              
                              unAdustedClosedWonAmountList.add(unAdjusted13);
                              unAdustedClosedWonAmountList.add(unAdjusted14);
                              unAdustedClosedWonAmountList.add(unAdjusted15);
                              unAdustedClosedWonAmountList.add(unAdjusted16);
                              unAdustedClosedWonAmountList.add(unAdjusted17);
                              unAdustedClosedWonAmountList.add(unAdjusted18);
                              unAdustedClosedWonAmountList.add(unAdjusted19);
                              unAdustedClosedWonAmountList.add(unAdjusted20);
                              unAdustedClosedWonAmountList.add(unAdjusted21);
                              unAdustedClosedWonAmountList.add(unAdjusted22);
                              unAdustedClosedWonAmountList.add(unAdjusted23);
                              unAdustedClosedWonAmountList.add(unAdjusted24);
                              
                              
                              if(lastdateMOdified!=null)
                              lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
                              
                              if(StageName!=null)
                              StageName=StageName.replaceAll(',', '');
                              
                                 finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+bulevel1+','+geoNumber+','+assignedGeo+','+'Unadjusted Closed Won'+','+contractName+','+contractLineItemName+','+OppName+','+','+StageName+','+OppType+','+OppRecordType+','+contractLineBSLA+','+tcvVal+','+SVRYR1Val+','+0+','+oppAmount +','+oppProductAmount+','+serviceStartdate+','+serviceEnddate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                               If(unAdustedClosedWonAmountList!=null && unAdustedClosedWonAmountList.size()>0){
                                      for(Double obj7:unAdustedClosedWonAmountList){
                                        finalSuccessStr+=math.round(obj7)+',';
                                      }
                                     
                                  }
                                  finalSuccessStr+='\n';
                                  
                               finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+bulevel1+','+geoNumber+','+assignedGeo+','+'Adjusted Closed Won'+','+contractName+','+contractLineItemName+','+OppName+','+','+StageName+','+OppType+','+OppRecordType+','+contractLineBSLA+','+tcvVal+','+SVRYR1Val+','+0+','+oppAmount +','+oppProductAmount+','+serviceStartdate+','+serviceEnddate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                               If(adustedClosedWonAmountList!=null && adustedClosedWonAmountList.size()>0){
                                      for(Double obj8:adustedClosedWonAmountList){
                                        finalSuccessStr+=math.round(obj8)+',';
                                      }
                                     
                                  }
                                  finalSuccessStr+='\n';
                             }
                             
                           }
                         }
                       }
                     }
                     // pipeline 
                     
                     if(mapOppIdVsOppLineItemList.containskey(oppId+'#'+revenueStr)){
                     for(Id lineObj:mapOppIdVsOppLineItemList.get(oppId+'#'+revenueStr)){
                     if(mapLineItemIdVsListProductModelPipeLine.containsKey(lineObj)){
                       
                         List<double> unAdustedPipelineAmountList = new List<double>();
                      List<double> adustedPipeLineAmountList = new List<double>();

                         double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
                         double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
                           String costcenter='',businessUnit='';
                           
                           String lastmodifiedby='',lastmodifiedDateStr='',offeringName='';
                      datetime lastdateMOdified;
                      Integer i=0;decimal offeringTotalP=0;
                          
                           for(FCST_Product_Model__c productModel:mapLineItemIdVsListProductModelPipeLine.get(lineObj)){
                                  i++;
                                 
                          if(i==1){
                            lastdateMOdified=productModel.LastModifiedDate;
                            lastmodifiedby=productModel.LastModifiedBy.Name;
                          }
                          
                          if(productModel.LastModifiedDate!=null && lastdateMOdified<productModel.LastModifiedDate){
                            lastdateMOdified=productModel.LastModifiedDate;  
                            lastmodifiedby=productModel.LastModifiedBy.Name;  
                            

                          }
                          
                          
                          if(productModel.FCST_Product_Line_ID__c!=null && mapLineIdVsTotalAmount.containsKey(productModel.FCST_Product_Line_ID__c))
                               offeringTotalP=mapLineIdVsTotalAmount.get(productModel.FCST_Product_Line_ID__c);
                               
                          if(productModel.Product__r.Name!=null)
                          offeringName=productModel.Product__r.Name;
                                 
                                 if((String)productModel.getSObject('Product__r').get(costCenterAPI)!=null)
                            costcenter=(String)productModel.getSObject('Product__r').get(costCenterAPI);
                            
                          if((String)productModel.getSObject('Product__r').get(businessUnitAPI)!=null)
                            businessUnit=(String)productModel.getSObject('Product__r').get(businessUnitAPI);
                            
                             if(productModel.Fiscal_Period__r.Month_Number__c==1 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted1+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted1+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==2 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted2+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted2+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==3 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted3+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted3+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==4 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted4+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted4+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==5 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted5+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted5+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==6 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted6+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted6+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==7 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted7+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted7+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==8 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted8+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted8+=productModel.Weighted_Revenue__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==9 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted9+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted9+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==10 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted10+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted10+=productModel.Weighted_Revenue__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==11 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted11+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted11+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==12 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted12+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted12+=productModel.Weighted_Revenue__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==1 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted13+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted13+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==2 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted14+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted14+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==3 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted15+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted15+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==4 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted16+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted16+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==5 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted17+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted17+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==6 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted18+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted18+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==7 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted19+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted19+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==8 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted20+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted20+=productModel.Weighted_Revenue__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==9 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted21+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted21+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==10 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted22+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted22+=productModel.Weighted_Revenue__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==11 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted23+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted23+=productModel.Weighted_Revenue__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==12 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted24+=productModel.User_Adjusted_Revenue__c;
                            unAdjusted24+=productModel.Weighted_Revenue__c;
                          }
                          
                          
                          
                             
                             
                       }
                           adustedPipeLineAmountList.add(ajusted1);
                        adustedPipeLineAmountList.add(ajusted2);
                        adustedPipeLineAmountList.add(ajusted3);
                        adustedPipeLineAmountList.add(ajusted4);
                        adustedPipeLineAmountList.add(ajusted5);
                        adustedPipeLineAmountList.add(ajusted6);
                        adustedPipeLineAmountList.add(ajusted7);
                        adustedPipeLineAmountList.add(ajusted8);
                        adustedPipeLineAmountList.add(ajusted9);
                        adustedPipeLineAmountList.add(ajusted10);
                        adustedPipeLineAmountList.add(ajusted11);
                        adustedPipeLineAmountList.add(ajusted12);
                        
                        adustedPipeLineAmountList.add(ajusted13);
                        adustedPipeLineAmountList.add(ajusted14);
                        adustedPipeLineAmountList.add(ajusted15);
                        adustedPipeLineAmountList.add(ajusted16);
                        adustedPipeLineAmountList.add(ajusted17);
                        adustedPipeLineAmountList.add(ajusted18);
                        adustedPipeLineAmountList.add(ajusted19);
                        adustedPipeLineAmountList.add(ajusted20);
                        adustedPipeLineAmountList.add(ajusted21);
                        adustedPipeLineAmountList.add(ajusted22);
                        adustedPipeLineAmountList.add(ajusted23);
                        adustedPipeLineAmountList.add(ajusted24);
                        
                        
                        
                        unAdustedPipelineAmountList.add(unAdjusted1);
                        unAdustedPipelineAmountList.add(unAdjusted2);
                        unAdustedPipelineAmountList.add(unAdjusted3);
                        unAdustedPipelineAmountList.add(unAdjusted4);
                        unAdustedPipelineAmountList.add(unAdjusted5);
                        unAdustedPipelineAmountList.add(unAdjusted6);
                        unAdustedPipelineAmountList.add(unAdjusted7);
                        unAdustedPipelineAmountList.add(unAdjusted8);
                        unAdustedPipelineAmountList.add(unAdjusted9);
                        unAdustedPipelineAmountList.add(unAdjusted10);
                        unAdustedPipelineAmountList.add(unAdjusted11);
                        unAdustedPipelineAmountList.add(unAdjusted12);
                        
                        unAdustedPipelineAmountList.add(unAdjusted13);
                        unAdustedPipelineAmountList.add(unAdjusted14);
                        unAdustedPipelineAmountList.add(unAdjusted15);
                        unAdustedPipelineAmountList.add(unAdjusted16);
                        unAdustedPipelineAmountList.add(unAdjusted17);
                        unAdustedPipelineAmountList.add(unAdjusted18);
                        unAdustedPipelineAmountList.add(unAdjusted19);
                        unAdustedPipelineAmountList.add(unAdjusted20);
                        unAdustedPipelineAmountList.add(unAdjusted21);
                        unAdustedPipelineAmountList.add(unAdjusted22);
                        unAdustedPipelineAmountList.add(unAdjusted23);
                        unAdustedPipelineAmountList.add(unAdjusted24);
                           
                           
                           if(lastdateMOdified!=null)
                              lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
                              
                              
                        if(offeringName!=null)
                          offeringName=offeringName.replaceAll(',', '');      
                              
                          finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+businessUnit+','+geoNumber+','+assignedGeo+','+'Unadjusted Pipeline'+','+' '+','+' '+','+OppName+','+offeringName+','+StageName+','+OppType+','+OppRecordType+','+OppBslaNumber+','+tcvVal+','+SVRYR1Val+','+offeringTotalP+','+oppAmount +','+oppProductAmount+','+serviceStartdate+','+serviceEnddate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                          If(unAdustedPipelineAmountList!=null && unAdustedPipelineAmountList.size()>0){
                                for(Double obj9:unAdustedPipelineAmountList){
                                  finalSuccessStr+=math.round(obj9)+',';
                                }
                               
                           }
                          finalSuccessStr+=',\n';
                          
                          finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+businessUnit+','+geoNumber+','+assignedGeo+','+'Adjusted Pipeline'+','+' '+','+' '+','+OppName+','+offeringName+','+StageName+','+OppType+','+OppRecordType+','+OppBslaNumber+','+tcvVal+','+SVRYR1Val+','+offeringTotalP+','+oppAmount +','+oppProductAmount+','+serviceStartdate+','+serviceEnddate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                         If(adustedPipeLineAmountList!=null && adustedPipeLineAmountList.size()>0){
                                for(Double obj10:adustedPipeLineAmountList){
                                  finalSuccessStr+=math.round(obj10)+',';
                                }
                               
                            }
                            finalSuccessStr+='\n';
                       }
                     
                       }
                       }  
                       
                       if(mapOppAboveRevenueTypeVsOppLineItemList.containskey(oppId+'#'+revenueStr)){
                     for(Id lineObj:mapOppAboveRevenueTypeVsOppLineItemList.get(oppId+'#'+revenueStr)){
                     if(mapLineItemIdVsListProductModelFunnel.containsKey(lineObj)){
                       
                         List<double> unAdustedPipelineAmountList = new List<double>();
                      List<double> adustedPipeLineAmountList = new List<double>();

                         double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
                         String costcenter='',businessUnit='';  
                         
                         String lastmodifiedby='',lastmodifiedDateStr='',OfferingName='';
                      datetime lastdateMOdified;
                      Integer i=0;decimal offeringTotalP=0;
                        
                           for(FCST_Product_Model__c productModel:mapLineItemIdVsListProductModelFunnel.get(lineObj)){
                             
                                i++;
                                 
                          if(i==1){
                            lastdateMOdified=productModel.LastModifiedDate;
                            lastmodifiedby=productModel.LastModifiedBy.Name;
                          }
                          
                          if(productModel.LastModifiedDate!=null && lastdateMOdified<productModel.LastModifiedDate){
                            lastdateMOdified=productModel.LastModifiedDate;  
                            lastmodifiedby=productModel.LastModifiedBy.Name;  
                            

                          }
                          if(productModel.FCST_Product_Line_ID__c!=null && mapLineIdVsTotalAmount.containsKey(productModel.FCST_Product_Line_ID__c))
                               offeringTotalP=mapLineIdVsTotalAmount.get(productModel.FCST_Product_Line_ID__c);
                             
                             
                          if(productModel.Product__r.Name!=null)
                            OfferingName=productModel.Product__r.Name;
                                 
                                 if((String)productModel.getSObject('Product__r').get(costCenterAPI)!=null)
                            costcenter=(String)productModel.getSObject('Product__r').get(costCenterAPI);
                            
                          if((String)productModel.getSObject('Product__r').get(businessUnitAPI)!=null)
                            businessUnit=(String)productModel.getSObject('Product__r').get(businessUnitAPI);
                            
                        if(productModel.Amount__c!=null){    
                             if(productModel.Fiscal_Period__r.Month_Number__c==1 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted1+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==2 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted2+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==3 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted3+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==4 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted4+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==5 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted5+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==6 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted6+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==7 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted7+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==8 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted8+=productModel.Amount__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==9 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted9+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==10 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted10+=productModel.Amount__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==11 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted11+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==12 && productModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            ajusted12+=productModel.Amount__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==1 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted13+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==2 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted14+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==3 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted15+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==4 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted16+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==5 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted17+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==6 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted18+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==7 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted19+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==8 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted20+=productModel.Amount__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==9 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted21+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==10 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted22+=productModel.Amount__c;
                          }
                          
                          if(productModel.Fiscal_Period__r.Month_Number__c==11 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted23+=productModel.Amount__c;
                          }
                          if(productModel.Fiscal_Period__r.Month_Number__c==12 && productModel.Fiscal_Period__r.Fiscal_Year__c==nextFullYear){
                            ajusted24+=productModel.Amount__c;
                          }
                          
                        }
                          
                             
                             
                       }
                           adustedPipeLineAmountList.add(ajusted1);
                        adustedPipeLineAmountList.add(ajusted2);
                        adustedPipeLineAmountList.add(ajusted3);
                        adustedPipeLineAmountList.add(ajusted4);
                        adustedPipeLineAmountList.add(ajusted5);
                        adustedPipeLineAmountList.add(ajusted6);
                        adustedPipeLineAmountList.add(ajusted7);
                        adustedPipeLineAmountList.add(ajusted8);
                        adustedPipeLineAmountList.add(ajusted9);
                        adustedPipeLineAmountList.add(ajusted10);
                        adustedPipeLineAmountList.add(ajusted11);
                        adustedPipeLineAmountList.add(ajusted12);
                        
                        adustedPipeLineAmountList.add(ajusted13);
                        adustedPipeLineAmountList.add(ajusted14);
                        adustedPipeLineAmountList.add(ajusted15);
                        adustedPipeLineAmountList.add(ajusted16);
                        adustedPipeLineAmountList.add(ajusted17);
                        adustedPipeLineAmountList.add(ajusted18);
                        adustedPipeLineAmountList.add(ajusted19);
                        adustedPipeLineAmountList.add(ajusted20);
                        adustedPipeLineAmountList.add(ajusted21);
                        adustedPipeLineAmountList.add(ajusted22);
                        adustedPipeLineAmountList.add(ajusted23);
                        adustedPipeLineAmountList.add(ajusted24);
                        
                        if(lastdateMOdified!=null)
                              lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
                        
                      if(OfferingName!=null)
                        OfferingName=OfferingName.replaceAll(',', '');  
                         
                         finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+revenueStr+','+costcenter+','+businessUnit+','+geoNumber+','+assignedGeo+','+'Full Above the Funnel'+','+' '+','+' '+','+OppName+','+OfferingName+','+StageName+','+OppType+','+OppRecordType+','+OppBslaNumber+','+tcvVal+','+SVRYR1Val+','+serviceStartdate+','+offeringTotalP+','+oppAmount +','+oppProductAmount+','+serviceEnddate+','+termsInMonth+','+transitionDate+','+openAdminVersion+','+formattedDate+','+lastmodifiedby+','+lastmodifiedDateStr+',';
                         If(adustedPipeLineAmountList!=null && adustedPipeLineAmountList.size()>0){
                              for(Double obj11:adustedPipeLineAmountList){
                                finalSuccessStr+=math.round(obj11)+',';
                              }
                             
                          }
                          finalSuccessStr+='\n';
                       }
                     
                       }
                       }
                       
                     
                   }
                 }
               }
             }
           else{
             List<Double> zeroamount =new List<Double>();
             for(Integer i=0;i<24;i++){
                   zeroamount.add(0);
                 }
               
               finalSuccessStr+=programName+','+cpmRegion+','+peName+','+pmName+','+'No Revenue'+',,'+','+geoNumber+',,'+'No Forecast'+','+','+','+','+','+','+','+','+','+','+','+','+' '+','+', '+','+' '+','+','+','+openAdminVersion+','+formattedDate+',,,';
               If(zeroamount!=null && zeroamount.size()>0){
                  for(Double obj12:zeroamount){
                    finalSuccessStr+=math.round(obj12)+',';
                  }
                 
              }
              finalSuccessStr+='\n';
           }
       
         }
       }  
      }
          catch(Exception e) {
              System.debug('Exception Message '+e);
              System.debug('Exception Line Number: '+e.getLineNumber());
          
          }   
         
         
       

     }
     
     global void finish(Database.BatchableContext bc){
       
        String loginUserEmail=UserInfo.getUserEmail();
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(finalSuccessStr);
      String csvSuccessName = 'Data_Extract_'+fromSelectedYear+'.csv';
      csvAttachment.setFileName(csvSuccessName);
      csvAttachment.setBody(csvBlob);
      
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      String[] toAddresses = new String[]{loginUserEmail};
      String subject = 'Data Extract for year '+fromSelectedYear ;
      email.setSubject(subject);
      email.setToAddresses(toAddresses);
      email.setPlainTextBody('All forecast data and Contract Data');
      email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
      Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
     }    
}