public class FCST_Actuals_DataExtract {

    public List<wrapperContractLineWise> wrapperContractLineWiseList{get; set;}    
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
     
     
    public FCST_Actuals_DataExtract(){
        
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
        
        todayDate=date.today();
       
        String accQuery='select Id from Account where   '+cpmRegionLabelName+'!=null LIMIT 500';
         List<Account> accListVal=database.query(accQuery);
        System.debug('accListVal'+accListVal);
     //total_size=accListVal.size();
     // total_size=2;
            //System.debug('...total_size.....'+total_size);
         //formattedDate =todayDate.year()+'-'+todayDate.month()+'-'+todayDate.day();
         formattedDate =todayDate.month()+'/'+todayDate.day()+'/'+todayDate.year();
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
        
       
        System.debug('options'+options);            
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
            wrapperContractLineWiseList = new List<wrapperContractLineWise>();
            selectedYr=s_FilterPlanningYear.right(2);
            nextYear=String.ValueOf(Integer.ValueOf(selectedYr)+1);
        
           currentFullYear=s_FilterPlanningYear;
           nextFullYear=String.ValueOf(Integer.ValueOf(currentFullYear)+1);
            
            Integer currentYear=date.today().Year();
            String LineitemQuery = 'SELECT Id, name from Contract_LineItem__c where Id In(Select Contract_LineItem__c from  Actual_Model__c)';
            List<Contract_LineItem__c> conListVal = database.query(LineitemQuery);
            String ActualQuery ='SELECT Account__r.Name, Contract_LineItem__r.Fcst_Revenue_Type__c, Contract_LineItem__r.Cost_Center__c, GEO_Description__c,FCST_GEO__c,FCST_Contract__r.Contract__c,Contract_LineItem__c, Revenue_Stream__c,    FCST_Contract__r.Contract_Description__c,FCST_Contract__r.Name,FCST_Contract__r.Opportunity__c, LastModifiedBy.Name,LastModifiedDate, Contract_LineItem__r.Name, Contract_LineItem__r.Line_Description__c,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Month_Number__c, FCST_Planning_Version__r.Name,Actual_Amount__c from Actual_Model__c Where ';
             ActualQuery += ' FCST_Planning_Version__r.Name =: openAdminVersion  and Contract_LineItem__c IN:conListVal and Account__r.'+cpmRegionLabelName+' !=null  and Fiscal_Period__r.Fiscal_Year__c =:currentFullYear';
             ActualQuery += ' order by Account__r.Name,Contract_LineItem__r.Fcst_Revenue_Type__c';
            
             List<Actual_Model__c> ActualModelList = database.query(ActualQuery); 
            System.debug('ActualModelList'+ActualModelList);
            Map<Id,List<Actual_Model__c>> mapContractLineItemIdVsActualModelList = new Map<Id,List<Actual_Model__c>>();
            
            for(Actual_Model__c accModel : ActualModelList){
                    if(mapContractLineItemIdVsActualModelList.containsKey(accModel.Contract_LineItem__c)){
                        List<Actual_Model__c> existingModel=mapContractLineItemIdVsActualModelList.get(accModel.Contract_LineItem__c);
                        existingModel.add(accModel);
                        mapContractLineItemIdVsActualModelList.put(accModel.Contract_LineItem__c,existingModel);
                    }
                    else{
                        List<Actual_Model__c> newModelList = new List<Actual_Model__c>();
                        newModelList.add(accModel);
                        mapContractLineItemIdVsActualModelList.put(accModel.Contract_LineItem__c,newModelList);
                    }
            }
         
          //  datetime = createdDate;
           for(Id lineIdobj:mapContractLineItemIdVsActualModelList.keySet()){
             	System.debug('In lineIdobj>>'+lineIdobj);
                  List<double> ActualAmountList = new List<double>();
                    double Actual1=0,Actual2=0,Actual3=0,Actual4=0,Actual5=0,Actual6=0,Actual7=0,Actual8=0,Actual9=0,Actual10=0,Actual11=0,Actual12=0;
                    String contractLineItemName='',AccountName='',RevenueType='',CostCentre='',Geo='',Contractnum='',ContractLineDesc='',LastModifiedBy='',planningversion='',dataextdate='',lastdate='';
               		String contractLineItemName25Digit='',AccountName25Digit='',RevenueType25Digit='',Geo25Digit='',Contractnum25Digit='',ContractLineDesc25Digit='';
 					datetime modDate;
               Integer i=0;
               
                for(Actual_Model__c accModel:mapContractLineItemIdVsActualModelList.get(lineIdobj)){
                    i++;
                    System.debug('i'+i);
                     if(i==1){
                       modDate=accModel.LastModifiedDate;
                       LastModifiedBy=accModel.LastModifiedBy.Name; 
                                 }
                    if(accModel.LastModifiedDate!=null && (modDate<accModel.LastModifiedDate)){
                        modDate=accModel.LastModifiedDate;
                        LastModifiedBy=accModel.LastModifiedBy.Name;
                    }
                    if(modDate!=null){
                       lastdate = modDate.month()+'/'+modDate.day()+'/'+modDate.year();
                    }
                    if(accModel.Contract_LineItem__r.Name!=null){
                        contractLineItemName = accModel.Contract_LineItem__r.Name;
                    	contractLineItemName25Digit = reduceName(contractLineItemName);
                    }
                    if(accModel.Account__r.Name!=null){
               			AccountName = accModel.Account__r.Name;
                        AccountName25Digit = reduceName(AccountName);
                    }
                    if(accModel.Contract_LineItem__r.Fcst_Revenue_Type__c!=null){
                        RevenueType= accModel.Contract_LineItem__r.Fcst_Revenue_Type__c;
                        RevenueType25Digit =  reduceName(RevenueType);
                    }
                    if(accModel.Contract_LineItem__r.Cost_Center__c!=null)
                        CostCentre= accModel.Contract_LineItem__r.Cost_Center__c;
                    if(accModel.GEO_Description__c!=null && accModel.FCST_GEO__c!=null){
                        Geo= accModel.FCST_GEO__c+' '+accModel.GEO_Description__c;
                        Geo25Digit = reduceName(Geo);
                    }
                    if(accModel.FCST_Contract__r.Contract__c!=null){
                        Contractnum=accModel.FCST_Contract__r.Contract__c;
                        Contractnum25Digit =  reduceName(Contractnum);
                    }
                    if(accModel.Contract_LineItem__r.Line_Description__c!=null){
                        ContractLineDesc=accModel.Contract_LineItem__r.Line_Description__c;
                        ContractLineDesc25Digit =  reduceName(ContractLineDesc);
                    }
                      //  if(accModel.LastModifiedBy.Name!=null)
                       // LastModifiedBy=accModel.LastModifiedBy.Name;
                        if(accModel.FCST_Planning_Version__r.Name!=null)
                        planningversion=accModel.FCST_Planning_Version__r.Name;
                    	if(formattedDate!=null)
                            System.debug('formattedDate'+formattedDate);
                    	dataextdate = formattedDate;
                    	//if(accModel.LastModifiedDate!=null)
                            //lastdate=accModel.LastModifiedDate.month()+'/'+accModel.LastModifiedDate.day()+'/'+accModel.LastModifiedDate.year();
                        if(accModel.Fiscal_Period__r.Month_Number__c==1 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual1+= accModel.Actual_Amount__c;
                            System.debug('Amount1'+accModel.Actual_Amount__c);
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==2 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual2+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==3 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual3+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==4 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual4+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==5 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual5+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==6 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual6+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==7 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual7+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==8 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual8+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==9 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual9+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==10 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual10+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==11 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual11+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==12 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual12+= accModel.Actual_Amount__c;
                        }
                    
                    
                }
                        ActualAmountList.add(Actual1);
                        ActualAmountList.add(Actual2);
                        ActualAmountList.add(Actual3);
                        ActualAmountList.add(Actual4);
                        ActualAmountList.add(Actual5);
                        ActualAmountList.add(Actual6);
                        ActualAmountList.add(Actual7);
                        ActualAmountList.add(Actual8);
                        ActualAmountList.add(Actual9);
                        ActualAmountList.add(Actual10);
                        ActualAmountList.add(Actual11);
                        ActualAmountList.add(Actual12);
                        System.debug('ActualAmountList'+ActualAmountList);
                wrapperContractLineWise wrapList = new	wrapperContractLineWise(contractLineItemName,contractLineItemName25Digit,AccountName,AccountName25Digit,RevenueType,RevenueType25Digit,CostCentre,Geo,Geo25Digit,Contractnum,Contractnum25Digit,ContractLineDesc,ContractLineDesc25Digit,LastModifiedBy,planningversion,lastdate,dataextdate,ActualAmountList);
                System.debug('wrapList'+wrapList);
                if(wrapList!=null){wrapperContractLineWiseList.add(wrapList);}
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
        FCST_ActualData_Extract_Batch_Download uca = new FCST_ActualData_Extract_Batch_Download(s_FilterPlanningYear,openAdminVersion);
        Database.executeBatch(uca,5);
    }
    
    
    
        
    public class wrapperContractLineWise{
        public String contractLineItemName{get;set;}
        public String AccountName{get;set;}
        public String RevenueType{get;set;}
        public String Geo{get;set;}   
        public String Contractnum{get;set;}
        public String ContractLineDesc{get;set;}
        public String contractLineItemName25Digit{get;set;}
        public String AccountName25Digit{get;set;}
        public String RevenueType25Digit{get;set;}
        public String CostCentre{get;set;}
        public String Geo25Digit{get;set;}   
        public String Contractnum25Digit{get;set;}
        public String ContractLineDesc25Digit{get;set;}
        public String LastModifiedBy{get;set;}
        public String planningversion{get;set;}
        public string lastdate{get;set;}
        public string dataextdate{get;set;}
        public List<double> doubleAmount{get;set;}
     
        public wrapperContractLineWise(String contractLineItemName,String contractLineItemName25Digit,String AccountName,String AccountName25Digit,String RevenueType,String RevenueType25Digit,String CostCentre,String Geo,String Geo25Digit,String Contractnum,String Contractnum25Digit,String ContractLine,String ContractLineDesc25Digit,String LastModifiedBy,String planningversion,String lastdate,string dataextdate,List<double> doubleAmount)
        {	
            this.contractLineItemName=contractLineItemName;
            this.AccountName=AccountName;
            this.RevenueType=RevenueType;
            this.Geo=Geo;
            this.Contractnum=Contractnum;
            this.ContractLineDesc=ContractLineDesc;
            this.contractLineItemName25Digit=contractLineItemName25Digit;
            this.AccountName25Digit=AccountName25Digit;
            this.RevenueType25Digit=RevenueType25Digit;
            this.CostCentre=CostCentre;
            this.Geo25Digit=Geo25Digit;
            this.Contractnum25Digit=Contractnum25Digit;
            this.ContractLineDesc25Digit=ContractLineDesc25Digit;
            this.LastModifiedBy=LastModifiedBy;
            this.planningversion=planningversion;
            this.lastdate = lastdate;
            this.dataextdate = dataextdate;
      		this.doubleAmount=doubleAmount;
        }
    }
    
    

     
}