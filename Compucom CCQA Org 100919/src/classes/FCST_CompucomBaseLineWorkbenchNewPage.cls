public with sharing class FCST_CompucomBaseLineWorkbenchNewPage { 
   
    public string strPlanningVersion{get;set;}
    public String Planversion{get;set;} 
    public string strPlanningYear{get;set;}
    public String planningPeriod{get;set;}
    public Transient string tableBlock{get;set;} 
    private boolean editableCell;
    public Integer globalYear{get;set;}
    public Set<String> accountSet{get;set;}
    public string strAccount{get;set;}
    public string strUserName {get;set;}
    private Date yearCloseDate;
    private Date YearStartDate;
    Integer increaseVal;
    public boolean IsTableDataPresent{get;set;} 
    public String globalMonth{get;set;}
    public string strPlanYear{get;set;}
    public Integer lastYear{get;set;}
    public Integer cYear{get;set;}
    public Integer initialYear{get;set;}
    public String cpID{get;set;}
    public List<Integer> yearList{get;set;}
    Public String strContract{get;set;}
    public Set<string> contractSet{get;set;}
    List<FCST_Contract__c> conList;
    List<Contract_LineItem__c> lineList;
    public String strLine   {get;set;}
    public Set<String> lineSet {get;set;}
    Set<String> InitialSet;



       //>>>>>>>>>>pagination start>>>>>>>>>>
        public integer counter=0; 
        public integer list_size=10;  
        public integer total_size;
        
        public PageReference Beginning() { 
          counter = 0;
          fetchOppRecord();
          return null;
       }
    
       public PageReference Previous() { 
          counter -= list_size;
          fetchOppRecord();
          return null;
       }
    
       public PageReference Next() { 
          counter += list_size;
          fetchOppRecord();
          return null;
       }
    
     
       public PageReference End() { 
          counter = total_size - math.mod(total_size, list_size);
          if(counter==total_size){
            counter=counter-list_size;
          }
          
          fetchOppRecord();
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
       public String pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
       public String AccountN = apexpages.currentpage().getparameters().get('AccId');
       public String UserStringId = apexpages.currentpage().getparameters().get('su');
       public Integer Year = System.Today().year();
       public String currentYear=String.valueOf(Year);
       
    
    public FCST_CompucomBaseLineWorkbenchNewPage(){  
         try{ 
                     IsTableDataPresent = true;
                     conList = new List<FCST_Contract__c>();
                     lineSet = new Set<String>();
                     contractSet = new Set<String>();
                     yearList= new List<Integer>();
            List<Account> accountList = new List<Account>();
            List<Account> NewAccountList = new List<Account>();
            accountSet = new Set<String>();
            planningPeriod='Planning Period';
            
            
            User currentuserobj = new User();
            
            if(pVVersionStringId!=null){
                Planning_Version__c planningVersionobj=[Select Name from Planning_Version__c where Id=:Id.valueOf(pVVersionStringId) LIMIT 1];
                strPlanningVersion=planningVersionobj.Name;
            }
            if(strPlanningVersion!=null)
                strPlanningYear=strPlanningVersion.left(4);
            if(strPlanningYear!=null){  
                List<Fiscal_Year_Planning__c> fiscalYearList=[Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c order by Name];
                for(Fiscal_Year_Planning__c fsYrObj:fiscalYearList){
                        yearList.add(Integer.ValueOf(fsYrObj.Name));
                        if(fsYrObj.Name!=null && strPlanningYear!=null && fsYrObj.Name==strPlanningYear){
                        cYear=Integer.ValueOf(strPlanningYear);
                        YearStartDate=fsYrObj.StartDate__c;
                        yearCloseDate=fsYrObj.EndDate__c;
                    }
                }
            }
            
            if(yearList!=null && yearList.size()>0){
                initialYear=yearList[0];
                lastYear=yearList[yearList.size()-1];
            }
            
            if(UserStringId!=null){
               currentuserobj=[Select Name,UserRoleId,UserRole.Name from User where Id=:Id.valueOf(UserStringId) and UserType!='Partner' and isActive=true LIMIT 1];
               strUserName=currentuserobj.Name;
            }
            
             
           String accQuery1= 'Select Id,Name from Account where Id =:AccountN';
           NewAccountList= Database.query(accQuery1);
           if(NewAccountList!=null && NewAccountList.size()>0){   
                    for(Account accObj:NewAccountList){
                         accountSet.add(accObj.Name);
                         straccount=accObj.Name; 
                    }
            }
                            
            String conQuery ='Select id,name,Contract__c from FCST_Contract__c where Fcst_Account__r.id =:AccountN and Contract_Owner__c=:UserStringId and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion ) and FCST_Contract_Created_Year__c <: currentYear  LIMIT 15000';
            conList = Database.query(conQuery);
            
            if(!conList.isEmpty()){
               strContract =String.valueOf(conList[0].Contract__c);
            }
             for(FCST_Contract__c conObj: conList){
                contractSet.add(conObj.Contract__c);
            }
         	
           lineSet.add('All');
            if(strContract!='' && strContract!=null && strContract!='All'){
           String lineQuery ='Select id,name,FCST_Contract__r.name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.Contract__c =:strContract and FCST_Contract__r.id!=null and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion) ORDER BY Name LIMIT 15000';

           lineList = Database.query(lineQuery);
            }
          if(lineList!=null && lineList.size()>0){
          	           for(Contract_LineItem__c lineObj: lineList){ 
           	 
                 lineSet.add(lineObj.name);
                
                 contractSet.add(lineObj.FCST_Contract__r.Contract__c);
            }
          	
          }
            
          
           system.debug('ccccccccccccccc>>>>'+contractSet);
            
           if(pVVersionStringId!=null){
               getFromPlanningVersion();
                fetchOppRecord();
            }
         	
         	  system.debug('ccccccccccccccc>>>>'+contractSet);
         	
         	
                //USAGE
            System.debug('controller 1.getQueries>>>>>>>: ' + Limits.getQueries());
            System.debug('controller 2.getQueryRows>>>>> ' + Limits.getQueryRows());
            System.debug('controller 3.getDmlRows>>>>>>> ' + Limits.getDmlRows());
            System.debug('controller 4.getDmlStatements>>>>> ' + Limits.getDmlStatements());
            System.debug('controller 5.getCpuTime>>>>>>>>>' + Limits.getCpuTime());
            System.debug('controller 6.getHeapSize>>>>>>>>>' + Limits.getHeapSize());
             //LIMITS
             
            System.debug('controller 1. TOtal LIMITs getQueries>>>>>>>: ' + Limits.getLimitQueries());
            System.debug('controller 2.  TOtal LIMITs getQueryRows>>>>> ' + Limits.getLimitQueryRows());
            System.debug('controller 3.  TOtal LIMITs getDmlRows>>>>>>> ' + Limits.getLimitDmlRows());
            System.debug('controller 4.  TOtal LIMITs getDmlStatements>>>>> ' + Limits.getLimitDmlStatements());
            System.debug('controller 5.  TOtal LIMITs getCpuTime>>>>>>>>>' + Limits.getLimitCpuTime());
            System.debug('controller 6.  TOtal LIMITs getHeapSize>>>>>>>>>' + Limits.getLimitHeapSize());
            
        
       }
       catch(Exception e){
            System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
            System.debug('Exception error Message>>>>>>> '+e);
        }     
                
    } 
    
    /***********************************Filter List Start ********************************************/ 
    
        public List<SelectOption> getPlanningYearOptionList() {
        List<SelectOption> PlanningYearoptions = new List<SelectOption>();
        Integer myear = (system.today()).year();
        set<string> setYear = new set<string>();
        set<string> setValidVersions = new set<string>{'Open (Admin)'};
        for(Planning_Version__c cp :  [select id,Planning_Version_Fiscal_Year__c,Is_this_a_Budget_Planning_Version__c  from Planning_Version__c where Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false  and Planning_Version_Fiscal_Year__c <> '2017' and Version_Status__c IN: setValidVersions order by Planning_Version_Fiscal_Year__c]){
            setYear.add(cp.Planning_Version_Fiscal_Year__c);
        } 
        for(string cp :  setYear){
            {
                if(strPlanYear == null && myear == Integer.valueOf(cp))strPlanYear = cp;
                PlanningYearoptions.add(new SelectOption(cp,cp));
            }
            }
        for(string cp :  setYear){
            {
                if(strPlanYear == null )strPlanYear = cp;
            }
            }       
       
        return PlanningYearoptions;
    }
    
 /***********************************Planning Version Start ********************************************/    

    public List<SelectOption> getFromPlanningVersion(){
        List<SelectOption> planningVersionOption = new List<SelectOption>();
        String pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
            
        if(pVVersionStringId!=null){
            Planning_Version__c planningVersionobj=[Select Name from Planning_Version__c where Id=:Id.valueOf(pVVersionStringId) LIMIT 1];
            strPlanningVersion=planningVersionobj.Name;
            Planversion=strPlanningVersion;
        }
        if(strPlanningVersion <> null){
            planningVersionOption.add(new SelectOption(strPlanningVersion,strPlanningVersion));
        }
        
        for(Planning_Version__c pvObj:[Select Name,Version_Status__c from Planning_Version__c where (Version_Status__c='Open (Admin)' ) and Id!=null ]){
                if(strPlanningVersion!=pvObj.Name){
                    planningVersionOption.add(new SelectOption(pvObj.Name,pvObj.Name));
                }
          }
        return planningVersionOption;
     }
    

  /***********************************Contacts  change start********************************************/  
     public void getContractChange(){
       try{ 
           conList = new List<FCST_Contract__c>(); 
           lineList = new List<Contract_LineItem__c>();
           lineSet = new Set<String>();
           String conQuery ='Select id,name from FCST_Contract__c where name =:strContract';
           conList = Database.query(conQuery);
          // if(!conList.isEmpty()){
          // }
           //for(FCST_Contract__c conObj: conList){
            //    contractSet.add(conObj.Contract__c);
          //  }

           lineSet.add('All');
           if(strContract!=''){
           String lineQuery ='Select id,name from Contract_LineItem__c where FCST_Contract__r.Contract__c=:strContract and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where  Contract_LineItem__r.id !=null and Planning_Version__r.Name=:strPlanningVersion) order by name';
           lineList = Database.query(lineQuery);
            for(Contract_LineItem__c lineObj: lineList){
                lineSet.add(lineObj.name);
            }
           }
       
       
            //USAGE
            System.debug('getAccountChange 1.getQueries>>>>>>>: ' + Limits.getQueries());
            System.debug('getAccountChange 2.getQueryRows>>>>> ' + Limits.getQueryRows());
            System.debug('getAccountChange 3.getDmlRows>>>>>>> ' + Limits.getDmlRows());
            System.debug('getAccountChange 4.getDmlStatements>>>>> ' + Limits.getDmlStatements());
            System.debug('getAccountChange 5.getCpuTime>>>>>>>>>' + Limits.getCpuTime());
            System.debug('getAccountChange 6.getHeapSize>>>>>>>>>' + Limits.getHeapSize());
             //LIMITS
             
            System.debug('getAccountChange 1. TOtal LIMITs getQueries>>>>>>>: ' + Limits.getLimitQueries());
            System.debug('getAccountChange 2.  TOtal LIMITs getQueryRows>>>>> ' + Limits.getLimitQueryRows());
            System.debug('getAccountChange 3.  TOtal LIMITs getDmlRows>>>>>>> ' + Limits.getLimitDmlRows());
            System.debug('getAccountChange 4.  TOtal LIMITs getDmlStatements>>>>> ' + Limits.getLimitDmlStatements());
            System.debug('getAccountChange 5.  TOtal LIMITs getCpuTime>>>>>>>>>' + Limits.getLimitCpuTime());
            System.debug('getAccountChange 6.  TOtal LIMITs getHeapSize>>>>>>>>>' + Limits.getLimitHeapSize());
            
        
       }
       catch(Exception e){
           System.debug('getAccountChange Exception error Message>>>>>>> '+e.getLineNumber());
           System.debug('getAccountChange Exception error Message>>>>>>> '+e);
       }   
   
   }
 /***********************************Contacts  change End********************************************/        
 /***********************************User Change End ********************************************/
    
  public pagereference mainfetchOppRecord(){
    counter = 0;
    increaseVal=0;
    String increaseValStr = ApexPages.CurrentPage().getParameters().get('getincreaseValue');
      
    if(increaseValStr!=null)
        increaseVal= Integer.ValueOf(increaseValStr);
        fetchOppRecord();
        return null;
   }
   
   
public pagereference  fetchOppRecord(){
       try{
           
       
             IsTableDataPresent = false;
             globalYear=0;
     
             String UserStringId = apexpages.currentpage().getparameters().get('su');
            Id selectedUserId=Id.valueOf(UserStringId);
            
             string strPlanningYear;
             Date yearCloseDate,YearStartDate,monthStartDate,monthCloseDate;
                  
           
            if(strPlanningVersion!=null)
                strPlanningYear=strPlanningVersion.left(4);
            
           if(strPlanningYear.isNumeric())
                globalYear=Integer.ValueOf(strPlanningYear);
        
           
            if(increaseVal!=null){
                globalYear=globalYear+increaseVal;
             }  
           List<Fiscal_Year_Planning__c> fiscalYearList = new List<Fiscal_Year_Planning__c>();
           if(globalYear!=null){    
                 fiscalYearList=[Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c where Name=:String.valueOf(globalYear) LIMIT 1];
                 if(fiscalYearList!=null && fiscalYearList.size()>0){
                    YearStartDate=fiscalYearList[0].StartDate__c;
                    yearCloseDate=fiscalYearList[0].EndDate__c;
                }
            }
           
           planningPeriod=YearStartDate.day()+' '+getmonthName(YearStartDate.month())+' '+globalYear+' to '+yearCloseDate.day()+' '+getmonthName(yearCloseDate.month())+' '+globalYear;
       
            if(strPlanningVersion!=null){ 
            List<Planning_Version__c> planningVertionList=[Select Name,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c from Planning_Version__c where Name=:strPlanningVersion LIMIT 1];
            if(planningVertionList!=null && planningVertionList.size()>0){
            monthStartDate=planningVertionList[0].Data_Entry_Start_Date__c;
            monthCloseDate=planningVertionList[0].Data_Entry_Closed_Date__c;
             }
             }
            if(monthStartDate!=null && monthCloseDate!=null){
                 globalMonth = getmonthName(monthStartDate.month());
             }
                String likeStr='FY'+globalYear+'%';
        
           
       
      contractSet = new Set<String>();
      Map<String,List<Contract_LineItem__c>> mapConIdvsConlineItemList = new Map<String,List<Contract_LineItem__c>>();
      Map<Id,String> ConHavingAccountIdName = new Map<Id,String>();
      Map<Id,String> LineHavingLineItemName = new Map<Id,String>();      
      Map<String,Set<String>> ConVsLineItemName = new Map<String,Set<String>>();
      Map<String,List<FCST_Initial_Forecast__c>> mapLineNameVsContactList = new Map<String,List<FCST_Initial_Forecast__c>>();
      Set<Id> ConHavingLineItemIdSet = new Set<Id>();
      List<Contract_LineItem__c> ConLineItemList = new List<Contract_LineItem__c>();
      Map<id,Set<String>> ConidVsLineItem = new Map<id,Set<String>>();
      Map<Id,List<FCST_Contract__c>> ConVsLineItem = new Map<Id,List<FCST_Contract__c>>();
      Map<String,List<Actual_Model__c>> LineItemIdVsActualList = new Map<String,List<Actual_Model__c>>();
      
        String coontactQuery ='Select Contract__c from FCST_Contract__c where Fcst_Account__r.name =:straccount and Contract_Owner__c=:UserStringId and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion ) and FCST_Contract_Created_Year__c <: currentYear ';
        List<FCST_Contract__c> totalContactList=database.query(coontactQuery);
         for(FCST_Contract__c cont:totalContactList){
          contractSet.add(cont.Contract__c);
       }
       String ContactlineInnerQuery ='Select id,FCST_Contract__r.Fcst_Account__r.Id,FCST_Contract__r.Fcst_Account__r.Name,name,Risk_Factor__c,FCST_Contract__c,FCST_Contract__r.name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.Contract__c =:strContract and  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where FCST_Contract__r.Contract__c =:strContract and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr )';
          
       if(strLine!='All' && strLine!=null && String.isNotBlank(strLine)){
                ContactlineInnerQuery +=' and name=:strLine';
       }
               ContactlineInnerQuery +=' order by Name LIMIT 15000'; 
             
      List<Contract_LineItem__c> totalLineItemList=database.query(ContactlineInnerQuery); 
       for(Contract_LineItem__c ConLine:totalLineItemList){
            if(ConLine.Id!=null && ConLine.Name!=null && strContract!='' && strContract!=null && strContract!='All'){ 
            LineHavingLineItemName.put(ConLine.Id,ConLine.Name);  
            }
            }
        total_size =LineHavingLineItemName.keySet().size();
       
       
       
       
       
       
       
      
      String ContactQuery='Select id,name,Contract_Description__c,Fcst_Account__r.id,Fcst_Account__r.Name,Contract__c from FCST_Contract__c where Id<>null and Contract__c=:strContract and Contract_Owner__c=:UserStringId and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where FCST_Contract__r.Contract__c=:strContract and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and FCST_Contract_Created_Year__c <: currentYear ';
             if(strContract!='All' && strContract!=null && String.isNotBlank(strContract)){
                ContactQuery +=' and Contract__c=:strContract';
           }
            ContactQuery +=' order by Name LIMIT 15000';
          
            List<FCST_Contract__c> ContactLisst=database.query(ContactQuery); 
            for(FCST_Contract__c Con:ContactLisst){
                 contractSet.add(Con.Contract__c);
                   if(ConVsLineItem.containsKey(Con.Fcst_Account__r.id)){
                   List<FCST_Contract__c> mapContainCon =ConVsLineItem.get(Con.Fcst_Account__r.id);
                   mapContainCon.add(Con);
                   ConVsLineItem.put(Con.Fcst_Account__r.id,mapContainCon);
             }else {
                   List<FCST_Contract__c> newConList = new List<FCST_Contract__c>();
                   newConList.add(Con);
                   ConVsLineItem.put(Con.Fcst_Account__r.id,newConList);
             }
                             if(Con.Fcst_Account__r.id!=null && Con.Fcst_Account__r.Name!=null){
                ConHavingAccountIdName.put(Con.Fcst_Account__r.id,Con.Fcst_Account__r.Name);    
            }
             
            }
           
      for(Contract_LineItem__c ConLineObj:[select Id,Name,FCST_Contract__r.id,Risk_Factor__c,Line_Description__c,FCST_Fiscal_Year_List__c from Contract_LineItem__c  where  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where FCST_Contract__r.Contract__c IN:contractSet and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and id<>null and ID IN:LineHavingLineItemName.keySet() order by Name limit :list_size  offset :counter]){   
          ConHavingLineItemIdSet.add(ConLineObj.Id);
               
                   
                   
              if(mapConIdvsConlineItemList.containsKey(ConLineObj.FCST_Contract__r.id+ConLineObj.name) ){
                     List<Contract_LineItem__c> mapContainConline =mapConIdvsConlineItemList.get(ConLineObj.FCST_Contract__r.id+ConLineObj.name);
                    mapContainConline.add(ConLineObj);
                    mapConIdvsConlineItemList.put(ConLineObj.FCST_Contract__r.id+ConLineObj.name,mapContainConline); 
             }
             else {
                   List<Contract_LineItem__c> newConLineList = new List<Contract_LineItem__c>();
                   newConLineList.add(ConLineObj);
                   mapConIdvsConlineItemList.put(ConLineObj.FCST_Contract__r.id+ConLineObj.name,newConLineList);
             }
             
             
               if(ConVsLineItemName.containsKey(ConLineObj.FCST_Contract__r.id)){
                   Set<String> mapContainFam =ConVsLineItemName.get(ConLineObj.FCST_Contract__r.id);
                   mapContainFam.add(ConLineObj.Name+ConLineObj.FCST_Contract__r.id);
                   ConVsLineItemName.put(ConLineObj.FCST_Contract__r.id,mapContainFam); 
                }else{
                   Set<String> newFamList = new Set<String>();
                   newFamList.add(ConLineObj.Name+ConLineObj.FCST_Contract__r.id);
                   ConVsLineItemName.put(ConLineObj.FCST_Contract__r.id,newFamList);
                }
                
                   if(ConidVsLineItem.containsKey(ConLineObj.FCST_Contract__r.id)){
                   Set<String> mapContainFam =ConidVsLineItem.get(ConLineObj.FCST_Contract__r.id);
                   mapContainFam.add(ConLineObj.FCST_Contract__r.id+ConLineObj.name);
                   ConidVsLineItem.put(ConLineObj.FCST_Contract__r.id,mapContainFam); 
                }else{
                   Set<String> newFamList = new Set<String>();
                   newFamList.add(ConLineObj.FCST_Contract__r.id+ConLineObj.name);
                   ConidVsLineItem.put(ConLineObj.FCST_Contract__r.id,newFamList);
                }
        }
    
    
      String InitialForecastQuery = 'Select Name,Fcst_Amount__c,Planning_Version__r.Name,Risk_Factor__c,Account__r.id,Account__r.Name,Forecast_with_Risk__c,FCST_Contract__r.id,FCST_Planning_Fiscal_Year__r.Name,Contract_LineItem__r.id,Contract_LineItem__r.Name,Fiscal_Period__c,RiskAmount__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and Account__r.Name=:straccount and Contract_LineItem__r.id IN:ConHavingLineItemIdSet and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr and id<>null  ';
      List<FCST_Initial_Forecast__c>InitialForecastList=database.query(InitialForecastQuery);
              for(FCST_Initial_Forecast__c productObj: Database.query(InitialForecastQuery)){
              if(mapLineNameVsContactList.containsKey(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name) ){
                   List<FCST_Initial_Forecast__c> mapContainInitialForecastModel =mapLineNameVsContactList.get(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name);
                   mapContainInitialForecastModel.add(productObj);
                   mapLineNameVsContactList.put(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name,mapContainInitialForecastModel);
             }
             else {
                   List<FCST_Initial_Forecast__c> newInitialForecastList = new List<FCST_Initial_Forecast__c>();
                   newInitialForecastList.add(productObj);
                   mapLineNameVsContactList.put(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name,newInitialForecastList); 
             }
             
            
        }
        
        
        
    String  tableRecord='<table id="table_id" class="slds-table slds-table--bordered slds-table--cell-buffer"><tr class="slds-text-title--caps"><th style="background-color: #313A8B;;border-bottom-color: #313A8B;border-right-color: #313A8B;border-left-color: #313A8B;"></th><th  style="background-color: #313A8B;;border-left-color:#313a8b;width:20%;text-align: center;" rowspan="2"><label  style="color: white;position: relative; right: 140px;" >Account/Contract</label></th><th  colspan="13" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" ><b>Planning Year</b><b class="Ram"  style="color: white;"> - '+globalYear+'</b></label></th></tr><tr class="slds-text-title--caps"><th style="background-color: #313A8B;border-left-color: #313A8B;border-right-color: #313A8B;border-top-color: #313A8B;"></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jan</label></th><th   class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Feb</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Mar</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Apr</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >May</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jun</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jul</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Aug</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Sep</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Oct</label></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Nov</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Dec</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Total</label></th></tr>';          
    String tableBody='';
          List<String> args2 = new String[]{'0','number','###,###,###'};
          String j = 'FY'+globalYear+'%';
       
       
          //><>>>>>>>>>>>>>>>>>>>>>>>>>>Actual calculation>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        String actualQuery = 'select id,Name,Account__c,Actual_Amount__c,Contract_LineItem__r.Name,FCST_Contract__r.id,FCST_Planning_Version__r.Name,Fiscal_Period__r.Name from Actual_Model__c where  FCST_Contract__r.Contract__c =:strContract and Account__r.name =:straccount and FCST_Contract__r.FCST_Contract_Created_Year__c <: currentYear  and FCST_Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name LIKE :j and id!=null LIMIT 15000';            
           
        List<Actual_Model__c> actualnewList = database.query(actualQuery);
        if(actualnewList.size()>0){  
        for(Actual_Model__c actualObj:actualnewList){
              if(LineItemIdVsActualList.containsKey(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name)){
                   List<Actual_Model__c> mapContainActualModel =LineItemIdVsActualList.get(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name);   
                   mapContainActualModel.add(actualObj);
                   LineItemIdVsActualList.put(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name,mapContainActualModel);
             }
             else{
                   List<Actual_Model__c> newActualModelList = new List<Actual_Model__c>();
                   newActualModelList.add(actualObj);
                   LineItemIdVsActualList.put(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name,newActualModelList);
             }
         }
       } 
         
         
         
         
Set<Id> pageSet= new Set<Id>();  
  for(Account acOBJ:[Select Id from Account where ID IN:ConHavingAccountIdName.keySet() order by Name ]){
  pageSet.add(acOBJ.Id);
        
          }
           
for(Id acciD :pageSet){  
            
        String BaseLineRowBody='';  
        Decimal totalAccLevelActual=0,AccLevelactualAmount1=0,AccLevelactualAmount2=0,AccLevelactualAmount3=0,AccLevelactualAmount4=0,AccLevelactualAmount5=0,AccLevelactualAmount6=0,AccLevelactualAmount7=0,AccLevelactualAmount8=0,AccLevelactualAmount9=0,AccLevelactualAmount10=0,AccLevelactualAmount11=0,AccLevelactualAmount12=0;
 
                        Decimal ConLevelMAmount1=0,ConLevelMAmount2=0,ConLevelMAmount3=0,ConLevelMAmount4=0,ConLevelMAmount5=0,ConLevelMAmount6=0,ConLevelMAmount7=0,ConLevelMAmount8=0,ConLevelMAmount9=0,ConLevelMAmount10=0,ConLevelMAmount11=0,ConLevelMAmount12=0,TotalConLevelMAmount=0;
                        Decimal ConForecastwithRisk1=0,ConForecastwithRisk2=0,ConForecastwithRisk3=0,ConForecastwithRisk4=0,ConForecastwithRisk5=0,ConForecastwithRisk6=0,ConForecastwithRisk7=0,ConForecastwithRisk8=0,ConForecastwithRisk9=0,ConForecastwithRisk10=0,ConForecastwithRisk11=0,ConForecastwithRisk12=0,TotalConForecastwithRisk=0;
               
       if(ConVsLineItem.containsKey(acciD)){
                    String FinalLineitemList='';
                   String ConDescrip=''; 
       for(FCST_Contract__c Con :ConVsLineItem.get(acciD)){
        if(Con.Contract_Description__c!=null){
            ConDescrip=Con.Contract_Description__c;
            
        }else{
            ConDescrip='';
        }
                        Decimal totalConLevelActual=0,ConLevelactualAmount1=0,ConLevelactualAmount2=0,ConLevelactualAmount3=0,ConLevelactualAmount4=0,ConLevelactualAmount5=0,ConLevelactualAmount6=0,ConLevelactualAmount7=0,ConLevelactualAmount8=0,ConLevelactualAmount9=0,ConLevelactualAmount10=0,ConLevelactualAmount11=0,ConLevelactualAmount12=0;
                        String ConLineItemmList='',AllLineItems='';
                        
       if(ConidVsLineItem.containsKey(Con.Id)){
                            
       for(String str :ConidVsLineItem.get(Con.Id)){
                            
                                    String BaselineLineItemrow='';
                                    String AF1,AF2,AF3,AF4,AF5,AF6,AF7,AF8,AF9,AF10,AF11,AF12;
                                    String LineItemmList='';
                                    Set<id> LineSet = new Set<id>();
                                    id Lineitemi;
                            
       if(mapConIdvsConlineItemList.containsKey(str)){
                              List<Contract_LineItem__c> ContactLineItemList=mapConIdvsConlineItemList.get(str);
                            String Descrip='';  
       for(Contract_LineItem__c ConLineItemObj:ContactLineItemList){
                                Descrip=ConLineItemObj.Line_Description__c;
//************************************** Actual string calculation Start ************************************************                
                     Decimal totalActual=0,actualAmount1=0,actualAmount2=0,actualAmount3=0,actualAmount4=0,actualAmount5=0,actualAmount6=0,actualAmount7=0,actualAmount8=0,actualAmount9=0,actualAmount10=0,actualAmount11=0,actualAmount12=0;
                         
       if(LineItemIdVsActualList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name)){
                        List<Actual_Model__c> getActualList=LineItemIdVsActualList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name);

       for(Actual_Model__c actobj:getActualList){
                     String fiscalPeriod=actobj.Fiscal_Period__r.Name;
                     String planningP = fiscalPeriod.split('P')[1];
                    
                     if( planningP=='01'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount1+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount1+=actualAmount1;
                                     AccLevelactualAmount1=ConLevelactualAmount1;
                                    
                    }
                    else if( planningP=='02'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount2+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount2+=actualAmount2;
                                      AccLevelactualAmount2=ConLevelactualAmount2;
                       
                        
                    }
                    else if( planningP=='03'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount3+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount3+=actualAmount3;
                                     AccLevelactualAmount3=ConLevelactualAmount3;
                                    
                       
                    }
                    else if( planningP=='04'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount4+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount4+=actualAmount4;
                                      AccLevelactualAmount4=ConLevelactualAmount4;
                        
                    }
                    else if( planningP=='05'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount5+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount5+=actualAmount5;
                                     AccLevelactualAmount5=ConLevelactualAmount5;
                       
                    }
                    else if( planningP=='06'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount6+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount6+=actualAmount6;
                                     AccLevelactualAmount6=ConLevelactualAmount6;
                       
                    }
                    else if( planningP=='07'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                    actualAmount7+=actobj.Actual_Amount__c; 
                                    ConLevelactualAmount7+=actualAmount7;
                                    AccLevelactualAmount7=ConLevelactualAmount7;
                    }
                    else if( planningP=='08'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount8+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount8+=actualAmount8;
                                      AccLevelactualAmount8=ConLevelactualAmount8;
                    }
                    else if( planningP=='09'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount9+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount9+=actualAmount9;
                                      AccLevelactualAmount9=ConLevelactualAmount9;
                    }
                    else if( planningP=='10'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount10+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount10+=actualAmount10;
                                     AccLevelactualAmount10=ConLevelactualAmount10;
                    }
                    else if( planningP=='11'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount11+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount11+=actualAmount11;
                                     AccLevelactualAmount11=ConLevelactualAmount11;
                    }
                    else if( planningP=='12'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount12+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount12+=actualAmount12;
                                      AccLevelactualAmount12=ConLevelactualAmount12;
                    }
                              totalActual=actualAmount1+actualAmount2+actualAmount3+actualAmount4+actualAmount5+actualAmount6+actualAmount7+actualAmount8+actualAmount9+actualAmount10+actualAmount11+actualAmount12;

                    }
                    }

                
                
//***************************************************************** Actual string calculation end *********************************************************************************** 
                                
                                
                  
                                      
                   

      if(mapLineNameVsContactList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name)){
                    
                    Set<id> ModelId = new Set<id>();
                    ID ModelIdd,ModelIdd1,ModelIdd2,ModelIdd3,ModelIdd4,ModelIdd5,ModelIdd6,ModelIdd7,ModelIdd8,ModelIdd9,ModelIdd10,ModelIdd11,ModelIdd12,ModelRisk ;
                    Decimal MAmount1=0,MAmount2=0,MAmount3=0,MAmount4=0,MAmount5=0,MAmount6=0,MAmount7=0,MAmount8=0,MAmount9=0,MAmount10=0,MAmount11=0,MAmount12=0,TotalMAmount=0;
                    Decimal ForecastwithRisk1=0,ForecastwithRisk2=0,ForecastwithRisk3=0,ForecastwithRisk4=0,ForecastwithRisk5=0,ForecastwithRisk6=0,ForecastwithRisk7=0,ForecastwithRisk8=0,ForecastwithRisk9=0,ForecastwithRisk10=0,ForecastwithRisk11=0,ForecastwithRisk12=0,TotalForecastwithRisk=0;
                    Decimal RiskAmount1=0,RiskAmount2=0,RiskAmount3=0,RiskAmount4=0,RiskAmount5=0,RiskAmount6=0,RiskAmount7=0,RiskAmount8=0,RiskAmount9=0,RiskAmount10=0,RiskAmount11=0,RiskAmount12=0,TotalRiskAmount=0;
                  
                     List<FCST_Initial_Forecast__c> getInitialForecastModelList=mapLineNameVsContactList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name);
                                                  Decimal RiskFectorr=0;
      if(ConLineItemObj.Risk_Factor__c!=null){
                                   RiskFectorr=ConLineItemObj.Risk_Factor__c;   
                                   }
                                  Lineitemi=ConLineItemObj.id;
                                  LineSet.add(Lineitemi);
                    
                    
      for(FCST_Initial_Forecast__c InitialForecastModelObj:getInitialForecastModelList){ 
                          Decimal RiskAmount=0; 
      if(InitialForecastModelObj.RiskAmount__c!=null){
                          RiskAmount=InitialForecastModelObj.RiskAmount__c*(-1);   
                         }
                          String fiscalPeriod=InitialForecastModelObj.FCST_Planning_Fiscal_Year__r.Name; 
                          String planningP = fiscalPeriod.split('P')[1];
                         
                          
             if( planningP=='01' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount1=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount1+=MAmount1;
                                        ForecastwithRisk1=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk1+=ForecastwithRisk1;
                                        RiskAmount1=RiskAmount;
                                        ModelIdd1=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd1);
                                         
                                     }
             else if( planningP=='02'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount2=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount2+=MAmount2;
                                        ForecastwithRisk2=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk2+=ForecastwithRisk2;
                                        RiskAmount2=RiskAmount;
                                        ModelIdd2=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd2);
                                     }
           else if( planningP=='03'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount3=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount3+=MAmount3;
                                        ForecastwithRisk3=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk3+=ForecastwithRisk3;
                                        RiskAmount3=RiskAmount;
                                        ModelIdd3=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd3);
                                     }
          else if( planningP=='04'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount4=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount4+=MAmount4;
                                        ForecastwithRisk4=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk4+=ForecastwithRisk4;
                                        RiskAmount4=RiskAmount;
                                        ModelIdd4=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd4);
                                     }
          else if( planningP=='05'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount5=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount5+=MAmount5;
                                        ForecastwithRisk5=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk5+=ForecastwithRisk5;
                                        RiskAmount5=RiskAmount;
                                        ModelIdd5=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd5);
                                     }
         else if( planningP=='06'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount6=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount6+=MAmount6;
                                        ForecastwithRisk6=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk6+=ForecastwithRisk6;
                                        RiskAmount6=RiskAmount;
                                        ModelIdd6=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd6);
                                     }
         else if( planningP=='07'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount7=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount7+=MAmount7;
                                        ForecastwithRisk7=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk7+=ForecastwithRisk7;
                                        RiskAmount7=RiskAmount;
                                        ModelIdd7=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd7);
                                     }
         else if( planningP=='08'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount8=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount8+=MAmount8;
                                        ForecastwithRisk8=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk8+=ForecastwithRisk8;
                                        RiskAmount8=RiskAmount;
                                        ModelIdd8=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd8);
                                          
                                     }
         else if( planningP=='09' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount9=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount9+=MAmount9;
                                        ForecastwithRisk9=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk9+=ForecastwithRisk9;
                                        RiskAmount9=RiskAmount;
                                        ModelIdd9=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd9);
                                     }
         else if( planningP=='10' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount10=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount10+=MAmount10;
                                        ForecastwithRisk10=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk10+=ForecastwithRisk10;
                                        RiskAmount10=RiskAmount;
                                        ModelIdd10=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd10);
                                     }
         else if( planningP=='11' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount11=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount11+=MAmount11;
                                        ForecastwithRisk11=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk11+=ForecastwithRisk11;
                                        RiskAmount11=RiskAmount;
                                        ModelIdd11=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd11);
                                        
                                     }
          else if( planningP=='12' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount12=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount12+=MAmount12;
                                        ForecastwithRisk12=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk12+=ForecastwithRisk12;
                                        RiskAmount12=RiskAmount;
                                        ModelIdd12=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd12);
                                     }
                         
                         
                         
                                     }//itrretion closed
                                        if(strPlanningVersion==Planversion){
                                           editableCell=true;
                                       }else {
                                           editableCell=false;
                                       }
                                     
                         TotalRiskAmount=RiskAmount1+RiskAmount2+RiskAmount3+RiskAmount4+RiskAmount5+RiskAmount6+RiskAmount7+RiskAmount8+RiskAmount9+RiskAmount10+RiskAmount11+RiskAmount12;            
                         TotalForecastwithRisk=ForecastwithRisk1+ForecastwithRisk2+ForecastwithRisk3+ForecastwithRisk4+ForecastwithRisk5+ForecastwithRisk6+ForecastwithRisk7+ForecastwithRisk8+ForecastwithRisk9+ForecastwithRisk10+ForecastwithRisk11+ForecastwithRisk12;            
                         TotalMAmount=MAmount1+MAmount2+MAmount3+MAmount4+MAmount5+MAmount6+MAmount7+MAmount8+MAmount9+MAmount10+MAmount11+MAmount12;            
                        
                        
                         BaselineLineItemrow='<tr><th Style="background-color: #D9D9D9;" class=BaseLineCon'+acciD+'><a style="color:black" target="_blank"  href="/'+ConLineItemObj.Id+'" title="LineItem Name"> '+ConLineItemObj.name+' <span id='+ConLineItemObj.Id+'Sign></span></a></th><th Style="text-align: center;background-color: #D9D9D9;color:black;" class=BaseLineCon'+acciD+'> '+ConLineItemObj.Line_Description__c+' </th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th></tr>'; 
                         String  LineItemActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalActual.setscale(0).format(), args2)+'</th></tr>';   
                         String  forcastWithRisk='<tr><th  title="Forecast With Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ForecastwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';  
                         String B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13; 
                         
                    String  Risk='<tr ><th title="Risk" class=BaseLineCon'+acciD+'  style="background-color:white;color:black;text-align: right;">Risk</th><th style="background-color:white;"></th>';
                   if(RiskAmount1!=null && RiskAmount1!=0){
                   C1='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount1.setscale(0).format(), args2)+')'+'</th>';
                     
                       } else{
                   C1='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount2!=null && RiskAmount2!=0){
                   C2='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount2.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C2='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount3!=null && RiskAmount3!=0){
                   C3='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount3.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C3='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount4!=null && RiskAmount4!=0){
                   C4='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount4.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C4='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount5!=null && RiskAmount5!=0){
                   C5='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount5.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C5='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount6!=null && RiskAmount6!=0){
                   C6='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount6.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C6='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                    if(RiskAmount7!=null && RiskAmount7!=0){
                   C7='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount7.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C7='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                    if(RiskAmount8!=null && RiskAmount8!=0){
                   C8='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount8.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C8='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount9!=null && RiskAmount9!=0){
                   C9='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount9.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C9='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount10!=null && RiskAmount10!=0){
                   C10='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount10.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C10='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount11!=null && RiskAmount11!=0){
                   C11='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount11.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C11='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount12!=null && RiskAmount12!=0){
                   C12='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount12.setscale(0).format(), args2)+')'+'</th>';
                       } else{
                   C12='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(TotalRiskAmount!=null && TotalRiskAmount!=0){
                   C13='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(TotalRiskAmount.setscale(0).format(), args2)+')'+'</th>'; 
                       } else{
                   C13='<th style="text-align: center;background-color:#D0CECE;">$0</th></tr>';
                       }

                  
                  Risk+=C1+C2+C3+C4+C5+C6+C7+C8+C9+C10+C11+C12+C13;   
                

                
                         
                         
                         
                           
                   String  WithoutRisk='<tr ><th title="Forecast without Risk" class=bestOppRow'+acciD+' style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th><th style="background-color:white;"></th>';
                   if(MAmount1!=null && ModelId.contains(ModelIdd1)){
                   B1='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd1+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount1.setscale(0).format(), args2)+'</div></th>';
                     
                       } else{
                   B1='<th style="text-align: center;">$0</th>';
                       }
                   if(MAmount2!=null && ModelId.contains(ModelIdd2)){
                   B2='<th style="background-color:white;text-align: center; "><div  class=mostlLikelyOpp'+acciD+' id='+ModelIdd2+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount2.setscale(0).format(), args2)+'</div></th>';
                       } else{
                   B2='<th style="text-align: center;">$0</th>';
                       }
                   if(MAmount3!=null && ModelId.contains(ModelIdd3)){
                   B3='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd3+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount3.setscale(0).format(), args2)+'</div></th>';
                                          } else{
                   B3='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount4!=null && ModelId.contains(ModelIdd4)){
                   B4='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd4+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount4.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B4='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount5!=null && ModelId.contains(ModelIdd5)){ 
                   B5='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd5+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount5.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B5='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount6!=null && ModelId.contains(ModelIdd6)){
                   B6='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd6+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount6.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B6='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount7!=null && ModelId.contains(ModelIdd7)){
                   B7='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd7+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount7.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B7='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount8!=null && ModelId.contains(ModelIdd8)){
                   B8='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd8+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount8.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B8='<th style="text-align: center;">$0</th>';
                       }
                  
                  if(MAmount9!=null && ModelId.contains(ModelIdd9)){
                   B9='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd9+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount9.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B9='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount10!=null && ModelId.contains(ModelIdd10)){
                   B10='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd10+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount10.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B10='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount11!=null && ModelId.contains(ModelIdd11)){
                   B11='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd11+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount11.setscale(0).format(), args2)+'</div></th>';
                                        } else{
                   B11='<th style="text-align: center;">$0</th>'; 
                       }
                 
                  if(MAmount12!=null && ModelId.contains(ModelIdd12)){
                   B12='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd12+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount12.setscale(0).format(), args2)+'</div></th>';
                                         } else{
                   B12='<th style="text-align: center;">$0</th>';
                       }
                  
                  WithoutRisk+=B1+B2+B3+B4+B5+B6+B7+B8+B9+B10+B11+B12+'<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalMAmount.setscale(0).format(), args2)+'</th></tr>';   
                
                           String RiskFactor='<tr><th title="Risk Factor" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Risk Factor</th><th style="background-color:white;"></th>';
                                if(RiskFectorr!=null){
                                   AF1='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+Lineitemi+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningLineItemChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr.setscale(0).format(), args2)+'%</div></th>';
                             
                                  } else{
                           AF1='<th style="text-align: center;">$0</th>';
                               }
                           RiskFactor+=AF1+'<th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th><th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th></tr>';                   
                        
                        
                         AllLineItems=BaselineLineItemrow+LineItemActualAmount+WithoutRisk+forcastWithRisk+Risk+RiskFactor;    
                                     
                                  }//model if closed
                              }//Lineitem for loop Closed
                              }//Lineitem If Closed
                           ConLineItemmList+=AllLineItems;//+LineItemmList; 
                         }//ConidVsLineItem for loop closed
                        
                         }//ConidVsLineItem if Closed
                       TotalConLevelMAmount=ConLevelMAmount1+ConLevelMAmount2+ConLevelMAmount3+ConLevelMAmount4+ConLevelMAmount5+ConLevelMAmount6+ConLevelMAmount7+ConLevelMAmount8+ConLevelMAmount9+ConLevelMAmount10+ConLevelMAmount11+ConLevelMAmount12;
                       TotalConForecastwithRisk=ConForecastwithRisk1+ConForecastwithRisk2+ConForecastwithRisk3+ConForecastwithRisk4+ConForecastwithRisk5+ConForecastwithRisk6+ConForecastwithRisk7+ConForecastwithRisk8+ConForecastwithRisk9+ConForecastwithRisk10+ConForecastwithRisk11+ConForecastwithRisk12;
                       totalConLevelActual=ConLevelactualAmount1+ConLevelactualAmount2+ConLevelactualAmount3+ConLevelactualAmount4+ConLevelactualAmount5+ConLevelactualAmount6+ConLevelactualAmount7+ConLevelactualAmount8+ConLevelactualAmount9+ConLevelactualAmount10+ConLevelactualAmount11+ConLevelactualAmount12;
                        String BaselineContactrow='<tr><th Style="background-color: #D9D9D9;" class=BaseLineCon'+acciD+'><a style="color:black" target="_blank"  href="/'+Con.Id+'" title="Contact Name"> '+Con.Contract__c+' <span id='+Con.Id+'Sign></span></a></th><th Style="text-align: center;background-color: #D9D9D9;color:black;" class=BaseLineCon'+acciD+'> '+ConDescrip+' </th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th></tr>';
                       
                        String  BaseLineTotalFCSTinclRisk='<tr title="Total FCST incl Risk"style="padding-left: 100px;"><th class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th></tr>'; 
                        String  BaselineTotalFCST='<tr ><th  title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Forecast with Risk</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';
                        String  BaselineActuallAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalConLevelActual.setscale(0).format(), args2)+'</th></tr>';   
                       
                       
                       BaseLineRowBody+=BaselineContactrow+BaselineActuallAmount+BaseLineTotalFCSTinclRisk+BaselineTotalFCST+ConLineItemmList; 
                        }//Contact for loop closed 
                      }//Contact if Closed
           totalAccLevelActual= AccLevelactualAmount1+AccLevelactualAmount2+AccLevelactualAmount3+AccLevelactualAmount4+AccLevelactualAmount5+AccLevelactualAmount6+AccLevelactualAmount7+AccLevelactualAmount8+AccLevelactualAmount9+AccLevelactualAmount10+AccLevelactualAmount11+AccLevelactualAmount12;
           String accountRow='<tr style="background-color:#F2F2F2;"><th style="background-color:#F2F2F2;size: 10%;"><b style="position: relative; left: 168px;border-left: white;"><a title="Account Name" style="color:black;  target="_blank"  href="/'+acciD+'" target="_blank">'+ConHavingAccountIdName.get(acciD)+'</a></b><th style="background-color:#F2F2F2;size: 10%;"></th> </th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;font-weight: bold;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th></tr>';  
           String  TotalforcastWithRisk='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;position: relative; right: 0px;border-left: #D0CECE;"><b style="position: relative; left: -69px;border-left: #D0CECE;">  Forecast with Risk</b></th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';  
           String  TotalforWithoutRisk='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th title=" Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;position: relative; right: 0px;border-left: #D0CECE;"><b style="position: relative; left: -75px;border-left: #D0CECE;">  Forecast without Risk</b></th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th></tr>';  
           String  ActualAmount='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;"><b style="position: relative; left: -66px;border-left: white;">Actual Amount</b></th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalAccLevelActual.setscale(0).format(), args2)+'</th></tr>';   
           String  BaseLineRow='<tr><th title="Forecast Category" class=worstRow'+acciD+'  style="background-color:#FFE699;color:black;size: 10%;font-size: 110%;border-right-color: #FFE699;"><b style="position: relative;left: 611px;">Baseline Amount</b></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th></tr>';
           
        tableBody+=accountRow+ActualAmount+TotalforWithoutRisk+TotalforcastWithRisk+BaseLineRow+BaseLineRowBody;  
         
       }
    
      mapConIdvsConlineItemList.clear();
      ConHavingAccountIdName.clear();
      mapLineNameVsContactList.clear();
      
        
        
      tableRecord+=tableBody+'</table>'; 
      if(tableBody!='')
      IsTableDataPresent = true;
      tableBlock=tableRecord;
       //USAGE
            System.debug('fetchOppRecord 1.getQueries>>>>>>>: ' + Limits.getQueries());
            System.debug('fetchOppRecord 2.getQueryRows>>>>> ' + Limits.getQueryRows());
            System.debug('fetchOppRecord 3.getDmlRows>>>>>>> ' + Limits.getDmlRows());
            System.debug('fetchOppRecord 4.getDmlStatements>>>>> ' + Limits.getDmlStatements());
            System.debug('fetchOppRecord 5.getCpuTime>>>>>>>>>' + Limits.getCpuTime());
            System.debug('fetchOppRecord 6.getHeapSize>>>>>>>>>' + Limits.getHeapSize());
             //LIMITS
             
            System.debug('fetchOppRecord 1. TOtal LIMITs getQueries>>>>>>>: ' + Limits.getLimitQueries());
            System.debug('fetchOppRecord 2.  TOtal LIMITs getQueryRows>>>>> ' + Limits.getLimitQueryRows());
            System.debug('fetchOppRecord 3.  TOtal LIMITs getDmlRows>>>>>>> ' + Limits.getLimitDmlRows());
            System.debug('fetchOppRecord 4.  TOtal LIMITs getDmlStatements>>>>> ' + Limits.getLimitDmlStatements());
            System.debug('fetchOppRecord 5.  TOtal LIMITs getCpuTime>>>>>>>>>' + Limits.getLimitCpuTime());
            System.debug('fetchOppRecord 6.  TOtal LIMITs getHeapSize>>>>>>>>>' + Limits.getLimitHeapSize());
            
          
       }
         catch(Exception e){
            System.debug('Exception error Message>>>>>>> '+e);
            System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
        }
       
  
           
            
        return null;
    }
    
     //??>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Data Saving functionality start>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    public pageReference updatePlanningModel(){
        try{   
            String planningModelStr=Apexpages.currentPage().getParameters().get('id');
            Id planningModelId;
            if(planningModelStr!=null)
               planningModelId=Id.valueOf(planningModelStr);
               String planningModelAmount=Apexpages.currentPage().getParameters().get('planningModelAmount');
               Decimal planningModelDecimal;
               if(planningModelAmount!=null)
                  planningModelDecimal=decimal.valueOf(planningModelAmount); 
               List<FCST_Initial_Forecast__c> planningModelList=[Select Id,Name,Contract_LineItem__c,Fcst_Amount__c,Risk_Factor__c,Planning_Version__c,Planning_Version__r.name from FCST_Initial_Forecast__c where Id=:planningModelId];
               if(planningModelList.Size()>0 ){
                  planningModelList[0].Fcst_Amount__c=Math.round(planningModelDecimal);
                  update planningModelList;
               }
            }catch(Exception e){
                   System.debug('Exception error Message>>>>>>> '+e);
                   System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
            }
            return null;
     }
   
    
    public pageReference updateRiskFector(){
      try{
          String planningModelStr=Apexpages.currentPage().getParameters().get('id');
          Id planningModelId;
          if(planningModelStr!=null)
             planningModelId=Id.valueOf(planningModelStr);
             String planningLineAmount=Apexpages.currentPage().getParameters().get('planningLineAmount');
             Decimal planningModelDecimal;
             if(planningLineAmount!=null)
                planningModelDecimal=decimal.valueOf(planningLineAmount); 
             Contract_LineItem__c lineRecord =[select id,Risk_Factor__c from Contract_LineItem__c where id=:planningModelId limit 1];
             if(lineRecord !=null){
                lineRecord.Risk_Factor__c =planningModelDecimal;
                update lineRecord;
             }
          } catch(Exception e){
                  System.debug('Exception error Message>>>>>>> '+e);
                  System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
          }
  return null;     
 }
    
    
    
    
    
  
    public  string getmonthName(Integer monthNumber){
        String monthName;
         if(monthNumber==1)monthName='January';
        if(monthNumber==2)monthName='February';
        if(monthNumber==3)monthName='March';
        if(monthNumber==4)monthName='April';
        if(monthNumber==5)monthName='May';
        if(monthNumber==6)monthName='June';
        if(monthNumber==7)monthName='July';
        if(monthNumber==8)monthName='August';
        if(monthNumber==9)monthName='September';
        if(monthNumber==10)monthName='October';
        if(monthNumber==11)monthName='November';
        if(monthNumber==12)monthName='December';return monthName;  
    }
    
     
    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
    public pagereference BackPage(){
        PageReference pg = new Pagereference('/apex/FCST_CompucomSummaryWorkBench?pv='+pVVersionStringId+'&su='+UserStringId+'&AccId='+AccountN);
        pg.setredirect(true);
        return pg;
    }
        
 
    
   
}