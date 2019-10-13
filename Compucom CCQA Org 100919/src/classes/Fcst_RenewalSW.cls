public with sharing class Fcst_RenewalSW {
     /*
    Developer Name : Dhara Mahesh
    Modified  Date : 05-09-2019
    WorkItem(JIRA Story) : Story FCST-CC2P-013-Renewal Workbench
    Changes : New component
   */ 
   
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
    Public String pVVersionStringId;
    Public String AccountId;
    Public String UserStringId;
    public String likeStr;
    public String OppType ;
    List<Account> accountList;
    List<Opportunity> oppList;
    public Set<String> StageNameSet;
   @testVisible private Date YearStartDate;
    @testVisible private Date yearCloseDate;
    Integer increaseVal;
    public boolean editableCell;
    public boolean AdjeditableCell;
    public string userCurrencySign = '$';
    //>>>>>>>>>>pagination start>>>>>>>>>>
    public integer counter=0; 
    public integer list_size=1; 
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
   public Fcst_RenewalSW(){ 
       try{ 
           getFromPlanningVersion();
           IsTableDataPresent = true;
           yearList= new List<Integer>();
           accountList = new List<Account>();
           oppList = new List<Opportunity>();
           opportunitySet = new Set<String>();
           StageNameSet = new Set<String>{'Lead (Above the Funnel)','Closed Won','Closed Lost','Closed/No Action'};
           planningPeriod='Planning Period';
           OppType = 'Renewal Annuity';
           editableCell = true;
           AdjeditableCell = false;
           User currentuserobj = new User();
           pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
           AccountId = apexpages.currentpage().getparameters().get('AccId');
           UserStringId = apexpages.currentpage().getparameters().get('su');
           if(strOpportunity==null || strOpportunity=='' || String.isEmpty(strOpportunity) || String.isBlank(strOpportunity)){
               strOpportunity='All'; 
           }
       
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

            String accQuery = 'Select Id,Name from Account where Id =:AccountId and Id IN(Select Account__c from FCST_Product_Model__c where Planning_Version__r.Name=:strPlanningVersion) ORDER BY Name LIMIT 15000';
            accountList= Database.query(accQuery);
            if(accountList!=null && accountList.size()>0){   
               for(Account accObj:accountList){
                  strAccount = accObj.name;
               }
            }
            String oppQuery = 'select Id,Account.Id,Name,Amount,Account.Name,StageName,CloseDate,Type from Opportunity where Account.Name =:strAccount and CloseDate >=: YearStartDate and Id IN(select Opportunity__c from FCST_Product_Model__c where Id<>null and Planning_Version__r.Name=:strPlanningVersion)  and StageName NOT IN:StageNameSet and Type=:OppType LIMIT 1000';
            oppList = Database.query(oppQuery);
            for(Opportunity OppObj1: oppList){
                opportunitySet.add(OppObj1.Name);
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
           globalYear=0;
           StageNameSet = new Set<String>();
           Set<Id> pagSet= new Set<Id>();
           List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
           Map<Id,String> oppHavingAccountIdName = new Map<Id,String>();
           Map<Id,List<Opportunity>> mapAccIdVsOpenOppList = new Map<Id,List<Opportunity>>();
           Map<String,Set<String>> OppIdVsProdCode = new Map<String,Set<String>>();
           Map<String,List<FCST_Product_Model__c>> mapProCodeVsmodList = new Map<String,List<FCST_Product_Model__c>>();
           Map<String,List<OpportunityLineItem>> mapProdCodeVsLineList = new Map<String,List<OpportunityLineItem>>();
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
              if(oppObj.StageName!='Closed Won' && oppObj.StageName!='Closed Lost' && oppObj.StageName!='Lead (Above the Funnel)'){
                 StageNameSet.add(oppObj.StageName);  
              } 
           }
         String productModelFilter='';
         if(strPlanningVersion!=null && strPlanningVersion<>'All'){
            productModelFilter+=' and Planning_Version__r.Name=:strPlanningVersion';
            }
         productModelFilter+=' and Fiscal_Period__r.Name LIKE :likeStr ';
           
         String oppQueryString='Select Account.Owner.Id,Id,Name,Account.Id,Account.Name,Owner.Id,CloseDate,Type from Opportunity where Id<>null  and CloseDate >=: YearStartDate and Id IN(Select Opportunity__c from FCST_Product_Model__c where Id<>null  '+productModelFilter+') and StageName IN :StageNameSet and Type=:OppType ';
         String oppQueryCountString='Select Account.Owner.Id,Id,Name,Account.Id,Account.Name,Owner.Id,CloseDate,Type from Opportunity where Id<>null  and CloseDate >=: YearStartDate and  Id IN(Select Opportunity__c from FCST_Product_Model__c where Id<>null  '+productModelFilter+') and StageName IN :StageNameSet and Type=:OppType ';
         if(strOpportunity!=null && strOpportunity!='All' && strOpportunity!=''){
            oppQueryString+=' and Name =:strOpportunity and Account.Name =:strAccount ';
            oppQueryCountString+=' and Name =:strOpportunity and Account.Name =:strAccount';
         }else{
         oppQueryString+=' and Name IN:opportunitySet and Account.Name =:strAccount';
         oppQueryCountString+=' and Name IN:opportunitySet and Account.Name =:strAccount';
         } 
         oppQueryString+=' order by Account.Name limit :list_size  offset :counter';
         oppQueryCountString+=' order by Account.Name limit 2000';
         List<Opportunity> OpporrtunityList=database.query(oppQueryString);
         List<Opportunity> ActualOppList=database.query(oppQueryCountString);
         total_size=ActualOppList.size();
         if(total_size>2000){
            total_size=2000;
         }
       
          
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
             system.debug('mapAccIdVsOpenOppList>>>>'+mapAccIdVsOpenOppList); 
            }
         }
         String oppLineItemQuery='select Product2.Name,Risk_Factor__c,Product2.family,Opportunity.Accountid,OpportunityId,Product2Id,Name from OpportunityLineItem  where  OpportunityId IN:OpporrtunityList';
         oppLineItemQuery+=' order by OpportunityId '; 
         oppLineItemList=database.query(oppLineItemQuery);
         if(oppLineItemList!=null && oppLineItemList.size()>0){
            for(OpportunityLineItem oppLineObj:oppLineItemList){
                if(mapProdCodeVsLineList.containsKey(oppLineObj.id+'#'+oppLineObj.OpportunityId) ){
                List<OpportunityLineItem> mapContainOppline =mapProdCodeVsLineList.get(oppLineObj.id+'#'+oppLineObj.OpportunityId);
                mapContainOppline.add(oppLineObj);
                mapProdCodeVsLineList.put(oppLineObj.id+'#'+oppLineObj.OpportunityId,mapContainOppline); 
                }else {
                      List<OpportunityLineItem> newOppLineList = new List<OpportunityLineItem>();
                      newOppLineList.add(oppLineObj);
                      mapProdCodeVsLineList.put(oppLineObj.id+'#'+oppLineObj.OpportunityId,newOppLineList);
                }
                if(OppIdVsProdCode.containsKey(oppLineObj.OpportunityId)){
                   Set<String> mapContainLine =OppIdVsProdCode.get(oppLineObj.OpportunityId);
                   mapContainLine.add(oppLineObj.id+'#'+oppLineObj.OpportunityId);
                   OppIdVsProdCode.put(oppLineObj.OpportunityId,mapContainLine); 
                }else{
                     Set<String> newLineList = new Set<String>();
                     newLineList.add(oppLineObj.id+'#'+oppLineObj.OpportunityId);
                     OppIdVsProdCode.put(oppLineObj.OpportunityId,newLineList);
                }
            }
         }
         String modelQuery = 'Select Planning_Version__r.Name,Name,Weighted_Revenue__c,User_Adjusted_Revenue__c,Fiscal_Period__r.Name,Amount__c,Opportunity__c,Planning_Version__c,Product__c,FCST_Product_Line_ID__c from FCST_Product_Model__c where Planning_Version__r.Name=:strPlanningVersion  and Opportunity__c IN:OpporrtunityList and Fiscal_Period__r.Name  LIKE :likeStr order by Opportunity__c LIMIT 20000';
         for(FCST_Product_Model__c productObj: Database.query(modelQuery)){
             if(mapProCodeVsmodList.containsKey(productObj.FCST_Product_Line_ID__c+'+'+productObj.Opportunity__c) ){
                List<FCST_Product_Model__c> mapContainProductModel =mapProCodeVsmodList.get(productObj.FCST_Product_Line_ID__c+'+'+productObj.Opportunity__c);
                mapContainProductModel.add(productObj);
                mapProCodeVsmodList.put(productObj.FCST_Product_Line_ID__c+'+'+productObj.Opportunity__c,mapContainProductModel);
             }else {
                   List<FCST_Product_Model__c> newProductList = new List<FCST_Product_Model__c>();
                   newProductList.add(productObj);
                   mapProCodeVsmodList.put(productObj.FCST_Product_Line_ID__c+'+'+productObj.Opportunity__c,newProductList); 
             }
          }  
           
         String  tableRecord='<table id="table_id"  class="slds-table slds-table--bordered slds-table--cell-buffer"><tr style="pointer-events: none;"><th  style="background-color: #313A8B;width:20%;text-align: center;" rowspan="2"><label  style="color: white;">Account/Opportunity</label></th><th  colspan="13" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" ><b>Planning Year</b><b class="Ram"  style="color: white;"> - '+globalYear+'</b></label></th></tr><tr style="pointer-events: none;"><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Jan</label></th><th   class="w_f"  style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Feb</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Mar</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Apr</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >May</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jun</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jul</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Aug</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Sep</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Oct</label></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Nov</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Dec</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Total</label></th></tr>';        
         String tableBody='';
         List<String> args2 = new String[]{'0','number','###,###,###'};
         String OppBody = ' ';
         for(Id acciD :pagSet){
             Decimal TotalAccAdjFcastAmt=0,AccAdjFcastAmt1=0,AccAdjFcastAmt2=0,AccAdjFcastAmt3=0,AccAdjFcastAmt4=0,AccAdjFcastAmt5=0,AccAdjFcastAmt6=0,AccAdjFcastAmt7=0,AccAdjFcastAmt8=0,AccAdjFcastAmt9=0,AccAdjFcastAmt10=0,AccAdjFcastAmt11=0,AccAdjFcastAmt12=0;
             Decimal TotalAccUnAdjFcastAmt=0,AccUnAdjFcastAmt1=0,AccUnAdjFcastAmt2=0,AccUnAdjFcastAmt3=0,AccUnAdjFcastAmt4=0,AccUnAdjFcastAmt5=0,AccUnAdjFcastAmt6=0,AccUnAdjFcastAmt7=0,AccUnAdjFcastAmt8=0,AccUnAdjFcastAmt9=0,AccUnAdjFcastAmt10=0,AccUnAdjFcastAmt11=0,AccUnAdjFcastAmt12=0;
             String OpenOppRow = ' ';
           if(mapAccIdVsOpenOppList.containsKey(acciD)){
              for(Opportunity oppObj:mapAccIdVsOpenOppList.get(acciD)){
                  String oppAdjString='',oppUnAdjString='';
                  Decimal TotalOppAdjFcastAmt=0,oppAdjFcastAmt1=0,oppAdjFcastAmt2=0,oppAdjFcastAmt3=0,oppAdjFcastAmt4=0,oppAdjFcastAmt5=0,oppAdjFcastAmt6=0,oppAdjFcastAmt7=0,oppAdjFcastAmt8=0,oppAdjFcastAmt9=0,oppAdjFcastAmt10=0,oppAdjFcastAmt11=0,oppAdjFcastAmt12=0;
                  Decimal TotalOppUnAdjFcastAmt=0,oppUnAdjFcastAmt1=0,oppUnAdjFcastAmt2=0,oppUnAdjFcastAmt3=0,oppUnAdjFcastAmt4=0,oppUnAdjFcastAmt5=0,oppUnAdjFcastAmt6=0,oppUnAdjFcastAmt7=0,oppUnAdjFcastAmt8=0,oppUnAdjFcastAmt9=0,oppUnAdjFcastAmt10=0,oppUnAdjFcastAmt11=0,oppUnAdjFcastAmt12=0;
                  if(OppIdVsProdCode.containsKey(oppObj.Id)){
                     totalProductString='';
                     for(String str :OppIdVsProdCode.get(oppObj.Id)){
                         if(mapProdCodeVsLineList.containsKey(str)){
                         List<OpportunityLineItem> OpportunityLineItemList=mapProdCodeVsLineList.get(str);
                         String adjproductString='',unAdjproductString='';
                        
                         for(OpportunityLineItem oppLineItemObj:OpportunityLineItemList){
                             String ap1,ap2,ap3,ap4,ap5,ap6,ap7,ap8,ap9,ap10,ap11,ap12;
                             String up1,up2,up3,up4,up5,up6,up7,up8,up9,up10,up11,up12;
                             String productString='<tr title="Offering Name" class="'+oppObj.Id+'" style="background-color:rgb(217,217,217);"><td style="text-align: center;background-color:rgb(217,217,217);"><b>'+oppLineItemObj.Product2.Name+'</b></td><th style="background-color:rgb(217,217,217);" colspan="13"></th></tr>';
                             if(mapProCodeVsmodList.containsKey(oppLineItemObj.id+'+'+oppLineItemObj.OpportunityId)){
                                Decimal AdjFcastAmt=0,TotalAdjFcastAmt=0,AdjFcastAmt1=0,AdjFcastAmt2=0,AdjFcastAmt3=0,AdjFcastAmt4=0,AdjFcastAmt5=0,AdjFcastAmt6=0,AdjFcastAmt7=0,AdjFcastAmt8=0,AdjFcastAmt9=0,AdjFcastAmt10=0,AdjFcastAmt11=0,AdjFcastAmt12=0;
                                Decimal UnAdjFcastAmt=0,TotalUnAdjFcastAmt=0,UnAdjFcastAmt1=0,UnAdjFcastAmt2=0,UnAdjFcastAmt3=0,UnAdjFcastAmt4=0,UnAdjFcastAmt5=0,UnAdjFcastAmt6=0,UnAdjFcastAmt7=0,UnAdjFcastAmt8=0,UnAdjFcastAmt9=0,UnAdjFcastAmt10=0,UnAdjFcastAmt11=0,UnAdjFcastAmt12=0;
                                List<FCST_Product_Model__c> getproductModelList=mapProCodeVsmodList.get(oppLineItemObj.Id+'+'+oppLineItemObj.OpportunityId);
                                for(FCST_Product_Model__c productModelObj:getproductModelList){
                                    String fiscalPeriod=productModelObj.Fiscal_Period__r.Name; 
                                    String planningP = fiscalPeriod.split('P')[1];
                                    if(productModelObj.Weighted_Revenue__c!=null && productModelObj.User_Adjusted_Revenue__c!=null){
                                       UnAdjFcastAmt=Math.round((productModelObj.User_Adjusted_Revenue__c));
                                       AdjFcastAmt=Math.round((productModelObj.Weighted_Revenue__c));
                                       if(planningP=='01'){
                                          AdjFcastAmt1+=AdjFcastAmt;
                                          UnAdjFcastAmt1+=UnAdjFcastAmt;
                                          oppAdjFcastAmt1+=AdjFcastAmt;
                                          oppUnAdjFcastAmt1+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt1+=AdjFcastAmt;
                                          AccUnAdjFcastAmt1+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap1='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt1.setscale(0).format(), args2)+'</div></td>';
                                          up1='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt1.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='02'){
                                          AdjFcastAmt2+=AdjFcastAmt;
                                          UnAdjFcastAmt2+=UnAdjFcastAmt;
                                          oppAdjFcastAmt2+=AdjFcastAmt;
                                          oppUnAdjFcastAmt2+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt2+=AdjFcastAmt;
                                          AccUnAdjFcastAmt2+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap2='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt2.setscale(0).format(), args2)+'</div></td>';
                                          up2='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt2.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='03'){
                                          AdjFcastAmt3+=AdjFcastAmt;
                                          UnAdjFcastAmt3+=UnAdjFcastAmt;
                                          oppAdjFcastAmt3+=AdjFcastAmt;
                                          oppUnAdjFcastAmt3+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt3+=AdjFcastAmt;
                                          AccUnAdjFcastAmt3+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap3='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt3.setscale(0).format(), args2)+'</div></td>';
                                          up3='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt3.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='04'){
                                          AdjFcastAmt4+=AdjFcastAmt;
                                          UnAdjFcastAmt4+=UnAdjFcastAmt;
                                          oppAdjFcastAmt4+=AdjFcastAmt;
                                          oppUnAdjFcastAmt4+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt4+=AdjFcastAmt;
                                          AccUnAdjFcastAmt4+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap4='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt4.setscale(0).format(), args2)+'</div></td>';
                                          up4='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt4.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='05'){
                                          AdjFcastAmt5+=AdjFcastAmt;
                                          UnAdjFcastAmt5+=UnAdjFcastAmt;
                                          oppAdjFcastAmt5+=AdjFcastAmt;
                                          oppUnAdjFcastAmt5+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt5+=AdjFcastAmt;
                                          AccUnAdjFcastAmt5+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap5='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt5.setscale(0).format(), args2)+'</div></td>';
                                          up5='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt5.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='06'){
                                          AdjFcastAmt6+=AdjFcastAmt;
                                          UnAdjFcastAmt6+=UnAdjFcastAmt;
                                          oppAdjFcastAmt6+=AdjFcastAmt;
                                          oppUnAdjFcastAmt6+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt6+=AdjFcastAmt;
                                          AccUnAdjFcastAmt6+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap6='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt6.setscale(0).format(), args2)+'</div></td>';
                                          up6='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt6.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='07'){
                                          AdjFcastAmt7+=AdjFcastAmt;
                                          UnAdjFcastAmt7+=UnAdjFcastAmt;
                                          oppAdjFcastAmt7+=AdjFcastAmt;
                                          oppUnAdjFcastAmt7+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt7+=AdjFcastAmt;
                                          AccUnAdjFcastAmt7+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap7='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt7.setscale(0).format(), args2)+'</div></td>';
                                          up7='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt7.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='08'){
                                          AdjFcastAmt8+=AdjFcastAmt;
                                          UnAdjFcastAmt8+=UnAdjFcastAmt;
                                          oppAdjFcastAmt8+=AdjFcastAmt;
                                          oppUnAdjFcastAmt8+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt8+=AdjFcastAmt;
                                          AccUnAdjFcastAmt8+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap8='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt8.setscale(0).format(), args2)+'</div></td>';
                                          up8='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt8.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='09'){
                                          AdjFcastAmt9+=AdjFcastAmt;
                                          UnAdjFcastAmt9+=UnAdjFcastAmt;
                                          oppAdjFcastAmt9+=AdjFcastAmt;
                                          oppUnAdjFcastAmt9+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt9+=AdjFcastAmt;
                                          AccUnAdjFcastAmt9+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap9='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt9.setscale(0).format(), args2)+'</div></td>';
                                          up9='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt9.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='10'){
                                          AdjFcastAmt10+=AdjFcastAmt;
                                          UnAdjFcastAmt10+=UnAdjFcastAmt;
                                          oppAdjFcastAmt10+=AdjFcastAmt;
                                          oppUnAdjFcastAmt10+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt10+=AdjFcastAmt;
                                          AccUnAdjFcastAmt10+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap10='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt10.setscale(0).format(), args2)+'</div></td>';
                                          up10='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt10.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='11'){
                                          AdjFcastAmt11+=AdjFcastAmt;
                                          UnAdjFcastAmt11+=UnAdjFcastAmt;
                                          oppAdjFcastAmt11+=AdjFcastAmt;
                                          oppUnAdjFcastAmt11+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt11+=AdjFcastAmt;
                                          AccUnAdjFcastAmt11+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap11='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt11.setscale(0).format(), args2)+'</div></td>';
                                          up11='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt11.setscale(0).format(), args2)+'</div></td>';
                                       }
                                       if(planningP=='12'){
                                          AdjFcastAmt12+=AdjFcastAmt;
                                          UnAdjFcastAmt12+=UnAdjFcastAmt;
                                          oppAdjFcastAmt12+=AdjFcastAmt;
                                          oppUnAdjFcastAmt12+=UnAdjFcastAmt;
                                          TotalOppAdjFcastAmt+=AdjFcastAmt;
                                          TotalOppUnAdjFcastAmt+=UnAdjFcastAmt;
                                          AccAdjFcastAmt12+=AdjFcastAmt;
                                          AccUnAdjFcastAmt12+=UnAdjFcastAmt;
                                          TotalAccAdjFcastAmt+=AdjFcastAmt;
                                          TotalAccUnAdjFcastAmt+=UnAdjFcastAmt;
                                          TotalAdjFcastAmt+=AdjFcastAmt;
                                          TotalUnAdjFcastAmt+=UnAdjFcastAmt;
                                          ap12='<td><div style="text-align: left;" id=ad'+productModelObj.Id+' contenteditable='+AdjeditableCell+' >'+userCurrencySign+String.format(AdjFcastAmt12.setscale(0).format(), args2)+'</div></td>';
                                          up12='<td><div style="text-align: left;" id='+productModelObj.Id+' onfocusin="checkEnterClick(this.id),selectText(this.id)" onfocusout="planningModelChange(this.id)" contenteditable='+editableCell+' >'+userCurrencySign+String.format(UnAdjFcastAmt12.setscale(0).format(), args2)+'</div></td>';
                                       }
                                    }
                                }//prodmodel for close
                                if(ap1==null){ap1='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up1==null){up1='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap2==null){ap2='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up2==null){up2='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap3==null){ap3='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up3==null){up3='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap4==null){ap4='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up4==null){up4='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap5==null){ap5='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up5==null){up5='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap6==null){ap6='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up6==null){up6='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap7==null){ap7='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up7==null){up7='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap8==null){ap8='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up8==null){up8='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap9==null){ap9='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up9==null){up9='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap10==null){ap10='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up10==null){up10='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap11==null){ap11='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up11==null){up11='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                if(ap12==null){ap12='<td style="text-align: left;"   >'+userCurrencySign+0+'</td>';  }
                                if(up12==null){up12='<td style="text-align: left;background-color:rgb(217,217,217);"   >'+userCurrencySign+0+'</td>';  }
                                   adjproductString+='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;">Unadjusted Forecast</td>';
                                   adjproductString+=ap1+ap2+ap3+ap4+ap5+ap6+ap7+ap8+ap9+ap10+ap11+ap12+'<td><div style="text-align: left;" >'+userCurrencySign+String.format(TotalAdjFcastAmt.setscale(0).format(), args2)+'</div></td></tr>';
                                   unAdjproductString+='<tr ><td style="text-align: right;">Adjusted Forecast</td>';
                                   unAdjproductString+=up1+up2+up3+up4+up5+up6+up7+up8+up9+up10+up11+up12+'<td style="text-align: left;background-color:rgb(217,217,217);"><div style="text-align: left;background-color:rgb(217,217,217);" >'+userCurrencySign+String.format(TotalUnAdjFcastAmt.setscale(0).format(), args2)+'</div></td></tr>';
                                   totalProductString+=productString+adjproductString+unAdjproductString;
                             }//prodcodvsmodel if close
                         }//lineitem for close
                         }//prodcode if close
                     }//line for close
                  }//line if close
                  String oppWrapLabel='',oppLabel='';
                  oppLabel = oppObj.Name;
                  if(oppLabel.length()>25){
                     oppWrapLabel = oppLabel.substring(0,25)+'...';
                  }else{
                     oppWrapLabel = oppLabel; 
                  }
                  OpenOppRow ='<tr title="'+oppLabel+'" style="background-color:rgb(217,217,217);"><th style="background-color:rgb(217,217,217);size: 10%;text-align: left;color:black" ><b>'+oppWrapLabel+'</b></th><th style="background-color:rgb(217,217,217);" colspan="13"></th></tr>';
                  oppAdjString ='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Unadjusted Forecast</b></td><td>'+userCurrencySign+String.format(oppAdjFcastAmt1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppAdjFcastAmt12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(TotalOppAdjFcastAmt.setscale(0).format(), args2)+'</td></tr>';
                  oppUnAdjString ='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Adjusted Forecast</b></td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(oppUnAdjFcastAmt12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(TotalOppUnAdjFcastAmt.setscale(0).format(), args2)+'</td></tr>';
                  OppBody+=OpenOppRow+oppAdjString+oppUnAdjString+totalProductString;
              }//open oppy for close
           }//open oppy if close
         Decimal oppCount=0;
         if(mapAccIdVsOpenOppList.containsKey(acciD)){
            oppCount+=mapAccIdVsOpenOppList.get(acciD).size();
         } 
         String accWrapLabel='',accLabel='';
         accLabel = oppHavingAccountIdName.get(acciD);
             if(accLabel.length()>25){
               accWrapLabel = accLabel.substring(0,25)+'...';
             }else{
                accWrapLabel = accLabel; 
             }
             String accountRow='<tr title="'+accLabel+'" style="background-color:rgb(242, 242, 242);"><th style="background-color:rgb(242, 242, 242);size: 10%;"><b>'+accWrapLabel+'</b> </th><th style="background-color:rgb(242, 242, 242);size: 10%;" colspan="13"></th></tr>';
         String accountAdjRow='<tr style="background-color:rgb(217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Unadjusted Forecast</b></td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccAdjFcastAmt12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(TotalAccAdjFcastAmt.setscale(0).format(), args2)+'</td></tr>';
         String accountUnAdjRow='<tr style="background-color:rgb( 217,217,217);pointer-events: none;"><td style="text-align: right;"><b>Adjusted Forecast</b></td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt1.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt2.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt3.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt4.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt5.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt6.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt7.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt8.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt9.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt10.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt11.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+ String.format(AccUnAdjFcastAmt12.setscale(0).format(), args2)+'</td><td>'+userCurrencySign+String.format(TotalAccUnAdjFcastAmt.setscale(0).format(), args2)+'</td></tr>';
         String OpenCatRow='<tr style="background-color:rgb(217,225,242);"><th style="background-color:rgb(217,225,242);size: 10%;text-align: center;color:black" colspan="14"><b>Renewals - OPEN</b></th></tr>';
         tableBody+=accountRow+accountAdjRow+accountUnAdjRow+OpenCatRow+OppBody; 
         }
         tableRecord+=tableBody+'</table>'; 
         if(tableBody!='')
         IsTableDataPresent = true;
         tableBlock=tableRecord;
         }catch(Exception e){
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
        List<FCST_Product_Model__c> planningModelList=[Select Id,Name,Amount__c,User_Adjusted_Revenue__c,Opportunity__c,Product__c,Planning_Version__c,Planning_Version__r.name from FCST_Product_Model__c where Id=:planningModelId];
      
        String planningVertionQuery = 'Select id,Name,Version_Status__c from Planning_Version__c where ';
        Id oppId;
        if(planningModelList!=null && planningModelList.size()>0 && planningModelList[0].Opportunity__c!=null){
             oppId=planningModelList[0].Opportunity__c;
        }
        String existingModelQuery='Select Id,Name,Amount__c,User_Adjusted_Revenue__c,Opportunity__c,Product__c,Planning_Version__c from FCST_Product_Model__c where  Opportunity__c=:oppId';
       
        if(planningModelList!=null && planningModelList.size()>0 && planningModelList[0].Product__c!=null){
            Id productId=planningModelList[0].Product__c;
          existingModelQuery+=' and Product__c=:productId';
        }
      
        if(planningModelList!=null && planningModelList.size()>0 && planningModelList[0].Planning_Version__c!=null){
            string planingVersion=planningModelList[0].Planning_Version__c;
            string planingVersion1=planningModelList[0].Planning_Version__r.Name;
            existingModelQuery+=' and Planning_Version__c=:planingVersion';
            planningVertionQuery+=' Name=:planingVersion1';
        }
       List<FCST_Product_Model__c> existingModelLIst=database.query(existingModelQuery);
        List<Planning_Version__c> planningVertionList = database.query(planningVertionQuery);
        string opplineItemQuery='select Product2.Name,OpportunityId,Product2Id,Name,TotalPrice from OpportunityLineItem where ';
        
        if(planningModelList!=null && planningModelList.size()>0 && planningModelList[0].Product__c!=null){
            Id productId=planningModelList[0].Product__c;
            opplineItemQuery+=' Product2Id=:productId';
        }
        if(planningModelList!=null && planningModelList.size()>0 && planningModelList[0].Opportunity__c!=null){
            Id oppcId=planningModelList[0].Opportunity__c;
            opplineItemQuery+=' and OpportunityId=:oppcId';
        }
        
        List<OpportunityLineItem> oppLineItemList=database.query(opplineItemQuery);
        Decimal totalExistingModelAmount=0;
        
            if(existingModelLIst.size()>0){
                for(FCST_Product_Model__c prodModel : existingModelLIst){
               totalExistingModelAmount+=Math.round(prodModel.User_Adjusted_Revenue__c);
                }
                if(planningModelDecimal!=null){
                totalExistingModelAmount+=Math.round(planningModelDecimal);
                }
            }
        
        if(planningModelList!=null && planningModelList.size()>0 && planningModelList[0].User_Adjusted_Revenue__c!=null)
            totalExistingModelAmount=totalExistingModelAmount-planningModelList[0].User_Adjusted_Revenue__c;
        
        
       if(oppLineItemList!=null && oppLineItemList.size()>0 && planningModelList.Size()>0 && oppLineItemList[0].TotalPrice!=null && totalExistingModelAmount<=oppLineItemList[0].TotalPrice){
           planningModelList[0].User_Adjusted_Revenue__c=Math.round(planningModelDecimal);
            update planningModelList;
           
        }
        else{
             planningModelList[0].User_Adjusted_Revenue__c=Math.round(planningModelDecimal);
            update planningModelList;
        
        }
        }
        catch(Exception e){
            System.debug('Exception error Message>>>>>>> '+e);
            System.debug('Exception error Message>>>>>>> '+e.getLineNumber());
        }
        return null;
     }
 //****************************************************Update Model End ********************************************************//
/*********************************************fetchOppMethod End***************************************************************/   
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
        set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
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
   
}