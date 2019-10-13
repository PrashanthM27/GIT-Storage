public with sharing class FCST_HyperLinkUpload_Controller {
	
	public List<wrapperContractLineItem> wrapperContractLineItemList{get; set;}    
	public string s_FilterPlanningYear{get;set;}
	public String selectedYr{get;set;}
	String openAdminVersion{get;set;}
	
	 public String cpmRegionLabelName;
    public String BSLALabelName;
    public String oppGeoLabelName;
    public string costCenterAPI;
	
	
	public FCST_HyperLinkUpload_Controller(){
		
		getFilterPlanningYear();
		
		set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
		List<Planning_Version__c> pvlist=[select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
		if(pvlist!=null && pvlist.size()>0)
			openAdminVersion=pvlist[0].Name;
			
	   Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
		cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
		BSLALabelName = mapCustomObj.FCST_BSLA__c;
		costCenterAPI=mapCustomObj.Cost_Center__c;
		oppGeoLabelName=mapCustomObj.Geo__c;
			
	   updateWrapperList();
		
	}
	
	public void onChangeYear() {
        updateWrapperList();     
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
        	
        else If(modelObj.FCST_Revenue_Types__c=='Prod - Commodity' && modelObj.Opportunity_Stage_Type__c=='Open')
        	str='Gross Sales - Commodity Hardware';
        
        else If(modelObj.FCST_Revenue_Types__c=='Prod - Enterprise' && modelObj.Opportunity_Stage_Type__c=='Open')
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
    
    	
	public void updateWrapperList(){
		//try {
			selectedYr=s_FilterPlanningYear.right(2);
			String likeStr='FY'+s_FilterPlanningYear+'%';
			
			//String accName='Acccount AAAAAAAA!!!!!!!!!!!';
			
			String intialForecastQuery='Select Account__r.Name,Contract_LineItem__r.Hyperion_Revenue_Type__c	,Contract_LineItem__r.BSLA_Number__c,Id,Fiscal_Period__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Forecast_with_Risk__c ,Contract_LineItem__r.Id,Contract_LineItem__r.Name,Contract_LineItem__r.Geo_Geo_Name__c,Contract_LineItem__r.Cost_Center__c,Contract_LineItem__r.Cost_Center_Description__c,Contract_LineItem__r.Fcst_Revenue_Type__c,Contract_LineItem__r.BSLA__c    from FCST_Initial_Forecast__c where FCST_Fiscal_Year_List__r.Name=:s_FilterPlanningYear and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Planning_Version__r.Name=:openAdminVersion   order by Account__r.Name LIMIT 5000';
		    List<FCST_Initial_Forecast__c> contractIntialForecastList=database.query(intialForecastQuery); 
			
			String oppStageWon='Closed Won',oppStageCloseLost='Closed Lost',abovefunnel='Lead (Above the Funnel)';
			String openModelQuery ='Select Opportunity_Stage_Type__c,Opportunity_Type__c ,User_Adjusted_Revenue__c,Weighted_Revenue__c,Fiscal_Period__r.Month_Number__c,Account__r.Name,Hyperion_Revenue_Type__c,Opportunity__r.'+BSLALabelName+',Product__r.'+costCenterAPI+',Opportunity__c,FCST_Revenue_Types__c from FCST_Product_Model__c where Fiscal_Period__r.Name LIKE :likeStr and Planning_Version__r.Name=:openAdminVersion and Opportunity__r.StageName!=:oppStageCloseLost  and Opportunity__r.StageName!=:oppStageWon   order by Account__r.Name  LIMIT 5000';
     		List<FCST_Product_Model__c> forecastModelList=database.query(openModelQuery);
     		
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
			Set<String> costCenterNameSet = new Set<String>();
			Set<Id> oppIdSet = new Set<Id>();
			if(forecastModelList!=null && forecastModelList.size()>0){
				
	    		for(FCST_Product_Model__c fcst:forecastModelList){
	    			oppIdSet.add(fcst.Opportunity__c);
	    		}
	    		
	    		
			}
			
		   String oppGeoAPI=oppGeoLabelName.removeEnd('c')+'r';
     		String oppQueryString='Select Id,Name,'+oppGeoAPI+'.Name from Opportunity where Id IN:oppIdSet';
     		
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
	    	 
	    	List<Fcst_Cost_Center__c>	costCenterList=[Select Id,Name,Cost_Center_Description__c from Fcst_Cost_Center__c where Name IN:costCenterNameSet];
	    	Map<String,String> mapCostCenterNumberVsCostDescription =new Map<String,String>();
	    	
	    	if(costCenterList!=null && costCenterList.size()>0){
	    		for(Fcst_Cost_Center__c cosObj:costCenterList){
	    			if(cosObj.Cost_Center_Description__c!=null)
	    			mapCostCenterNumberVsCostDescription.put(cosObj.Name,cosObj.Cost_Center_Description__c);
	    		}
	    	}
     		
     		Map<String,List<FCST_Product_Model__c>> mapUniqueStringVsProductForecastList =new Map<String,List<FCST_Product_Model__c>>();
			
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
							
	    			if(mapUniqueStringVsProductForecastList.containsKey(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+forecastObj.FCST_Revenue_Types__c)){
	    				List<FCST_Product_Model__c> existingModel=mapUniqueStringVsProductForecastList.get(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+forecastObj.FCST_Revenue_Types__c);
	    				existingModel.add(forecastObj);
	    				mapUniqueStringVsProductForecastList.put(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+forecastObj.FCST_Revenue_Types__c,existingModel);
	    			}
	    			else{
	    				List<FCST_Product_Model__c> newModelList = new List<FCST_Product_Model__c>();
	    				newModelList.add(forecastObj);
	    				mapUniqueStringVsProductForecastList.put(BSLANumber+'#'+costcenter+'#'+GeoNumber+'#'+forecastObj.FCST_Revenue_Types__c,newModelList);
	    			}
	    		}
	    	}
	    	
	    	
	    	
		   
		   	
			wrapperContractLineItemList =new List<wrapperContractLineItem>();
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
					amountList.add(m1);
					amountList.add(m2);
					amountList.add(m3);
					amountList.add(m4);
					amountList.add(m5);
					amountList.add(m6);
					amountList.add(m7);
					amountList.add(m8);
					amountList.add(m9);
					amountList.add(m10);
					amountList.add(m11);
					amountList.add(m12);
					
					
					wrapperContractLineItem wrapObj = new wrapperContractLineItem(fcstObj.Account__r.Name,'USD',fcstObj.Contract_LineItem__r.BSLA_Number__c+' CompuCom Systems Inc',fcstObj.Contract_LineItem__r.Cost_Center__c+' '+fcstObj.Contract_LineItem__r.Cost_Center_Description__c,fcstObj.Contract_LineItem__r.Geo_Geo_Name__c,fcstObj.Contract_LineItem__r.Hyperion_Revenue_Type__c ,amountList);
					wrapperContractLineItemList.add(wrapObj);
			    }
			  
			 }
			 System.debug('...mapUniqueStringVsProductForecastList...'+mapUniqueStringVsProductForecastList);
			 	     	  for(String mapKey:mapUniqueStringVsProductForecastList.keyset())	{
			 	     	  	 System.debug('...mapKey...'+mapKey);
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
					
					amountList.add(m1);
					amountList.add(m2);
					amountList.add(m3);
					amountList.add(m4);
					amountList.add(m5);
					amountList.add(m6);
					amountList.add(m7);
					amountList.add(m8);
					amountList.add(m9);
					amountList.add(m10);
					amountList.add(m11);
					amountList.add(m12);
					
					
					String costcenterDescription='',bsla='',costcenter='',geoName='',revenueType='',AccountName='';		
					
					if(fcstObj.getSObject('Opportunity__r')!=null && (String)fcstObj.getSObject('Opportunity__r').get(BSLALabelName)!=null)
						bsla=(String)fcstObj.getSObject('Opportunity__r').get(BSLALabelName);
					
					if(fcstObj.getSObject('Product__r')!=null && (String)fcstObj.getSObject('Product__r').get(costCenterAPI)!=null)
						costcenter=(String)fcstObj.getSObject('Product__r').get(costCenterAPI);
					
					
					If(fcstObj!=null)
					revenueType= revenueTypeGetValue(fcstObj);	
					
					
						
					if(mapCostCenterNumberVsCostDescription.containsKey(costcenter))
						costcenterDescription=mapCostCenterNumberVsCostDescription.get(costcenter);	
						
					if(oppIdvsGeoName.ContainsKey(fcstObj.Opportunity__c)){
						geoName=oppIdvsGeoName.get(fcstObj.Opportunity__c);
					}	
					
					
					    
					 if(fcstObj.Account__r.Name!=null)	   
					    AccountName=fcstObj.Account__r.Name;
					    
					 	
				wrapperContractLineItem wrapObj = new wrapperContractLineItem(fcstObj.Account__r.Name,'USD',bsla+' CompuCom Systems Inc',costcenter+' '+costcenterDescription,geoName,revenueType ,amountList);
					wrapperContractLineItemList.add(wrapObj);
					 System.debug('...wrapObj...'+wrapObj);
						
				    }
			  
			 }
		/* }
	       catch(Exception e) {
			    System.debug('The following exception has occurred: ' + e.getMessage());
				System.debug('Line number: ' + e.getLineNumber()); 
			}*/ 
		      
	}
	
    public List<SelectOption> getFilterPlanningYear() {
        List<SelectOption> options = new List<SelectOption>();
        String CurrentYear = String.ValueOf(Date.today().year());
        for(Fiscal_Year_Planning__c fypObj :  [select Id,Name from Fiscal_Year_Planning__c order by Name LIMIT 100]){
        	options.add(new SelectOption(fypObj.Name,fypObj.Name));
            if(fypObj.Name==CurrentYear)
            	s_filterPlanningYear=fypObj.Name;
        } 
            
        return options;
    }
    
    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
    
    public void callBatchClass(){
        FCST_HyperLinkUpload_Batchs_Download uca = new FCST_HyperLinkUpload_Batchs_Download(s_FilterPlanningYear);
        Database.executeBatch(uca,5);
    }
    
    
    
    	
    public class wrapperContractLineItem{
	    public String programName{get;set;}
	    public String countryStr{get;set;}
	    public String BSLANumber{get;set;}
	    public String costcenterNumber{get;set;}
	    public String geoNumber{get;set;}
	    public string revenueString{get;set;}
	    public List<double> amountList{get;set;}
		
	     
	       public wrapperContractLineItem(String programName,String countryStr,String BSLANumber,String costcenterNumber,String geoNumber,string revenueString,List<double> amountList){
	     
	         this.programName=programName;
	         this.countryStr=countryStr;
	         this.BSLANumber=BSLANumber;
	         this.costcenterNumber=costcenterNumber;
	         this.geoNumber=geoNumber;
	         this.revenueString=revenueString;
	         this.amountList=amountList;
	         
	         
	         
	         
	         
	       }
	  }
}