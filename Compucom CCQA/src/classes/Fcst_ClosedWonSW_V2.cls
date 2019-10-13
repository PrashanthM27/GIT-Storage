public with sharing class Fcst_ClosedWonSW_V2 {  
   
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
    public List<Opportunity> oppList;
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
   public Fcst_ClosedWonSW_V2(){ 
       try{ 
           mfu = new MappingFieldUtility();
           getFromPlanningVersion();
           IsTableDataPresent = true;
           yearList= new List<Integer>();
           accountList = new List<Account>();
           oppList = new List<Opportunity>();
           conList = new List<FCST_Contract__c>();
           lineList = new List<Contract_LineItem__c>();
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
          
            String conQuery ='Select id,name,Contract__c,Contract_Owner__c,FCST_Q__c,Contract_Description__c,Opportunity__r.name,Fcst_Account__c,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.name =:strAccount and FCST_Contract_Created_Year__c >=: strPlanningYear order by name';
            conList = Database.query(conQuery);
           if(!conList.isEmpty()){
               if(conList[0].Contract__c!=null){
               strContract =String.valueOf(conList[0].FCST_Q__c+'#'+conList[0].Contract__c);
               }else{
               strContract =String.valueOf(conList[0].FCST_Q__c);  
               }
               strOpportunity=String.valueOf(conList[0].Opportunity__r.name);
           }
            for(FCST_Contract__c conObj: conList){
                opportunitySet.add(conObj.Opportunity__r.name);
                if(conObj.Contract__c!=null){
                contractSet.add(conObj.FCST_Q__c+'#'+conObj.Contract__c);
                }else{
                contractSet.add(conObj.FCST_Q__c);  
                }
            }
           lineSet.add('All');
           if(strContract!=null){
           conNameList = strContract.split('#');
           conName = conNameList[0];
           }
           String lineQuery1='';
           System.debug('conName>>>>'+conName);
           if(conName!=null && String.isNotBlank(conName)){
           lineQuery1 ='Select id,name,FCST_Q__c from Contract_LineItem__c where  FCST_Q__c =:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.name=:strPlanningVersion) order by name';
           }
           if(String.isNotBlank(lineQuery1))
           lineList = Database.query(lineQuery1);
           if(!lineList.isEmpty()){
               strLine ='All';
           }
         //  if(!lineList.isEmpty())
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
           if(strPlanningYear!=null && strPlanningYear.isNumeric())
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
            //  System.debug('>>>planningPeriod...'+planningPeriod);
           for(Opportunity oppObj : oppList){
              if(oppObj.StageName=='Closed Won'){
                 StageNameSet.add(oppObj.StageName);  
              } 
           }
       String oppQueryString='';
          if(Test.isRunningTest()){
			oppQueryString='Select Account.Owner.Id,Id,Name,Account.Id,Account.Name,Owner.Id,Division__c from Opportunity where Id IN (select Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__r.Account.name=:strAccount  and FCST_Planning_Version__r.name=:strPlanningVersion and Fcst_Fiscal_Period__r.Name LIKE :likeStr)';
        		 oppQueryString+=' and Name =:strOpportunity and Account.Name =:strAccount ';
                 oppQueryString+=' order by Account.Name';
			}
			else{
				oppQueryString='Select Account.Owner.Id,Id,Name,Account.Id,Account.Name,Owner.Id,'+mfu.getQNum()+' from Opportunity where Id IN (select Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__r.Account.name=:strAccount  and FCST_Planning_Version__r.name=:strPlanningVersion and Fcst_Fiscal_Period__r.Name LIKE :likeStr)';
        		 oppQueryString+=' and Name =:strOpportunity and Account.Name =:strAccount ';
                 oppQueryString+=' order by Account.Name';
			} 
         
         
          System.debug('>>>oppQueryString>>>'+oppQueryString);
         List<Opportunity> OpporrtunityList=database.query(oppQueryString);
        
      System.debug('>>>OpporrtunityList>>>'+OpporrtunityList);
          
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
         String conQuery ='Select id,name,Contract__c,Contract_Description__c,FCST_Q__c,Opportunity__c,Contract_Owner__c from FCST_Contract__c where FCST_Q__c =:conName and FCST_Contract_Created_Year__c>=: strPlanningYear order by name';
                
           for(FCST_Contract__c c : Database.query(conQuery)){
               mapOppIdVsContract.put(c.Opportunity__c,c);
           }
         String lineQuery='',lineCountQuery='';
         if(conName!=null && String.isNotBlank(conName)){
          lineQuery = 'Select id,name,FCST_Contract__r.Contract__c,Line_Description__c,FCST_Q__c from Contract_LineItem__c where FCST_Q__c =:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr ) ';
          lineCountQuery = 'Select id,name,FCST_Contract__r.Contract__c,Line_Description__c,FCST_Q__c from Contract_LineItem__c where FCST_Q__c =:conName and Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr ) ';  
           if(strLine!='All' && strLine!=null && String.isNotBlank(strLine)){
                lineQuery +=' and name=:strLine ';
                lineCountQuery +=' and name=:strLine ';
           }
                lineQuery +=' order by name limit :list_size  offset :counter';
                lineCountQuery +=' order by name';
           }
           if(String.isNotBlank(lineCountQuery)){
           List<Contract_LineItem__c> lineCountResult = Database.query(lineCountQuery);
           
           total_size=lineCountResult.size();
           }
           if(total_size>2000){
              total_size=2000;
           }
           if(String.isNotBlank(lineQuery))
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
          
         String initialFcastQuery = 'select id,Name,Contract_LineItem__c,Fcst_Amount__c,FCST_Contract__c,FCST_Fiscal_Year_List__c,FCST_Planning_Fiscal_Year__r.name,Planning_Version__r.name,RiskAmount__c,Forecast_with_Risk__c,Risk_Factor__c from FCST_Initial_Forecast__c where Contract_LineItem__c IN :lineIds and Planning_Version__r.name =:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name LIKE :likeStr ';
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
         String oppInFcastQuery = 'Select id,name,Fcst_Fiscal_Period__r.name,Fcst_Q__c,User_Adjusted_Revenue__c,Fcst_Opportunity__c,FCST_Planning_Version__c,FCST_Planning_Version__r.name from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__r.name =:strOpportunity and FCST_Planning_Version__r.name=:strPlanningVersion and  Fcst_Fiscal_Period__r.Name LIKE :likeStr';
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
           
         String actualQuery ='select id,name,Account__c,Contract_LineItem__c,Actual_Amount__c,Fiscal_Period__r.name from Actual_Model__c where Account__c=:AccountId and Fiscal_Period__r.Name LIKE :likeStr and FCST_Planning_Version__r.name=:strPlanningVersion';
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
              Decimal accTotWORNeg=0,accWORNeg1=0,accWORNeg2=0,accWORNeg3=0,accWORNeg4=0,accWORNeg5=0,accWORNeg6=0,accWORNeg7=0,accWORNeg8=0,accWORNeg9=0,accWORNeg10=0,accWORNeg11=0,accWORNeg12=0;
              Decimal accTotWR=0,accWR1=0,accWR2=0,accWR3=0,accWR4=0,accWR5=0,accWR6=0,accWR7=0,accWR8=0,accWR9=0,accWR10=0,accWR11=0,accWR12=0;
              Decimal accTotWRNeg=0,accWRNeg1=0,accWRNeg2=0,accWRNeg3=0,accWRNeg4=0,accWRNeg5=0,accWRNeg6=0,accWRNeg7=0,accWRNeg8=0,accWRNeg9=0,accWRNeg10=0,accWRNeg11=0,accWRNeg12=0;
              Decimal accActTot=0,accAct1=0,accAct2=0,accAct3=0,accAct4=0,accAct5=0,accAct6=0,accAct7=0,accAct8=0,accAct9=0,accAct10=0,accAct11=0,accAct12=0;
              Decimal accActTotNeg=0,accActNeg1=0,accActNeg2=0,accActNeg3=0,accActNeg4=0,accActNeg5=0,accActNeg6=0,accActNeg7=0,accActNeg8=0,accActNeg9=0,accActNeg10=0,accActNeg11=0,accActNeg12=0;
             if(mapAccIdVsOpenOppList.containsKey(acciD)){
                
                for(Opportunity oppObj:mapAccIdVsOpenOppList.get(acciD)){
                    String oppInFCastString='',conRow='',conFCastWoutRisk='',conFCastWRisk='',conActualRow='',lineRow='',lineFCastWoutRisk='',lineFCastWRisk='',lineActualRow='',lineRisk='',lineRiskFactor='',lineBody='';
                    String op1,op2,op3,op4,op5,op6,op7,op8,op9,op10,op11,op12;
                    Decimal opInFCastAmt=0,TotOpInFCastAmt=0,opInFCastAmt1=0,opInFCastAmt2=0,opInFCastAmt3=0,opInFCastAmt4=0,opInFCastAmt5=0,opInFCastAmt6=0,opInFCastAmt7=0,opInFCastAmt8=0,opInFCastAmt9=0,opInFCastAmt10=0,opInFCastAmt11=0,opInFCastAmt12=0;
                    String qnumber = mfu.getQNum();
                    oppObj.Fcst_Text_QNum__c = (String)oppObj.get(qnumber);
                    if(mapoppVsmodList.containsKey(oppObj.id)){
                    for(FCST_Opportunity_Initial_Forecast__c OppInObj : mapoppVsmodList.get(oppObj.id)){
                        System.debug('OppInObj>>>>>'+OppInObj);
                        String fiscalPeriod=OppInObj.Fcst_Fiscal_Period__r.Name; 
                        String planningP = fiscalPeriod.split('P')[1];
                        if(OppInObj.User_Adjusted_Revenue__c!=null){
                           opInFCastAmt = Math.round((OppInObj.User_Adjusted_Revenue__c));
                           System.debug('....planningP...'+planningP);
                           if(planningP=='01'){
                              opInFCastAmt1 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                               if(opInFCastAmt1<0){
                                   opInFCastAmt1 = opInFCastAmt1 * -1;
                                op1='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt1.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op1='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt1.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='02'){
                              opInFCastAmt2 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                               if(opInFCastAmt2<0){
                                   opInFCastAmt2 = opInFCastAmt2 * -1;
                                op2='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt2.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op2='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt2.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='03'){
                              opInFCastAmt3 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                               if(opInFCastAmt3<0){
                                   opInFCastAmt3 = opInFCastAmt3 * -1;
                                op3='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt3.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op3='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt3.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='04'){
                              opInFCastAmt4 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt4<0){
                                   opInFCastAmt4 = opInFCastAmt4 * -1;
                                op4='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt4.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op4='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt4.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='05'){
                              opInFCastAmt5 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt5<0){
                                   opInFCastAmt5 = opInFCastAmt5 * -1;
                                op5='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt5.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op5='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt5.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='06'){
                              opInFCastAmt6 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt6<0){
                                   opInFCastAmt6 = opInFCastAmt6 * -1;
                                op6='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt6.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op6='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt6.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='07'){
                              opInFCastAmt7 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt7<0){
                                   opInFCastAmt7 = opInFCastAmt7 * -1;
                                op7='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt7.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op7='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt7.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='08'){
                              opInFCastAmt8 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt8<0){
                                   opInFCastAmt8 = opInFCastAmt8 * -1;
                                op8='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt8.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op8='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt8.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='09'){
                              opInFCastAmt9 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt9<0){
                                   opInFCastAmt9 = opInFCastAmt9 * -1;
                                op9='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt9.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op9='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt9.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='10'){
                              opInFCastAmt10 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt10<0){
                                   opInFCastAmt10 = opInFCastAmt10 * -1;
                                op10='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt10.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op10='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt10.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='11'){
                              opInFCastAmt11 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt11<0){
                                   opInFCastAmt11 = opInFCastAmt11 * -1;
                                op11='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt11.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op11='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt11.setscale(0).format(), args2)+'</div></td>';  
                               }
                           }
                           if(planningP=='12'){
                              opInFCastAmt12 += opInFCastAmt;
                              TotOpInFCastAmt += opInFCastAmt;
                              if(opInFCastAmt12<0){
                                   opInFCastAmt12 = opInFCastAmt12 * -1;
                                op12='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+'('+String.format(opInFCastAmt12.setscale(0).format(), args2)+')'+'</div></td>';
                               }else{
                                 op12='<td><div style="text-align: left;" id=ad'+OppInObj.Id+' contenteditable='+NonEditable+' >'+userCurrencySign+String.format(opInFCastAmt12.setscale(0).format(), args2)+'</div></td>';  
                               }
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
                    oppInFCastString+='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;">PM FORECAST</td>';
                    oppInFCastString+=op1+op2+op3+op4+op5+op6+op7+op8+op9+op10+op11+op12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotOpInFCastAmt.setscale(0).format(), args2)+'</div></td></tr>';
                    
                    if(mapOppIdVsContract.containsKey(oppObj.id)){
                       lineRow='';lineBody='';
                       Decimal conTotWOR=0,conWOR1=0,conWOR2=0,conWOR3=0,conWOR4=0,conWOR5=0,conWOR6=0,conWOR7=0,conWOR8=0,conWOR9=0,conWOR10=0,conWOR11=0,conWOR12=0;
                       Decimal conTotWORNeg=0,conWORNeg1=0,conWORNeg2=0,conWORNeg3=0,conWORNeg4=0,conWORNeg5=0,conWORNeg6=0,conWORNeg7=0,conWORNeg8=0,conWORNeg9=0,conWORNeg10=0,conWORNeg11=0,conWORNeg12=0;
                       Decimal conTotWR=0,conWR1=0,conWR2=0,conWR3=0,conWR4=0,conWR5=0,conWR6=0,conWR7=0,conWR8=0,conWR9=0,conWR10=0,conWR11=0,conWR12=0;
                       Decimal conTotWRNeg=0,conWRNeg1=0,conWRNeg2=0,conWRNeg3=0,conWRNeg4=0,conWRNeg5=0,conWRNeg6=0,conWRNeg7=0,conWRNeg8=0,conWRNeg9=0,conWRNeg10=0,conWRNeg11=0,conWRNeg12=0;
                       Decimal conActTot=0,conAct1=0,conAct2=0,conAct3=0,conAct4=0,conAct5=0,conAct6=0,conAct7=0,conAct8=0,conAct9=0,conAct10=0,conAct11=0,conAct12=0;
                       Decimal conActTotNeg=0,conActNeg1=0,conActNeg2=0,conActNeg3=0,conActNeg4=0,conActNeg5=0,conActNeg6=0,conActNeg7=0,conActNeg8=0,conActNeg9=0,conActNeg10=0,conActNeg11=0,conActNeg12=0;
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
                            String lineLabel='',lineLabelWrap='';
                            lineActualRow='';
                            Integer i=0;
                           for(Contract_LineItem__c lineObj:mapConIdVslineList.get(conObj.id)){
                       //****************************Actual-Start*******************************************
                       Decimal totActualAmt=0,actualAmt=0,actualAmt1=0,actualAmt2=0,actualAmt3=0,actualAmt4=0,actualAmt5=0,actualAmt6=0,actualAmt7=0,actualAmt8=0,actualAmt9=0,actualAmt10=0,actualAmt11=0,actualAmt12=0;
                       Decimal totActualAmtNeg=0,actualAmtNeg=0,actualAmtNeg1=0,actualAmtNeg2=0,actualAmtNeg3=0,actualAmtNeg4=0,actualAmtNeg5=0,actualAmtNeg6=0,actualAmtNeg7=0,actualAmtNeg8=0,actualAmtNeg9=0,actualAmtNeg10=0,actualAmtNeg11=0,actualAmtNeg12=0;
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
                            lineLabelWrap=lineLabel;
                            if(lineLabel.length()>25){
                                lineLabel = lineLabel.substring(0,25)+'...';
                            }
                        }
                        //****************************lineItemLabel-End************************************
                        String l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,rf,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,wr1,wr2,wr3,wr4,wr5,wr6,wr7,wr8,wr9,wr10,wr11,wr12,rf1,rf2,rf3,rf4,rf5,rf6,rf7,rf8,rf9,rf10,rf11,rf12;
                        Decimal TotLineInFCastAmt=0,TotRiskAmt=0,TotWriskAmt=0; 
                        if(mapLineVsmodList.containsKey(lineObj.id)){
                            Decimal riskFctor=0,modelWRiskAmt=0,modelRiskAmt=0,lineInFCastAmt=0,lineInFCastAmt1=0,lineInFCastAmt2=0,lineInFCastAmt3=0,lineInFCastAmt4=0,lineInFCastAmt5=0,lineInFCastAmt6=0,lineInFCastAmt7=0,lineInFCastAmt8=0,lineInFCastAmt9=0,lineInFCastAmt10=0,lineInFCastAmt11=0,lineInFCastAmt12=0;
                            Decimal lineInFCastAmtNeg1=0,lineInFCastAmtNeg2=0,lineInFCastAmtNeg3=0,lineInFCastAmtNeg4=0,lineInFCastAmtNeg5=0,lineInFCastAmtNeg6=0,lineInFCastAmtNeg7=0,lineInFCastAmtNeg8=0,lineInFCastAmtNeg9=0,lineInFCastAmtNeg10=0,lineInFCastAmtNeg11=0,lineInFCastAmtNeg12=0; 
                            Decimal riskAmt1=0,riskAmt2=0,riskAmt3=0,riskAmt4=0,riskAmt5=0,riskAmt6=0,riskAmt7=0,riskAmt8=0,riskAmt9=0,riskAmt10=0,riskAmt11=0,riskAmt12=0;
                            Decimal WriskAmt1=0,WriskAmt2=0,WriskAmt3=0,WriskAmt4=0,WriskAmt5=0,WriskAmt6=0,WriskAmt7=0,WriskAmt8=0,WriskAmt9=0,WriskAmt10=0,WriskAmt11=0,WriskAmt12=0;
                            Decimal WriskAmtNeg1=0,WriskAmtNeg2=0,WriskAmtNeg3=0,WriskAmtNeg4=0,WriskAmtNeg5=0,WriskAmtNeg6=0,WriskAmtNeg7=0,WriskAmtNeg8=0,WriskAmtNeg9=0,WriskAmtNeg10=0,WriskAmtNeg11=0,WriskAmtNeg12=0;
                           for(FCST_Initial_Forecast__c modelObj:mapLineVsmodList.get(lineObj.id)){
                               lineFCastWoutRisk='';lineRiskFactor='';lineRisk='';lineFCastWRisk='';
                               String fiscalPeriod=modelObj.FCST_Planning_Fiscal_Year__r.Name; 
                               String planningP = fiscalPeriod.split('P')[1];
                               
                               if(modelObj.Fcst_Amount__c!=null){ 
                                  riskFctor = Math.round(modelObj.Risk_Factor__c);
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
                                      
                                  if(lineInFCastAmt1 < 0){ 
                                     lineInFCastAmtNeg1 = lineInFCastAmt1*-1;
                                     l1='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg1.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l1='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt1.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf1='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt1 < 0){ 
                                     WriskAmtNeg1 = WriskAmt1*-1;
                                     wr1='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg1.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr1='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt1.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  if(riskAmt1 < 0){ 
                                     riskAmt1 = riskAmt1*-1; 
                                     r1='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt1.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r1='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt1.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='02'){
                                  lineInFCastAmt2 += lineInFCastAmt;
                                  riskAmt2 += modelRiskAmt;
                                  WriskAmt2 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt2;
                                  TotRiskAmt += riskAmt2;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt2 < 0){ 
                                     lineInFCastAmtNeg2 = lineInFCastAmt2*-1;
                                     l2='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg2.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l2='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt2.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf2='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt2 < 0){ 
                                     WriskAmtNeg2 = WriskAmt2*-1;
                                     wr2='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg2.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr2='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt2.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  if(riskAmt2 < 0){ 
                                     riskAmt2 = riskAmt2*-1; 
                                     r2='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt2.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r2='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt2.setscale(0).format(), args2)+'</div></td>'; 
                                  }  
                                  }
                                  if(planningP=='03'){
                                  lineInFCastAmt3 += lineInFCastAmt;
                                  riskAmt3 +=modelRiskAmt;
                                  WriskAmt3 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt3;
                                  TotRiskAmt += riskAmt3;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                   
                                  if(lineInFCastAmt3 < 0){ 
                                     lineInFCastAmtNeg3 = lineInFCastAmt3*-1;
                                     l3='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg3.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l3='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt3.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf3='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt3 < 0){ 
                                     WriskAmtNeg3 = WriskAmt3*-1;
                                     wr3='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg3.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr3='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt3.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  if(riskAmt3 < 0){ 
                                     riskAmt3 = riskAmt3*-1; 
                                     r3='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt3.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r3='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt3.setscale(0).format(), args2)+'</div></td>'; 
                                  }       
                                  }
                                  if(planningP=='04'){
                                  lineInFCastAmt4 += lineInFCastAmt;
                                  riskAmt4 += modelRiskAmt;
                                  WriskAmt4 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt4;
                                  TotRiskAmt += riskAmt4;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt4 < 0){ 
                                     lineInFCastAmtNeg4 = lineInFCastAmt4*-1;
                                     l4='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg4.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l4='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt4.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf4='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt4 < 0){ 
                                     WriskAmtNeg4 = WriskAmt4*-1;
                                     wr4='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg4.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr4='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt4.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  if(riskAmt4 < 0){ 
                                     riskAmt4 = riskAmt4*-1; 
                                     r4='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt4.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r4='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt4.setscale(0).format(), args2)+'</div></td>'; 
                                  }        
                                  }
                                  if(planningP=='05'){
                                  lineInFCastAmt5 += lineInFCastAmt;
                                  riskAmt5 += modelRiskAmt;
                                  WriskAmt5 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt5;
                                  TotRiskAmt += riskAmt5;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt5 < 0){ 
                                     lineInFCastAmtNeg5 = lineInFCastAmt5*-1;
                                     l5='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg5.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l5='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt5.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf5='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt5 < 0){ 
                                     WriskAmtNeg5 = WriskAmt5*-1;
                                     wr5='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg5.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr5='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt5.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  if(riskAmt5 < 0){ 
                                     riskAmt5 = riskAmt5*-1; 
                                     r5='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt5.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r5='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt5.setscale(0).format(), args2)+'</div></td>'; 
                                  }   
                                  }
                                  if(planningP=='06'){
                                  lineInFCastAmt6 += lineInFCastAmt;
                                  riskAmt6 += modelRiskAmt;
                                  WriskAmt6 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt6;
                                  TotRiskAmt += riskAmt6;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt6 < 0){ 
                                     lineInFCastAmtNeg6 = lineInFCastAmt6*-1;
                                     l6='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg6.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l6='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt6.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf6='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt6 < 0){ 
                                     WriskAmtNeg6 = WriskAmt6*-1;
                                     wr6='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg6.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr6='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt6.setscale(0).format(), args2)+'</div></td>'; 
                                  }    
                                  if(riskAmt6 < 0){ 
                                     riskAmt6 = riskAmt6*-1; 
                                     r6='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt6.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r6='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt6.setscale(0).format(), args2)+'</div></td>'; 
                                  }      
                                  }
                                  if(planningP=='07'){
                                  lineInFCastAmt7 += lineInFCastAmt;
                                  riskAmt7 += modelRiskAmt;
                                  WriskAmt7 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt7;
                                  TotRiskAmt += riskAmt7;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt7 < 0){ 
                                     lineInFCastAmtNeg7 = lineInFCastAmt7*-1;
                                     l7='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg7.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l7='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt7.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf7='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt7 < 0){ 
                                     WriskAmtNeg7 = WriskAmt7*-1;
                                     wr7='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg7.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr7='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt7.setscale(0).format(), args2)+'</div></td>'; 
                                  }    
                                  if(riskAmt7 < 0){ 
                                     riskAmt7 = riskAmt7*-1; 
                                     r7='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt7.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r7='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt7.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='08'){
                                  lineInFCastAmt8 += lineInFCastAmt;
                                  riskAmt8 += modelRiskAmt;
                                  WriskAmt8 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt8;
                                  TotRiskAmt += riskAmt8;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt8 < 0){ 
                                     lineInFCastAmtNeg8 = lineInFCastAmt8*-1;
                                     l8='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg8.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l8='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt8.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf8='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt8 < 0){ 
                                     WriskAmtNeg8 = WriskAmt8*-1;
                                     wr8='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg8.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr8='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt8.setscale(0).format(), args2)+'</div></td>'; 
                                  }     
                                  if(riskAmt8 < 0){ 
                                     riskAmt8 = riskAmt8*-1; 
                                     r8='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt8.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r8='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt8.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='09'){
                                  lineInFCastAmt9 += lineInFCastAmt;
                                  riskAmt9 +=modelRiskAmt;
                                  WriskAmt9 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt9;
                                  TotRiskAmt += riskAmt9;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt9 < 0){ 
                                     lineInFCastAmtNeg9 = lineInFCastAmt9*-1;
                                     l9='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg9.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l9='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt9.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf9='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt9 < 0){ 
                                     WriskAmtNeg9 = WriskAmt9*-1;
                                     wr9='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg9.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr9='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt9.setscale(0).format(), args2)+'</div></td>'; 
                                  }    
                                  if(riskAmt9 < 0){ 
                                     riskAmt9 = riskAmt9*-1; 
                                     r9='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt9.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r9='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt9.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='10'){
                                  lineInFCastAmt10 += lineInFCastAmt;
                                  riskAmt10 += modelRiskAmt;
                                  WriskAmt10 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt10;
                                  TotRiskAmt += riskAmt10;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt10 < 0){ 
                                     lineInFCastAmtNeg10 = lineInFCastAmt10*-1;
                                     l10='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg10.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l10='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt10.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf10='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt10 < 0){ 
                                     WriskAmtNeg10 = WriskAmt10*-1;
                                     wr10='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg10.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr10='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt10.setscale(0).format(), args2)+'</div></td>'; 
                                  }   
                                  if(riskAmt10 < 0){ 
                                     riskAmt10 = riskAmt10*-1; 
                                     r10='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt10.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r10='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt10.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='11'){
                                  lineInFCastAmt11 += lineInFCastAmt;
                                  riskAmt11 += modelRiskAmt;
                                  WriskAmt11 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt11;
                                  TotRiskAmt += riskAmt11;
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt11 < 0){ 
                                     lineInFCastAmtNeg11 = lineInFCastAmt11*-1;
                                     l11='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg11.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l11='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt11.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf11='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>';
                                  if(WriskAmt11 < 0){ 
                                     WriskAmtNeg11 = WriskAmt11*-1;
                                     wr11='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg11.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr11='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt11.setscale(0).format(), args2)+'</div></td>'; 
                                  }    
                                  if(riskAmt11 < 0){ 
                                     riskAmt11 = riskAmt11*-1; 
                                     r11='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt11.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r11='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt11.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                  }
                                  if(planningP=='12'){
                                  lineInFCastAmt12 += lineInFCastAmt;
                                  riskAmt12 += modelRiskAmt;
                                  WriskAmt12 += modelWRiskAmt;
                                  TotWriskAmt += WriskAmt12;
                                  TotRiskAmt += riskAmt12; 
                                  TotLineInFCastAmt += lineInFCastAmt;
                                      
                                  if(lineInFCastAmt12 < 0){ 
                                     lineInFCastAmtNeg12 = lineInFCastAmt12*-1;
                                     l12='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+'('+String.format(lineInFCastAmtNeg12.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     l12='<td><div style="text-align: left;" id=wr'+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)"  contenteditable='+editableCell+' >'+userCurrencySign+String.format(lineInFCastAmt12.setscale(0).format(), args2)+'</div></td>'; 
                                  }
                                      
                                  rf12='<td><div style="text-align: left;background-color:white;" id='+modelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="riskFactorChange(this.id)" contenteditable='+editableCell+' >'+String.format(riskFctor.setscale(0).format(), args2)+'%'+'</div></td>'; 
                                  if(WriskAmt12 < 0){ 
                                     WriskAmtNeg12 = WriskAmt12*-1;
                                     wr12='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+'('+String.format(WriskAmtNeg12.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     wr12='<td><div style="text-align: left;" id=wrisk'+modelObj.Id+ '>'+userCurrencySign+String.format(WriskAmt12.setscale(0).format(), args2)+'</div></td>'; 
                                  }    
                                  if(riskAmt12 < 0){ 
                                     riskAmt12 = riskAmt12*-1; 
                                     r12='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+'('+String.format(riskAmt12.setscale(0).format(), args2)+')'+'</div></td>'; 
                                  }else{
                                     r12='<td><div style="text-align: left;" id=risk'+modelObj.Id+'>'+userCurrencySign+String.format(riskAmt12.setscale(0).format(), args2)+'</div></td>'; 
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
                        }
                        if(rf1==null){rf1='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf2==null){rf2='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf3==null){rf3='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf4==null){rf4='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf5==null){rf5='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf6==null){rf6='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf7==null){rf7='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf8==null){rf8='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf9==null){rf9='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf10==null){rf10='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf11==null){rf11='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  }
                        if(rf12==null){rf12='<td style="text-align: left;background-color:rgb(217,217,217);pointer-events: none;"   >'+0+'%'+'</td>';  } 
                               
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
                               
                        lineRow ='<tr title="'+lineLabelWrap+'" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+lineLabel+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
                        lineActualRow = '<tr ><td style="text-align: right;background-color:rgb(217,217,217);"><b>Actual Amount</b></td>';
                        if(actualAmt1<0){
                          actualAmtNeg1 = actualAmt1*-1;
                        lineActualRow += '<td><div id='+lineObj.Id+'#01#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true"> '+userCurrencySign+'('+ String.format(actualAmtNeg1.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td><div id='+lineObj.Id+'#01#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true"> '+userCurrencySign+ String.format(actualAmt1.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt2<0){
                          actualAmtNeg2 = actualAmt2*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#02#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg2.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td> <div id='+lineObj.Id+'#02#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt2.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt3<0){
                          actualAmtNeg3 = actualAmt3*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#03#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg3.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td> <div id='+lineObj.Id+'#03#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt3.setscale(0).format(), args2)+'</div></td>';   
                        }
                        if(actualAmt4<0){
                          actualAmtNeg4 = actualAmt4*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#04#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg4.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td> <div id='+lineObj.Id+'#04#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt4.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt5<0){
                          actualAmtNeg5 = actualAmt5*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#05#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg5.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td> <div id='+lineObj.Id+'#05#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt5.setscale(0).format(), args2)+'</div></td>';   
                        }       
                        if(actualAmt6<0){
                          actualAmtNeg6 = actualAmt6*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#06#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg6.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td> <div id='+lineObj.Id+'#06#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt6.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt7<0){
                          actualAmtNeg7 = actualAmt7*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#07#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg7.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td> <div id='+lineObj.Id+'#07#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt7.setscale(0).format(), args2)+'</div></td>';   
                        }
                        if(actualAmt8<0){
                          actualAmtNeg8 = actualAmt8*-1;
                        lineActualRow += '<td> <div id='+lineObj.Id+'#08#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg8.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td><div id='+lineObj.Id+'#08#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt8.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt9<0){
                          actualAmtNeg9 = actualAmt9*-1;
                        lineActualRow += '<td><div id='+lineObj.Id+'#09#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg9.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td><div id='+lineObj.Id+'#09#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt9.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt10<0){
                          actualAmtNeg10 = actualAmt10*-1;
                        lineActualRow += '<td><div id='+lineObj.Id+'#10#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg10.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td><div id='+lineObj.Id+'#10#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt10.setscale(0).format(), args2)+'</div></td>';   
                        } 
                        if(actualAmt11<0){
                          actualAmtNeg11 = actualAmt11*-1;
                        lineActualRow += '<td><div id='+lineObj.Id+'#11#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg11.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td><div id='+lineObj.Id+'#11#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt11.setscale(0).format(), args2)+'</div></td>';   
                        }
                        if(actualAmt12<0){
                          actualAmtNeg12 = actualAmt12*-1;
                        lineActualRow += '<td><div id='+lineObj.Id+'#12#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+'('+ String.format(actualAmtNeg12.setscale(0).format(), args2)+')'+'</div></td>';
                        }else{
                        lineActualRow += '<td><div id='+lineObj.Id+'#12#'+i+' style="text-align: left;background-color:white;"  onfocusin="checkEnterClick(this.id),selectText(this.id)"  onfocusout="updateActuals(this.id)" contenteditable="true">'+userCurrencySign+ String.format(actualAmt12.setscale(0).format(), args2)+'</div></td>';   
                        }
                        if(totActualAmt<0){
                          totActualAmtNeg = totActualAmt*-1;
                        lineActualRow += '<td style="background-color:rgb(217,217,217);">'+userCurrencySign+'('+ String.format(totActualAmtNeg.setscale(0).format(), args2)+')'+'</td>';
                        }else{
                        lineActualRow += '<td style="background-color:rgb(217,217,217);">'+userCurrencySign+ String.format(totActualAmt.setscale(0).format(), args2)+'</td>';   
                        } 
                        lineFCastWoutRisk += '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast without Risk</b></td>'; 
                        
                        if(TotLineInFCastAmt < 0){
                            TotLineInFCastAmt = TotLineInFCastAmt*-1;
                        lineFCastWoutRisk += l1+l2+l3+l4+l5+l6+l7+l8+l9+l10+l11+l12+'<td><div style="text-align: left;" >'+userCurrencySign+'('+String.format(TotLineInFCastAmt.setscale(0).format(), args2)+')'+'</div></td></tr>';
                        }else{
                        lineFCastWoutRisk += l1+l2+l3+l4+l5+l6+l7+l8+l9+l10+l11+l12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotLineInFCastAmt.setscale(0).format(), args2)+'</div></td></tr>';
                        } 
                        lineFCastWRisk += '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast with Risk</b></td>'; 
                        if(TotWriskAmt < 0){
                            TotWriskAmt = TotWriskAmt*-1;
                        lineFCastWRisk += wr1+wr2+wr3+wr4+wr5+wr6+wr7+wr8+wr9+wr10+wr11+wr12+'<td><div style="text-align: left;" >'+userCurrencySign+'('+String.format(TotWriskAmt.setscale(0).format(), args2)+')'+'</div></td></tr>'; 
                        }else{
                        lineFCastWRisk += wr1+wr2+wr3+wr4+wr5+wr6+wr7+wr8+wr9+wr10+wr11+wr12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotWriskAmt.setscale(0).format(), args2)+'</div></td></tr>';     
                        }      
                        lineRisk += '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Risk</b></td>';
                        if(TotRiskAmt < 0){
                            
                        lineRisk += r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+'<td><div style="text-align: left;" >'+userCurrencySign+'('+String.format((TotRiskAmt*-1).setscale(0).format(), args2)+')'+'</div></td></tr>'; 
                        }else{
                          lineRisk += r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format((TotRiskAmt).setscale(0).format(), args2)+'</div></td></tr>';   
                        }
                        lineRiskFactor += '<tr><td style="text-align: right;background-color:rgb(217,217,217);pointer-events: none;"><b>Risk Factor</b></td>';
                        lineRiskFactor += rf1+rf2+rf3+rf4+rf5+rf6+rf7+rf8+rf9+rf10+rf11+rf12+'<td style="background-color:rgb(217,217,217);pointer-events: none;"><div style="text-align: left;" > </div></td></tr>';     
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
                      
                      String conWrapLabel='';
                        if(conLabel.length()>25){
                            conWrapLabel = conLabel.substring(0,25)+'...';
                        }else{
                            conWrapLabel=conLabel;
                        }
                      conRow='<tr title="'+conLabel+'" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+conWrapLabel+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
                      conActualRow = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Actual Amount</b></td>';
                      if(conAct1<0){
                          conActNeg1 = conAct1*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg1.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct1.setscale(0).format(), args2)+'</td>';   
                      }  
                      if(conAct2<0){
                          conActNeg2 = conAct2*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg2.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct2.setscale(0).format(), args2)+'</td>';   
                      } 
                      if(conAct3<0){
                          conActNeg3 = conAct3*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg3.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct3.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct4<0){
                          conActNeg4 = conAct4*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg4.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct4.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct5<0){
                          conActNeg5 = conAct5*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg5.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct5.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct6<0){
                          conActNeg6 = conAct6*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg6.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct6.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct7<0){
                          conActNeg7 = conAct7*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg7.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct7.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct8<0){
                          conActNeg8 = conAct8*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg8.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct8.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct9<0){
                          conActNeg9 = conAct9*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg9.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct9.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct10<0){
                          conActNeg10 = conAct10*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg10.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct10.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct11<0){
                          conActNeg11 = conAct11*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg11.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct11.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conAct12<0){
                          conActNeg12 = conAct12*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActNeg12.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conAct12.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conActTot<0){
                          conActTotNeg = conActTot*-1;
                       conActualRow += '<td>'+userCurrencySign+'('+ String.format(conActTotNeg.setscale(0).format(), args2)+')'+'</td></tr>';
                      }else{
                       conActualRow += '<td>'+userCurrencySign+ String.format(conActTot.setscale(0).format(), args2)+'</td></tr>';   
                      }
                      conFCastWoutRisk = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast without Risk</b></td>';
                      if(conWOR1<0){
                          conWORNeg1 = conWOR1*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg1.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR1.setscale(0).format(), args2)+'</td>';   
                      } 
                      if(conWOR2<0){
                          conWORNeg2 = conWOR2*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg2.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR2.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR3<0){
                          conWORNeg3 = conWOR3*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg3.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR3.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR4<0){
                          conWORNeg4 = conWOR4*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg4.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR4.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR5<0){
                         conWORNeg5 = conWOR5*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg5.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR5.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR6<0){
                          conWORNeg6 = conWOR6*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg6.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR6.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR7<0){
                          conWORNeg7 = conWOR7*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg7.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR7.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR8<0){
                          conWORNeg8 = conWOR8*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg8.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR8.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR9<0){
                          conWORNeg9= conWOR9*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg9.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR9.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR10<0){
                          conWORNeg10 = conWOR10*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg10.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR10.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR11<0){
                         conWORNeg11 = conWOR11*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg11.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR11.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWOR12<0){
                          conWORNeg12 = conWOR12*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conWORNeg12.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conWOR12.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conTotWOR<0){
                          conTotWORNeg = conTotWOR*-1;
                       conFCastWoutRisk += '<td>'+userCurrencySign+'('+ String.format(conTotWORNeg.setscale(0).format(), args2)+')'+'</td></tr>';
                      }else{
                       conFCastWoutRisk += '<td>'+userCurrencySign+ String.format(conTotWOR.setscale(0).format(), args2)+'</td></tr>';   
                      }
                            
                      
                      conFCastWRisk = '<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast with Risk</b></td>';
                      if(conWR1<0){
                          conWRNeg1 = conWR1*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg1.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR1.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR2<0){
                          conWRNeg2 = conWR2*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg2.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR2.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR3<0){
                          conWRNeg3 = conWR3*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg3.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR3.setscale(0).format(), args2)+'</td>';   
                      } 
                      if(conWR4<0){
                          conWRNeg4 = conWR4*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg4.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR4.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR5<0){
                          conWRNeg5 = conWR5*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg5.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR5.setscale(0).format(), args2)+'</td>';   
                      } 
                     if(conWR6<0){
                          conWRNeg6 = conWR6*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg6.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR6.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR7<0){
                          conWRNeg7 = conWR7*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg7.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR7.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR8<0){
                          conWRNeg8 = conWR8*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg8.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR8.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR9<0){
                          conWRNeg9 = conWR9*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg9.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR9.setscale(0).format(), args2)+'</td>';   
                      } 
                      if(conWR10<0){
                          conWRNeg10 = conWR10*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg10.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR10.setscale(0).format(), args2)+'</td>';   
                      }
                      if(conWR11<0){
                          conWRNeg11 = conWR11*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg11.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR11.setscale(0).format(), args2)+'</td>';   
                      } 
                      if(conWR12<0){
                          conWRNeg12 = conWR12*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conWRNeg12.setscale(0).format(), args2)+')'+'</td>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conWR12.setscale(0).format(), args2)+'</td>';   
                      } 
                      if(conTotWR<0){
                      conTotWRNeg = conTotWR*-1;
                      conFCastWRisk += '<td>'+userCurrencySign+'('+ String.format(conTotWRNeg.setscale(0).format(), args2)+')'+'</td></tr>';
                      }else{
                      conFCastWRisk += '<td>'+userCurrencySign+ String.format(conTotWR.setscale(0).format(), args2)+'</td></tr>';   
                      } 
                      
                    }
                    String OppWrapLabel='',OppLabel='';
                    OppLabel = oppObj.Fcst_Text_QNum__c+' '+oppObj.name;
                    if(OppLabel.length()>25){
                       OppWrapLabel=OppLabel.substring(0,25)+'...'; 
                    }else{
                        OppWrapLabel=OppLabel;
                    }
                    oppQRow='<tr title="'+OppLabel+'" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+OppWrapLabel+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
                    TotOppRow += oppQRow+oppInFCastString+conRow+conActualRow+conFCastWoutRisk+conFCastWRisk+lineBody;
                }
              
             }
             String strAccountWrap='';
             if(strAccount.length()>25){
                strAccountWrap = strAccount.substring(0,25)+'...'; 
             }else{
                 strAccountWrap = strAccount;
             }
             String accountRow='<tr title="'+strAccount+'" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+strAccountWrap+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
             String actualRow='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Actual Amount</b></td>';
             if(accAct1<0){
                 accActNeg1 = accAct1*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg1.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct1.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct2<0){
                 accActNeg2 = accAct2*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg2.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct2.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct3<0){
                 accActNeg3 = accAct3*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg3.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct3.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct4<0){
                 accActNeg4 = accAct4*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg4.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct4.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct5<0){
                 accActNeg5 = accAct5*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg5.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct5.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct6<0){
                 accActNeg6 = accAct6*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg6.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct6.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct7<0){
                 accActNeg7 = accAct7*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg7.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct7.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct8<0){
                 accActNeg8 = accAct8*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg8.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct8.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct9<0){
                 accActNeg9 = accAct9*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg9.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct9.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct10<0){
                 accActNeg10 = accAct10*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg10.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct10.setscale(0).format(), args2)+'</td>';   
             }  
             if(accAct11<0){
                 accActNeg11 = accAct11*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg11.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct11.setscale(0).format(), args2)+'</td>';   
             }  
              if(accAct12<0){
                 accActNeg12 = accAct12*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActNeg12.setscale(0).format(), args2)+')'+'</td>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accAct12.setscale(0).format(), args2)+'</td>';   
             } 
              if(accActTot<0){
                 accActTotNeg = accActTot*-1;
             actualRow += '<td>'+userCurrencySign+'('+ String.format(accActTotNeg.setscale(0).format(), args2)+')'+'</td></tr>';
             }else{
             actualRow += '<td>'+userCurrencySign+ String.format(accActTot.setscale(0).format(), args2)+'</td></tr>';   
             } 
             String accountWithoutRRow ='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast without Risk</b></td>';
             if(accWOR1<0){
                 accWORNeg1 = accWOR1*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg1.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR1.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR2<0){
                 accWORNeg2 = accWOR2*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg2.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR2.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR3<0){
                 accWORNeg3 = accWOR3*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg3.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR3.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR4<0){
                 accWORNeg4 = accWOR4*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg4.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR4.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR5<0){
                 accWORNeg5 = accWOR5*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg5.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR5.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR6<0){
                 accWORNeg6 = accWOR6*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg6.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR6.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR7<0){
                 accWORNeg7 = accWOR7*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg7.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR7.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR8<0){
                 accWORNeg8 = accWOR8*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg8.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR8.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR9<0){
                 accWORNeg9 = accWOR9*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg9.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR9.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR10<0){
                 accWORNeg5 = accWOR10*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg10.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR10.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR11<0){
                 accWORNeg11 = accWOR11*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg11.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR11.setscale(0).format(), args2)+'</td>';   
             }
             if(accWOR12<0){
                 accWORNeg12 = accWOR12*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accWORNeg12.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accWOR12.setscale(0).format(), args2)+'</td>';   
             }
             if(accTotWOR<0){
                 accTotWORNeg = accTotWOR*-1;
             accountWithoutRRow += '<td>'+userCurrencySign+'('+ String.format(accTotWORNeg.setscale(0).format(), args2)+')'+'</td></tr>';
             }else{
             accountWithoutRRow += '<td>'+userCurrencySign+ String.format(accTotWOR.setscale(0).format(), args2)+'</td></tr>';   
             }
             
             String accountWithRRow='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Forecast with Risk</b></td>';
             if(accWR1<0){
                 accWRNeg1 = accWR1*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg1.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR1.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR2<0){
                 accWRNeg2 = accWR2*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg2.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR2.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR3<0){
                 accWRNeg3 = accWR3*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg3.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR3.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR4<0){
                 accWRNeg4 = accWR4*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg4.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR4.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR5<0){
                 accWRNeg5 = accWR5*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg5.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR5.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR6<0){
                 accWRNeg6 = accWR6*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg6.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR6.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR7<0){
                 accWRNeg7 = accWR7*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg7.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR7.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR8<0){
                 accWRNeg8 = accWR8*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg8.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR8.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR9<0){
                 accWRNeg9 = accWR9*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg9.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR9.setscale(0).format(), args2)+'</td>';   
             } 
             if(accWR10<0){
                 accWRNeg10 = accWR10*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg10.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR10.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR11<0){
                 accWRNeg11 = accWR11*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg11.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR11.setscale(0).format(), args2)+'</td>';   
             }
             if(accWR12<0){
                 accWRNeg12 = accWR12*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accWRNeg12.setscale(0).format(), args2)+')'+'</td>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accWR12.setscale(0).format(), args2)+'</td>';   
             }
             if(accTotWR<0){
                 accTotWRNeg = accTotWR*-1;
             accountWithRRow += '<td>'+userCurrencySign+'('+ String.format(accTotWRNeg.setscale(0).format(), args2)+')'+'</td></tr>';
             }else{
             accountWithRRow += '<td>'+userCurrencySign+ String.format(accTotWR.setscale(0).format(), args2)+'</td></tr>';   
             }
            
                 
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
               List<FCST_Initial_Forecast__c> planningModelList=[Select Id,Name,Contract_LineItem__c,Risk_Factor__c,Fcst_Amount__c,Planning_Version__c,Planning_Version__r.name from FCST_Initial_Forecast__c where Id=:planningModelId];
               if(planningModelList.Size()>0 ){
                  planningModelList[0].Risk_Factor__c=Math.round(planningModelDecimal);
                  update planningModelList;
               }
            }catch(Exception e){
                   System.debug('Exception error Message>>>>>>> '+e);
                   System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
            }
            return null;
     }
 //****************************************************Update Model End ********************************************************//
 
    public pageReference updateActualModel(){
        try{   
            String lineItemId=Apexpages.currentPage().getParameters().get('lineItemId');
            String PeriodNumber=Apexpages.currentPage().getParameters().get('periodnumber');
            String actualAmount=Apexpages.currentPage().getParameters().get('actualAmount');
            String globalYearStringVal=String.valueOf(globalYear);
            String fiscalPeriod='FY'+globalYearStringVal+'P'+PeriodNumber;
           // System.debug('>>>globalYearStringVal>>>>'+globalYearStringVal);
            List<Actual_Model__c> updateactual = new List<Actual_Model__c>();
            
            List<Contract_LineItem__c> contractLineItemList=[Select Line_Description__c,Fcst_Revenue_Type__c,FCST_Contract__r.Opportunity__c,FCST_Contract__r.Fcst_Geo_Name__c,FCST_Contract__r.Fcst_Geo_Numbers__c,Cost_Center_Description__c,Cost_Center__c,BSLA_Number__c,Id,FCST_Contract__r.Fcst_Account__c,FCST_Contract__c from Contract_LineItem__c where Id=:lineItemId LIMIT 1];
            System.debug('>>>contractLineItemList>>>>'+contractLineItemList);
            
            if(contractLineItemList!=null && contractLineItemList.size()>0){
            	List<Actual_Model__c>  actualList = [Select Id from Actual_Model__c where Account__c=:contractLineItemList[0].FCST_Contract__r.Fcst_Account__c and FCST_Planning_Version__r.Name=:Planversion and Fiscal_Period__r.Name=:fiscalPeriod and Revenue_Type__c=:contractLineItemList[0].Fcst_Revenue_Type__c and FCST_Contract__c=:contractLineItemList[0].FCST_Contract__c and Contract_LineItem__c=:contractLineItemList[0].id];
                
                if(actualList!=null && actualList.size()>0 && actualAmount!=null){
                	actualList[0].Actual_Amount__c=decimal.ValueOf(actualAmount);
                	updateactual.add(actualList[0]);
                }
                else{
                	
                	List<Planning_Version__c>  pvList=   [Select Name,Id from Planning_Version__c where Name=:strPlanningVersion LIMIT 1];
                	List<Fiscal_Year_Model__c> fsList =[Select Name,Id,Fiscal_Planning_Year__c from Fiscal_Year_Model__c where Name=:fiscalPeriod];
                	List<Opportunity> oppList =[Select Name,Id from Opportunity where Name=:strOpportunity];
                	
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
                	actObj.Opportunity__c=oppList[0].Id;
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
                if(cp!=null && strPlanYear == null && myear == Integer.valueOf(cp))strPlanYear = cp;
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
           if(strContract!=null)
           conNameList = strContract.split('#');
           
           if(conNameList.size()>0 && conNameList!=null)
           conName = conNameList[0];
           conList = new List<FCST_Contract__c>(); 
           lineList = new List<Contract_LineItem__c>();
           lineSet = new Set<String>();
           String conQuery ='Select id,name,Contract__c,Opportunity__r.name,FCST_Q__c from FCST_Contract__c where FCST_Q__c =:conName';
           conList = Database.query(conQuery);
           if(!conList.isEmpty()){
               strOpportunity=String.valueOf(conList[0].Opportunity__r.name);
           }else{
             strOpportunity ='';  
           }
           lineSet.add('All');
           String lineQuery ='Select id,name,FCST_Q__c from Contract_LineItem__c where FCST_Q__c =:conName order by name';
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