public with sharing class FCST_Data_Extract_Controller {
	
	public List<wrapperAccountWise> wrapperAccountWiseList{get; set;}    
	public string s_FilterPlanningYear{get;set;}
	public String selectedYr{get;set;}
	public String nextYear{get;set;}
	public String openAdminVersion{get;set;}
	
	public string cpmRegionLabelName;
	public string PMTypeLabelName;
	public string PETypeLabelName;
	public string GeoLabelName;
	
	public string serviceStartDateAPI;
	public string serviceEndDateAPI;
	public string transitionDateAPI;
	public string termsInMonthAPI;
	public string oppBslaAPI;
	
	public string oppRecordTypeAPI;
	
	public string costCenterAPI;
	public string businessUnitAPI;
	
	public string TCVAPI;
	public string SVCYR1API;
	public string oppGeoLookupAPI;
	
	public string currentFullYear{get;set;}
	public string nextFullYear{get;set;}
	
	public date todayDate {get;set;}
	public String formattedDate {get;set;}
    public String errorMsg{get;set;}
    public List<SelectOption> FilterPlanningVersion{get;set;}
    
    public map<String,String> mapRecordIdVsName;
	
	
	 public static String reduceName(String str){
	  if(str!=null && str.length()>25){
		str=str.substring(0, 25)+'...';
	  }
	 
	 return str;
	
	}
	       //>>>>>>>>>>pagination start>>>>>>>>>>
        public integer counter=0; 
        public integer list_size=5;  
        public integer total_size;
        
        public PageReference Beginning() { 
          counter = 0;
         // System.debug('>>Beginning>>counter>>>'+counter);
         updateWrapperList();
          return null;
       }
    
       public PageReference Previous() { 
          counter -= list_size;
         // System.debug('>>Previous>>list_size>>>'+list_size);
        //  System.debug('>>Previous>>counter>>>'+counter);
         updateWrapperList();
          return null;
       }
    
       public PageReference Next() { 
          counter += list_size;
          
        //  System.debug('>>Next>>list_size>>>'+list_size);
      //    System.debug('>>Next>>counter>>>'+counter);
          updateWrapperList();
          return null;
       }
    
     
       public PageReference End() { 
          counter = total_size - math.mod(total_size, list_size);
          if(counter==total_size){
            counter=counter-list_size;
          }
         // System.debug('>>End>>list_size>>>'+list_size);
         // System.debug('>>End>>counter>>>'+counter);
          updateWrapperList();
          return null;
       }
    
       public Boolean getDisablePrevious() { 
         if (counter>0) {
          return false;
          } else return true;
       }
    
       public Boolean getDisableNext() {
        if (counter + list_size < total_size){ 
            
            return false;} else return true;
        }
    
       public Integer getTotal_size() {
          return total_size;
       }
    
       public Integer getPageNumber() {
          return counter/list_size + 1;
       }
    
       public Integer getTotalPages() {
            if(total_size==null)
                total_size=0;
            
            if (math.mod(total_size, list_size) > 0) {
             return total_size/list_size + 1;
            } else {
             return (total_size/list_size);
         }
       }
     //>>>>>>>>>>pagination start End>>>>>>>>>>
	 
	 
	public FCST_Data_Extract_Controller(){
		
		mapRecordIdVsName = new Map<String, String>();
		List<RecordType> recordTypeList=[select Id,Name from RecordType LIMIT 8000];
		if(recordTypeList!=null && recordTypeList.size()>0){
			for(RecordType recordObj:recordTypeList){
				mapRecordIdVsName.put(String.ValueOf(recordObj.Id),recordObj.Name);
			}
		}
		Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
		cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
	    PMTypeLabelName=mapCustomObj.FCST_ProgramManager__c;
	    PETypeLabelName=mapCustomObj.FCST_Program_Executive__c;
	    GeoLabelName=mapCustomObj.FCST_GeoCodes__c;
	    
	     serviceStartDateAPI=mapCustomObj.Fcst_StartDate__c;
	     serviceEndDateAPI=mapCustomObj.Fcst_EndDate__c;
	     transitionDateAPI=mapCustomObj.Transition_Date__c;
	     termsInMonthAPI=mapCustomObj.Term_In_Months__c;
	    
	    costCenterAPI=mapCustomObj.Cost_Center__c;
	    businessUnitAPI=mapCustomObj.Fcst_BusinessUnit__c;
	    
	    TCVAPI=mapCustomObj.Opportunity_TCV__c;
	    SVCYR1API=mapCustomObj.Opportunity_SVC_YR1__c;
	    oppGeoLookupAPI=mapCustomObj.Geo__c;
	    oppBslaAPI=mapCustomObj.FCST_BSLA__c;
	    
	    oppRecordTypeAPI=mapCustomObj.Opportunity_RecordType_Api__c;
	    
	    todayDate=date.today();
	    
	    String accQuery='select Id from Account where   '+cpmRegionLabelName+'!=null LIMIT 500';
	     List<Account> accListVal=database.query(accQuery);
	 total_size=accListVal.size();
	 // total_size=2;
	        //System.debug('...total_size.....'+total_size);
	   formattedDate=todayDate.month()+'/'+todayDate.day()+'/'+todayDate.year();
	    
	    getFilterPlanningYear();
	    planningVersion();
	    selectedYr=s_FilterPlanningYear.right(2);
	    nextYear=String.ValueOf(Integer.ValueOf(selectedYr)+1);
		
		currentFullYear=s_FilterPlanningYear;
		nextFullYear=String.ValueOf(Integer.ValueOf(currentFullYear)+1);
		
		
		
		set<string> setValidVersions = new set<string>{'Open (Admin)'};
		List<Planning_Version__c> pvlist=[select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
		if(pvlist!=null && pvlist.size()>0)
			openAdminVersion=pvlist[0].Name;
			
			
	  updateWrapperList();
		
	}
	
    public List<SelectOption> getFilterPlanningYear() {
      
	List<SelectOption> options = new List<SelectOption>();
    String CurrentYear = String.ValueOf(Date.today().year());
        Set<String> yrList = new Set<String>();
        set<string> setValidVersions = new set<string>{'Closed','Open (Admin)'};
		List<Planning_Version__c> pvlist=[select Id,Name,Version_Status__c,Planning_Version_Fiscal_Year__c,Fiscal_Year_Planning__r.Name from Planning_Version__c where   Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
		if(pvlist!=null && pvlist.size()>0){ 
			for(Planning_Version__c pvObj:pvlist){
				yrList.add(pvObj.Fiscal_Year_Planning__r.Name);
				if(pvObj.Fiscal_Year_Planning__r.Name==CurrentYear)
					s_filterPlanningYear=pvObj.Fiscal_Year_Planning__r.Name;
			}
		}
		
		
		
		for(String str:yrList){
			options.add(new SelectOption(str,str));
		}
        
       
            
        return options;
	}
    	
	public void onChangeYear() {
		planningVersion();
       // updateWrapperList();     
    }
    
    public void loadLandingUI() {
    	counter = 0;
        updateWrapperList();
     
    }
    
 public List<SelectOption> planningVersion() {
         FilterPlanningVersion = new List<SelectOption>();
        set<string> setValidVersions = new set<string>{'Closed','Open (Admin)'};
		List<Planning_Version__c> pvlist=[select Id,Name,Version_Status__c,Planning_Version_Fiscal_Year__c from Planning_Version__c where Fiscal_Year_Planning__r.Name =:s_filterPlanningYear and  Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
		if(pvlist!=null && pvlist.size()>0){
			for(Planning_Version__c pvObj:pvlist){
				FilterPlanningVersion.add(new SelectOption(pvObj.Name,pvObj.Name));
				openAdminVersion=pvObj.Name;
			}
		}
		//System.debug('>>>options>>>'+options);
        return FilterPlanningVersion;
    }   
  
	
	public void updateWrapperList(){
		
		try{
			
			selectedYr=s_FilterPlanningYear.right(2);
	    	nextYear=String.ValueOf(Integer.ValueOf(selectedYr)+1);
		
		   currentFullYear=s_FilterPlanningYear;
		   nextFullYear=String.ValueOf(Integer.ValueOf(currentFullYear)+1);
			
			Integer currentYear=date.today().Year();
			if(counter>500)
				counter=500;
				
			String accQuery='Select Id,Name,'+GeoLabelName+','+cpmRegionLabelName+','+PETypeLabelName+','+PMTypeLabelName+' from Account where   '+cpmRegionLabelName+'!=null   order by Name limit :list_size  offset :counter ';
	       
	        List<Account> accListVal=database.query(accQuery);
	       // System.debug('>>>accListVal>>>'+accListVal.size());
	        Map<Id,List<Opportunity>> mapAccountVsOppList =new Map<Id,List<Opportunity>>();
	        Map<Id,Opportunity> mapOppIdVsOppObj =new Map<Id,Opportunity>();
	        String assisgnedGeoAPI=oppGeoLookupAPI.removeEnd('c')+'r';
	        String queryAssignGeoApI=oppGeoLookupAPI.removeEnd('c')+'r.Name';
	        String oppQuery='Select '+oppBslaAPI+','+oppRecordTypeAPI+',Type,id,Name,AccountId,StageName,'+serviceStartDateAPI+','+serviceEndDateAPI+','+transitionDateAPI+','+termsInMonthAPI+','+TCVAPI+','+SVCYR1API+','+oppGeoLookupAPI+','+queryAssignGeoApI+' from Opportunity where AccountId IN:accListVal';
	        
	      //  System.debug('>>>oppQuery>>>'+oppQuery);
	         List<Opportunity> oppList=database.query(oppQuery);
	      //  System.debug('>>>oppList>>>'+oppList.size());
	        
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
	        
	    //    System.debug('...mapAccountVsOppList.....'+mapAccountVsOppList);
	        
	        Set<Id> pmIdSet = new Set<Id>();
	        
	        if(accListVal!=null && accListVal.size()>0){
	        	for(Account acc :accListVal){
	        		if((String) acc.get(PMTypeLabelName)!=null)
	        			pmIdSet.add(Id.ValueOf((String) acc.get(PMTypeLabelName)));
	        	    if((String) acc.get(PETypeLabelName)!=null)
	        			pmIdSet.add(Id.ValueOf((String) acc.get(PETypeLabelName)));
	        	}
	        }
	       // System.debug('...pmIdSet.....'+pmIdSet);
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
	        
	         String baselineQuery ='Select  Contract_LineItem__r.BSLA_Number__c,FCST_Contract__r.Fcst_Service_End_date__c,FCST_Contract__r.Fcst_Service_start_date__c ,LastModifiedBy.Name,LastModifiedDate,Contract_LineItem__r.Cost_Center__c,FCST_Contract__r.Contract__c,Contract_LineItem__r.Line_Description__c,Contract_LineItem__r.BU_Level2__c,Contract_LineItem__r.BU_Level1__c,FCST_Contract__r.Contract_Description__c,FCST_Planning_Fiscal_Year__r.Fiscal_Year__c,Contract_LineItem__r.Name,FCST_Contract__c,FCST_Contract__r.Name,Contract_LineItem__c,FCST_Contract__r.Opportunity__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Fcst_Amount__c,Forecast_with_Risk__c,Account__r.Id ,Contract_LineItem__r.Fcst_Revenue_Type__c  from  FCST_Initial_Forecast__c where ';
			 baselineQuery += ' Planning_Version__r.Name =: openAdminVersion and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c<:currentYear	and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null  and (FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:currentFullYear or FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:nextFullYear)';
			 baselineQuery += ' order by Account__r.Id,Contract_LineItem__r.Fcst_Revenue_Type__c';
			 
			 List<FCST_Initial_Forecast__c> baselineIntialForecastList=database.query(baselineQuery); 
			 
			//  System.debug('...baselineQuery.....'+baselineQuery);
		//	  System.debug('...baselineIntialForecastList.....'+baselineIntialForecastList);
			  
			// Map<String,List<FCST_Initial_Forecast__c>> accRevTypeVsbaselineInitialModel = new Map<String,List<FCST_Initial_Forecast__c>>();
			 
			 if(baselineIntialForecastList!=null && baselineIntialForecastList.size()>0){
			 	for(FCST_Initial_Forecast__c baseObj:baselineIntialForecastList){
			 		contractIdSet.add(baseObj.FCST_Contract__c);
			 		//mapContractIdVsName.put(baseObj.FCST_Contract__c,baseObj.FCST_Contract__r.Contract__c);
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
			 
			
			  
			 
			 String closeWonQuery ='Select Contract_LineItem__r.BSLA_Number__c,LastModifiedBy.Name,LastModifiedDate,Contract_LineItem__r.Cost_Center__c,FCST_Contract__r.Contract__c,Contract_LineItem__r.Line_Description__c,Contract_LineItem__r.BU_Level2__c,Contract_LineItem__r.BU_Level1__c,FCST_Contract__r.Contract_Description__c,FCST_Planning_Fiscal_Year__r.Fiscal_Year__c,Contract_LineItem__r.Name,FCST_Contract__c,FCST_Contract__r.Name,Contract_LineItem__c,FCST_Contract__r.Opportunity__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Fcst_Amount__c,Forecast_with_Risk__c,Account__r.Id ,Contract_LineItem__r.Fcst_Revenue_Type__c  from  FCST_Initial_Forecast__c   where ';//
			 closeWonQuery += ' Planning_Version__r.Name =: openAdminVersion  and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c>=:currentYear	and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null and (FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:currentFullYear or FCST_Planning_Fiscal_Year__r.Fiscal_Year__c=:nextFullYear)';
			 closeWonQuery += ' order by Account__r.Id,Contract_LineItem__r.Fcst_Revenue_Type__c';
			 
		//	 System.debug('...closeWonQuery.....'+closeWonQuery);
			 
			 List<FCST_Initial_Forecast__c> closeWonIntialForecastList=database.query(closeWonQuery); 
			 
	//		 System.debug('...closeWonIntialForecastList.....'+closeWonIntialForecastList);
			// Map<String,List<FCST_Initial_Forecast__c>> accRevTypeVsCloseWonInitialModel = new Map<String,List<FCST_Initial_Forecast__c>>();
			 
			 if(closeWonIntialForecastList!=null && closeWonIntialForecastList.size()>0){
			 	for(FCST_Initial_Forecast__c closeWonObj:closeWonIntialForecastList){
			 	//	System.debug('...closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c.....'+closeWonObj.Contract_LineItem__r.Fcst_Revenue_Type__c);
			 		//mapContractIdVsName.put(closeWonObj.FCST_Contract__c,closeWonObj.FCST_Contract__r.Contract__c);
			 		
			 		contractIdSet.add(closeWonObj.FCST_Contract__c);
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
		//	  System.debug('...accRevTypeVsCloseWonInitialModel.....'+accRevTypeVsCloseWonInitialModel);
			 String oppStageWon='Closed Won',oppStageCloseLost='Closed Lost',abovefunnel='Lead (Above the Funnel)';
	         
			 String openOppQuery='select Product__r.Name,LastModifiedBy.Name,LastModifiedDate,Product__r.'+costCenterAPI+',Product__r.'+businessUnitAPI+',Opportunity__r.StageName,FCST_Product_Line_ID__c,Product__c,Opportunity__c,Fiscal_Period__r.Fiscal_Year__c,Account__r.Id,Fiscal_Period__r.Month_Number__c,User_Adjusted_Revenue__c,Weighted_Revenue__c,FCST_Revenue_Types__c , Opportunity__r.AccountId  from FCST_Product_Model__c where Id <> null ';
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
	    			
	    			
				
			 	}
			 }
			 
			 
			 String aboveFunnelOppQuery='select Product__r.Name,LastModifiedBy.Name,LastModifiedDate,Product__r.'+costCenterAPI+',Product__r.'+businessUnitAPI+',Opportunity__r.StageName,FCST_Product_Line_ID__c,Opportunity__c,Fiscal_Period__r.Fiscal_Year__c,Amount__c,Account__r.Id,Fiscal_Period__r.Month_Number__c,User_Adjusted_Revenue__c,Weighted_Revenue__c,FCST_Revenue_Types__c , Opportunity__r.AccountId  from FCST_Product_Model__c where Id <> null ';
	         aboveFunnelOppQuery+= '  and Planning_Version__r.Name =: openAdminVersion and Account__c IN:accListVal  and Opportunity__r.StageName=:abovefunnel and  FCST_Revenue_Types__c<>null and Account_CPM_Region__c!=null and (Fiscal_Period__r.Fiscal_Year__c=:nextFullYear or Fiscal_Period__r.Fiscal_Year__c=:currentFullYear)';
	         aboveFunnelOppQuery += ' order by Opportunity__r.AccountId,FCST_Revenue_Types__c';
	         
			 List<FCST_Product_Model__c> aboveFunnelForecastList=database.query(aboveFunnelOppQuery); 
			 
		     System.debug('....aboveFunnelForecastList>>>>>'+aboveFunnelForecastList);
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
				
			 	}
			 }
			 
			 
			/*  System.debug('...accIdRevenueTypeVsContractBaselineSet.....'+accIdRevenueTypeVsContractBaselineSet);
			   System.debug('...OppVsContractBaselineIdSet.....'+OppVsContractBaselineIdSet);
			 
			 
			 System.debug('....mapOppAboveRevenueTypeVsOppLineItemList>>>>>'+mapOppAboveRevenueTypeVsOppLineItemList);
			 
			 System.debug('...accIdVsRevenueTypeMapSet.....'+accIdVsRevenueTypeMapSet);
			 System.debug('...revenueTypeVsOppIdSet.....'+revenueTypeVsOppIdSet);
			 System.debug('...accIdRevenueTypeVsContractBaselineSet.....'+accIdRevenueTypeVsContractBaselineSet);
			  System.debug('...contractVsBaseLineconLineItemIdSet.....'+contractVsBaseLineconLineItemIdSet);
			   System.debug('...mapContractLineItemIdVsIntialForecastList.....'+mapContractLineItemIdVsIntialForecastList);
			  System.debug('...openAdminVersion.....'+openAdminVersion);
			  
			  */
			//  System.debug('...accIdVsRevenueTypeMapSet.....'+accIdVsRevenueTypeMapSet);
			 wrapperAccountWiseList = new List<wrapperAccountWise>();
			 
			 
			 List<FCST_Contract__c> listFCSTContract = [Select Id,Contract__c,Fcst_Geo_Name__c,Fcst_Geo_Numbers__c from FCST_Contract__c where Id IN:contractIdSet];
			 if(listFCSTContract!=null){
			 	for(FCST_Contract__c conObj:listFCSTContract){
			 		mapContractIdVsName.put(conObj.Id,conObj);
			 	}
			 	
			 	
			 }
		//	 System.debug('>>>accListVal...'+accListVal);
			 if(accListVal!=null && accListVal.size()>0){
			 	
			 	for(Account accObj:accListVal){
			 //		System.debug('>>>accObj. name....'+accObj.Name); 
			 	 // String geoNumber=(String) accObj.get(GeoLabelName);
				 		   String geoNumber='',cpmRegion='',programName='',peNameId='',pmNameId='',peName='',pmName='';
				 		   String geoNumber25Digit='',cpmRegion25Digit='',programName25Digit='',peName25Digit='',pmName25Digit='';
				 		   if((String) accObj.get(cpmRegionLabelName)!=null)
			 			   	cpmRegion=(String) accObj.get(cpmRegionLabelName);
			 			   
			 			   if(accObj.Name!=null)	
			 			   	programName=accObj.Name; 
			 			   	
			 			  if((String) accObj.get(PMTypeLabelName)!=null)
			 			   	pmNameId=(String) accObj.get(PMTypeLabelName);
			 			  if((String) accObj.get(PETypeLabelName)!=null)
			 			    peNameId=(String) accObj.get(PETypeLabelName);
			 			
			 			//System.debug('>>>pmNameId.....'+pmNameId);
			 			//System.debug('>>>mapIdVsName.....'+mapIdVsName);
			 			//System.debug('>>>peNameId.....'+peNameId); 
			 			
			 			 if((String) accObj.get(GeoLabelName)!=null)
			 			    geoNumber=(String) accObj.get(GeoLabelName);
			 			  
			 			  
			 			  if(pmNameId!=null && pmNameId!='' && mapIdVsName.containsKey(Id.ValueOf(pmNameId))){
			 			  	pmName=mapIdVsName.get(Id.ValueOf(pmNameId));
			 			  }
			 			  if(peNameId!=null && peNameId!='' && mapIdVsName.containsKey(Id.ValueOf(peNameId))){
			 			  	peName=mapIdVsName.get(Id.ValueOf(peNameId));
			 			  }
			 			  
			 			  geoNumber25Digit=reduceName(geoNumber);
			 			  cpmRegion25Digit=reduceName(cpmRegion);
			 			  programName25Digit=reduceName(programName);
			 			  peName25Digit=reduceName(peName);
			 			  pmName25Digit=reduceName(pmName);
			 			  
			 		//	System.debug('>>>accIdVsRevenueTypeMapSet...'+accIdVsRevenueTypeMapSet);  
			 	//		System.debug('>>>accObj.Id..'+accObj.Id);    
			 	    if(accIdVsRevenueTypeMapSet.containsKey(accObj.Id)){
			 	    	for(String revenueAccId:accIdVsRevenueTypeMapSet.get(accObj.Id)){
			 	    		String[] revList = revenueAccId.split('#'); 
			 	    		String revenueStr=revList[0];
			 	    	//	System.debug('>>revenueStr....'+revenueStr); 
			 	    	//	System.debug('>>revenueTypeVsOppIdSet....'+revenueTypeVsOppIdSet); 
			 	    		
			 	    	//...........................................................................
			 	    	
			 	    	if(accIdRevenueTypeVsContractBaselineSet.containsKey(accObj.Id+'#'+revenueStr)){
			 	    					for(Id contractId:accIdRevenueTypeVsContractBaselineSet.get(accObj.Id+'#'+revenueStr)){
			 	    						String contractName='',contractName25Digit='',assignedGeoContract='',geoNameContract='',geonumContract='';
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
			 	    						assignedGeoContract+=geoNameContract;
			 	    						
			 	    						if(assignedGeoContract!=null)
			 	    						assignedGeoContract=assignedGeoContract.replaceAll(',', '').trim();
			 	    						
			 	    						contractName25Digit=reduceName(contractName);
			 	    						if(contractVsBaseLineconLineItemIdSet.containsKey(contractId+'#'+revenueStr)){
			 	    							for(Id conLineItemId:contractVsBaseLineconLineItemIdSet.get(contractId+'#'+revenueStr)){
			 	    								String contractLineItemName='',contractLineItemName25Digit='';
			 	    								
			 	    								if(mapContractLineItemIdVsName.containsKey(conLineItemId)){
			 	    									contractLineItemName=mapContractLineItemIdVsName.get(conLineItemId);
			 	    								}
			 	    								contractLineItemName25Digit=reduceName(contractLineItemName);
			 	    							//	System.debug('>>>conLineItemId.....'+conLineItemId); 	
			 	    								List<double> unAdustedBaselineAmountList = new List<double>();
													List<double> adustedBaseLineAmountList = new List<double>();

			 	    								double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
			 	    								double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
			 	    								String bulevel1='',bulevel2='';
			 	    								
			 	    								String costcenter='',businessUnit='';
			 	    								
			 	    								String lastmodifiedby='',lastmodifiedDateStr='',bslanumber='';
			 	    								datetime lastdateMOdified,ServiceSDate,ServiceEDate;
			 	    								Integer i=0;
			 	    								
			 	    								if(mapContractLineItemIdVsIntialForecastList.containsKey(conLineItemId)){
			 	    									for(FCST_Initial_Forecast__c initialObj:mapContractLineItemIdVsIntialForecastList.get(conLineItemId)){
			 	    										i++;
			 	    										
			 	    										if(initialObj.FCST_Contract__r.Fcst_Service_End_date__c!=null)
			 	    											ServiceEDate=initialObj.FCST_Contract__r.Fcst_Service_End_date__c;
			 	    										
			 	    										if(initialObj.FCST_Contract__r.Fcst_Service_start_date__c!=null)
			 	    											ServiceSDate=initialObj.FCST_Contract__r.Fcst_Service_start_date__c;
			 	    											
			 	    									    if(initialObj.Contract_LineItem__r.BSLA_Number__c!=null)
			 	    											bslanumber=initialObj.Contract_LineItem__r.BSLA_Number__c;
			 	    											
			 	    									    
			 	    										
			 	    										if(i==1){
			 	    											lastdateMOdified=initialObj.LastModifiedDate;
			 	    											lastmodifiedby=initialObj.LastModifiedBy.Name;
			 	    											
			 	    											
			 	    										}
			 	    										
			 	    										if(initialObj.LastModifiedDate!=null && lastdateMOdified<initialObj.LastModifiedDate){
			 	    											lastdateMOdified=initialObj.LastModifiedDate;	
			 	    										 	lastmodifiedby=initialObj.LastModifiedBy.Name;	
			 	    												
			 	    										}
			 	    										
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
															
															List<String> datesValue=new List<String>();
															datesValue.add(formattedDate);
															datesValue.add(lastmodifiedby);
															if(lastdateMOdified!=null)
															lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
															
															datesValue.add(lastmodifiedDateStr);
															
															String serviceStartDate='',ServiceEndDate='';
															
															if(ServiceSDate!=null)
																serviceStartDate=ServiceSDate.month()+'/'+ServiceSDate.day()+'/'+ServiceSDate.year();
															
															if(ServiceEDate!=null)
																ServiceEndDate=ServiceEDate.month()+'/'+ServiceEDate.day()+'/'+ServiceEDate.year();
															
															Opportunity oppVal= new Opportunity();
															oppVal.Name='';
															oppVal.Type='';
															oppVal.StageName='';
															
														wrapAccountpart wrapAccountpart1 = new wrapAccountpart('',bslanumber,assignedGeoContract);	
															
			 	    									wrapperAccountWise wrapAccountObj1 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,bulevel1,'Unadjusted Baseline',geoNumber,geoNumber25Digit,contractName,contractName25Digit,contractLineItemName,contractLineItemName25Digit,oppVal,'','',serviceStartDate,ServiceEndDate,'','',openAdminVersion,datesValue,unAdustedBaselineAmountList,costcenter,bulevel1,0,0,wrapAccountpart1);
			 	    									wrapperAccountWise wrapAccountObj2 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,bulevel1,'Adjusted Baseline',geoNumber,geoNumber25Digit,contractName,contractName25Digit,contractLineItemName,contractLineItemName25Digit,oppVal,'','',serviceStartDate,ServiceEndDate,'','',openAdminVersion,datesValue,adustedBaseLineAmountList,costcenter,bulevel1,0,0,wrapAccountpart1);
			 	    									wrapperAccountWiseList.add(wrapAccountObj1);
			 	    									wrapperAccountWiseList.add(wrapAccountObj2);
			 	    									//System.debug('>>costcenter....'+costcenter);
			 	    								}
			 	    								
			 	    							}
			 	    						}
			 	    					}
			 	    				}
			 	    		
			 	    		
			 	    		
			 	    		
			 	    	//	..................  
			 	    		if(revenueTypeVsOppIdSet.containsKey(revenueAccId)){
			 	    			for(Id oppId:revenueTypeVsOppIdSet.get(revenueAccId)){
			 	    				String OppName,OppName25Digit='',oppStage='',serviceStartdate='',serviceEnddate='',termsInMonth='',transitionDate='',assignedGeo='',OppRecordType='',OppBslaNumber='';
			 	    				Opportunity oppObj = new Opportunity();
			 	    				double tcvVal=0,SVRYR1Val=0;
			 	    				if(mapOppIdVsOppObj.containsKey(oppId)){
			 	    					OppName=mapOppIdVsOppObj.get(oppId).Name;
			 	    					oppStage=mapOppIdVsOppObj.get(oppId).StageName;
			 	    					oppObj=mapOppIdVsOppObj.get(oppId);
			 	    					
			 	    					Opportunity oppVal=mapOppIdVsOppObj.get(oppId);
			 	    					
			 	    					if((String) oppVal.get(oppRecordTypeAPI)!=null)
			 	    						OppRecordType=(String) oppVal.get(oppRecordTypeAPI);
			 	    						
			 	    					if(OppRecordType!=null && mapRecordIdVsName.containsKey(OppRecordType))
			 	    						OppRecordType=	mapRecordIdVsName.get(OppRecordType);
			 	    					
			 	    					if((String) oppVal.get(oppBslaAPI)!=null)
			 	    						OppBslaNumber=(String) oppVal.get(oppBslaAPI);
			 	    						
			 	    						
			 	    				    if(OppBslaNumber=='US')
			 	    				     	OppBslaNumber='10C363';		
			 	    					if(OppBslaNumber=='Canada')
			 	    				     	OppBslaNumber='203563';	
			 	    					
			 	    					if((Date) oppVal.get(serviceStartDateAPI)!=null){
				 	    					date oppServiceStartDate=(Date) oppVal.get(serviceStartDateAPI);
				 	    					serviceStartdate=oppServiceStartDate.month()+'/'+oppServiceStartDate.day()+'/'+oppServiceStartDate.year();
			 	    					}
			 	    					
			 	    					if((Date) oppVal.get(serviceEndDateAPI)!=null){
			 	    					 date	oppServiceEndDate=(Date) oppVal.get(serviceEndDateAPI);
			 	    						
			 	    						serviceEnddate=oppServiceEndDate.month()+'/'+oppServiceEndDate.day()+'/'+oppServiceEndDate.year();
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
			 	    				
			 	    				
			 	    				  // if((Id) oppVal.get(oppGeoLookupAPI)!=null)  Geo_Test__
			 	    					//	assignedGeo=(Id ) oppVal.get(oppGeoLookupAPI);	
			 	    				//	System.debug('>>>assisgnedGeoAPI.....'+assisgnedGeoAPI);
			 	    				//	System.debug('>>>oppVal.....'+oppVal);
			 	    					 	
			 	    					if(oppVal.getSObject(assisgnedGeoAPI)!=null && (String)oppVal.getSObject(assisgnedGeoAPI).get('Name')!=null)
										assignedGeo=(String)oppVal.getSObject(assisgnedGeoAPI).get('Name');
										
										if(assignedGeo!=null)
			 	    						assignedGeo=assignedGeo.replaceAll(',', '').trim();
										
			 	    					//System.debug('>>>assignedGeo.....'+assignedGeo);
			 	    				}
			 	    				OppName25Digit=reduceName(OppName);
			 	    				
			 	    				//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			 	    			//	System.debug('>>>oppId.....'+oppId); 	
			 	    			//	System.debug('>>>OppVsContractClosedWonIdSet.....'+OppVsContractClosedWonIdSet); 
			 	    				
			 	    				if(OppVsContractBaselineIdSet.containsKey(oppId)){
			 	    					for(Id contractId:OppVsContractBaselineIdSet.get(oppId)){
			 	    						String contractName='',contractName25Digit='',assignedGeoContract='',geoNameContract='',geonumContract='';
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
											  assignedGeoContract+=geoNameContract;
											  
											  
											  if(assignedGeoContract!=null)
			 	    						assignedGeoContract=assignedGeoContract.replaceAll(',', '').trim();
			 	    						
			 	    						contractName25Digit=reduceName(contractName);
			 	    						if(contractVsBaseLineconLineItemIdSet.containsKey(contractId+'#'+revenueStr)){
			 	    							for(Id conLineItemId:contractVsBaseLineconLineItemIdSet.get(contractId+'#'+revenueStr)){
			 	    								String contractLineItemName='',contractLineItemName25Digit='';
			 	    								
			 	    								if(mapContractLineItemIdVsName.containsKey(conLineItemId)){
			 	    									contractLineItemName=mapContractLineItemIdVsName.get(conLineItemId);
			 	    								}
			 	    								contractLineItemName25Digit=reduceName(contractLineItemName);
			 	    							//	System.debug('>>>conLineItemId.....'+conLineItemId); 	
			 	    								List<double> unAdustedBaselineAmountList = new List<double>();
													List<double> adustedBaseLineAmountList = new List<double>();

			 	    								double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
			 	    								double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
			 	    								String bulevel1='',bulevel2='';String costcenter='',businessUnit='';
			 	    								String lastmodifiedby='',lastmodifiedDateStr='',contractLineBSLA='';
													datetime lastdateMOdified,ServiceSDate,ServiceEDate;
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
															
															
															List<String> datesValue=new List<String>();
															datesValue.add(formattedDate);
															datesValue.add(lastmodifiedby);
															
														//	System.debug('>2>lastmodifiedDateStr....'+lastmodifiedDateStr);
															if(lastdateMOdified!=null )
																lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
															
															datesValue.add(lastmodifiedDateStr);
															
															
															String serviceStartSDate='',ServiceEndEDate='';
															
															if(ServiceSDate!=null)
																serviceStartSDate=ServiceSDate.month()+'/'+ServiceSDate.day()+'/'+ServiceSDate.year();
															
															if(ServiceEDate!=null)
																ServiceEndEDate=ServiceEDate.month()+'/'+ServiceEDate.day()+'/'+ServiceEDate.year();
															
														oppStage='';	
															
														wrapAccountpart wrapAccountpart12 = new wrapAccountpart(OppRecordType,contractLineBSLA,assignedGeoContract);
														
			 	    									wrapperAccountWise wrapAccountObj1 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,bulevel1,'Unadjusted Baseline',geoNumber,geoNumber25Digit,contractName,contractName25Digit,contractLineItemName,contractLineItemName25Digit,oppObj,OppName25Digit,oppStage,serviceStartSdate,serviceEndEdate,termsInMonth,transitionDate,openAdminVersion,datesValue,unAdustedBaselineAmountList,costcenter,bulevel1,tcvVal,SVRYR1Val,wrapAccountpart12);
			 	    									wrapperAccountWise wrapAccountObj2 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,bulevel1,'Adjusted Baseline',geoNumber,geoNumber25Digit,contractName,contractName25Digit,contractLineItemName,contractLineItemName25Digit,oppObj,OppName25Digit,oppStage,serviceStartSdate,serviceEndEdate,termsInMonth,transitionDate,openAdminVersion,datesValue,adustedBaseLineAmountList,costcenter,bulevel1,tcvVal,SVRYR1Val,wrapAccountpart12);
			 	    									wrapperAccountWiseList.add(wrapAccountObj1);
			 	    									wrapperAccountWiseList.add(wrapAccountObj2);
			 	    									//System.debug('>2>costcenter....'+costcenter);
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
			 	    						string contractName25Digit=reduceName(contractName);
			 	    				//		System.debug('>>>contractId.....'+contractId); 
			 	    						if(contractVsCloseWonconLineItemIdSet.containsKey(contractId+'#'+revenueStr)){
			 	    							for(Id conLineItemId:contractVsCloseWonconLineItemIdSet.get(contractId+'#'+revenueStr)){
			 	    								String contractLineItemName='';
			 	    								
			 	    								if(mapContractLineItemIdVsName.containsKey(conLineItemId)){
			 	    									contractLineItemName=mapContractLineItemIdVsName.get(conLineItemId);
			 	    								}
			 	    								string contractLineItemName25Digit=reduceName(contractLineItemName);
			 	    								List<double> unAdustedClosedWonAmountList = new List<double>();
													List<double> adustedClosedWonAmountList = new List<double>();
													String bulevel1='',bulevel2='';String costcenter='',businessUnit='';
			 	    								double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
			 	    								double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
			 	    							//	System.debug('>>>mapContractLineItemIdVsIntialForecastList.....'+mapContractLineItemIdVsIntialForecastList); 
			 	    							
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
															
															List<String> datesValue=new List<String>();
															datesValue.add(formattedDate);
															datesValue.add(lastmodifiedby);
															if(lastdateMOdified!=null)
															lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
															
															datesValue.add(lastmodifiedDateStr);
															oppStage='';
															
															wrapAccountpart wrapAccountpart3 = new wrapAccountpart(OppRecordType,contractLineBSLA,assignedGeo);	
															
			 	    									wrapperAccountWise wrapAccountObj3 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,buLevel1,'Unadjusted Closed Won',geoNumber,geoNumber25Digit,contractName,contractName25Digit,contractLineItemName,contractLineItemName25Digit,oppObj,OppName25Digit,oppStage,serviceStartdate,serviceEnddate,termsInMonth,transitionDate,openAdminVersion,datesValue,unAdustedClosedWonAmountList,costcenter,buLevel1,tcvVal,SVRYR1Val,wrapAccountpart3);
			 	    									wrapperAccountWise wrapAccountObj4 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,buLevel1,'Adjusted Closed Won',geoNumber,geoNumber25Digit,contractName,contractName25Digit,contractLineItemName,contractLineItemName25Digit,oppObj,OppName25Digit,oppStage,serviceStartdate,serviceEnddate,termsInMonth,transitionDate,openAdminVersion,datesValue,adustedClosedWonAmountList,costcenter,buLevel1,tcvVal,SVRYR1Val,wrapAccountpart3);
			 	    									wrapperAccountWiseList.add(wrapAccountObj3);
			 	    									wrapperAccountWiseList.add(wrapAccountObj4);
			 	    									//System.debug('>3>costcenter....'+costcenter);
			 	    								}
			 	    								
			 	    							}
			 	    						}
			 	    					}
			 	    				}
			 	    				// pipeline 
			 	    	//			System.debug('>>>>>>>pipeline>>>'+oppId);
			 	    				
			 	    		    if(mapOppIdVsOppLineItemList.containskey(oppId+'#'+revenueStr)){
			 	    				for(Id lineObj:mapOppIdVsOppLineItemList.get(oppId+'#'+revenueStr)){
			 	    				if(mapLineItemIdVsListProductModelPipeLine.containsKey(lineObj)){
			 	    					
			 	    						List<double> unAdustedPipelineAmountList = new List<double>();
											List<double> adustedPipeLineAmountList = new List<double>();

			 	    						double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
			 	    						double unAdjusted1=0,unAdjusted2=0,unAdjusted3=0,unAdjusted4=0,unAdjusted5=0,unAdjusted6=0,unAdjusted7=0,unAdjusted8=0,unAdjusted9=0,unAdjusted10=0,unAdjusted11=0,unAdjusted12=0,unAdjusted13=0,unAdjusted14=0,unAdjusted15=0,unAdjusted16=0,unAdjusted17=0,unAdjusted18=0,unAdjusted19=0,unAdjusted20=0,unAdjusted21=0,unAdjusted22=0,unAdjusted23=0,unAdjusted24=0;
			 	    						String costcenter='',businessUnit='',OfferingName='';	
			 	    						String lastmodifiedby='',lastmodifiedDateStr='';
											datetime lastdateMOdified;
											Integer i=0;

			 	    					    for(FCST_Product_Model__c productModel:mapLineItemIdVsListProductModelPipeLine.get(lineObj)){
			 	    								
			 	    								
			 	    								
			 	    							i++;
			 	    								if(productModel.Product__r.Name!=null)
			 	    									OfferingName=productModel.Product__r.Name;
			 	    											
													if(i==1){
														lastdateMOdified=productModel.LastModifiedDate;
														lastmodifiedby=productModel.LastModifiedBy.Name;
													}
													
													if(productModel.LastModifiedDate!=null && lastdateMOdified<productModel.LastModifiedDate){
														lastdateMOdified=productModel.LastModifiedDate;	
														lastmodifiedby=productModel.LastModifiedBy.Name;
														
															}
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
												
												List<String> datesValue=new List<String>();
												datesValue.add(formattedDate);
												datesValue.add(lastmodifiedby);
												
												if(lastdateMOdified!=null)
												lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
												
												datesValue.add(lastmodifiedDateStr);
										//System.debug('before>opp4>costcenter....'+costcenter); 
										//System.debug('before>opp4>businessUnit....'+businessUnit); 	
										wrapAccountpart  wrapAccountpart5 = new wrapAccountpart(OppRecordType,OppBslaNumber,assignedGeo);	
											
 	    									wrapperAccountWise wrapAccountObj5 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,'NA','Unadjusted Pipeline',geoNumber,geoNumber25Digit,'','','','',oppObj,OppName25Digit,OfferingName,serviceStartdate,serviceEnddate,termsInMonth,transitionDate,openAdminVersion,datesValue,unAdustedPipelineAmountList,costcenter,businessUnit,tcvVal,SVRYR1Val,wrapAccountpart5);
 	    									wrapperAccountWise wrapAccountObj6 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,'NA','Adjusted Pipeline',geoNumber,geoNumber25Digit,'','','','',oppObj,OppName25Digit,OfferingName,serviceStartdate,serviceEnddate,termsInMonth,transitionDate,openAdminVersion,datesValue,adustedPipeLineAmountList,costcenter,businessUnit,tcvVal,SVRYR1Val,wrapAccountpart5);
 	    									wrapperAccountWiseList.add(wrapAccountObj5);
 	    									wrapperAccountWiseList.add(wrapAccountObj6);
 	    									
 	    								//	System.debug('>opp4>costcenter....'+costcenter); 
										//System.debug('>opp4>businessUnit....'+businessUnit); 
									//	System.debug('>opp4>wrapAccountObj5....'+wrapAccountObj5); 
									//	System.debug('>opp4>wrapAccountObj6....'+wrapAccountObj6); 
			 	    				  }
			 	    				
			 	    			    }
			 	    		      }  
			 	    		      
			 	    		      //>>>>>>>>>>>>>>>>>>>funnel
			 	    		      if(mapOppAboveRevenueTypeVsOppLineItemList.containskey(oppId+'#'+revenueStr)){
			 	    				for(Id lineObj:mapOppAboveRevenueTypeVsOppLineItemList.get(oppId+'#'+revenueStr)){
			 	    				if(mapLineItemIdVsListProductModelFunnel.containsKey(lineObj)){
			 	    					
			 	    						List<double> unAdustedPipelineAmountList = new List<double>();
											List<double> adustedPipeLineAmountList = new List<double>();

			 	    						double ajusted1=0,ajusted2=0,ajusted3=0,ajusted4=0,ajusted5=0,ajusted6=0,ajusted7=0,ajusted8=0,ajusted9=0,ajusted10=0,ajusted11=0,ajusted12=0,ajusted13=0,ajusted14=0,ajusted15=0,ajusted16=0,ajusted17=0,ajusted18=0,ajusted19=0,ajusted20=0,ajusted21=0,ajusted22=0,ajusted23=0,ajusted24=0;
			 	    						String costcenter='',businessUnit='',OfferingName='';
			 	    						String lastmodifiedby='',lastmodifiedDateStr='';
											datetime lastdateMOdified;
											Integer i=0;
			 	    					    for(FCST_Product_Model__c productModel:mapLineItemIdVsListProductModelFunnel.get(lineObj)){
			 	    					    	
			 	    					    	     i++;
			 	    										
													if(i==1){
														lastdateMOdified=productModel.LastModifiedDate;
														lastmodifiedby=productModel.LastModifiedBy.Name;
													}
													
													if(productModel.Product__r.Name!=null)
			 	    									OfferingName=productModel.Product__r.Name;
			 	    									
													
													if(productModel.LastModifiedDate!=null && lastdateMOdified<productModel.LastModifiedDate){
														lastdateMOdified=productModel.LastModifiedDate;	
														lastmodifiedby=productModel.LastModifiedBy.Name;	
														
													}
			 	    								if((String)productModel.getSObject('Product__r').get(costCenterAPI)!=null)
														costcenter=(String)productModel.getSObject('Product__r').get(costCenterAPI);
														
													if((String)productModel.getSObject('Product__r').get(businessUnitAPI)!=null)
														businessUnit=(String)productModel.getSObject('Product__r').get(businessUnitAPI);
											
											
									
														
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
												
												List<String> datesValue=new List<String>();
												datesValue.add(formattedDate);
												datesValue.add(lastmodifiedby);
											if(lastdateMOdified!=null)	
												lastmodifiedDateStr=lastdateMOdified.month()+'/'+lastdateMOdified.day()+'/'+lastdateMOdified.year();
												
												datesValue.add(lastmodifiedDateStr);
											
											wrapAccountpart wrapAccountpart7 = new wrapAccountpart(OppRecordType,OppBslaNumber,assignedGeo);		
												
 	    									wrapperAccountWise wrapAccountObj7 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,revenueStr,'NA','Full Above the Funnel',geoNumber,geoNumber25Digit,'','','','',oppObj,OppName25Digit,OfferingName,serviceStartdate,serviceEnddate,termsInMonth,transitionDate,openAdminVersion,datesValue,adustedPipeLineAmountList,costcenter,businessUnit,tcvVal,SVRYR1Val,wrapAccountpart7);
 	    									wrapperAccountWiseList.add(wrapAccountObj7);
 	    							//		System.debug('>opp5>costcenter....'+costcenter); 
									//	System.debug('>opp5>businessUnit....'+businessUnit); 
			 	    				  }
			 	    				
			 	    			    }
			 	    		      }
			 	    		      
			 	    		      //sdasdsd
			 	    				
			 	    			}
			 	    		}
			 	    	}
			 	    } 
			 		else{
			 			List<Double> zeroamount =new List<Double>();
			 			for(Integer i=0;i<24;i++){
			 						zeroamount.add(0);
			 					}
			 					
			 					List<String> datesValue=new List<String>();
								datesValue.add(formattedDate);
								
								datesValue.add('');
								datesValue.add('');
								
								Opportunity oppval = new Opportunity();
								oppval.Name='';
								oppval.Type='';
								
								wrapAccountpart wrapAccountpart5 = new wrapAccountpart('','','');	
								
			 			wrapperAccountWise wrapAccountObj5 = new wrapperAccountWise(programName,programName25Digit,cpmRegion,cpmRegion25Digit,peName,peName25Digit,pmName,pmName25Digit,'No Revenue','NA','No Forecast',geoNumber,geoNumber25Digit,'','','','',oppval,'','','','','','',openAdminVersion,datesValue,zeroamount,'','',0,0,wrapAccountpart5);
			 	    	wrapperAccountWiseList.add(wrapAccountObj5);
			 		}
			 
			 	}
			 	
			 	
			 	
			 	
			 }
			 
			 
			 
	        
		}
		catch(Exception e) {
			ApexPages.Message apexMessage1 = new ApexPages.Message(ApexPages.Severity.Error, 'Error message :-'+ e.getMessage());
			ApexPages.Message apexMessage2 = new ApexPages.Message(ApexPages.Severity.Error, 'Error Line Number :-'+ e.getLineNumber());
			ApexPages.addMessage(apexMessage1);	
			ApexPages.addMessage(apexMessage2);	
			
			    System.debug('The following exception has occurred: ' + e.getMessage());
				System.debug('Line number: ' + e.getLineNumber()); 
			}
		
		
	}
	

    
    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
    
    public void callBatchClass(){
        FCST_Data_Extract_Batch_Download uca = new FCST_Data_Extract_Batch_Download(s_FilterPlanningYear,openAdminVersion);
        Database.executeBatch(uca,5);
    }
    
    public class wrapAccountpart{
    	public String oppRecordType{get;set;}
    	public String bslanumber{get;set;}
    	public String assignedGeo{get;set;}
    	
    	public wrapAccountpart(String oppRecordType,String bslanumber,String assignedGeo){
    		this.oppRecordType=oppRecordType;
    		this.bslanumber=bslanumber;
    		this.assignedGeo=assignedGeo;
    	}
    }
    
    	
    public class wrapperAccountWise{
	     
	    public String programName{get;set;}
	    public String cpmRegion{get;set;}
	    public String peName{get;set;}
	    public String pmName{get;set;}
	    public String revenueType{get;set;}
	    
	    public String buLevel1{get;set;}
	    public String forecastType{get;set;}
	    public String geoNumber{get;set;}
	    public String contractName{get;set;}
	    public String contractLineItemName{get;set;}
	    public String oppName{get;set;}
	    public String oppStage{get;set;}
	    
	    public String costcenter{get;set;}
	    public String businessUnit{get;set;}
	    
	    public String serviceStartdateVal{get;set;}
	    public String serviceEndDateval{get;set;}
	    public String transitionDateVal{get;set;}
	    public String termsInMonthVal{get;set;}
	    
	    public String programName25Digit{get;set;}
	    public String cpmRegion25Digit{get;set;}
	    public String peName25Digit{get;set;}
	    public String pmName25Digit{get;set;}
	    public String geoNumber25Digit{get;set;}
	    public String contractName25Digit{get;set;}
	    public String contractLineItemName25Digit{get;set;}
	    public String oppName25Digit{get;set;}
	    
	    public String selectedPV{get;set;}
	    public List<String> dateExtraction{get;set;}
	    public List<double> doubleAmount{get;set;}
	    
	    public double tcvAmout{get;set;}
	    public double SVRAmount{get;set;}
	    public wrapAccountpart wrapAccountObj{get;set;}
	    public Opportunity oppObj{get;set;}
	    
	    
	    
		
	    
	    
		public wrapperAccountWise(String programName,String programName25Digit,String cpmRegion,String cpmRegion25Digit,String peName,String peName25Digit,String pmName,String pmName25Digit,String revenueType,String buLevel1,String forecastType,String geoNumber,String geoNumber25Digit,String contractName,String contractName25Digit,String contractLineItemName,String contractLineItemName25Digit,Opportunity oppObj,String oppName25Digit,String oppStage,String serviceStartdateVal,String serviceEndDateval,String termsInMonthVal,String transitionDateVal,String selectedPV,List<String> dateExtraction,List<double> doubleAmount,String costcenter,String businessUnit,double tcvAmout,double SVRAmount,wrapAccountpart wrapAccountObj){
			this.programName=programName;
			this.cpmRegion=cpmRegion;
			this.peName=peName;
			this.pmName=pmName;
			this.revenueType=revenueType;
			this.buLevel1=buLevel1;
			this.forecastType=forecastType;
			this.geoNumber=geoNumber;
			this.contractName=contractName;
			this.contractLineItemName=contractLineItemName;
			this.oppName=oppName;
			
			this.serviceStartdateVal=serviceStartdateVal;
			this.serviceEndDateval=serviceEndDateval;
			this.transitionDateVal=transitionDateVal;
			this.termsInMonthVal=termsInMonthVal;
			
			this.costcenter=costcenter;
			this.businessUnit=businessUnit;
			
			
			this.selectedPV=selectedPV;
			this.dateExtraction=dateExtraction;
			this.doubleAmount=doubleAmount;
			this.oppStage=oppStage;
			
			this.programName25Digit=programName25Digit;
	    this.cpmRegion25Digit=cpmRegion25Digit;
	    this.peName25Digit=peName25Digit;
	    this.pmName25Digit=pmName25Digit;
	    this.geoNumber25Digit=geoNumber25Digit;
	    this.contractName25Digit=contractName25Digit;
	    this.contractLineItemName25Digit=contractLineItemName25Digit;
	    this.oppName25Digit=oppName25Digit;
	    
	    this.tcvAmout=tcvAmout;
	    this.SVRAmount=SVRAmount;
	    this.wrapAccountObj=wrapAccountObj;
	    this.oppObj=oppObj;   
	    }
	}
	
	

	 
}