public with sharing class FCST_CompucomBaseLineWorkbenchC { 
   
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
    List<String> conNameList;
    Public String conName='';


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
       
    
  public FCST_CompucomBaseLineWorkbenchC(){  
         try{ 
         strLine='All';
                     IsTableDataPresent = true;
                     conList = new List<FCST_Contract__c>();
                     lineSet = new Set<String>();
                     contractSet = new Set<String>();
                     yearList= new List<Integer>();
            List<Account> accountList = new List<Account>();
            List<Account> NewAccountList = new List<Account>();
            conNameList = new List<String>();
            accountSet = new Set<String>();
            planningPeriod='Planning Period';
            system.debug('AccounttttttId>>>>'+AccountN );
            
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
                            
            String conQuery ='Select id,name,Contract__c from FCST_Contract__c where Fcst_Account__r.id =:AccountN and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and Account__r.id=:AccountN ) and FCST_Contract_Created_Year__c <: currentYear  LIMIT 15000';
            conList = Database.query(conQuery);
            
            if(!conList.isEmpty()){
               strContract =String.valueOf(conList[0].Contract__c+'#'+conList[0].name);
            }
             for(FCST_Contract__c conObj: conList){
                contractSet.add(conObj.Contract__c+'#'+conObj.name);
                 system.debug('Lineeeeeeeee>>>>>'+conObj.name);
            }
            
             
           lineSet.add('All');
           
            if(strContract!='' && strContract!=null && strContract!='All'){
             conNameList = strContract.split('#');
             conName = conNameList[conNameList.size()-1];
          system.debug('LineeeeeeeeeR>>>>>'+conName );
          
           String lineQuery ='Select id,name,FCST_Contract__r.name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.name=:conName and FCST_Contract__r.id!=null and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion) ORDER BY Name LIMIT 15000';

           lineList = Database.query(lineQuery);
            }
            system.debug('Lineeeeeeeee>>>>>'+lineList);
          if(lineList!=null && lineList.size()>0){
                       for(Contract_LineItem__c lineObj: lineList){ 
              
                 lineSet.add(lineObj.name);
                
                 contractSet.add(lineObj.FCST_Contract__r.Contract__c+'#'+lineObj.FCST_Contract__r.name);
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
     strLine='All';
             conNameList = strContract.split('#');
             conName = conNameList[conNameList.size()-1];
           conList = new List<FCST_Contract__c>(); 
           lineList = new List<Contract_LineItem__c>();
           lineSet = new Set<String>();
           String conQuery ='Select id,name from FCST_Contract__c where name=:conName';
           conList = Database.query(conQuery);

           lineSet.add('All');
           if(strContract!=''){
           String lineQuery ='Select id,name from Contract_LineItem__c where FCST_Contract__r.name=:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where  Contract_LineItem__r.id !=null and Planning_Version__r.Name=:strPlanningVersion) order by name';
           
           lineList = Database.query(lineQuery);
            system.debug('Lineeeeeeeee1>>>>>'+lineList );
            for(Contract_LineItem__c lineObj: lineList){
                lineSet.add(lineObj.name);
            }
           }          
        system.debug('Lineeeeeeeee2>>>>>'+lineSet);
       
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
      
        String coontactQuery ='Select Contract__c,Name from FCST_Contract__c where Fcst_Account__r.name =:straccount and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion ) and FCST_Contract_Created_Year__c <: currentYear ';
        List<FCST_Contract__c> totalContactList=database.query(coontactQuery);
         system.debug('Lineeeeeeeee3>>>>>'+totalContactList);
         for(FCST_Contract__c cont:totalContactList){
          contractSet.add(cont.Contract__c+'#'+cont.name);
       }
       
       String ContactlineInnerQuery ='Select id,FCST_Contract__r.Fcst_Account__r.Id,FCST_Contract__r.Fcst_Account__r.Name,name,FCST_Contract__c,FCST_Contract__r.name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.name=:conName and  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where FCST_Contract__r.name=:conName and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr )';
          
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
       
       
       
       
       
       
       
      
      String ContactQuery='Select id,name,Contract_Description__c,Fcst_Account__r.id,Fcst_Account__r.Name,Contract__c from FCST_Contract__c where Id<>null and Name=:conName and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where FCST_Contract__r.name=:conName and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and FCST_Contract_Created_Year__c <: currentYear ';
             if(strContract!='All' && strContract!=null && String.isNotBlank(strContract)){
                ContactQuery +=' and name=:conName';
           }
            ContactQuery +=' order by Name LIMIT 15000';
          
            List<FCST_Contract__c> ContactLisst=database.query(ContactQuery); 
            for(FCST_Contract__c Con:ContactLisst){
                 contractSet.add(Con.Contract__c+'#'+Con.name);
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
           system.debug('checkkkkkkkkkk>>>>'+ConHavingAccountIdName);
      for(Contract_LineItem__c ConLineObj:[select Id,Name,FCST_Contract__r.id,Line_Description__c,FCST_Fiscal_Year_List__c from Contract_LineItem__c  where  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and id<>null and ID IN:LineHavingLineItemName.keySet() order by Name limit :list_size  offset :counter]){   
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
        
        
        
    String  tableRecord='<table id="table_id" class="slds-table slds-table--bordered slds-table--cell-buffer"><tr class="slds-text-title--caps"><th style="background-color: #313A8B;border-bottom-color: #313A8B;border-right-color: #313A8B;border-left-color: #313A8B;"></th><th  style="background-color: #313A8B;;border-left-color:#313a8b;width:20%;text-align: center;" rowspan="2"><label  style="color: white;position: relative; right: 53%;" >Account/Contract</label></th><th  colspan="13" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" ><b>Planning Year</b><b class="Ram"  style="color: white;"> - '+globalYear+'</b></label></th></tr><tr class="slds-text-title--caps"><th style="background-color: #313A8B;border-left-color: #313A8B;border-right-color: #313A8B;border-top-color: #313A8B;"></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jan</label></th><th   class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Feb</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Mar</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Apr</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >May</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jun</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jul</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Aug</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Sep</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Oct</label></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Nov</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Dec</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Total</label></th></tr>';          
    String tableBody='';
          List<String> args2 = new String[]{'0','number','###,###,###'};
          String j = 'FY'+globalYear+'%';
       
       
          //><>>>>>>>>>>>>>>>>>>>>>>>>>>Actual calculation>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        String actualQuery = 'select id,Name,Account__c,Actual_Amount__c,Contract_LineItem__r.Name,FCST_Contract__r.id,FCST_Planning_Version__r.Name,Fiscal_Period__r.Name from Actual_Model__c where  FCST_Contract__r.name=:conName and Account__r.name =:straccount and FCST_Contract__r.FCST_Contract_Created_Year__c <: currentYear  and FCST_Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name LIKE :j and id!=null LIMIT 15000';            
           
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
                        Decimal ConForecast1=0,ConForecastwithRisk1=0,ConForecastwithRisk2=0,ConForecastwithRisk3=0,ConForecastwithRisk4=0,ConForecastwithRisk5=0,ConForecastwithRisk6=0,ConForecastwithRisk7=0,ConForecastwithRisk8=0,ConForecastwithRisk9=0,ConForecastwithRisk10=0,ConForecastwithRisk11=0,ConForecastwithRisk12=0,TotalConForecastwithRisk=0;
               String ConDescrip='',ContactrDescrip='';
       if(ConVsLineItem.containsKey(acciD)){
                    String FinalLineitemList='';
                    
       for(FCST_Contract__c Con :ConVsLineItem.get(acciD)){
        if(Con.Contract_Description__c!=null){
            ConDescrip=Con.Contract_Description__c;
            ContactrDescrip=ConDescrip;
        }else{
            ConDescrip='';
        }
        if(ConDescrip.length()>25){
                                 ConDescrip = ConDescrip.substring(0,25)+'...';
                            }
       
       
                        Decimal totalConLevelActual=0,ConLevelactualAmount1=0,ConLevelactualAmount2=0,ConLevelactualAmount3=0,ConLevelactualAmount4=0,ConLevelactualAmount5=0,ConLevelactualAmount6=0,ConLevelactualAmount7=0,ConLevelactualAmount8=0,ConLevelactualAmount9=0,ConLevelactualAmount10=0,ConLevelactualAmount11=0,ConLevelactualAmount12=0;
                        String ConLineItemmList='',AllLineItems='';
                        
       if(ConidVsLineItem.containsKey(Con.Id)){
                            
       for(String str :ConidVsLineItem.get(Con.Id)){
                            
                                    String BaselineLineItemrow='';
                                    String LineItemmList='';
                                    Set<id> LineSet = new Set<id>();
                                    id Lineitemi;
                            
       if(mapConIdvsConlineItemList.containsKey(str)){
                              List<Contract_LineItem__c> ContactLineItemList=mapConIdvsConlineItemList.get(str);
                            String Descrip='';
                            Integer i=0;  
       for(Contract_LineItem__c ConLineItemObj:ContactLineItemList){
                                Descrip=ConLineItemObj.Line_Description__c;
//************************************** Actual string calculation Start ************************************************                
                     Decimal totalActual=0,actualAmount1=0,actualAmount2=0,actualAmount3=0,actualAmount4=0,actualAmount5=0,actualAmount6=0,actualAmount7=0,actualAmount8=0,actualAmount9=0,actualAmount10=0,actualAmount11=0,actualAmount12=0;
                         
       if(LineItemIdVsActualList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name)){
                        List<Actual_Model__c> getActualList=LineItemIdVsActualList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name);

       for(Actual_Model__c actobj:getActualList){
                     String fiscalPeriod=actobj.Fiscal_Period__r.Name;
                     String planningP = fiscalPeriod.split('P')[1];
                    Decimal ActuallForAll=actobj.Actual_Amount__c;
                     if( planningP=='01'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount1+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount1+=actobj.Actual_Amount__c;
                                     AccLevelactualAmount1=ConLevelactualAmount1;
                                    
                                    
                    }
                    else if( planningP=='02'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount2+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount2+=actobj.Actual_Amount__c;
                                      AccLevelactualAmount2=ConLevelactualAmount2;
                        
                    }
                    else if( planningP=='03'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount3+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount3+=actobj.Actual_Amount__c;
                                     AccLevelactualAmount3=ConLevelactualAmount3;
                       
                    }
                    else if( planningP=='04'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount4+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount4+=actobj.Actual_Amount__c;
                                      AccLevelactualAmount4=ConLevelactualAmount4;
                    }
                    else if( planningP=='05'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount5+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount5+=actobj.Actual_Amount__c;
                                     AccLevelactualAmount5=ConLevelactualAmount5;
                    }
                    else if( planningP=='06'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount6+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount6+=actobj.Actual_Amount__c;
                                     AccLevelactualAmount6=ConLevelactualAmount6;
                    }
                    else if( planningP=='07'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                    actualAmount7+=actobj.Actual_Amount__c;
                                    ConLevelactualAmount7+=actobj.Actual_Amount__c;
                                    AccLevelactualAmount7=ConLevelactualAmount7; 
                    }
                    else if( planningP=='08'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount8+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount8+=actobj.Actual_Amount__c;
                                      AccLevelactualAmount8=ConLevelactualAmount8;
                    }
                    else if( planningP=='09'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount9+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount9+=actobj.Actual_Amount__c;
                                      AccLevelactualAmount9=ConLevelactualAmount9;
                    }
                    else if( planningP=='10'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount10+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount10+=actobj.Actual_Amount__c;
                                     AccLevelactualAmount10=ConLevelactualAmount10;
                    }
                    else if( planningP=='11'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount11+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount11+=actobj.Actual_Amount__c;
                                     AccLevelactualAmount11=ConLevelactualAmount11;
                    }
                    else if( planningP=='12'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount12+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount12+=actobj.Actual_Amount__c;
                                      AccLevelactualAmount12=ConLevelactualAmount12;
                    }
                              totalActual=actualAmount1+actualAmount2+actualAmount3+actualAmount4+actualAmount5+actualAmount6+actualAmount7+actualAmount8+actualAmount9+actualAmount10+actualAmount11+actualAmount12;
                                     
                                    
                                     
                                      
                                    
                                     
                    }
                    
                    
                    }

         String Av1,Av2,Av3,Av4,Av5,Av6,Av7,Av8,Av9,Av10,Av11,Av12,Av13;
           
            String  LineItemActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount </th><th style="background-color:white;"></th>';
           
           if(actualAmount1<0){
           Av1='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#01#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount1*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av1='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#01#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount1.setscale(0).format(), args2)+'</div></th>';
           }
           
           
           if(actualAmount2<0){
           Av2='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#02#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount2*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av2='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#02#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount2.setscale(0).format(), args2)+'</div></th>';
           }
           
           
            if(actualAmount3<0){
           Av3='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#03#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount3*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av3='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#03#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount3.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount4<0){
           Av4='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#04#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount4*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av4='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#04#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount4.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount5<0){
           Av5='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#05#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount5*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av5='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#05#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount5.setscale(0).format(), args2)+'</div></th>';
           }


           if(actualAmount6<0){
           Av6='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#06#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount6*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av6='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#06#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount6.setscale(0).format(), args2)+'</div></th>';
           }


           if(actualAmount7<0){
           Av7='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#07#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount7*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av7='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#07#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount7.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount8<0){
           Av8='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#08#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount8*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
          Av8='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#08#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount8.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount9<0){
           Av9='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#09#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount9*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av9='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#09#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount9.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount10<0){
           Av10='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#10#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount10*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av10='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#10#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount10.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount11<0){
           Av11='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#11#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount11*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
           Av11='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#11#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount11.setscale(0).format(), args2)+'</div></th>';
           }



           if(actualAmount12<0){
           Av12='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#12#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$ ('+String.format((actualAmount12*-1).setscale(0).format(), args2)+')'+'</div></th>';
           
           } else{
           
          Av12='<th style="text-align: center;background-color:white;" class=BaseloneCon'+acciD+'><div id='+ConLineItemObj.Id+'#12#'+i+' style="text-align: center;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">$'+String.format(actualAmount12.setscale(0).format(), args2)+'</div></th>';
           }


           if(totalActual<0){
           Av13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((totalActual*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Av13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(totalActual.setscale(0).format(), args2)+'</th>';
           }


        LineItemActualAmount+=Av1+Av2+Av3+Av4+Av5+Av6+Av7+Av8+Av9+Av10+Av11+Av12+Av13;                          
                
//***************************************************************** Actual string calculation end *********************************************************************************** 
                                
                                
                  
                                      
                   

      if(mapLineNameVsContactList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name)){
                    
                    Set<id> ModelId = new Set<id>();
                     Set<id> Modelname = new Set<id>();
                    ID ModelNam1,ModelNam2,ModelNam3,ModelNam4,ModelNam5,ModelNam6,ModelNam7,ModelNam8,ModelNam9,ModelNam10,ModelNam11,ModelNam12 ;
                    ID ModelIdd,ModelIdd1,ModelIdd2,ModelIdd3,ModelIdd4,ModelIdd5,ModelIdd6,ModelIdd7,ModelIdd8,ModelIdd9,ModelIdd10,ModelIdd11,ModelIdd12,ModelRisk ;
                    Decimal MAmount1=0,MAmount2=0,MAmount3=0,MAmount4=0,MAmount5=0,MAmount6=0,MAmount7=0,MAmount8=0,MAmount9=0,MAmount10=0,MAmount11=0,MAmount12=0,TotalMAmount=0;
                    Decimal ForecastwithRisk1=0,FvdvdorecastwithRisk1=0,ForecastwithRisk2=0,ForecastwithRisk3=0,ForecastwithRisk4=0,ForecastwithRisk5=0,ForecastwithRisk6=0,ForecastwithRisk7=0,ForecastwithRisk8=0,ForecastwithRisk9=0,ForecastwithRisk10=0,ForecastwithRisk11=0,ForecastwithRisk12=0,TotalForecastwithRisk=0;
                    Decimal TotalwithRisk1=0,TotalwithRisk2=0,TotalwithRisk3=0,TotalwithRisk4=0,TotalwithRisk5=0,TotalwithRisk6=0,TotalwithRisk7=0,TotalwithRisk8=0,TotalwithRisk9=0,TotalwithRisk10=0,TotalwithRisk11=0,TotalwithRisk12=0,TotalTotalwithRisk=0;
                   String lineLabel='',lineLabelWrap='';
                    Decimal RiskAmount1=0,RiskAmount2=0,RiskAmount3=0,RiskAmount4=0,RiskAmount5=0,RiskAmount6=0,RiskAmount7=0,RiskAmount8=0,RiskAmount9=0,RiskAmount10=0,RiskAmount11=0,RiskAmount12=0,TotalRiskAmount=0;
                    Decimal RiskFectorr1=0,RiskFectorr2=0,RiskFectorr3=0,RiskFectorr4=0,RiskFectorr5=0,RiskFectorr6=0,RiskFectorr7=0,RiskFectorr8=0,RiskFectorr9=0,RiskFectorr10=0,RiskFectorr11=0,RiskFectorr12=0,TotalRiskFectorr=0;
                     List<FCST_Initial_Forecast__c> getInitialForecastModelList=mapLineNameVsContactList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name);
                                  Lineitemi=ConLineItemObj.id;
                                  LineSet.add(Lineitemi);
                    if(ConLineItemObj.Name != null && ConLineItemObj.Line_Description__c != null){
                            lineLabel = ConLineItemObj.Line_Description__c;
                            lineLabelWrap=lineLabel;
                            if(lineLabel.length()>25){
                                lineLabel = lineLabel.substring(0,25)+'...';
                            }
                        }
                    
      for(FCST_Initial_Forecast__c InitialForecastModelObj:getInitialForecastModelList){ 
                          Decimal RiskAmount=0; 
      if(InitialForecastModelObj.RiskAmount__c!=null){
                          RiskAmount=InitialForecastModelObj.RiskAmount__c;   
                         }
                          String fiscalPeriod=InitialForecastModelObj.FCST_Planning_Fiscal_Year__r.Name; 
                          String planningP = fiscalPeriod.split('P')[1];
                        // Decimal ForRisk=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                          
             if( planningP=='01' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount1=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount1+=MAmount1;
                                        
                                        RiskAmount1=RiskAmount;
                                        RiskFectorr1=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk1=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                      
                                        ConForecastwithRisk1+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ModelIdd1=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd1);
                                        
                                         
                                     }
             else if( planningP=='02'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount2=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount2+=MAmount2;
                                        RiskFectorr2=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        
                                        ForecastwithRisk2=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                          
                                        ConForecastwithRisk2+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount2=RiskAmount;
                                        
                                        ModelIdd2=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd2);
                                        
                                     }
           else if( planningP=='03'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount3=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount3+=MAmount3;
                                        RiskFectorr3=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk3=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                         
                                        ConForecastwithRisk3+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount3=RiskAmount;
                                       
                                        ModelIdd3=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd3);
                                     }
          else if( planningP=='04'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount4=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount4+=MAmount4;
                                        RiskFectorr4=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk4=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                         
                                        ConForecastwithRisk4+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount4=RiskAmount;
                                      
                                        ModelIdd4=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd4);
                                     }
          else if( planningP=='05'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount5=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount5+=MAmount5;
                                        RiskFectorr5=InitialForecastModelObj.Risk_Factor__c;
                                       TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk5=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                           
                                        ConForecastwithRisk5+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount5=RiskAmount;
                                       
                                        ModelIdd5=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd5);
                                     }
         else if( planningP=='06'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount6=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount6+=MAmount6;
                                        RiskFectorr6=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk6=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                          
                                        ConForecastwithRisk6+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount6=RiskAmount;
                                       
                                        ModelIdd6=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd6);
                                     }
         else if( planningP=='07'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount7=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount7+=MAmount7;
                                        RiskFectorr7=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk7=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk7+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount7=RiskAmount;
                                        
                                        ModelIdd7=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd7);
                                     }
         else if( planningP=='08'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount8=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount8+=MAmount8;
                                        RiskFectorr8+=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk8=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk8+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount8=RiskAmount;
                                       
                                        ModelIdd8=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd8);
                                          
                                     }
         else if( planningP=='09' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount9=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount9+=MAmount9;
                                        RiskFectorr9=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk9=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk9+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount9=RiskAmount;
                                       
                                        ModelIdd9=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd9);
                                     }
         else if( planningP=='10' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount10=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount10+=MAmount10;
                                        RiskFectorr10=InitialForecastModelObj.Risk_Factor__c;
                                       TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk10=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk10+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount10=RiskAmount;
                                        
                                        ModelIdd10=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd10);
                                     }
         else if( planningP=='11' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount11=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount11+=MAmount11;
                                        RiskFectorr11=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk11=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk11+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        RiskAmount11=RiskAmount;
                                       
                                        ModelIdd11=InitialForecastModelObj.Id;
                                        ModelId.add(ModelIdd11);
                                        
                                     }
          else if( planningP=='12' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount12=Math.round(InitialForecastModelObj.Fcst_Amount__c);
                                        ConLevelMAmount12+=MAmount12;
                                        RiskFectorr12=InitialForecastModelObj.Risk_Factor__c;
                                        TotalForecastwithRisk+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ForecastwithRisk12=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
                                        ConForecastwithRisk12+=Math.round(InitialForecastModelObj.Forecast_with_Risk__c);
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
                        
                                    
                         TotalMAmount=MAmount1+MAmount2+MAmount3+MAmount4+MAmount5+MAmount6+MAmount7+MAmount8+MAmount9+MAmount10+MAmount11+MAmount12;            
                         String B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,AF1,AF2,AF3,AF4,AF5,AF6,AF7,AF8,AF9,AF10,AF11,AF12,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13; 

                        
                         BaselineLineItemrow='<tr><th Style="background-color: #D9D9D9;" class=BaseLineCon'+acciD+'><a style="color:black" target="_blank"  href="/'+ConLineItemObj.Id+'" title="LineItem Name"> '+ConLineItemObj.name+' <span id='+ConLineItemObj.Id+'Sign></span></a></th><th title="'+lineLabelWrap+'"  Style="text-align: center;background-color: #D9D9D9;color:black;" class=BaseLineCon'+acciD+'>'+lineLabel+' </th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:white;" class=BaseLineCon'+acciD+'></th></tr>'; 
                         //String  LineItemActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount1.setscale(0).format(), args2)+'</th><th style="background-color :#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalActual.setscale(0).format(), args2)+'</th></tr>';   
                         
                         
                         String  forcastWithRisk='<tr><th  title="Forecast With Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th><th style="background-color:white;"></th>';
                    system.debug('ForecastwithRisk1777>>>'+ForecastwithRisk1);   
                        if(ForecastwithRisk1<0){
                        F1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F1='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk1.setscale(0).format(), args2)+'</th>';
                         }
                       
                        if(ForecastwithRisk2<0){
                        F2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F2='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk2.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk3<0){
                        F3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F3='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk3.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk4<0){
                        F4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F4='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk4.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk5<0){
                        F5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F5='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk5.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk6<0){
                        F6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F6='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk6.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk7<0){
                        F7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F7='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk7.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk8<0){
                        F8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F8='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk8.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk9<0){
                        F9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F9='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk9.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk10<0){
                        F10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F10='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk10.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk11<0){
                        F11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F11='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk11.setscale(0).format(), args2)+'</th>';
                         }
                        if(ForecastwithRisk12<0){
                        F12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ForecastwithRisk12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        F12='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ForecastwithRisk12.setscale(0).format(), args2)+'</th>';
                         }
                        
                   if(TotalForecastwithRisk<0 ){
                         F13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalForecastwithRisk*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{

                        F13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';
                         
                         }


                      forcastWithRisk+=F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+F13; 

                        
                         
                    String  Risk='<tr ><th title="Risk" class=BaseLineCon'+acciD+'  style="background-color:white;color:black;text-align: right;">Risk</th><th style="background-color:white;"></th>';
                   if(RiskAmount1!=null && RiskAmount1!=0){
                   C1='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount1.setscale(0).format(), args2)+')'+'</th>';
                   if(RiskAmount1<0){
                         C1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount1.setscale(0).format(), args2)+'</th>';
                         }  
                       } else{
                   C1='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount2!=null && RiskAmount2!=0){
                   C2='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount2.setscale(0).format(), args2)+')'+'</th>';
                   if(RiskAmount2<0){
                         C2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount2.setscale(0).format(), args2)+'</th>';
                         }  
                       
                       } else{
                   C2='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount3!=null && RiskAmount3!=0){
                   C3='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount3.setscale(0).format(), args2)+')'+'</th>';
                                      if(RiskAmount3<0){
                         C3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount3.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C3='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount4!=null && RiskAmount4!=0){
                   C4='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount4.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount4<0){
                         C4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount4.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C4='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount5!=null && RiskAmount5!=0){
                   C5='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount5.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount5<0){
                         C5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount5.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C5='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount6!=null && RiskAmount6!=0){
                   C6='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount6.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount6<0){
                         C6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount6.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C6='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                    if(RiskAmount7!=null && RiskAmount7!=0){
                   C7='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount7.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount7<0){
                         C7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount7.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C7='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                    if(RiskAmount8!=null && RiskAmount8!=0){
                   C8='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount8.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount8<0){
                         C8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount8.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C8='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount9!=null && RiskAmount9!=0){
                   C9='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount9.setscale(0).format(), args2)+')'+'</th>';
                                          if(RiskAmount9<0){
                         C9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount9.setscale(0).format(), args2)+'</th>';
                         }  
                       
                       
                       } else{
                   C9='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount10!=null && RiskAmount10!=0){
                   C10='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount10.setscale(0).format(), args2)+')'+'</th>';
                                          if(RiskAmount10<0){
                         C10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount10.setscale(0).format(), args2)+'</th>';
                         }  
                       
                       
                       } else{
                   C10='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount11!=null && RiskAmount11!=0){
                   C11='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount11.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount11<0){
                         C11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount11.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C11='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(RiskAmount12!=null && RiskAmount12!=0){
                   C12='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(RiskAmount12.setscale(0).format(), args2)+')'+'</th>';
                                         if(RiskAmount12<0){
                         C12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((RiskAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(RiskAmount12.setscale(0).format(), args2)+'</th>';
                         }  
                      
                      
                       } else{
                   C12='<th style="text-align: center;background-color:#D0CECE;">$0</th>';
                       }
                   if(TotalRiskAmount!=null && TotalRiskAmount!=0){
                   C13='<th style="background-color:#D0CECE;text-align: center;">$ ('+String.format(TotalRiskAmount.setscale(0).format(), args2)+')'+'</th>'; 
                                          if(TotalRiskAmount<0){
                         C13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalRiskAmount*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                         C13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalRiskAmount.setscale(0).format(), args2)+'</th>';
                         }  
                       
                       
                       } else{
                   C13='<th style="text-align: center;background-color:#D0CECE;">$0</th></tr>';
                       }

                  
                  Risk+=C1+C2+C3+C4+C5+C6+C7+C8+C9+C10+C11+C12+C13;   
                

                
                         
                         
                         
                           
                   String  WithoutRisk='<tr ><th title="Forecast without Risk" class=bestOppRow'+acciD+' style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th><th style="background-color:white;"></th>';
                   if(MAmount1!=null && ModelId.contains(ModelIdd1)){
                    if(MAmount1<0){
                   B1='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd1+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B1='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd1+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount1.setscale(0).format(), args2)+'</th>';
                    }
                    
                                      } else{
                   B1='<th style="text-align: center;">$0</th>';
                       }
                   if(MAmount2!=null && ModelId.contains(ModelIdd2)){
                    if(MAmount2<0){
                   B2='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd2+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B2='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd2+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount2.setscale(0).format(), args2)+'</th>';
                    }
                     
                                     } else{
                   B2='<th style="text-align: center;">$0</th>';
                       }
                   if(MAmount3!=null && ModelId.contains(ModelIdd3)){
                    if(MAmount3<0){
                   B3='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd3+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B3='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd3+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount3.setscale(0).format(), args2)+'</th>';
                    }
                                      
                                          } else{
                   B3='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount4!=null && ModelId.contains(ModelIdd4)){
                    if(MAmount4<0){
                   B4='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd4+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B4='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd4+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount4.setscale(0).format(), args2)+'</th>';
                    }
                                     
                                         } else{
                   B4='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount5!=null && ModelId.contains(ModelIdd5)){ 
                    if(MAmount5<0){
                   B5='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd5+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B5='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd5+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount5.setscale(0).format(), args2)+'</th>';
                    }
                                         } else{
                   B5='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount6!=null && ModelId.contains(ModelIdd6)){
                    if(MAmount6<0){
                   B6='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd6+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B6='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd6+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount6.setscale(0).format(), args2)+'</th>';
                    }
                                        
                                         } else{
                   B6='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount7!=null && ModelId.contains(ModelIdd7)){
                    if(MAmount7<0){
                   B7='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd7+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B7='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd7+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount7.setscale(0).format(), args2)+'</th>';
                    }
                                         } else{
                   B7='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount8!=null && ModelId.contains(ModelIdd8)){
                    if(MAmount8<0){
                   B8='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd8+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B8='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd8+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount8.setscale(0).format(), args2)+'</th>';
                    }
                                         } else{
                   B8='<th style="text-align: center;">$0</th>';
                       }
                  
                  if(MAmount9!=null && ModelId.contains(ModelIdd9)){
                    if(MAmount9<0){
                   B9='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd9+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B9='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd9+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount9.setscale(0).format(), args2)+'</th>';
                    }
                                         } else{
                   B9='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount10!=null && ModelId.contains(ModelIdd10)){
                    if(MAmount10<0){
                   B10='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd10+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B10='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd10+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount10.setscale(0).format(), args2)+'</th>';
                    }
                                         } else{
                   B10='<th style="text-align: center;">$0</th>';
                       }
                   
                  if(MAmount11!=null && ModelId.contains(ModelIdd11)){
                    if(MAmount11<0){
                   B11='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd11+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B11='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd11+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount11.setscale(0).format(), args2)+'</th>';
                    }
                                        } else{
                   B11='<th style="text-align: center;">$0</th>'; 
                       }
                 
                  if(MAmount12!=null && ModelId.contains(ModelIdd12)){
                    if(MAmount12<0){
                   B12='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd12+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$ ('+String.format((MAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
                     } else{
                    B12='<th style="background-color:white;text-align: center;"><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd12+' onfocusin="checkEnterClick,selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+'>$'+String.format(MAmount12.setscale(0).format(), args2)+'</th>';
                    }
                                         } else{
                   B12='<th style="text-align: center;">$0</th>';
                       }
                       
                    if(TotalMAmount<0){
                    B13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalMAmount*-1).setscale(0).format(), args2)+')'+'</th></tr>';
                     } else{
                    B13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalMAmount.setscale(0).format(), args2)+'</th></tr>';
                    }
                       
                       
                  
                  WithoutRisk+=B1+B2+B3+B4+B5+B6+B7+B8+B9+B10+B11+B12+B13;  
                     String RiskFactor='<tr><th title="Risk Factor" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Risk Factor</th><th style="background-color:white;"></th>';
                     
                     if(RiskFectorr1!=null && ModelId.contains(ModelIdd1)){
                      AF1='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd1+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr1.setscale(0).format(), args2)+'%</div></th>';
                             
                                  } else{
                    AF1='<th style="text-align: center;">0%</th>';
                               }
                               
                   if(RiskFectorr2!=null && ModelId.contains(ModelIdd2) ){
                   AF2='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd2+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr2.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF2='<th style="text-align: center;">0%</th>'; 
                       }

                   if(RiskFectorr3!=null && ModelId.contains(ModelIdd3) ){
                   AF3='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd3+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr3.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF3='<th style="text-align: center;">0%</th>'; 
                       }
                               
                   if(RiskFectorr4!=null && ModelId.contains(ModelIdd4)){
                   AF4='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd4+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr4.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF4='<th style="text-align: center;">0%</th>'; 
                       }

                   if(RiskFectorr5!=null && ModelId.contains(ModelIdd5)){
                   AF5='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd5+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr5.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF5='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr6!=null && ModelId.contains(ModelIdd6) ){
                   AF6='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd6+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr6.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF6='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr7!=null && ModelId.contains(ModelIdd7)){
                   AF7='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd7+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr7.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF7='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr8!=null && ModelId.contains(ModelIdd8)){
                   AF8='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd8+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr8.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF8='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr9!=null && ModelId.contains(ModelIdd9)){
                   AF9='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd9+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr9.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF9='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr10!=null && ModelId.contains(ModelIdd10)){
                   AF10='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd10+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr10.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF10='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr11!=null && ModelId.contains(ModelIdd11)){
                   AF11='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd11+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr11.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF11='<th style="text-align: center;">0%</th>'; 
                       }
                   if(RiskFectorr12!=null && ModelId.contains(ModelIdd12)){
                   AF12='<th style="background-color:white;text-align: center; "><div class=mostlLikelyOpp'+acciD+' id='+ModelIdd12+'ab onfocusin="checkEnterClick,selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+'>'+String.format(RiskFectorr12.setscale(0).format(), args2)+'%</div></th>';
                                        } else{
                   AF12='<th style="text-align: center;">0%</th>'; 
                       }


                           RiskFactor+=AF1+AF2+AF3+AF4+AF5+AF6+AF7+AF8+AF9+AF10+AF11+AF12+'<th style="background-color:#BFBFBF;;text-align: center;border-right-color: #BFBFBF; " class=BaseloneCon'+acciD+'></th></tr>';                   
                        
                        
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
                       String ContName = Con.Contract__c;
                            
                            if(ContName.length()>25){
                                ContName = ContName.substring(0,25)+'...';
                            }
                             
                        String BaselineContactrow='<tr><th Style="background-color: #D9D9D9;" class=BaseLineCon'+acciD+'><a style="color:black" target="_blank"  href="/'+Con.Id+'" title="'+Con.Contract__c+'"> '+ContName+' <span id='+Con.Id+'Sign></span></a></th><th  Style="text-align: center;background-color: #D9D9D9;color:black;" class=BaseLineCon'+acciD+' title="'+ContactrDescrip+'"> '+ConDescrip+' </th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th><th Style="text-align: center;background-color: #D9D9D9;border-right-color: #D9D9D9;color:#D9D9D9;" class=BaseLineCon'+acciD+'></th></tr>';
                      String CF1,CF2,CF3,CF4,CF5,CF6,CF7,CF8,CF9,CF10,CF11,CF12,CF13; 
                       
                        //String  BaselineTotalFCST='<tr ><th  title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Forecast with Risk</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseLineCon'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';
                        String  BaselineTotalFCST='<tr ><th  title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Forecast with Risk</th><th style="background-color:white;"></th>';
                       system.debug('conforecasrtWithRisk>>>>'+ConForecastwithRisk1);
                        if(ConForecastwithRisk1<0){
                        CF1='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF1='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         
                         
                         if(ConForecastwithRisk2<0){
                        CF2='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF2='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk3<0){
                        CF3='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF3='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk4<0){
                        CF4='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                       CF4='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk5<0){
                        CF5='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF5='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk6<0){
                        CF6='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF6='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ConForecastwithRisk7<0){
                        CF7='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF7='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ConForecastwithRisk8<0){
                        CF8='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF8='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk9<0){
                        CF9='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF9='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk10<0){
                        CF10='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF10='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk11<0){
                        CF11='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF11='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk12<0){
                        CF12='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF12='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(TotalConForecastwithRisk<0){
                        CF13='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((TotalConForecastwithRisk*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        CF13='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th>';
                         }
                         
                         BaselineTotalFCST+=CF1+CF2+CF3+CF4+CF5+CF6+CF7+CF8+CF9+CF10+CF11+CF12+CF13;   
                           
                          
                          
                        




                      //  String  BaseLineTotalFCSTinclRisk='<tr title="Total FCST incl Risk"style="padding-left: 100px;"><th class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaselineCon'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th></tr>'; 
         String KP1,KP2,KP3,KP4,KP5,KP6,KP7,KP8,KP9,KP10,KP11,KP12,KP13;
           
            String  BaseLineTotalFCSTinclRisk='<tr title="Total FCST incl Risk"style="padding-left: 100px;"><th class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th><th style="background-color:white;"></th>';
           
           if(ConLevelMAmount1<0){
           KP1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(ConLevelMAmount2<0){
           KP2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
            if(ConLevelMAmount3<0){
           KP3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount4<0){
           KP4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount5<0){
           KP5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelMAmount6<0){
           KP6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelMAmount7<0){
           KP7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount8<0){
           KP8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          KP8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount9<0){
           KP9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount10<0){
           KP10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount11<0){
           KP11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount12<0){
           KP12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          KP12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(TotalConLevelMAmount<0){
           KP13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalConLevelMAmount*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           KP13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th>';
           }


        BaseLineTotalFCSTinclRisk+=KP1+KP2+KP3+KP4+KP5+KP6+KP7+KP8+KP9+KP10+KP11+KP12+KP13;                         
                        
                        
     // String  BaselineActuallAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:white;"></th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalConLevelActual.setscale(0).format(), args2)+'</th></tr>';   
         String Tv1,Tv2,Tv3,Tv4,Tv5,Tv6,Tv7,Tv8,Tv9,Tv10,Tv11,Tv12,Tv13;
           
          String  BaselineActuallAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:white;"></th>';
           system.debug('ConLevelactualAmount1ConLevelactualAmount1>>>'+ConLevelactualAmount1);
           if(ConLevelactualAmount1<0){
           Tv1='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv1='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(ConLevelactualAmount2<0){
           Tv2='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv2='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
            if(ConLevelactualAmount3<0){
           Tv3='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv3='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount4<0){
           Tv4='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv4='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount5<0){
           Tv5='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv5='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelactualAmount6<0){
           Tv6='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv6='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelactualAmount7<0){
           Tv7='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv7='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount8<0){
           Tv8='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          Tv8='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount9<0){
           Tv9='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv9='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount10<0){
           Tv10='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv10='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount11<0){
           Tv11='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv11='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelactualAmount12<0){
           Tv12='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((ConLevelactualAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          Tv12='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(ConLevelactualAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(totalConLevelActual<0){
           Tv13='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$ ('+String.format((totalConLevelActual*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv13='<th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalConLevelActual.setscale(0).format(), args2)+'</th>';
           }


        BaselineActuallAmount+=Tv1+Tv2+Tv3+Tv4+Tv5+Tv6+Tv7+Tv8+Tv9+Tv10+Tv11+Tv12+Tv13;                        
                       BaseLineRowBody+=BaselineContactrow+BaselineActuallAmount+BaseLineTotalFCSTinclRisk+BaselineTotalFCST+ConLineItemmList; 
                        }//Contact for loop closed 
                      }//Contact if Closed
           totalAccLevelActual= AccLevelactualAmount1+AccLevelactualAmount2+AccLevelactualAmount3+AccLevelactualAmount4+AccLevelactualAmount5+AccLevelactualAmount6+AccLevelactualAmount7+AccLevelactualAmount8+AccLevelactualAmount9+AccLevelactualAmount10+AccLevelactualAmount11+AccLevelactualAmount12;
          String s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13;
         String AccountName = ConHavingAccountIdName.get(acciD);
                            if(AccountName.length()>25){
                                AccountName = AccountName.substring(0,25)+'...';
                            }
           String accountRow='<tr style="background-color:#F2F2F2;"><th style="background-color:#F2F2F2;size: 10%;"><b style="position: relative; left: 62%;border-left: white;"><a title='+ConHavingAccountIdName.get(acciD)+' style="color:black;  target="_blank"  href="/'+acciD+'" target="_blank">'+AccountName+'</a></b><th style="background-color:#F2F2F2;size: 10%;"></th> </th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;font-weight: bold;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th></tr>';  
          // String  TotalforWithoutRisk='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th title=" Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;position: relative; right: 0px;border-left: #D0CECE;"><b style="position: relative; left: -75px;border-left: #D0CECE;">  Forecast without Risk</b></th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th></tr>';  
         String L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13;
           
           String  TotalforWithoutRisk='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th title=" Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;position: relative; right: 0px;border-left: #D0CECE;"><b style="position: relative; left: -75px;border-left: #D0CECE;">  Forecast without Risk</b></th>';
           
           if(ConLevelMAmount1<0){
           L1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(ConLevelMAmount2<0){
           L2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
                   if(ConLevelMAmount3<0){
           L3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount4<0){
           L4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount5<0){
           L5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelMAmount6<0){
           L6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelMAmount7<0){
           L7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount8<0){
           L8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount9<0){
           L9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount10<0){
           L10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount11<0){
           L11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount12<0){
           L12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(TotalConLevelMAmount<0){
           L13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalConLevelMAmount*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th>';
           }


        TotalforWithoutRisk+=L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12+L13;           
          
           String  TotalforcastWithRisk='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th title=" Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;position: relative; right: 0px;border-left: #D0CECE;"><b style="position: relative; left: -75px;border-left: #D0CECE;">  Forecast with Risk</b></th>';
                       system.debug('knkhih>>>'+ConForecastwithRisk1);
                        if(ConForecastwithRisk1<0){
                        s1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s1='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk2<0){
                        s2='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s2='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk3<0){
                        s3='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s3='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk4<0){
                        s4='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                       s4='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk5<0){
                        s5='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s5='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk6<0){
                        s6='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s6='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ConForecastwithRisk7<0){
                        s7='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s7='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ConForecastwithRisk8<0){
                        s8='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s8='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk9<0){
                        s9='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s9='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk10<0){
                        s10='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s10='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk11<0){
                        s11='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s11='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk12<0){
                        s12='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((ConForecastwithRisk12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s12='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(TotalConForecastwithRisk<0){
                        s13='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$ ('+String.format((TotalConForecastwithRisk*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s13='<th style="background-color:#D0CECE;text-align: center;" class=BaseLineCon'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';
                         }
                         
                        TotalforcastWithRisk+=s1+s2+s3+s4+s5+s6+s7+s8+s9+s10+s11+s12+s13;    
          
          
          
           //String  TotalforcastWithRisk='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;position: relative; right: 0px;border-left: #D0CECE;"><b style="position: relative; left: -69px;border-left: #D0CECE;">  Forecast with Risk</b></th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';  
          // String  ActualAmount='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;"><b style="position: relative; left: -66px;border-left: white;">Actual Amount</b></th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalAccLevelActual.setscale(0).format(), args2)+'</th></tr>';   
         String ACT1,ACT2,ACT3,ACT4,ACT5,ACT6,ACT7,ACT8,ACT9,ACT10,ACT11,ACT12,ACT13;
           
            String  ActualAmount='<tr><th style="background-color:white;color:black;border-right-color: white;border-left: white;"></th><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;"><b style="position: relative; left: -66px;border-left: white;">Actual Amount</b></th>';
           
           if(AccLevelactualAmount1<0){
           ACT1='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT1='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(AccLevelactualAmount2<0){
           ACT2='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT2='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
            if(AccLevelactualAmount3<0){
           ACT3='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT3='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount4<0){
           ACT4='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT4='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount5<0){
           ACT5='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT5='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(AccLevelactualAmount6<0){
           ACT6='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT6='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(AccLevelactualAmount7<0){
           ACT7='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT7='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount8<0){
           ACT8='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          ACT8='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount9<0){
           ACT9='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT9='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount10<0){
           ACT10='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT10='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount11<0){
           ACT11='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT11='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(AccLevelactualAmount12<0){
           ACT12='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((AccLevelactualAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          ACT12='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelactualAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(totalAccLevelActual<0){
           ACT13='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$ ('+String.format((totalAccLevelActual*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           ACT13='<th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(totalAccLevelActual.setscale(0).format(), args2)+'</th>';
           }


        ActualAmount+=ACT1+ACT2+ACT3+ACT4+ACT5+ACT6+ACT7+ACT8+ACT9+ACT10+ACT11+ACT12+ACT13;           
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
               List<FCST_Initial_Forecast__c> planningModelList=[Select Id,Name,Contract_LineItem__c,Fcst_Amount__c,Planning_Version__c,Planning_Version__r.name from FCST_Initial_Forecast__c where Id=:planningModelId];
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
   
    
 public pageReference updateRiskFactor(){
      try{
          String RiskFectoridStr=Apexpages.currentPage().getParameters().get('id');
          system.debug('FectorId>>>>>'+RiskFectoridStr);
          Id RiskFectorid;
          if(RiskFectoridStr!=null)
             RiskFectorid=Id.valueOf(RiskFectoridStr);
             String riskFactor=Apexpages.currentPage().getParameters().get('riskFactor');
             system.debug('riskFactor>>>>>'+riskFactor);
             Decimal riskDecimal;
             if(riskFactor!=null)
                riskDecimal=decimal.valueOf(riskFactor); 
                 system.debug('riskDecimal>>>>>'+riskDecimal);
             FCST_Initial_Forecast__c RiskFectorRecord =[select id,Risk_Factor__c from FCST_Initial_Forecast__c where id=:RiskFectorid limit 1];
                 system.debug('RiskFectorRecord>>>>>'+RiskFectorRecord);
             if(RiskFectorRecord !=null){
                RiskFectorRecord.Risk_Factor__c =riskDecimal;
                update RiskFectorRecord;
             }
          } catch(Exception e){
                  System.debug('Exception error Message>>>>>>> '+e);
                  System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
          }
  return null;     
 }
   
      public pageReference updateActualModel(){
        try{   
            String lineItemId=Apexpages.currentPage().getParameters().get('lineItemId');
            String PeriodNumber=Apexpages.currentPage().getParameters().get('periodnumber');
            String actualAmount=Apexpages.currentPage().getParameters().get('actualAmount');
            String globalValue=String.ValueOf(globalYear);
            String fiscalPeriod='FY'+globalValue+'P'+PeriodNumber;
            List<Actual_Model__c> updateactual = new List<Actual_Model__c>();
            
            List<Contract_LineItem__c> contractLineItemList=[Select Line_Description__c,Fcst_Revenue_Type__c,FCST_Contract__r.Opportunity__c,FCST_Contract__r.Fcst_Geo_Name__c,FCST_Contract__r.Fcst_Geo_Numbers__c,Cost_Center_Description__c,Cost_Center__c,BSLA_Number__c,Id,FCST_Contract__r.Fcst_Account__c,FCST_Contract__c from Contract_LineItem__c where Id=:lineItemId LIMIT 1];
            
            
            if(contractLineItemList!=null && contractLineItemList.size()>0){
            	List<Actual_Model__c>  actualList = [Select Id from Actual_Model__c where Account__c=:contractLineItemList[0].FCST_Contract__r.Fcst_Account__c and FCST_Planning_Version__r.Name=:Planversion and Fiscal_Period__r.Name=:fiscalPeriod and Revenue_Type__c=:contractLineItemList[0].Fcst_Revenue_Type__c and FCST_Contract__c=:contractLineItemList[0].FCST_Contract__c and Contract_LineItem__c=:contractLineItemList[0].id];
                
                if(actualList!=null && actualList.size()>0 && actualAmount!=null){
                	actualList[0].Actual_Amount__c=decimal.ValueOf(actualAmount);
                	updateactual.add(actualList[0]);
                }
                else{
                	
                	List<Planning_Version__c>  pvList=   [Select Name,Id from Planning_Version__c where Name=:strPlanningVersion LIMIT 1];
                	List<Fiscal_Year_Model__c> fsList =[Select Name,Id,Fiscal_Planning_Year__c from Fiscal_Year_Model__c where Name=:fiscalPeriod];
                	//List<Opportunity> oppList =[Select Name,Id from Opportunity where Name=:strOpportunity];
                	
                	Actual_Model__c actObj = new Actual_Model__c();
                	actObj.Account__c=contractLineItemList[0].FCST_Contract__r.Fcst_Account__c;
                	if(actualAmount!=null)
                	actObj.Actual_Amount__c=decimal.ValueOf(actualAmount);
                	if(contractLineItemList[0].BSLA_Number__c!=null)
                	actObj.BSLA__c=String.ValueOf(contractLineItemList[0].BSLA_Number__c);
                	
                	if(contractLineItemList[0].Cost_Center__c!=null)
                	actObj.FCST_CC__c=contractLineItemList[0].Cost_Center__c;
                	
                	actObj.CC_Description__c=contractLineItemList[0].Cost_Center_Description__c;
                	actObj.Revenue_Type__c=contractLineItemList[0].Fcst_Revenue_Type__c;
                	//actObj.Opportunity__c=oppList[0].Id;
                	if(contractLineItemList[0].FCST_Contract__r.Fcst_Geo_Numbers__c!=null)
                	 actObj.FCST_GEO__c=contractLineItemList[0].FCST_Contract__r.Fcst_Geo_Numbers__c;
                	actObj.GEO_Description__c=contractLineItemList[0].FCST_Contract__r.Fcst_Geo_Name__c;
                	actObj.FCST_Planning_Version__c=pvList[0].Id;
                	actObj.Fiscal_Period__c=fsList[0].Id;
                	actObj.Fiscal_Year__c=fsList[0].Fiscal_Planning_Year__c;
                	
                	actObj.Contract_LineItem__c=contractLineItemList[0].Id;
                	actObj.FCST_Contract__c=contractLineItemList[0].FCST_Contract__c;
                	actObj.Revenue_Stream__c=contractLineItemList[0].Line_Description__c;
                	updateactual.add(actObj);
                }
                
                	
             }
             
             if(updateactual!=null && updateactual.size()>0)
             	upsert updateactual;
             
            }catch(Exception e){
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