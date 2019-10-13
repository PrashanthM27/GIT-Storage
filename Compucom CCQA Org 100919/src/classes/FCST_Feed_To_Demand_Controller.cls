public class FCST_Feed_To_Demand_Controller {
	/*
	public List<wrapperContractLineItem> wrapperContractLineItemList{get; set;}    
	public string s_FilterPlanningYear{get;set;}
	public String selectedPlanning_version{get;set;}
	public String selectedVersion{get;set;}
	

   public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
  
   public FCST_Feed_To_Demand_Controller(){
   		selectedVersion='Forecast';
   		getFilterPlanningYear();
   		getFilterPlanningVersion();
   		updateWrapperList();
   }
  
   public List<SelectOption> getFilterPlanningYear() {
        List<SelectOption> options = new List<SelectOption>();
        String CurrentYear = String.ValueOf(Date.today().year());
        for(Fiscal_Year_Planning__c fypObj :  [select Id,Name from Fiscal_Year_Planning__c order by Name LIMIT 100]){
        	options.add(new SelectOption(fypObj.Name,fypObj.Name));
            if(fypObj.Name==CurrentYear ){
            	s_filterPlanningYear=fypObj.Name;
            	System.debug('Line py :s_filterPlanningYear ' + s_filterPlanningYear);
            }
        } 
            
        return options;
    }
    
    public List<SelectOption> getFilterPlanningVersion() {
       List<SelectOption> options = new List<SelectOption>();
        
        try {
		        for(Planning_Version__c cp :  [select Id,Name,SequenceNo__c,Version_Status__c from Planning_Version__c where  Planning_Version_Fiscal_Year__c =: s_FilterPlanningYear and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false and Fiscal_Year_Planning__r.Name=:s_filterPlanningYear  order by SequenceNo__c ]){
		            options.add(new SelectOption(cp.Name,cp.Name));  
		            if(cp.Version_Status__c == 'Open (Admin)')  {
		               selectedPlanning_version=cp.Name;
		               System.debug('Line pv :selectedPlanning_version ' + selectedPlanning_version); 
		            }
		        }  
		        return options;
         }
	       catch(Exception e) {
			    System.debug('The following exception has occurred: ' + e.getMessage());
				System.debug('Line number: ' + e.getLineNumber()); 
			}
			return null;
    }
    
    

	public void onChangeYear() {
      getFilterPlanningVersion();   
    }
    
    public void onReportLoad() {
      updateWrapperList();   
    }
    
    
	public void updateWrapperList(){
		System.debug('Line number: updateWrapperList' ); 
			wrapperContractLineItemList =new List<wrapperContractLineItem>();
		try {
			System.debug('Line number:selectedPlanning_version ' + selectedPlanning_version); 
			System.debug('Line number:s_FilterPlanningYear ' + s_FilterPlanningYear); 
				
			String intialForecastQuery='Select Id,Fiscal_Period__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Forecast_with_Risk__c ,Contract_LineItem__r.Line_Description__c,Contract_LineItem__r.FCST_Fiscal_Year_List__c,FCST_Contract__r.Revenue_Source__c,Contract_LineItem__r.Fcst_Revenue_Type__c,FCST_Contract__r.Fcst_Account__r.FCST_CPM_Region__c,FCST_Fiscal_Year_List__r.Name   from FCST_Initial_Forecast__c where FCST_Fiscal_Year_List__r.Name=:s_FilterPlanningYear and Planning_Version__r.Name=:selectedPlanning_version order by Contract_LineItem__c LIMIT 30000';
		    List<FCST_Initial_Forecast__c> contractIntialForecastList=database.query(intialForecastQuery); 
			Map<Id,List<FCST_Initial_Forecast__c>> mapIdVsContractIntialList =new Map<Id,List<FCST_Initial_Forecast__c>>();
			System.debug('LintialForecastQuery ' + intialForecastQuery); 
			if(contractIntialForecastList!=null && contractIntialForecastList.size()>0){
	    		for(FCST_Initial_Forecast__c conIntialForecastObj:contractIntialForecastList){
	    			if(mapIdVsContractIntialList.containsKey(conIntialForecastObj.Contract_LineItem__r.Id)){
	    				List<FCST_Initial_Forecast__c> existingModel=mapIdVsContractIntialList.get(conIntialForecastObj.Contract_LineItem__r.Id);
	    				existingModel.add(conIntialForecastObj);
	    				mapIdVsContractIntialList.put(conIntialForecastObj.Contract_LineItem__r.Id,existingModel);
	    			}
	    			else{
	    				List<FCST_Initial_Forecast__c> newModelList = new List<FCST_Initial_Forecast__c>();
	    				newModelList.add(conIntialForecastObj);
	    				mapIdVsContractIntialList.put(conIntialForecastObj.Contract_LineItem__r.Id,newModelList);
	    			}
	    		}
	    	}
			
			
			  for(Id contractLineId:mapIdVsContractIntialList.keyset())	{
			  	if(mapIdVsContractIntialList.containsKey(contractLineId)){
					List<double> amountList = new List<double>();
					double m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0,Mtotal=0;
					FCST_Initial_Forecast__c fcstObj;
					for(FCST_Initial_Forecast__c initialObj:mapIdVsContractIntialList.get(contractLineId)){
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
					wrapperContractLineItem wrapObj = new wrapperContractLineItem(fcstObj,amountList);
					wrapperContractLineItemList.add(wrapObj);
			    }
			  
			 }
		 }
	       catch(Exception e) {
			    System.debug('The following exception has occurred: ' + e.getMessage());
				System.debug('Line number: ' + e.getLineNumber()); 
			}
		      
	}    
    
    public class wrapperContractLineItem{
	    
	    public FCST_Initial_Forecast__c contractLineObj{get;set;}
	    public List<double> amountList{get;set;}
		
	     
	       public wrapperContractLineItem(FCST_Initial_Forecast__c contractLineObjVal,List<double> amountListVal){
	     
	         contractLineObj=contractLineObjVal;
			 amountList=amountListVal;
	        
	       }
	  }*/
}