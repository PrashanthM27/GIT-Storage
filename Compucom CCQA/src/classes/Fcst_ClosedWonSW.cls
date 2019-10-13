public with sharing class Fcst_ClosedWonSW {  
   
    public boolean IsTableDataPresent   {get;set;}
    public List<Integer> yearList       {get;set;}
    public String planningPeriod        {get;set;}
    public string strPlanningVersion    {get;set;}
    public string strPlanningYear       {get;set;}
    public Integer cYear                {get;set;}
    public Integer initialYear          {get;set;}
    public Integer lastYear             {get;set;}
    public string strUserName           {get;set;}
    public string strAccount            {get;set;}
    public string strPlanYear           {get;set;}
    public String Planversion           {get;set;} 
    public Set<string> opportunitySet   {get;set;}
    public string strOpportunity        {get;set;}
    public Transient string tableBlock  {get;set;} 
    public String globalMonth           {get;set;}
    public Integer globalYear           {get;set;}
    Public String totalProductString    {get;set;}
    Public String strContract           {get;set;}
    public Set<string> contractSet      {get;set;}
    public String strLine               {get;set;}
    public Set<String> lineSet          {get;set;}
    Public String pVVersionStringId;
    Public String AccountId;
    Public String UserStringId;
    List<Account> accountList;
    List<Opportunity> oppList;
    List<FCST_Contract__c> conList;
    List<Contract_LineItem__c> lineList;
    List<String> conNameList;
    Public String conName='';
    @testVisible Set<String> StageNameSet;
    private Date YearStartDate;
    private Date yearCloseDate;
    Integer increaseVal;
    public boolean editableCell;
    public boolean NonEditable;
    public string userCurrencySign = '$';
    public MappingFieldUtility mfu;
    public String likeStr;
    //>>>>>>>>>>pagination start>>>>>>>>>>
    public integer counter=0; 
    public integer list_size=10; 
    public integer total_size;
    
    Public integer total_Page_Size;
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
//>>>>>>>>>>Pagination End>>>>>>>>>>
//>>>>>>>>>>Constructor start>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>    
   public Fcst_ClosedWonSW(){ 
       try{ 
           mfu = new MappingFieldUtility();
           getFromPlanningVersion();
           IsTableDataPresent = true;
           yearList= new List<Integer>();
           accountList = new List<Account>();
           oppList = new List<Opportunity>();
           conList = new List<FCST_Contract__c>();
           opportunitySet = new Set<String>();
           contractSet = new Set<String>();
           lineSet = new Set<String>();
           conNameList = new List<String>();
           StageNameSet = new Set<String>{'Closed Won'};
           planningPeriod='Planning Period';
           editableCell = true;
           NonEditable = false;
           User currentuserobj = new User();
           pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
           AccountId = apexpages.currentpage().getparameters().get('AccId');
           UserStringId = apexpages.currentpage().getparameters().get('su');
        
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

            String accQuery = 'Select Id,Name from Account where Id =:AccountId LIMIT 1';
            accountList= Database.query(accQuery);
            if(accountList!=null && accountList.size()>0){   
               for(Account accObj:accountList){
                  strAccount = accObj.name;
               }
            }
            String oppQuery = 'select Id,Account.Id,Name,owner.id,Amount,Account.Name,StageName from Opportunity where Account.Name =:strAccount and owner.id =:UserStringId and Id IN(select Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__r.Account.name=:strAccount) and CloseDate >=: YearStartDate  and StageName IN:StageNameSet  LIMIT 20000';
            oppList = Database.query(oppQuery);
            for(Opportunity OppObj1: oppList){
                opportunitySet.add(OppObj1.Name);
            }
            String conQuery ='Select id,name,Contract__c,Contract_Owner__c,FCST_Q__c,Contract_Description__c,Opportunity__r.name from FCST_Contract__c where Opportunity__r.name IN:opportunitySet and Contract_Owner__c =:UserStringId order by name';
            conList = Database.query(conQuery);
           if(!conList.isEmpty()){
               if(conList[0].Contract__c!=null){
               strContract =String.valueOf(conList[0].FCST_Q__c+'#'+conList[0].Contract__c+'#'+conList[0].name);
               }else{
               strContract =String.valueOf(conList[0].FCST_Q__c+'#'+conList[0].name);  
               }
               strOpportunity=String.valueOf(conList[0].Opportunity__r.name);
           }
            for(FCST_Contract__c conObj: conList){
                if(conObj.Contract__c!=null){
                contractSet.add(conObj.FCST_Q__c+'#'+conObj.Contract__c+'#'+conObj.name);
                }else{
                contractSet.add(conObj.FCST_Q__c+'#'+conObj.name);  
                }
            }
           lineSet.add('All');
           if(strContract!=null){
           conNameList = strContract.split('#');
           conName = conNameList[conNameList.size()-1];
           }
           String lineQuery ='Select id,name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.name =:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.name=:strPlanningVersion) order by name';
           lineList = Database.query(lineQuery);
           if(!lineList.isEmpty()){
               strLine ='All';
           }
            for(Contract_LineItem__c lineObj: lineList){
                lineSet.add(lineObj.name);
            }
            if(pVVersionStringId!=null){
                getFromPlanningVersion();
                fetchOppRecord();
            }
           
          
       }catch(Exception e){
            System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
            System.debug('Exception error Message>>>>>>> '+e);
        }     
    } 
/***********************************Constructor End***********************************************/
  
    public pagereference mainfetchOppRecord(){
           counter = 0;
           increaseVal=0;
           String increaseValStr = ApexPages.CurrentPage().getParameters().get('getincreaseValue');
           if(increaseValStr!=null)
              increaseVal= Integer.ValueOf(increaseValStr);
              fetchOppRecord();
      return null;
    }
/*********************************************fetchOppMethod End***************************************************************/   
    public pagereference  fetchOppRecord(){
       try{
           String strPlanningYear;
           IsTableDataPresent = false;
           String conLabel='';
           globalYear=0;
           StageNameSet = new Set<String>();
           Set<Id> pagSet= new Set<Id>();
           Set<Id> lineIds = new Set<Id>();
           List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
           Map<Id,String> oppHavingAccountIdName = new Map<Id,String>();
           Map<Id,List<Opportunity>> mapAccIdVsOpenOppList = new Map<Id,List<Opportunity>>();
           Map<Id,List<Contract_LineItem__c>> mapConIdVslineList = new Map<Id,List<Contract_LineItem__c>>();
           Map<Id,FCST_Contract__c> mapOppIdVsContract = new Map<Id,FCST_Contract__c>();
           Map<id,List<FCST_Initial_Forecast__c>> mapLineVsmodList = new Map<id,List<FCST_Initial_Forecast__c>>();
           Map<id,List<Actual_Model__c>> mapLineVsActModList = new Map<id,List<Actual_Model__c>>();
           Map<id,List<FCST_Opportunity_Initial_Forecast__c>> mapoppVsmodList = new Map<id,List<FCST_Opportunity_Initial_Forecast__c>>();
           
           Date yearCloseDate,YearStartDate,monthStartDate,monthCloseDate;
           if(strPlanningVersion!=null)
           strPlanningYear=strPlanningVersion.left(4);
           if(strPlanningYear.isNumeric())
             globalYear=Integer.ValueOf(strPlanningYear);
           if(increaseVal!=null){
             globalYear=globalYear+increaseVal;
           }  
           List<Fiscal_Year_Planning__c> fiscalYearList = new List<Fiscal_Year_Planning__c>();
           if(strPlanningYear!=null){  
              fiscalYearList=[Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c where Name=:String.valueOf(strPlanningYear) LIMIT 1];
              if(fiscalYearList!=null && fiscalYearList.size()>0){
                 YearStartDate=fiscalYearList[0].StartDate__c;
                 yearCloseDate=fiscalYearList[0].EndDate__c;
              }
           }
           likeStr='FY'+globalYear+'%';
           planningPeriod=YearStartDate.day()+' '+getmonthName(YearStartDate.month())+' '+globalYear+' to '+yearCloseDate.day()+' '+getmonthName(yearCloseDate.month())+' '+globalYear;
      
           for(Opportunity oppObj : oppList){
              if(oppObj.StageName=='Closed Won'){
                 StageNameSet.add(oppObj.StageName);  
              } 
           }
       
           
         String oppQueryString='Select Account.Owner.Id,Id,Name,Account.Id,Account.Name,Owner.Id,'+mfu.getQNum()+' from Opportunity where Id IN (select Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__r.Account.name=:strAccount  and Fcst_Fiscal_Period__r.Name LIKE :likeStr)';
        
         oppQueryString+=' and Name =:strOpportunity and Account.Name =:strAccount and owner.id =:UserStringId ';
         oppQueryString+=' order by Account.Name';
         List<Opportunity> OpporrtunityList=database.query(oppQueryString);
        
       
          
         for(Opportunity oppObj1:OpporrtunityList){
             oppHavingAccountIdName.put(oppObj1.Account.Id,oppObj1.Account.Name);
         }
        
         for(Account acOBJ:[Select Id from Account where ID IN:oppHavingAccountIdName.keySet() order by Name]){
             pagSet.add(acOBJ.Id);
         }
         if(OpporrtunityList!=null && OpporrtunityList.size()>0){
            for(Opportunity oppObj:OpporrtunityList){
              //Open Opportunity Map
                if(mapAccIdVsOpenOppList.containsKey(oppObj.Account.Id)){ 
                List<Opportunity> mapContainOpenOpp =mapAccIdVsOpenOppList.get(oppObj.Account.Id);
                mapContainOpenOpp.add(oppObj);
                mapAccIdVsOpenOppList.put(oppObj.Account.Id,mapContainOpenOpp);
             }else{
                   List<Opportunity> newoppList = new List<Opportunity>();
                   newoppList.add(oppObj);
                   mapAccIdVsOpenOppList.put(oppObj.Account.Id,newoppList);
                 
             }
             
            }
         }
         String conQuery ='Select id,name,Contract__c,Contract_Description__c,FCST_Q__c,Opportunity__c,Contract_Owner__c from FCST_Contract__c where Opportunity__c IN:OpporrtunityList and name =:conName and Contract_Owner__c =:UserStringId order by name';
                
           for(FCST_Contract__c c : Database.query(conQuery)){
               mapOppIdVsContract.put(c.Opportunity__c,c);
           }
         String lineQuery = 'Select id,name,FCST_Contract__r.Contract__c,Line_Description__c,Risk_Factor__c from Contract_LineItem__c where FCST_Contract__r.name =:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr ) ';
         String lineCountQuery = 'Select id,name,FCST_Contract__r.Contract__c,Line_Description__c,Risk_Factor__c from Contract_LineItem__c where FCST_Contract__r.name =:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr ) ';  
           if(strLine!='All' && strLine!=null && String.isNotBlank(strLine)){
                lineQuery +=' and name=:strLine ';
                lineCountQuery +=' and name=:strLine ';
           }
                lineQuery +=' order by name limit :list_size  offset :counter';
                lineCountQuery +=' order by name';
           List<Contract_LineItem__c> lineCountResult = Database.query(lineCountQuery);
           total_size=lineCountResult.size();
           if(total_size>2000){
              total_size=2000;
           }
         for(Contract_LineItem__c cl : Database.query(lineQuery)){
             lineIds.add(cl.id);
              if(mapConIdVslineList.containsKey(cl.FCST_Contract__c)){ 
                List<Contract_LineItem__c> mapContainLine =mapConIdVslineList.get(cl.FCST_Contract__c);
                mapContainLine.add(cl);
                mapConIdVslineList.put(cl.FCST_Contract__c,mapContainLine);
             }else{
                   List<Contract_LineItem__c> newLineList = new List<Contract_LineItem__c>();
                   newLineList.add(cl);
                   mapConIdVslineList.put(cl.FCST_Contract__c,newLineList);
                 
             }
         }
          
         String initialFcastQuery = 'select id,Name,Contract_LineItem__c,Fcst_Amount__c,FCST_Contract__c,FCST_Fiscal_Year_List__c,FCST_Planning_Fiscal_Year__r.name,Planning_Version__r.name,RiskAmount__c,Forecast_with_Risk__c from FCST_Initial_Forecast__c where Contract_LineItem__c IN :lineIds and Planning_Version__r.name =:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr ';
         for(FCST_Initial_Forecast__c ifobj: Database.query(initialFcastQuery)){
               if(mapLineVsmodList.containsKey(ifobj.Contract_LineItem__c) ){
                List<FCST_Initial_Forecast__c> mapContainProductModel =mapLineVsmodList.get(ifobj.Contract_LineItem__c);
                mapContainProductModel.add(ifobj);
                mapLineVsmodList.put(ifobj.Contract_LineItem__c,mapContainProductModel);
             }else {
                   List<FCST_Initial_Forecast__c> newProductList = new List<FCST_Initial_Forecast__c>();
                   newProductList.add(ifobj);
                   mapLineVsmodList.put(ifobj.Contract_LineItem__c,newProductList); 
             }
         }
         String oppInFcastQuery = 'Select id,name,Fcst_Fiscal_Period__r.name,Fcst_Q__c,Fcst_Weighted_Revenue__c,Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__r.name IN:opportunitySet and Fcst_Fiscal_Period__r.Name LIKE :likeStr';
         for(FCST_Opportunity_Initial_Forecast__c opifobj: Database.query(oppInFcastQuery)){
             if(mapoppVsmodList.containsKey(opifobj.Fcst_Opportunity__c) ){
                List<FCST_Opportunity_Initial_Forecast__c> mapContainProductModel =mapoppVsmodList.get(opifobj.Fcst_Opportunity__c);
                mapContainProductModel.add(opifobj);
                mapoppVsmodList.put(opifobj.Fcst_Opportunity__c,mapContainProductModel);
             }else {
                   List<FCST_Opportunity_Initial_Forecast__c> newProductList = new List<FCST_Opportunity_Initial_Forecast__c>();
                   newProductList.add(opifobj);
                   mapoppVsmodList.put(opifobj.Fcst_Opportunity__c,newProductList); 
             }
         }
           
         String actualQuery ='select id,name,Account__c,Contract_LineItem__c,Actual_Amount__c,Fiscal_Period__r.name from Actual_Model__c where Account__c=:AccountId and Fiscal_Period__r.Name LIKE :likeStr ';
         for(Actual_Model__c actObj: Database.query(actualQuery)){
             if(mapLineVsActModList.containsKey(actObj.Contract_LineItem__c) ){
                List<Actual_Model__c> mapContainProductModel =mapLineVsActModList.get(actObj.Contract_LineItem__c);
                mapContainProductModel.add(actObj);
                mapLineVsActModList.put(actObj.Contract_LineItem__c,mapContainProductModel);
             }else {
                   List<Actual_Model__c> newProductList = new List<Actual_Model__c>();
                   newProductList.add(actObj);
                   mapLineVsActModList.put(actObj.Contract_LineItem__c,newProductList); 
             }
         }
         String  tableRecord='<table id="table_id"  class="slds-table slds-table--bordered slds-table--cell-buffer"><tr style="pointer-events: none;"><th  style="background-color: #313A8B;width:20%;text-align: center;" rowspan="2"><label  style="color: white;">Account/Contract</label></th><th  colspan="13" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" ><b>Planning Year</b><b class="Ram"  style="color: white;"> - '+globalYear+'</b></label></th></tr><tr style="pointer-events: none;"><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Jan</label></th><th   class="w_f"  style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Feb</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Mar</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Apr</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >May</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jun</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jul</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Aug</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Sep</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Oct</label></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Nov</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Dec</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Total</label></th></tr>';        
         String tableBody='';
         List<String> args2 = new String[]{'0','number','###,###,###'};
         String OppBody = ' ';
         for(Id acciD :pagSet){
             String oppQRow ='',TotOppRow='';
              Decimal accTotWOR=0,accWOR1=0,accWOR2=0,accWOR3=0,accWOR4=0,accWOR5=0,accWOR6=0,accWOR7=0,accWOR8=0,accWOR9=0,accWOR10=0,accWOR11=0,accWOR12=0;
              Decimal accTotWR=0,accWR1=0,accWR2=0,accWR3=0,accWR4=0,accWR5=0,accWR6=0,accWR7=0,accWR8=0,accWR9=0,accWR10=0,accWR11=0,accWR12=0;
              Decimal accActTot=0,accAct1=0,accAct2=0,accAct3=0,accAct4=0,accAct5=0,accAct6=0,accAct7=0,accAct8=0,accAct9=0,accAct10=0,accAct11=0,accAct12=0;
             if(mapAccIdVsOpenOppList.containsKey(acciD)){
                
                for(Opportunity oppObj:mapAccIdVsOpenOppList.get(acciD)){
                    String oppInFCastString='',conRow='',conFCastWoutRisk='',conFCastWRisk='',conActualRow='',lineRow='',lineFCastWoutRisk='',lineFCastWRisk='',lineActualRow='',lineRisk='',lineRiskFactor='',lineBody='';
                    String op1,op2,op3,op4,op5,op6,op7,op8,op9,op10,op11,op12;
                    Decimal opInFCastAmt=0,TotOpInFCastAmt=0,opInFCastAmt1=0,opInFCastAmt2=0,opInFCastAmt3=0,opInFCastAmt4=0,opInFCastAmt5=0,opInFCastAmt6=0,opInFCastAmt7=0,opInFCastAmt8=0,opInFCastAmt9=0,opInFCastAmt10=0,opInFCastAmt11=0,opInFCastAmt12=0;
                    String qnumber = mfu.getQNum();
                    oppObj.Fcst_Text_QNum__c = (String)oppObj.get(qnumber);
                    if(mapoppVsmodList.containsKey(oppObj.id)){
                    for(FCST_Opportunity_Initial_Forecast__c OppInObj : mapoppVsmodList.get(oppObj.id)){
                        String fiscalPeriod=OppInObj.Fcst_Fiscal_Period__r.Name; 
                        String planningP = fiscalPeriod.split('P')[1];
                        if(OppInObj.Fcst_Weighted_Revenue__c!=null){
                           opInFCastAmt = Math.round((OppInObj.Fcst_Weighted_Revenue__c));
                           if(planningP=='01'){
                              opInFCastAmt1 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op1='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt1.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='02'){
                              opInFCastAmt2 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op2='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt2.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='03'){
                              opInFCastAmt3 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op3='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt3.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='04'){
                              opInFCastAmt4 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op4='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt4.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='05'){
                              opInFCastAmt5 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op5='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt5.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='06'){
                              opInFCastAmt6 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op6='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt6.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='07'){
                              opInFCastAmt7 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op7='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt7.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='08'){
                              opInFCastAmt8 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op8='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt8.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='09'){
                              opInFCastAmt9 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op9='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt9.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='10'){
                              opInFCastAmt10 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op10='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt10.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='11'){
                              opInFCastAmt11 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op11='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt11.setscale(0).format(), args2)+'</div></td>';                           
                           }
                           if(planningP=='12'){
                              opInFCastAmt12 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              op12='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt12.setscale(0).format(), args2)+'</div></td>';                           
                           }
                        }
                    }
                    }
                    if(op1==null){op1='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op2==null){op2='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op3==null){op3='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op4==null){op4='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op5==null){op5='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op6==null){op6='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op7==null){op7='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op8==null){op8='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op9==null){op9='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op10==null){op10='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op11==null){op11='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    if(op12==null){op12='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                    oppInFCastString+='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;">Initial Forecast</td>';
                    oppInFCastString+=op1+op2+op3+op4+op5+op6+op7+op8+op9+op10+op11+op12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotOpInFCastAmt.setscale(0).format(), args2)+'</div></td></tr>';
                    
                    if(mapOppIdVsContract.containsKey(oppObj.id)){
                       lineRow='';lineBody='';
                       Decimal conTotWOR=0,conWOR1=0,conWOR2=0,conWOR3=0,conWOR4=0,conWOR5=0,conWOR6=0,conWOR7=0,conWOR8=0,conWOR9=0,conWOR10=0,conWOR11=0,conWOR12=0;
                       Decimal conTotWR=0,conWR1=0,conWR2=0,conWR3=0,conWR4=0,conWR5=0,conWR6=0,conWR7=0,conWR8=0,conWR9=0,conWR10=0,conWR11=0,conWR12=0;
                       Decimal conActTot=0,conAct1=0,conAct2=0,conAct3=0,conAct4=0,conAct5=0,conAct6=0,conAct7=0,conAct8=0,conAct9=0,conAct10=0,conAct11=0,conAct12=0;
                       FCST_Contract__c conObj= mapOppIdVsContract.get(oppObj.id);
                        //****************************contractLabel-Start************************************
                        if(conObj.Contract__c != null && conObj.Contract_Description__c != null){
                            conLabel = conObj.Contract__c +'#'+conObj.Contract_Description__c;
                        }else if(conObj.FCST_Q__c != null && conObj.Contract_Description__c != null){
                            conLabel = conObj.FCST_Q__c +'#'+conObj.Contract_Description__c;
                        }else if(conObj.Contract__c != null){
                             conLabel = conObj.Contract__c;
                        }else{
                             conLabel = conObj.FCST_Q__c;
                        }
                        //****************************contractLabel-End************************************
                        //****************************ContractLine-Start***********************************
                        if(mapConIdVslineList.containsKey(conObj.id)){
                            String lineLabel='';
                            lineActualRow='';
                           for(Contract_LineItem__c lineObj:mapConIdVslineList.get(conObj.id)){
                       //****************************Actual-Start*******************************************
                       Decimal totActualAmt=0,actualAmt=0,actualAmt1=0,actualAmt2=0,actualAmt3=0,actualAmt4=0,actualAmt5=0,actualAmt6=0,actualAmt7=0,actualAmt8=0,actualAmt9=0,actualAmt10=0,actualAmt11=0,actualAmt12=0;
                       if(mapLineVsActModList.containsKey(lineObj.id)){
                          
                          for(Actual_Model__c actObj:mapLineVsActModList.get(lineObj.id)){
                             
                              String fiscalPeriod=actObj.Fiscal_Period__r.Name; 
                               String planningP = fiscalPeriod.split('P')[1];
                               if(actObj.Actual_Amount__c!=null){
                                  actualAmt = Math.round((actObj.Actual_Amount__c)); 
                                   if(planningP=='01'){
                                      actualAmt1 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='02'){
                                      actualAmt2 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='03'){
                                      actualAmt3 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='04'){
                                      actualAmt4 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='05'){
                                      actualAmt5 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='06'){
                                      actualAmt6 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='07'){
                                      actualAmt7 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='08'){
                                      actualAmt8 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='09'){
                                      actualAmt9 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='10'){
                                      actualAmt10 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='11'){
                                      actualAmt11 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                                   if(planningP=='12'){
                                      actualAmt12 += actualAmt;
                                      totActualAmt += actualAmt;
                                   }
                               }
                              }
                              if(actualAmt1!=null)
                                   conAct1 += actualAmt1;
                               if(actualAmt2!=null)
                                   conAct2 += actualAmt2;
                               if(actualAmt3!=null)
                                   conAct3 += actualAmt3;
                               if(actualAmt4!=null)
                                   conAct4 += actualAmt4;
                               if(actualAmt5!=null)
                                   conAct5 += actualAmt5;
                               if(actualAmt6!=null)
                                   conAct6 += actualAmt6;
                               if(actualAmt7!=null)
                                   conAct7 += actualAmt7;
                               if(actualAmt8!=null)
                                   conAct8 += actualAmt8;
                               if(actualAmt9!=null)
                                   conAct9 += actualAmt9;
                               if(actualAmt10!=null)
                                   conAct10 += actualAmt10;
                               if(actualAmt11!=null)
                                   conAct11 += actualAmt11;
                               if(actualAmt12!=null)
                                   conAct12 += actualAmt12;
                               conActTot = conAct1+conAct2+conAct3+conAct4+conAct5+conAct6+conAct7+conAct8+conAct9+conAct10+conAct11+conAct12;
                         
                           
                             
                        }
                       //****************************Actual-End*********************************************
                               
                       //****************************lineItemLabel-Start************************************
                        if(lineObj.Name != null && lineObj.Line_Description__c != null){
                            lineLabel = lineObj.Name +'#'+lineObj.Line_Description__c;
                        }
                        //****************************lineItemLabel-End************************************
                        String l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,rf,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,wr1,wr2,wr3,wr4,wr5,wr6,wr7,wr8,wr9,wr10,wr11,wr12;
                        Decimal TotLineInFCastAmt=0,TotRiskAmt=0,TotWriskAmt=0; 
                        if(mapLineVsmodList.containsKey(lineObj.id)){
                            Decimal riskfactor=0,modelWRiskAmt=0,modelRiskAmt=0,lineInFCastAmt=0,lineInFCastAmt1=0,lineInFCastAmt2=0,lineInFCastAmt3=0,lineInFCastAmt4=0,lineInFCastAmt5=0,lineInFCastAmt6=0,lineInFCastAmt7=0,lineInFCastAmt8=0,lineInFCastAmt9=0,lineInFCastAmt10=0,lineInFCastAmt11=0,lineInFCastAmt12=0;
                            Decimal riskAmt1=0,riskAmt2=0,riskAmt3=0,riskAmt4=0,riskAmt5=0,riskAmt6=0,riskAmt7=0,riskAmt8=0,riskAmt9=0,riskAmt10=0,riskAmt11=0,riskAmt12=0;
                            Decimal WriskAmt1=0,WriskAmt2=0,WriskAmt3=0,WriskAmt4=0,WriskAmt5=0,WriskAmt6=0,WriskAmt7=0,WriskAmt8=0,WriskAmt9=0,WriskAmt10=0,WriskAmt11=0,WriskAmt12=0;
                            if(lineObj.Risk_Factor__c != null){
                              riskfactor = math.round(lineObj.Risk_Factor__c);     
                            }
                           for(FCST_Initial_Forecast__c modelObj:mapLineVsmodList.get(lineObj.id)){
                               lineFCastWoutRisk='';lineRiskFactor='';lineRisk='';lineFCastWRisk='';
                               String fiscalPeriod=modelObj.FCST_Planning_Fiscal_Year__r.Name; 
                               String planningP = fiscalPeriod.split('P')[1];
                               if(modelObj.Fcst_Amount__c!=null){
                                  lineInFCastAmt = Math.round((modelObj.Fcst_Amount__c));
                                  modelRiskAmt = Math.round((modelObj.RiskAmount__c));
                                  modelWRiskAmt = Math.round((modelObj.Forecast_with_Risk__c));
                                  if(planningP=='01'){
                                  lineInFCastAmt1 += lineInFCastAmt;
                                  riskAmt1 += modelRiskAmt;
                                  WriskAmt1 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt1;
                                  TotRiskAmt += riskAmt1;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l1='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt1.setscale(0).format(), args2)+'</div></td>'; 
                                  wr1='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt1.setscale(0).format(), args2)+'</div></td>'; 
                                  if(riskAmt1 < 0){ 
                                     riskAmt1 = riskAmt1*-1; 
                                     r1='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt1.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='02'){
                                  lineInFCastAmt2 += lineInFCastAmt;
                                  riskAmt2 += modelRiskAmt;
                                  WriskAmt2 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt2;
                                  TotRiskAmt += riskAmt2;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l2='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt2.setscale(0).format(), args2)+'</div></td>';
                                  wr2='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt2.setscale(0).format(), args2)+'</div></td>'; 
                                  if(riskAmt2 < 0){ 
                                     riskAmt2 = riskAmt2*-1; 
                                     r2='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt2.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }  
                                  }
                                  if(planningP=='03'){
                                  lineInFCastAmt3 += lineInFCastAmt;
                                  riskAmt3 +=modelRiskAmt;
                                  WriskAmt3 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt3;
                                  TotRiskAmt += riskAmt3;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l3='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt3.setscale(0).format(), args2)+'</div></td>';
                                  wr3='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt3.setscale(0).format(), args2)+'</div></td>'; 
                                  if(riskAmt3 < 0){ 
                                     riskAmt3 = riskAmt3*-1; 
                                     r3='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt3.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }      
                                  }
                                  if(planningP=='04'){
                                  lineInFCastAmt4 += lineInFCastAmt;
                                  riskAmt4 += modelRiskAmt;
                                  WriskAmt4 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt4;
                                  TotRiskAmt += riskAmt4;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l4='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt4.setscale(0).format(), args2)+'</div></td>'; 
                                  wr4='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt4.setscale(0).format(), args2)+'</div></td>'; 
                                  if(riskAmt4 < 0){ 
                                     riskAmt4 = riskAmt4*-1; 
                                     r4='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt4.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }       
                                  }
                                  if(planningP=='05'){
                                  lineInFCastAmt5 += lineInFCastAmt;
                                  riskAmt5 += modelRiskAmt;
                                  WriskAmt5 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt5;
                                  TotRiskAmt += riskAmt5;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l5='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt5.setscale(0).format(), args2)+'</div></td>'; 
                                  wr5='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt5.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt5 < 0){ 
                                     riskAmt5 = riskAmt5*-1; 
                                     r5='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt5.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }   
                                  }
                                  if(planningP=='06'){
                                  lineInFCastAmt6 += lineInFCastAmt;
                                  riskAmt6 += modelRiskAmt;
                                  WriskAmt6 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt6;
                                  TotRiskAmt += riskAmt6;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l6='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt6.setscale(0).format(), args2)+'</div></td>';
                                  wr6='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt6.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt6 < 0){ 
                                     riskAmt6 = riskAmt6*-1; 
                                     r6='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt6.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }     
                                  }
                                  if(planningP=='07'){
                                  lineInFCastAmt7 += lineInFCastAmt;
                                  riskAmt7 += modelRiskAmt;
                                  WriskAmt7 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt7;
                                  TotRiskAmt += riskAmt7;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l7='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt7.setscale(0).format(), args2)+'</div></td>';                           
                                  wr7='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt7.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt7 < 0){ 
                                     riskAmt7 = riskAmt7*-1; 
                                     r7='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt7.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='08'){
                                  lineInFCastAmt8 += lineInFCastAmt;
                                  riskAmt8 += modelRiskAmt;
                                  WriskAmt8 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt8;
                                  TotRiskAmt += riskAmt8;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l8='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt8.setscale(0).format(), args2)+'</div></td>';                           
                                 wr8='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt8.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt8 < 0){ 
                                     riskAmt8 = riskAmt8*-1; 
                                     r8='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt8.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='09'){
                                  lineInFCastAmt9 += lineInFCastAmt;
                                  riskAmt9 +=modelRiskAmt;
                                  WriskAmt9 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt9;
                                  TotRiskAmt += riskAmt9;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l9='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt9.setscale(0).format(), args2)+'</div></td>';                           
                                 wr9='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt9.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt9 < 0){ 
                                     riskAmt9 = riskAmt9*-1; 
                                     r9='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt9.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='10'){
                                  lineInFCastAmt10 += lineInFCastAmt;
                                  riskAmt10 += modelRiskAmt;
                                  WriskAmt10 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt10;
                                  TotRiskAmt += riskAmt10;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l10='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt10.setscale(0).format(), args2)+'</div></td>';                           
                                 wr10='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt10.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt10 < 0){ 
                                     riskAmt10 = riskAmt10*-1; 
                                     r10='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt10.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='11'){
                                  lineInFCastAmt11 += lineInFCastAmt;
                                  riskAmt11 += modelRiskAmt;
                                  WriskAmt11 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt11;
                                  TotRiskAmt += riskAmt11;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l11='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt11.setscale(0).format(), args2)+'</div></td>';                           
                                  wr11='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt11.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt11 < 0){ 
                                     riskAmt11 = riskAmt11*-1; 
                                     r11='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt11.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='12'){
                                  lineInFCastAmt12 += lineInFCastAmt;
                                  riskAmt12 += modelRiskAmt;
                                  WriskAmt12 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt12;
                                  TotRiskAmt += riskAmt12;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                  l12='<td><div style="text-align: left;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt12.setscale(0).format(), args2)+'</div></td>';                           
                                  wr12='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt12.setscale(0).format(), args2)+'</div></td>'; 
                                      if(riskAmt12 < 0){ 
                                     riskAmt12 = riskAmt12*-1; 
                                     r12='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt12.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }
                                  }
                               }
                             
                           }
                              if(lineInFCastAmt1!=null)
                                   conWOR1 += lineInFCastAmt1;
                               if(lineInFCastAmt2!=null)
                                   conWOR2 += lineInFCastAmt2;
                               if(lineInFCastAmt3!=null)
                                   conWOR3 += lineInFCastAmt3;
                               if(lineInFCastAmt4!=null)
                                   conWOR4 += lineInFCastAmt4;
                               if(lineInFCastAmt5!=null)
                                   conWOR5 += lineInFCastAmt5;
                               if(lineInFCastAmt6!=null)
                                   conWOR6 += lineInFCastAmt6;
                               if(lineInFCastAmt7!=null)
                                   conWOR7 += lineInFCastAmt7;
                               if(lineInFCastAmt8!=null)
                                   conWOR8 += lineInFCastAmt8;
                               if(lineInFCastAmt9!=null)
                                   conWOR9 += lineInFCastAmt9;
                               if(lineInFCastAmt10!=null)
                                   conWOR10 += lineInFCastAmt10;
                               if(lineInFCastAmt11!=null)
                                   conWOR11 += lineInFCastAmt11;
                               if(lineInFCastAmt12!=null)
                                   conWOR12 += lineInFCastAmt12;
                               conTotWOR = conWOR1+conWOR2+conWOR3+conWOR4+conWOR5+conWOR6+conWOR7+conWOR8+conWOR9+conWOR10+conWOR11+conWOR12;
                            if(WriskAmt1!=null)
                                   conWR1 += WriskAmt1;
                               if(WriskAmt2!=null)
                                   conWR2 += WriskAmt2;
                               if(WriskAmt3!=null)
                                   conWR3 += WriskAmt3;
                               if(WriskAmt4!=null)
                                   conWR4 += WriskAmt4;
                               if(WriskAmt5!=null)
                                   conWR5 += WriskAmt5;
                               if(WriskAmt6!=null)
                                   conWR6 += WriskAmt6;
                               if(WriskAmt7!=null)
                                   conWR7 += WriskAmt7;
                               if(WriskAmt8!=null)
                                   conWR8 += WriskAmt8;
                               if(WriskAmt9!=null)
                                   conWR9 += WriskAmt9;
                               if(WriskAmt10!=null)
                                   conWR10 += WriskAmt10;
                               if(WriskAmt11!=null)
                                   conWR11 += WriskAmt11;
                               if(WriskAmt12!=null)
                                   conWR12 += WriskAmt12;
                               conTotWR = conWR1+conWR2+conWR3+conWR4+conWR5+conWR6+conWR7+conWR8+conWR9+conWR10+conWR11+conWR12;
                            rf='<td><div style="text-align: left;background-color:white;" id='+lineObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskfactor.setscale(0).format(), args2)+'%'+'</div></td>';
                        }
                        if(rf==null){rf='<td style="text-align: left;background-color:white;"   >'+0+'%'+'</td>';  }
                        if(l1==null){l1='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l2==null){l2='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l3==null){l3='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l4==null){l4='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l5==null){l5='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l6==null){l6='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l7==null){l7='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l8==null){l8='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l9==null){l9='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l10==null){l10='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l11==null){l11='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                        if(l12==null){l12='<td style="text-align: left;"   >'+userCurrencySign+0+'%'+'</td>';  }
                               
                        if(r1==null){r1='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r2==null){r2='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r3==null){r3='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r4==null){r4='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r5==null){r5='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r6==null){r6='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r7==null){r7='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r8==null){r8='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r9==null){r9='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r10==null){r10='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r11==null){r11='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(r12==null){r12='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                      
                       if(wr1==null){wr1='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr2==null){wr2='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr3==null){wr3='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr4==null){r4='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr5==null){wr5='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr6==null){wr6='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr7==null){wr7='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr8==null){wr8='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr9==null){wr9='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr10==null){wr10='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr11==null){wr11='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                        if(wr12==null){wr12='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                               
                        lineRow ='<tr title="line Name" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+lineLabel+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
                        lineActualRow = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Actual Amount</b></td><td>'+userCurrencySign+ String.format(actualAmt1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(actualAmt12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(totActualAmt.setscale(0).format(), args2)+'</td></tr>';
                        lineFCastWoutRisk += '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast without Risk</b></td>'; 
                        lineFCastWoutRisk += l1+l2+l3+l4+l5+l6+l7+l8+l9+l10+l11+l12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotLineInFCastAmt.setscale(0).format(), args2)+'</div></td></tr>';
                               
                        lineFCastWRisk += '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast with Risk</b></td>'; 
                        lineFCastWRisk += wr1+wr2+wr3+wr4+wr5+wr6+wr7+wr8+wr9+wr10+wr11+wr12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotWriskAmt.setscale(0).format(), args2)+'</div></td></tr>'; 
                               
                        lineRisk += '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Risk</b></td>';
                        if(TotRiskAmt < 0){        
                        lineRisk += r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+'<td><div style="text-align: left;" >'+userCurrencySign+'('+String.format((TotRiskAmt*-1).setscale(0).format(), args2)+')'+'</div></td></tr>'; 
                        }else{
                          lineRisk += r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format((TotRiskAmt).setscale(0).format(), args2)+'</div></td></tr>';   
                        }
                        lineRiskFactor += '<tr><td style="text-align: right;background-color:rgb(217,217,217);pointer-events: none;"><b>Risk Factor</b></td>';
                        lineRiskFactor += rf+'<td colspan="13" style="text-align: right;background-color:rgb(217,217,217);pointer-events: none;"></td></tr>';     
                        lineBody +=lineRow+lineActualRow+lineFCastWoutRisk+lineFCastWRisk+lineRisk+lineRiskFactor;
                           }
                        }
                        //****************************ContractLine-End*************************************
                       if(conWOR1!=null)
                                   accWOR1 += conWOR1;
                               if(conWOR2!=null)
                                   accWOR2 += conWOR2;
                               if(conWOR3!=null)
                                   accWOR3 += conWOR3;
                               if(conWOR4!=null)
                                   accWOR4 += conWOR4;
                               if(conWOR5!=null)
                                   accWOR5 += conWOR5;
                               if(conWOR6!=null)
                                   accWOR6 += conWOR6;
                               if(conWOR7!=null)
                                   accWOR7 += conWOR7;
                               if(conWOR8!=null)
                                   accWOR8 += conWOR8;
                               if(conWOR9!=null)
                                   accWOR9 += conWOR9;
                               if(conWOR10!=null)
                                   accWOR10 += conWOR10;
                               if(conWOR11!=null)
                                   accWOR11 += conWOR11;
                               if(conWOR12!=null)
                                   accWOR12 += conWOR12;
                               accTotWOR = accWOR1+accWOR2+accWOR3+accWOR4+accWOR5+accWOR6+accWOR7+accWOR8+accWOR9+accWOR10+accWOR11+accWOR12;
                            if(conWR1!=null)
                                   accWR1 += conWR1;
                               if(conWR2!=null)
                                   accWR2 += conWR2;
                               if(conWR3!=null)
                                   accWR3 += conWR3;
                               if(conWR4!=null)
                                   accWR4 += conWR4;
                               if(conWR5!=null)
                                   accWR5 += conWR5;
                               if(conWR6!=null)
                                   accWR6 += conWR6;
                               if(conWR7!=null)
                                   accWR7 += conWR7;
                               if(conWR8!=null)
                                   accWR8 += conWR8;
                               if(conWR9!=null)
                                   accWR9 += conWR9;
                               if(conWR10!=null)
                                   accWR10 += conWR10;
                               if(conWR11!=null)
                                   accWR11 += conWR11;
                               if(conWR12!=null)
                                   accWR12 += conWR12;
                               accTotWR = accWR1+accWR2+accWR3+accWR4+accWR5+accWR6+accWR7+accWR8+accWR9+accWR10+accWR11+accWR12;
                         if(conAct1!=null)
                                   accAct1 += conAct1;
                               if(conAct2!=null)
                                   accAct2 += conAct2;
                               if(conAct3!=null)
                                   accAct3 += conAct3;
                               if(conAct4!=null)
                                   accAct4 += conAct4;
                               if(conAct5!=null)
                                   accAct5 += conAct5;
                               if(conAct6!=null)
                                   accAct6 += conAct6;
                               if(conAct7!=null)
                                   accAct7 += conAct7;
                               if(conAct8!=null)
                                   accAct8 += conAct8;
                               if(conAct9!=null)
                                   accAct9 += conAct9;
                               if(conAct10!=null)
                                   accAct10 += conAct10;
                               if(conAct11!=null)
                                   accAct11 += conAct11;
                               if(conAct12!=null)
                                   accAct12 += conAct12;
                               accActTot = accAct1+accAct2+accAct3+accAct4+accAct5+accAct6+accAct7+accAct8+accAct9+accAct10+accAct11+accAct12;
                      
                        
                      conRow='<tr title="Q Name" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+conLabel+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
                      conActualRow = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Actual Amount</b></td><td>'+userCurrencySign+ String.format(conAct1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conAct12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(conActTot.setscale(0).format(), args2)+'</td></tr>';
                      conFCastWoutRisk = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast without Risk</b></td><td>'+userCurrencySign+ String.format(conWOR1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWOR12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(conTotWOR.setscale(0).format(), args2)+'</td></tr>';
                        
                      conFCastWRisk = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast with Risk</b></td><td>'+userCurrencySign+ String.format(conWR1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(conWR12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(conTotWR.setscale(0).format(), args2)+'</td></tr>';
                    }
                    
                    
                    oppQRow='<tr title="Q Name" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+oppObj.Fcst_Text_QNum__c+' '+oppObj.name+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
                    TotOppRow += oppQRow+oppInFCastString+conRow+conActualRow+conFCastWoutRisk+conFCastWRisk+lineBody;
                }
              
             }
             String accountRow='<tr title="Account Name" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+oppHavingAccountIdName.get(acciD)+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
             String actualRow='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Actual Amount</b></td><td>'+userCurrencySign+ String.format(accAct1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accAct12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(accActTot.setscale(0).format(), args2)+'</td></tr>';
             String accountWithoutRRow='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast without Risk</b></td><td>'+userCurrencySign+ String.format(accWOR1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWOR12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(accTotWOR.setscale(0).format(), args2)+'</td></tr>';
             
             String accountWithRRow='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast with Risk</b></td><td>'+userCurrencySign+ String.format(accWR1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(accWR12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(accTotWR.setscale(0).format(), args2)+'</td></tr>';
             String ClosedCatRow='<tr style="background-color:rgb(217,225,242);"><th style="background-color:rgb(217,225,242);size: 10%;text-align: center;color:black" colspan="14"><b>Closed Won Amount</b></th></tr>';
              tableBody+=accountRow+actualRow+accountWithoutRRow+accountWithRRow+ClosedCatRow+TotOppRow;
         }
         tableRecord+=tableBody+'</table>'; 
         tableBlock=tableRecord;
         if(tableBody!='' || String.isNotEmpty(tableBody) || String.isNotBlank(tableBody)){
         IsTableDataPresent = true;
         }
         }catch(Exception e){
            System.debug('Exception error Message>>>>>>> '+e);
            System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
       }
        return null;
    }
    

/*********************************************fetchOppMethod End***************************************************************/ 
 public pageReference updateRiskFactor(){
      try{
          String lineidStr=Apexpages.currentPage().getParameters().get('id');
          Id lineId;
          if(lineidStr!=null)
             lineId=Id.valueOf(lineidStr);
             String riskFactor=Apexpages.currentPage().getParameters().get('riskFactor');
             Decimal riskDecimal;
             if(riskFactor!=null)
                riskDecimal=decimal.valueOf(riskFactor); 
             Contract_LineItem__c lineRecord =[select id,Risk_Factor__c from Contract_LineItem__c where id=:lineId limit 1];
             if(lineRecord !=null){
                lineRecord.Risk_Factor__c =riskDecimal;
                update lineRecord;
             }
          } catch(Exception e){
                  System.debug('Exception error Message>>>>>>> '+e);
                  System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
          }
  return null;     
 }
    
    
//****************************************************Update Model Start ********************************************************//
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
 //****************************************************Update Model End ********************************************************//

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
        PageReference pg = new Pagereference('/apex/FCST_CompucomSummaryWorkBench?pv='+pVVersionStringId+'&su='+UserStringId+'&AccId='+AccountId);
        pg.setredirect(true);
        return pg;
    }
    
/***********************************Filter List Start ********************************************/ 
//Planning Year   
        public List<SelectOption> getPlanningYearOptionList() {
        List<SelectOption> PlanningYearoptions = new List<SelectOption>();
        Integer myear = (system.today()).year();
        set<string> setYear = new set<string>();
        set<string> setValidVersions = new set<string>{'Open (Admin)'};
        for(Planning_Version__c cp :  [select id,Planning_Version_Fiscal_Year__c,Is_this_a_Budget_Planning_Version__c  from Planning_Version__c where Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false  and Planning_Version_Fiscal_Year__c <> '2017' and Version_Status__c IN: setValidVersions order by Planning_Version_Fiscal_Year__c]){
            setYear.add(cp.Planning_Version_Fiscal_Year__c);
        } 
        for(string cp : setYear){
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
    
 //Planning Version     

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
        
        for(Planning_Version__c pvObj:[Select Name,Version_Status__c from Planning_Version__c where (Version_Status__c='Open (User)' OR Version_Status__c='Open (Admin)' OR Version_Status__c='In Progress' ) and Id!=null ]){
                if(strPlanningVersion!=pvObj.Name){
                    planningVersionOption.add(new SelectOption(pvObj.Name,pvObj.Name));
                }
          }
        return planningVersionOption;
     }
    
    
 /***********************************Filter List End ********************************************/
    //>>>>>>>>>>>>>>>>>>>>>>>Account  change start//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   public void getContractChange(){
       try{ 
           conNameList = new List<String>();
           conNameList = strContract.split('#');
           conName = conNameList[conNameList.size()-1];
           conList = new List<FCST_Contract__c>(); 
           lineList = new List<Contract_LineItem__c>();
           lineSet = new Set<String>();
           String conQuery ='Select id,name,Contract__c,Opportunity__r.name,Contract_Owner__c from FCST_Contract__c where name =:conName and Contract_Owner__c =:UserStringId';
           conList = Database.query(conQuery);
           if(!conList.isEmpty()){
               strOpportunity=String.valueOf(conList[0].Opportunity__r.name);
           }else{
             strOpportunity ='';  
           }
           lineSet.add('All');
           String lineQuery ='Select id,name,FCST_Contract__r.name from Contract_LineItem__c where FCST_Contract__r.name =:conName order by name';
           lineList = Database.query(lineQuery);
           if(!lineList.isEmpty()){
               strLine ='All';
           }
            for(Contract_LineItem__c lineObj: lineList){
                lineSet.add(lineObj.name);
            }
          
       
       
          
        
       }
       catch(Exception e){
           System.debug('getAccountChange Exception error Message>>>>>>> '+e.getLineNumber());
           System.debug('getAccountChange Exception error Message>>>>>>> '+e);
       }   
   
   }
   //>>>>>>>>>>>>>>>>>>>>>>>Account  change End//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   
}