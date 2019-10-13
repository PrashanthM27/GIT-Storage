public with sharing class FCST_Actual_HyperLinkUpload_Controller {
	
	public string s_FilterPlanningYear{get;set;}
	public String selectedYr{get;set;}
	public String S_FilterMonth{get;set;}
		String openAdminVersion{get;set;}
	
	public List<Actual_Model__c> actualList{get;set;}
	
	public FCST_Actual_HyperLinkUpload_Controller(){
		set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
		List<Planning_Version__c> pvlist=[select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
		if(pvlist!=null && pvlist.size()>0)
			openAdminVersion=pvlist[0].Name;
			
		getFilterPlanningYear();
		updateWrapperList();
	}
	
	public void onChangeYear() {
        updateWrapperList();     
    }
	
	public void updateWrapperList(){
		try {
			actualList=new List<Actual_Model__c>(); 
			selectedYr=s_FilterPlanningYear.right(2);
			String likeStr='FY'+s_FilterPlanningYear+'%';
			
			String actualQueryString='Select Id,BSLA__c,CC__c,FCST_GEO__c,CDR__c,Actual_Amount__c  from Actual_Model__c where Fiscal_Year__r.Name=:selectedYr and  FCST_Planning_Version__r.Name=:openAdminVersion LIMIT 30000';
		    
			actualList=database.query(actualQueryString);  
			 
		  }
	       catch(Exception e) {
			    System.debug('The following exception has occurred: ' + e.getMessage());
				System.debug('Line number: ' + e.getLineNumber()); 
			}
		      
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
    
    public List<SelectOption> getMonthName() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('01','January'));
        options.add(new SelectOption('02','February'));
        options.add(new SelectOption('03','March'));
        options.add(new SelectOption('04','April'));
        options.add(new SelectOption('05','May'));
        options.add(new SelectOption('06','June'));
        options.add(new SelectOption('07','July'));
        options.add(new SelectOption('08','August'));
        options.add(new SelectOption('09','September'));
        options.add(new SelectOption('10','October'));
        options.add(new SelectOption('11','November'));
        options.add(new SelectOption('12','December'));
            
        return options;
    }
    
    
    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
    
    public void callBatchClass(){
        FCST_Batch_ContractLine_Download uca = new FCST_Batch_ContractLine_Download(s_FilterPlanningYear);
      //  Database.executeBatch(uca);
    }
    

}