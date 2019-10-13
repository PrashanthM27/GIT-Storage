//test class-Test_FCST_Data_Extract_Batch_Download
global class FCST_HyperLinkUpload_Batchs_Download implements Database.Batchable<sObject>,Database.Stateful {
	private String fromSelectedYear;
    private  string finalSuccessStr;	
    public String selectedYr{get;set;}
    
    public String stringHead{get;set;}
    
    public String dataRelatedUS{get;set;}
    public String dataRelatedCANADA{get;set;}
    public String dataRelatedOtherRevenue{get;set;}
    
    
    public String cpmRegionLabelName;
    public String BSLALabelName;
    public String oppGeoLabelName;
    public string costCenterAPI;
    
    
	global FCST_HyperLinkUpload_Batchs_Download(String selectedYear) {
		dataRelatedUS='';
		dataRelatedCANADA='';
		dataRelatedOtherRevenue='';
		fromSelectedYear=selectedYear;
		selectedYr=fromSelectedYear.right(2);
		
		Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
		cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
		BSLALabelName = mapCustomObj.FCST_BSLA__c;
		costCenterAPI=mapCustomObj.Cost_Center__c;
		oppGeoLabelName=mapCustomObj.Geo__c;
		
		//string fileHearder= ',BSLA ,Cost Center + Cost Center Description,Geo# + Geo Name,Revenue Type,Jan FY-'+selectedYr+' ,Feb FY-'+selectedYr+' ,Mar FY-'+selectedYr+' ,Apr FY-'+selectedYr+',May FY-'+selectedYr+' ,Jun FY-'+selectedYr+' ,Jul FY-'+selectedYr+' ,Aug FY-'+selectedYr+' ,Sep FY-'+selectedYr+' ,Oct FY-'+selectedYr+',Nov FY-'+selectedYr+' ,Dec FY-'+selectedYr+' \n';
        
		
		
		
		 stringHead=',,,,,,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast \n';
		stringHead+=',,,,,,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer\n';
		stringHead+=',,,,,,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version \n';
		
		string fileHearder= ',, ,,,, FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+', FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+', FY'+selectedYr+' , FY'+selectedYr+' \n';
		fileHearder+=',, ,,,,Jan  ,Feb ,Mar  ,Apr,May,Jun ,Jul ,Aug  ,Sep,Oct ,Nov ,Dec \n';
		stringHead+=fileHearder;
         
         
        
		
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
	
	 //   String accName='Account for Test 06';
	    return Database.getQueryLocator('select Id,Name from Account where   '+cpmRegionLabelName+'!=null  order by Name '  );
	  
    }
    
    	public String revenueTypeGetValue(FCST_Product_Model__c modelObj ) {
        String str='';
        if(modelObj.FCST_Revenue_Types__c!=null)
        	str=modelObj.FCST_Revenue_Types__c;
        
        if(modelObj.FCST_Revenue_Types__c=='Annuity' && modelObj.Opportunity_Stage_Type__c=='Open')
        	str='ITO Annuity Unsold Identified';	
        	
        else If(modelObj.FCST_Revenue_Types__c=='Project' && modelObj.Opportunity_Stage_Type__c=='Open')
        	str='ITO Project Unsold Identified';
        
        else If(modelObj.FCST_Revenue_Types__c=='Project' && modelObj.Opportunity_Stage_Type__c=='Above the Funnel')
        	str='ITO Project Unsold Unidentified';
        	
        else If(modelObj.FCST_Revenue_Types__c=='Annuity' && modelObj.Opportunity_Stage_Type__c=='Above the Funnel')
        	str='ITO Annuity Unsold Unidentified';
        	
        else If(modelObj.FCST_Revenue_Types__c=='Prod - Commodity' )
        	str='Gross Sales - Commodity Hardware';
        
        else If(modelObj.FCST_Revenue_Types__c=='Prod - Enterprise' )
        	str='Gross Sales - Enterprise Hardware';
        
        
        
        
        else IF(modelObj.FCST_Revenue_Types__c=='eXcell' &&  modelObj.Opportunity_Stage_Type__c=='Open' && modelObj.Opportunity_Type__c=='Annuity')
		str='ITO Annuity Unsold Identified';
		
		else IF(modelObj.FCST_Revenue_Types__c=='eXcell' && modelObj.Opportunity_Stage_Type__c== 'Above the Funnel' && modelObj.Opportunity_Type__c=='Annuity')
		str='ITO Annuity Unsold Unidentified';
		
		
		else IF(modelObj.FCST_Revenue_Types__c=='eXcell' && modelObj.Opportunity_Stage_Type__c== 'Open' && modelObj.Opportunity_Type__c=='Project')
		str='ITO Project Unsold Identified';
		
		else IF(modelObj.FCST_Revenue_Types__c=='eXcell' && modelObj.Opportunity_Stage_Type__c=='Above the Funnel'   && modelObj.Opportunity_Type__c=='Project')
		str='ITO Project Unsold Unidentified';
		
		else IF(modelObj.FCST_Revenue_Types__c=='eXcell' && modelObj.Opportunity_Stage_Type__c=='Closed Won' && modelObj.Opportunity_Type__c=='Annuity')
		str='ITO Annuity Revenue';
		
		
		else IF(modelObj.FCST_Revenue_Types__c=='eXcell' && modelObj.Opportunity_Stage_Type__c== 'Closed Won' && modelObj.Opportunity_Type__c=='Project')
		str='ITO Project Revenue';

		
		

        
        
        return str;    
    }
    
     global void execute(Database.BatchableContext bc, List<Account> accList){
     	
     	try{
     		
     		String openAdminVersion;
			set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
			List<Planning_Version__c> pvlist=[select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
			if(pvlist!=null && pvlist.size()>0)
				openAdminVersion=pvlist[0].Name;
				
			
			
	        String likeStr='FY'+fromSelectedYear+'%';
	        String intialForecastQuery ='Select Account__r.Name,FCST_Contract__c,Contract_LineItem__r.Hyperion_Revenue_Type__c,Contract_LineItem__r.BSLA_Number__c,Id,Fiscal_Period__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Forecast_with_Risk__c ,Contract_LineItem__r.Id,Contract_LineItem__r.Name,Contract_LineItem__r.Geo_Geo_Name__c,Contract_LineItem__r.Cost_Center__c,Contract_LineItem__r.Cost_Center_Description__c,Contract_LineItem__r.Fcst_Revenue_Type__c,Contract_LineItem__r.BSLA__c    from FCST_Initial_Forecast__c where FCST_Fiscal_Year_List__r.Name=:fromSelectedYear and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Planning_Version__r.Name=:openAdminVersion and Account__c IN:accList order by Account__c,FCST_Contract__c ';
	    
	    
     		List<FCST_Initial_Forecast__c> contractIntialForecastList=database.query(intialForecastQuery); 
     		 
     		String oppStageWon='Closed Won',oppStageCloseLost='Closed Lost',abovefunnel='Lead (Above the Funnel)';
     		
     		String openModelQuery ='Select User_Adjusted_Revenue__c,Opportunity_Stage_Type__c,Opportunity_Type__c ,Weighted_Revenue__c,Fiscal_Period__r.Month_Number__c,Account__r.Name,Hyperion_Revenue_Type__c,Opportunity__r.'+BSLALabelName+',Product__r.'+costCenterAPI+',Opportunity__c,FCST_Revenue_Types__c from FCST_Product_Model__c where Fiscal_Period__r.Name LIKE :likeStr and Planning_Version__r.Name=:openAdminVersion and Opportunity__r.StageName!=:oppStageCloseLost  and Opportunity__r.StageName!=:oppStageWon  and  Account__c IN:accList order by Account__c ';
     		List<FCST_Product_Model__c> forecastModelList=database.query(openModelQuery);
     		
     		
     		String oppGeoAPI=oppGeoLabelName.removeEnd('c')+'r';
     		String oppQueryString='Select Id,Name,'+oppGeoAPI+'.Name from Opportunity where AccountId IN:accList';
     		
     		List<Opportunity> oppList =database.query(oppQueryString);
     		Map<Id,String> oppIdvsGeoName = new Map<Id,String>();
     		
     		if(oppList!=null && oppList.size()>0){
     			
     			for(Opportunity oppObj:oppList){
     				String geoNumber='';
     				if(oppObj.getSObject(oppGeoAPI)!=null && (String)oppObj.getSObject(oppGeoAPI).get('Name')!=null)
						geoNumber=(String)oppObj.getSObject(oppGeoAPI).get('Name');
					
					if(geoNumber!=null)
					oppIdvsGeoName.put(oppObj.Id,geoNumber);	
     				
     			}
     			
     		}
     		
     		
     		
     		Map<String,List<FCST_Initial_Forecast__c>> mapUniqueStringVsInitialForecastList =new Map<String,List<FCST_Initial_Forecast__c>>();
			
			if(contractIntialForecastList!=null && contractIntialForecastList.size()>0){
	    		for(FCST_Initial_Forecast__c conIntialForecastObj:contractIntialForecastList){
	    			if(mapUniqueStringVsInitialForecastList.containsKey(conIntialForecastObj.Contract_LineItem__r.BSLA_Number__c+'#'+conIntialForecastObj.Contract_LineItem__r.Cost_Center__c+'#'+conIntialForecastObj.Contract_LineItem__r.Geo_Geo_Name__c+'#'+conIntialForecastObj.Contract_LineItem__r.Hyperion_Revenue_Type__c)){
	    				List<FCST_Initial_Forecast__c> existingModel=mapUniqueStringVsInitialForecastList.get(conIntialForecastObj.Contract_LineItem__r.BSLA_Number__c+'#'+conIntialForecastObj.Contract_LineItem__r.Cost_Center__c+'#'+conIntialForecastObj.Contract_LineItem__r.Geo_Geo_Name__c+'#'+conIntialForecastObj.Contract_LineItem__r.Hyperion_Revenue_Type__c);
	    				existingModel.add(conIntialForecastObj);
	    				mapUniqueStringVsInitialForecastList.put(conIntialForecastObj.Contract_LineItem__r.BSLA_Number__c+'#'+conIntialForecastObj.Contract_LineItem__r.Cost_Center__c+'#'+conIntialForecastObj.Contract_LineItem__r.Geo_Geo_Name__c+'#'+conIntialForecastObj.Contract_LineItem__r.Hyperion_Revenue_Type__c,existingModel);
	    			}
	    			else{
	    				List<FCST_Initial_Forecast__c> newModelList = new List<FCST_Initial_Forecast__c>();
	    				newModelList.add(conIntialForecastObj);
	    				mapUniqueStringVsInitialForecastList.put(conIntialForecastObj.Contract_LineItem__r.BSLA_Number__c+'#'+conIntialForecastObj.Contract_LineItem__r.Cost_Center__c+'#'+conIntialForecastObj.Contract_LineItem__r.Geo_Geo_Name__c+'#'+conIntialForecastObj.Contract_LineItem__r.Hyperion_Revenue_Type__c,newModelList);
	    			}
	    		}
	    	}
	    	
	    	System.debug('...mapUniqueStringVsInitialForecastList.....'+mapUniqueStringVsInitialForecastList);
	    	Map<String,List<FCST_Product_Model__c>> mapUniqueStringVsProductForecastList =new Map<String,List<FCST_Product_Model__c>>();
			Set<String> costCenterNameSet = new Set<String>();
			if(forecastModelList!=null && forecastModelList.size()>0){
				
	    		for(FCST_Product_Model__c forecastObj:forecastModelList){
	    			String costcenter='',BSLANumber='',GeoNumber='';
	    			if(forecastObj.getSObject('Product__r')!=null && (String)forecastObj.getSObject('Product__r').get(costCenterAPI)!=null)
						costcenter=(String)forecastObj.getSObject('Product__r').get(costCenterAPI);
					
					costCenterNameSet.add(costcenter);
					
					if(forecastObj.getSObject('Opportunity__r')!=null && (String)forecastObj.getSObject('Opportunity__r').get(BSLALabelName)!=null)
						BSLANumber=(String)forecastObj.getSObject('Opportunity__r').get(BSLALabelName);
					
					if(oppIdvsGeoName.ContainsKey(forecastObj.Opportunity__c)){
						GeoNumber=oppIdvsGeoName.get(forecastObj.Opportunity__c);
					
					}	
					String revenueType='';
					if(forecastObj.FCST_Revenue_Types__c!=null)
					 revenueType=revenueTypeGetValue(forecastObj);
							
	    			if(mapUniqueStringVsProductForecastList.containsKey(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+revenueType)){
	    				List<FCST_Product_Model__c> existingModel=mapUniqueStringVsProductForecastList.get(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+revenueType);
	    				existingModel.add(forecastObj);
	    				mapUniqueStringVsProductForecastList.put(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+revenueType,existingModel);
	    			}
	    			else{
	    				List<FCST_Product_Model__c> newModelList = new List<FCST_Product_Model__c>();
	    				newModelList.add(forecastObj);
	    				mapUniqueStringVsProductForecastList.put(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+revenueType,newModelList);
	    			}
	    		}
	    	}
	    	
	    	System.debug('...mapUniqueStringVsProductForecastList.....'+mapUniqueStringVsProductForecastList); 
	    	List<Fcst_Cost_Center__c>	costCenterList=[Select Id,Name,Cost_Center_Description__c from Fcst_Cost_Center__c where Name IN:costCenterNameSet];
	    	Map<String,String> mapCostCenterNumberVsCostDescription =new Map<String,String>();
	    	
	    	if(costCenterList!=null && costCenterList.size()>0){
	    		for(Fcst_Cost_Center__c cosObj:costCenterList){
	    			if(cosObj.Cost_Center_Description__c!=null)
	    			mapCostCenterNumberVsCostDescription.put(cosObj.Name,cosObj.Cost_Center_Description__c);
	    		}
	    	}
	    	
	    	
	    	
	    	  for(String contractLineId:mapUniqueStringVsInitialForecastList.keyset())	{
			  	if(mapUniqueStringVsInitialForecastList.containsKey(contractLineId)){
					List<double> amountList = new List<double>();
					double m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0,Mtotal=0;
					FCST_Initial_Forecast__c fcstObj;
					for(FCST_Initial_Forecast__c initialObj:mapUniqueStringVsInitialForecastList.get(contractLineId)){
						fcstObj=initialObj;
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1){
							m1+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2){
							m2+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3){
							m3+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4){
							m4+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5){
							m5+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6){
							m6+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7){
							m7+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8){
							m8+=initialObj.Forecast_with_Risk__c;
						}
						
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9){
							m9+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10){
							m10+=initialObj.Forecast_with_Risk__c;
						}
						
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11){
							m11+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12){
							m12+=initialObj.Forecast_with_Risk__c;
						}
						
					}
					m1=math.round(m1);
					m2=math.round(m2);
					m3=math.round(m3);
					m4=math.round(m4);
					m5=math.round(m5);
					m6=math.round(m6);
					m7=math.round(m7);
					m8=math.round(m8);
					m9=math.round(m9);
					m10=math.round(m10);
					m11=math.round(m11);
					m12=math.round(m12);
					
					if(m1==null)
						m1=0;
					if(m2==null)
						m2=0;
				    if(m3==null)
						m3=0;
					if(m4==null)
						m4=0;
				    if(m5==null)
						m5=0;
					if(m6==null)
						m6=0;
				    if(m7==null)
						m7=0;
					if(m8==null)
						m8=0;
					if(m9==null)
						m9=0;
					if(m10==null)
						m10=0;
				    if(m11==null)
						m11=0;
					if(m12==null)
						m12=0;
						
					if(fcstObj.Contract_LineItem__r.Cost_Center__c==null)	
						fcstObj.Contract_LineItem__r.Cost_Center__c='';
						
				    if(fcstObj.Contract_LineItem__r.Cost_Center_Description__c==null)	
						fcstObj.Contract_LineItem__r.Cost_Center_Description__c='';
						
					if(fcstObj.Contract_LineItem__r.Fcst_Revenue_Type__c==null)	
						fcstObj.Contract_LineItem__r.Fcst_Revenue_Type__c='';
						
					if(fcstObj.Contract_LineItem__r.BSLA__c==null)	
						fcstObj.Contract_LineItem__r.BSLA__c='';	
					
					String bsla='';
					 bsla=fcstObj.Contract_LineItem__r.BSLA_Number__c;
					bsla=bsla.replaceAll(',', '').trim();
					
					String costcenter='';
					 costcenter=fcstObj.Contract_LineItem__r.Cost_Center__c;
					costcenter=costcenter.replaceAll(',', '').trim();
					
					String costcenterDescription='';
					 costcenterDescription=fcstObj.Contract_LineItem__r.Cost_Center_Description__c;
					costcenterDescription=costcenterDescription.replaceAll(',', '').trim();
					
					String geoName=fcstObj.Contract_LineItem__r.Geo_Geo_Name__c;
					if(geoName!=null)
						geoName=geoName.replaceAll(',', '').trim();
					else{
						geoName='';
					}
					
					String revenueType='',AccountName='';
					 revenueType=fcstObj.Contract_LineItem__r.Hyperion_Revenue_Type__c;
					revenueType=revenueType.replaceAll(',', '').trim();
					
					if(fcstObj.Account__r.Name!=null)
						AccountName=fcstObj.Account__r.Name;
						
					if(AccountName!=null)
						AccountName=AccountName.replaceAll(',', '').trim();
					
					
					if(revenueType!='Gross Sales-Enterprise Hardware' && revenueType!='Gross Sales-Commodity Hardware'  && revenueType!='ITO Annuity Revenue' && revenueType!='ITO Project Revenue'){
						dataRelatedOtherRevenue+=AccountName+',USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
	
					}
					else if(bsla=='203563'){
						dataRelatedCANADA+=AccountName+',USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
	
					}
					else if(bsla=='10C363'){
						dataRelatedUS+=AccountName+',USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
	
					}
					
			    }
			  
			 }
			 //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	     	  for(String mapKey:mapUniqueStringVsProductForecastList.keyset())	{
				  	if(mapUniqueStringVsProductForecastList.containsKey(mapKey)){
						List<double> amountList = new List<double>();
						double m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0,Mtotal=0;
						FCST_Product_Model__c fcstObj;
						for(FCST_Product_Model__c forecastObj:mapUniqueStringVsProductForecastList.get(mapKey)){
							fcstObj=forecastObj;
							if(forecastObj.Fiscal_Period__r.Month_Number__c==1){
								m1+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==2){
								m2+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==3){
								m3+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==4){
								m4+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==5){
								m5+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==6){
								m6+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==7){
								m7+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==8){
								m8+=forecastObj.User_Adjusted_Revenue__c;
							}
							
							if(forecastObj.Fiscal_Period__r.Month_Number__c==9){
								m9+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==10){
								m10+=forecastObj.User_Adjusted_Revenue__c;
							}
							
							if(forecastObj.Fiscal_Period__r.Month_Number__c==11){
								m11+=forecastObj.User_Adjusted_Revenue__c;
							}
							if(forecastObj.Fiscal_Period__r.Month_Number__c==12){
								m12+=forecastObj.User_Adjusted_Revenue__c;
							}
							
						}
						m1=math.round(m1);
						m2=math.round(m2);
						m3=math.round(m3);
						m4=math.round(m4);
						m5=math.round(m5);
						m6=math.round(m6);
						m7=math.round(m7);
						m8=math.round(m8);
						m9=math.round(m9);
						m10=math.round(m10);
						m11=math.round(m11);
						m12=math.round(m12);
						
						if(m1==null)
							m1=0;
						if(m2==null)
							m2=0;
					    if(m3==null)
							m3=0;
						if(m4==null)
							m4=0;
					    if(m5==null)
							m5=0;
						if(m6==null)
							m6=0;
					    if(m7==null)
							m7=0;
						if(m8==null)
							m8=0;
						if(m9==null)
							m9=0;
						if(m10==null)
							m10=0;
					    if(m11==null)
							m11=0;
						if(m12==null)
							m12=0;
					
					
					
					
					String costcenterDescription='',bsla='',costcenter='',geoName='',revenueType='',AccountName='';		
					
					if(fcstObj.getSObject('Opportunity__r')!=null && (String)fcstObj.getSObject('Opportunity__r').get(BSLALabelName)!=null)
						bsla=(String)fcstObj.getSObject('Opportunity__r').get(BSLALabelName);
					
					if(fcstObj.getSObject('Product__r')!=null && (String)fcstObj.getSObject('Product__r').get(costCenterAPI)!=null)
						costcenter=(String)fcstObj.getSObject('Product__r').get(costCenterAPI);
					
					if(fcstObj!=null)
						revenueType= revenueTypeGetValue(fcstObj);	
					
					
					if(mapCostCenterNumberVsCostDescription.containsKey(costcenter))
						costcenterDescription=mapCostCenterNumberVsCostDescription.get(costcenter);	
						
					if(oppIdvsGeoName.ContainsKey(fcstObj.Opportunity__c)){
						geoName=oppIdvsGeoName.get(fcstObj.Opportunity__c);
					}	
					
					if(costcenterDescription!=null)	
					    costcenterDescription=costcenterDescription.replaceAll(',', '').trim();
					
					if(bsla!=null)	
					    bsla=bsla.replaceAll(',', '').trim();
					
					if(costcenter!=null)	
					    costcenter=costcenter.replaceAll(',', '').trim();
					
					if(geoName!=null)	
					    geoName=geoName.replaceAll(',', '').trim();
					    
					if(revenueType!=null)	
					    revenueType=revenueType.replaceAll(',', '').trim();    
					    
					    
					 if(fcstObj.Account__r.Name!=null)	   
					    AccountName=fcstObj.Account__r.Name;
					    
					if(AccountName!=null)	
					    AccountName=AccountName.replaceAll(',', '').trim();    
					    	
						if(revenueType!='ITO Annuity Unsold Identified' && revenueType!='ITO Project Unsold Identified' && revenueType!='ITO Project Unsold Unidentified' && revenueType!='ITO Annuity Unsold Unidentified' && revenueType!='Gross Sales - Commodity Hardware' && revenueType!='Gross Sales - Enterprise Hardware' && revenueType!='Gross Sales-Enterprise Hardware' && revenueType!='Gross Sales-Commodity Hardware'  && revenueType!='ITO Annuity Revenue' && revenueType!='ITO Project Revenue'){
							 if(bsla=='Canada' || bsla=='203563'){
								bsla='203563';
							 }
							else if(bsla=='US' || bsla=='10C363'){ 
								bsla='10C363';
							}	
							dataRelatedOtherRevenue+=AccountName+',USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
		
						}
						else if(bsla=='Canada' || bsla=='203563'){
							bsla='203563';
							dataRelatedCANADA+=AccountName+',USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
		
						}
						else if(bsla=='US' || bsla=='10C363'){ 
								bsla='10C363';
							dataRelatedUS+=AccountName+',USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
		
						}
						
				    }
			  
			 }
			 
			 
			 
			 //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     		
		   }
	       catch(Exception e) {
	            System.debug('Exception Message '+e);
	            System.debug('Exception Line Number: '+e.getLineNumber());
	        }
     }
     
     global void finish(Database.BatchableContext bc){
     	
        String loginUserEmail=UserInfo.getUserEmail();
        
        Messaging.EmailFileAttachment csvAttachment1 = new Messaging.EmailFileAttachment();
        Blob csvBlob1 = blob.valueOf(stringHead+dataRelatedUS);
	    String csvSuccessName1 = 'Hyoreport_US_'+fromSelectedYear+'.csv';
	    csvAttachment1.setFileName(csvSuccessName1);
	    csvAttachment1.setBody(csvBlob1);
	    
	    Messaging.EmailFileAttachment csvAttachment2 = new Messaging.EmailFileAttachment();
        Blob csvBlob2 = blob.valueOf(stringHead+dataRelatedCANADA);
	    String csvSuccessName2 = 'Hyoreport_Canada_'+fromSelectedYear+'.csv';
	    csvAttachment2.setFileName(csvSuccessName2);
	    csvAttachment2.setBody(csvBlob2);
	    
	    Messaging.EmailFileAttachment csvAttachment3 = new Messaging.EmailFileAttachment();
        Blob csvBlob3 = blob.valueOf(stringHead+dataRelatedOtherRevenue);
	    String csvSuccessName3 = 'Hyoreport_Other_Revenue_'+fromSelectedYear+'.csv';
	    csvAttachment3.setFileName(csvSuccessName3);
	    csvAttachment3.setBody(csvBlob3);
	    
	    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[]{loginUserEmail};
	    String subject = 'Hyperion upload Data for year '+fromSelectedYear ;
	    email.setSubject(subject);
	    email.setToAddresses(toAddresses);
	    email.setPlainTextBody('All forecast data for cost center and geo');
	    
	    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
	      
	   // email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment1,csvAttachment2,csvAttachment3});
	   if(dataRelatedUS!=null && dataRelatedUS!='')
	    	fileAttachments.add(csvAttachment1);
	     
	    if(dataRelatedCANADA!=null && dataRelatedCANADA!='')
	    fileAttachments.add(csvAttachment2);
	    
	    if(dataRelatedOtherRevenue!=null && dataRelatedOtherRevenue!='')
	    fileAttachments.add(csvAttachment3);
	    
	     email.setFileAttachments(fileAttachments);
	    
	    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
     }    
}