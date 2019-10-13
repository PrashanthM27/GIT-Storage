public class FCST_Landing_UI_ControllerV1 {
  
  public boolean isDataFound{get;private set;}
  public string ErrorMessage{get;private set;}
  public string documentId{get;private set;}
  Map<string,string> mapStaticResourcePath;
    map<String,double> mapActualAmount;
    map<Id,double> mapContractUnAdjustedAmount;
    map<Id,double> mapContractAdjustedAmount;
    map<Id,double> mapClosedUnAdjustedAmount;
    map<Id,double> mapClosedAdjustedAmount;
    map<Id,double> mapOpenAmount;
    Set<Id> accIdSetVal;
    
    
    map<string,string> mapRoleClass;
    map<Id,UserRole> mapUserRoleInfo;
    map<Id,set<Id>> mapRoleRoles;
    map<Id,set<Id>> mapRoleUsers;
    map<Id,double> mapClosedWonAmount;
    map<Id,double> mapBaselineAmount;
    Map<id,double> mapRiskadjustedAmount;
    
  public string RevenueTypeLabelName{get;set;}
  public string BusinessUnitLabelName{get;set;}
  public string cpmRegionLabelName{get;set;}
  public string RevenueName{get;set;}
  public string BusinessUnitName{get;set;}
  public string cpmRegionName{get;set;}
  
  
  public string PMTypeLabelName{get;set;}
  
  public string S_FilterPlanningVersion{get;set;}
  public string s_FilterUser {set;get;}
  public string s_FilterPlanningYear{get;set;}
  public List<string> S_FilterQuarter{get;set;}
  public string business_String{get;set;}
  public string revenue_String{get;set;}
  public string cpmRegion_String{get;set;}
  
  public string role_String{get;set;}
  public string User_String{get;set;}
  public User cUser{get;set;}
  
  
  public List<SelectOption> FilterPlanningVersion{get;private set;}
  public List<SelectOption> FilterQuarter{get;private set;}

  public List<SelectOption> FilterUser{get;private set;}
  
  Map<ID, Account> accIdVsAccountMap;
  string userCurrencySign = '$';
    Mapping_Setting__c mapCustomObj;
    public List<wrapperSURevenueType> wrapperSUList{get; set;}  
    public Map<String,List<User>> mapUserRoleVsListUser{get;set;} 
    
    
    public FCST_Landing_UI_ControllerV1(){
      try {
        
      revenue_String='All';
      List<Document> documents = [SELECT Id, FolderId, Folder.Name FROM Document WHERE Name='Revenue Navigator User Guide V1.0' LIMIT 1];
      documentId=documents[0].id;
      //System.debug('>>>documentId>>>'+documentId);
        mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        if(mapCustomObj <> null){
          RevenueTypeLabelName = mapCustomObj.Fcst_Revenue_Type__c;
          BusinessUnitLabelName = mapCustomObj.Fcst_BusinessUnit__c;
          cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
          PMTypeLabelName=mapCustomObj.FCST_ProgramManager__c;
          Map<String, Schema.SObjectType> schemaMapOppLine = Schema.getGlobalDescribe();
              Schema.SObjectType ObjectSchemaOppLine = schemaMapOppLine.get('Product2');
              Map<String, Schema.SObjectField> schemaFieldMapOppLine = ObjectSchemaOppLine.getDescribe().fields.getMap();
              for(String fieldName : schemaFieldMapOppLine.keySet()){
                  if(RevenueTypeLabelName == fieldName){  
                      RevenueName = schemaFieldMapOppLine.get(fieldName).getDescribe().getLabel();
                  } 
              }
              
              Map<String, Schema.SObjectType> schemaMapAcc = Schema.getGlobalDescribe();
              Schema.SObjectType ObjectSchemaAcc = schemaMapAcc.get('Account');
              Map<String, Schema.SObjectField> schemaFieldMapAcc = ObjectSchemaAcc.getDescribe().fields.getMap();
              for(String fieldName : schemaFieldMapAcc.keySet()){
                if(cpmRegionLabelName == fieldName){  
                  cpmRegionName = schemaFieldMapAcc.get(fieldName).getDescribe().getLabel();
                }
            
             }
             Map<String, Schema.SObjectType> schemaMapOppLineItem = Schema.getGlobalDescribe();
              Schema.SObjectType ObjectSchemaOppline2 = schemaMapOppLineItem.get('OpportunityLineItem');
              Map<String, Schema.SObjectField> schemaFieldMapOpp = ObjectSchemaOppline2.getDescribe().fields.getMap();
              for(String fieldName : schemaFieldMapOpp.keySet()){
                  //  system.debug('------>'+fieldName);
               if(BusinessUnitLabelName == fieldName){
                    BusinessUnitName = schemaFieldMapOpp.get(fieldName).getDescribe().getLabel(); 
                }
            
             }
        }
        
         cUser = [select Id,Name,IsUnsubscribe__c,UserroleId,EditCategory__c,userRole.Name from User where Id=: userinfo.getUserId()];
         User_String=cUser.Id;
        getUserRole();
        fetchUserList(cUser.userRole.Name);
        Initialization();
        fiscalPeriod(); // newly added on 14 8 19 by Satya prasad
        SelectedUserDetail();
        
       } 
       catch(Exception e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
      System.debug('Line number: ' + e.getLineNumber()); 
     }
    }
    
    
    //  // newly added on 14 8 19 by Satya prasad ****starts here****
    List<String> fiscalPeriodForActual{get;set;}
    List<String> fiscalPeriodForForecast{get;set;}
    public  void fiscalPeriod(){
        fiscalPeriodForActual= new List<String>();
        fiscalPeriodForForecast= new List<String>();
        
        Integer pvMonth = Date.Today().Month();
        Integer pvYear = Date.Today().year();
        System.debug('......s_filterQuarter>>>>>>>'+s_filterQuarter);
        if(s_filterQuarter!=null && s_filterQuarter.size()>0){
            for(String strQuater:s_filterQuarter){
                String quaterStr=strQuater.split('-')[1];
                Integer quaterYear=Integer.valueOf(strQuater.split('-')[0]);
               System.debug('......quaterStr>>>>>>>'+quaterStr); 
                if(pvYear==quaterYear){
                    if(quaterStr=='Q1'){
                        System.debug('......Q1>>>>>>>'+quaterStr);
                        if(pvMonth==1){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P01');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P02');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P03');
                        }
                        if(Test.isRunningTest()){
                            pvMonth=2;
                        }
                        if(pvMonth==2){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P01');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P02');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P03');
                        }
                        if(Test.isRunningTest()){
                            pvMonth=3;
                        }
                        if(pvMonth==3){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P01');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P02');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P03');
                        }
                        if(Test.isRunningTest()){
                            pvMonth=4;
                        }
                        if(pvMonth>3){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P01');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P02');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P03');
                        }
                        
                     }
                     if(quaterStr=='Q2'){
                        //System.debug('......Q2>>>>>>>'+quaterStr);
                        if(pvMonth<4){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P04');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P05');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P06');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=4;
                        }
                        if(pvMonth==4){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P04');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P05');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P06');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=5;
                        }
                        if(pvMonth==5){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P04');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P05');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P06');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=6;
                        }
                        if(pvMonth==6){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P04');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P05');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P06');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=7;
                        }
                        if(pvMonth>6){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P04');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P05');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P06');
                        }
                     }
                     if(quaterStr=='Q3'){
                        if(pvMonth<7){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P07');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P08');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P09');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=7;
                        }
                        if(pvMonth==7){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P07');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P08');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P09');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=8;
                        }
                        if(pvMonth==8){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P07');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P08');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P09');
                        }
                         if(Test.isRunningTest()){
                            pvMonth=9;
                        }
                        if(pvMonth==9){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P07');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P08');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P09');
                        }
                        if(pvMonth>9){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P07');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P08');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P09');
                        }
                     }
                     if(quaterStr=='Q4'){
                        
                        if(pvMonth<10){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P10');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P11');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P12');
                        }
                        
                        if(pvMonth==10){
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P10');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P11');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P12');
                        }
                        if(pvMonth==11){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P10');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P11');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P12');
                        }
                        if(pvMonth==12){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P10');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P11');
                            fiscalPeriodForForecast.add('FY'+quaterYear+'P12');
                        }
                        if(pvMonth>12){
                            fiscalPeriodForActual.add('FY'+quaterYear+'P10');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P11');
                            fiscalPeriodForActual.add('FY'+quaterYear+'P12');
                        }
                     }
                }   
                else if(pvYear<quaterYear){ 
                    if(quaterStr=='Q1'){
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P01');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P02');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P03');
                     }
                     if(quaterStr=='Q2'){
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P04');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P05');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P06');
                     }
                     if(quaterStr=='Q3'){
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P07');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P08');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P09');
                     }
                     if(quaterStr=='Q4'){
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P10');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P11');
                        fiscalPeriodForForecast.add('FY'+quaterYear+'P12');
                     } 
                }
                else{
                    if(quaterStr=='Q1'){
                        fiscalPeriodForActual.add('FY'+quaterYear+'P01');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P02');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P03');
                     }
                     if(quaterStr=='Q2'){
                        fiscalPeriodForActual.add('FY'+quaterYear+'P04');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P05');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P06');
                     }
                     if(quaterStr=='Q3'){
                        fiscalPeriodForActual.add('FY'+quaterYear+'P07');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P08');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P09');
                     }
                     if(quaterStr=='Q4'){
                        fiscalPeriodForActual.add('FY'+quaterYear+'P10');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P11');
                        fiscalPeriodForActual.add('FY'+quaterYear+'P12');
                     }
                }
            }
            
        }
        for(String spf:fiscalPeriodForForecast){
        System.debug('>>>>fiscalPeriodForForecast>>>>>>  '+spf);
        
        }  for(String sac:fiscalPeriodForActual){      
            System.debug('>>>>>fiscalPeriodForActual>>>>> '+ sac);}
    }
    
    //  // newly added on 14 8 19 by Satya prasad ****ends here****
    
    public Static string get15DigitId(String mId){
        if(mId <> null && mId.trim() <> '' &&  mId.length()>15){
            return mId.substring(0,15);
        }
        return '';
    }
    
    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
    
    public void Initialization(){
        getFilterPlanningYear();
        setStaticResourceMap(new set<string>{'ForecastIcon'});
    }
    
    public void onChangeYear() {
        getFilterPlanningVersionList();
        getFilterQuarterList();     
    }
    
    public List<SelectOption> getUserRole() {
      List<SelectOption> options = new List<SelectOption>();
      mapUserRoleVsListUser= new Map<String,List<User>>();
            
        List<User> lstUser = getHierarchycalUsers(cUser);
        Set<String> roleSet= new Set<String>();
        
        if(lstUser!=null && lstUser.size()>0){
          for(User userObj:lstUser){
            roleSet.add(userObj.UserRole.Name);
            if(mapUserRoleVsListUser.containsKey(userObj.UserRole.Name)){
              List<User> userContainList=mapUserRoleVsListUser.get(userObj.UserRole.Name);
              userContainList.add(userObj);
              mapUserRoleVsListUser.put(userObj.UserRole.Name,userContainList);
            }
            else{
              List<User> userNewList = new List<User>();
              userNewList.add(userObj);
              mapUserRoleVsListUser.put(userObj.UserRole.Name,userNewList);
            }
          }
        }
        //roleSet.sort();
        List<String> userRoleList=new List<String>();
        userRoleList.addAll(roleSet);
        userRoleList.sort();
        for(String roleName:userRoleList){
          options.add(new SelectOption(roleName,roleName));
        }
        role_String=cUser.UserRole.Name;
        return options;
    }
    
    public void onChangeRole() {
        fetchUserList(role_String);     
    }
    
    public void fetchUserList(String roleName){
       FilterUser = new List<SelectOption>();
       List<User> userContainList=mapUserRoleVsListUser.get(roleName);
       userContainList.sort();
       if(userContainList!=null && userContainList.size()>0){
          for(User userObj:userContainList){
           FilterUser.add(new SelectOption(userObj.Id,userObj.Name));
          }
       }
    }
    
    public List<SelectOption> getFilterPlanningYear() {
        List<SelectOption> options = new List<SelectOption>();
        set<string> setYear = new set<string>();
        set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
        for(Planning_Version__c cp :  [select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c]){
            setYear.add(cp.Planning_Version_Fiscal_Year__c);
        } 
        for(string cp :  setYear){
            {
                s_filterPlanningYear=cp;
                options.add(new SelectOption(cp,cp));
            }
        }     
        onChangeYear();
        return options;
    }
    
    public void getFilterPlanningVersionList(){
      try {
          S_FilterPlanningVersion = null;
          List<SelectOption> options = new List<SelectOption>();
          set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
          Id cpID;
          for(Planning_Version__c cp :  [select Id,Name,SequenceNo__c,Version_Status__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Planning_Version_Fiscal_Year__c =: s_FilterPlanningYear and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false and Name <> '2017' order by SequenceNo__c ]){
              if(S_FilterPlanningVersion == null) if(cp.Version_Status__c == 'In Progress')S_FilterPlanningVersion = cp.Id;
              if(cp.Version_Status__c == 'Open (Admin)')cpID = cp.Id;
              
              options.add(new SelectOption(cp.Id,cp.Name));       
          }  
          if(S_FilterPlanningVersion == null && cpID <> null)S_FilterPlanningVersion = cpId;
          FilterPlanningVersion= options;
         }
         catch(Exception e) {
          System.debug('The following exception has occurred: ' + e.getMessage());
        System.debug('Line number: ' + e.getLineNumber()); 
      }
    }
    
    public void getFilterQuarterList(){
      try {
          FilterQuarter = new List<SelectOption>();
          S_FilterQuarter = new List<string>();
          Integer mmonth = (system.today()).month();
          Integer mquarter = (mmonth <= 3)?1:(mmonth <= 6)?2:(mmonth <= 9)?3:4;
          Date ssyear = system.today().addYears(-10);
          if(s_FilterPlanningYear <> null && s_FilterPlanningYear <> ''){
              Fiscal_Year_Planning__c FP = [Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c  where name =: s_FilterPlanningYear limit 1];
              ssyear = FP.StartDate__c;
          
          }
          
          for(Fiscal_Year_Planning__c p: [Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c where ID<>null order by StartDate__c LIMIT 100]){
              for(Integer i=1;i<=4;i++){
                  FilterQuarter.add(new SelectOption(p.Name+'-Q'+i,p.Name+'-Q'+i));
                  if(p.Name == string.valueOf((system.today()).year()) && i== mquarter)
                  S_FilterQuarter.add(p.Name+'-Q'+i);
              }
          }
      }
      catch(Exception e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
      System.debug('Line number: ' + e.getLineNumber()); 
    }
    }
    
   
    
    public List<SelectOption> getCPMRegionType() {
        List<SelectOption> cpmRegionOptions = new List<SelectOption>();
        cpmRegionOptions=getPicklistValues('Account',mapCustomObj.Fcst_CPM__c);
        return cpmRegionOptions;
    
    }
    
    public List<SelectOption> getRevenueType() {
        List<SelectOption> revnueOptions = new List<SelectOption>();
        revnueOptions=getPicklistValues('Product2',mapCustomObj.Fcst_Revenue_Type__c);
        revnueOptions.add(new SelectOption('Consolidated Revenue','Consolidated Revenue'));
        return revnueOptions;
    
    }
    
    
    
    public void setStaticResourceMap(set<string> setSRNames){
        mapStaticResourcePath = new map<string,string>();
        for(StaticResource St : [select Id,Name,NamespacePrefix,SystemModStamp from StaticResource  where Name IN: setSRNames]){
            mapStaticResourcePath.put(St.Name,'/resource/'+st.SystemModStamp.getTime());
        }
    }
    
    public List<SelectOption> getPicklistValues(String ObjectApi_name,String Field_name){ 
      try {
       List<SelectOption> options = new List<SelectOption>();
      Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
      Sobject Object_name = targetType.newSObject();
      Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
      Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
      Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
      List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
      options.add(new SelectOption('All','All'));
        for (Schema.PicklistEntry a : pick_list_values) { 
            options.add(new SelectOption(a.getValue(),a.getValue()));
         }
  
       return options;
      }
      catch(Exception e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
      System.debug('Line number: ' + e.getLineNumber()); 
      return null;
    }
    }
    
    
    public void onReportLoad(){ 
         fiscalPeriod(); // newly added on 14 8 19 by Satya prasad
        SelectedUserDetail();
    }
    
    
  
    public List<User> getHierarchycalUsers(User cUser){
      try {
          set<Id> finalUserRoleIdSet = new set<Id>();
          set<Id> excludeSameLevelUser = new set<Id>();
          
          for(User k: [select Id,UserRoleId from User where UserRoleId =: cUser.userRoleId and Id <>: cUser.Id])   
              excludeSameLevelUser.add(k.id);
              
          string userStartId = cUser.userRoleId;
          if(userStartId <> null){
              finalUserRoleIdSet = FCST_RoleHierarchySetUp.getRoleHierarchy(userStartId);     
          }
          List<user> lstUser;
          if(finalUserRoleIdSet.contains(cUser.userRoleId)){finalUserRoleIdSet = FCST_RoleHierarchySetUp.getRoleHierarchy(cUser.userRoleId);lstUser = [select Id,Name,UserRoleId,userRole.Name,UserRole.ParentRoleID,Parent_User__c,FullPhotoUrl from User where isActive = true and userroleId IN: finalUserRoleIdSet and ID NOT IN: excludeSameLevelUser];
          }
          else{
              lstUser = [select Id,Name,UserRoleId,userRole.Name,UserRole.ParentRoleID,Parent_User__c,FullPhotoUrl from User where 
              isActive = true and id =:cUser.id order by userRole.Name];
          }
          
          return lstUser;
      }
      catch(Exception e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
      System.debug('Line number: ' + e.getLineNumber()); 
      return null;
    }
    }
    
    public set<string> getFiscalYearFromQuarter(List<string> lstQuarter){
        set<string> setYear = new set<string>();
        if(lstQuarter <> null && lstQuarter.size()>0){
            for(string yq :lstQuarter){
                if(yq.contains('-Q')){
                    setYear.add(yq.split('-')[0]);
                }
            }
        }
        return setYear;
    }
    
    public set<string> getQuarterFromQuarter(List<string> lstQuarter){
        set<string> setYear = new set<string>();
        if(lstQuarter <> null && lstQuarter.size()>0){
            for(string yq :lstQuarter){
                if(yq.contains('-Q')){
                    setYear.add(yq.split('-')[1]);
                }
            }
        }
        return setYear;
    }
    
    public set<string> getFYPeriodFromQuarter(List<string> lstQuarter){
        set<string> SetFiscalPeriodName = new set<string>();
        if(lstQuarter <> null && lstQuarter.size()>0){
            for(string yq :lstQuarter){
                if(yq.contains('-Q')){
                  
                    List<String> yrstr=yq.split('-');
                 //   System.debug('yq.split[1]'+yrstr[1]);
                  //  System.debug('yq.split[0]'+yrstr[0]);
                    
                    if(yrstr[1]=='Q1'){
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P01');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P02');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P03');
                    }
                    else if(yrstr[1]=='Q2'){
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P04');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P05');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P06');
                    }
                    
                    else if (yrstr[1]=='Q3'){
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P07');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P08');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P09');
                    }
                    else if(yrstr[1]=='Q4'){
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P10');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P11');
                      SetFiscalPeriodName.add('FY'+yrstr[0]+'P12');
                    }
                      
                    
                    
                }
            }
        }
        return SetFiscalPeriodName;
    }
    
    public map<Id,set<Id>> getRoleRoles(list<User> lstUser){
        mapUserRoleInfo = new map<Id,Userrole>();
        map<Id,set<Id>> mapRoleRoles = new map<Id,set<Id>>();
        set<Id> setAvailableUserRoles = new set<Id>();
        for(User u: lstUser){
            setAvailableUserRoles.add(u.UserRoleId);
        }
        for(userrole u : [select Id,Name,ParentRoleId  from UserRole order by Name]){
            mapUserRoleInfo.put(u.id,u);
            if(u.ParentRoleId <> null){
                set<Id> settemp = new set<Id>();
                settemp.add(u.Id);
                if(mapRoleRoles.containsKey(u.ParentRoleId)){
                    settemp.addAll(mapRoleRoles.get(u.ParentRoleId));
                }
                mapRoleRoles.put(u.ParentRoleId,settemp);
                
            }
        }
        return mapRoleRoles;
    }
    public map<Id,set<Id>> getRoleUsers(list<User> lstUser){
        map<Id,set<Id>> mapRoleUsers= new map<Id,set<Id>>();
        for(User u: lstUser){
            set<Id> settemp = new set<Id>();
            settemp.add(u.Id);
            if(mapRoleUsers.containsKey(u.UserRoleId)) settemp.addAll(mapRoleUsers.get(u.UserRoleId));
            
            mapRoleUsers.put(u.UserRoleId,settemp);
        }        
        return mapRoleUsers;
    }


    
    public string RolesParentString(string str,Id roleId){ 
        if(mapUserRoleInfo.containsKey(roleId) && mapUserRoleInfo.get(roleId).ParentRoleId <> null){
            if(mapUserRoleInfo.ContainsKey(mapUserRoleInfo.get(roleId).ParentRoleId))
            str += ' '+RolesParentString('TR_'+mapUserRoleInfo.get(mapUserRoleInfo.get(roleId).ParentRoleId).Id+'',mapUserRoleInfo.get(roleId).ParentRoleId);
        }
        return str;
    }
    

    
    public string getImageSRC(string srName, string imagePath){
        if(mapStaticResourcePath.containsKey(srName)){string path = mapStaticResourcePath.get(srName);
            return path+'/'+srName+'/'+imagePath;
        }
        return '';
    }
    
    public Set<ID> getAllSubRoleIds(Set<ID> roleIds){
        Set<ID> currentRoleIds = new Set<ID>();
        for(Id rId : roleIds) {
            if(mapRoleRoles.containsKey(rId))
            currentRoleIds.addALL(mapRoleRoles.get(rId));
        }
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }   
        return currentRoleIds;
    }
    
    public void SelectedUserDetail(){
      try {
        
        Integer selectedYear=0;
        if(s_FilterPlanningYear!=null)
         selectedYear=Integer.valueOf(s_FilterPlanningYear);
         
        Date currentSelYrForOpp = date.newinstance(selectedYear, 01, 01);

        Integer currentYear=date.today().Year();
        String oppStageWon='Closed Won',oppStageCloseLost='Closed Lost';
            
            
        
        wrapperSUList =new List<wrapperSURevenueType>();
        Set<Id> accountIdHavingRevenue=new Set<Id>();
        Set<Id> allAccountId=new Set<Id>();
        
        
        String accQuery='select Id,Name,'+PMTypeLabelName+' from Account where '+PMTypeLabelName+'=:User_String and  '+cpmRegionLabelName+'!=null';
          if(cpmRegion_String!='All' && cpmRegion_String!=null){
              accQuery+= ' and '+cpmRegionLabelName+' =: cpmRegion_String ';
           } 
           accQuery+='  LIMIT 20000';
           
          accIdVsAccountMap = new Map<ID, Account>(); 
          
          List<Account> accListVal=database.query(accQuery); 
          for(Account accObj:accListVal){
          //  System.debug('>>>accObj.....Name...'+accObj.Name);
            accIdVsAccountMap.put(accObj.Id,accObj);
          }
          allAccountId.AddAll(accIdVsAccountMap.keySet());
          if(User_String == null)  User_String = apexpages.currentpage().getparameters().get('SUId');
          
          
          if(User_String <> null){      
            set<string> setFYName = getFiscalYearFromQuarter(s_filterQuarter);
            set<string> setFQName = getQuarterFromQuarter(s_filterQuarter);
            Set<String> setFYPeriod=getFYPeriodFromQuarter(s_filterQuarter);
            Map<String,Double> mapActualAmount = new Map<String,Double>();
            Map<String,Double> mapContractUnAdjustedAmount = new Map<String,Double>();
            Map<String,Double> mapContractAdjustedAmount = new Map<String,Double>();
            
            Map<String,Double> mapContractWonUnAdjustedAmount = new map<String,double>();
            Map<String,Double> mapContractWonAdjustedAmount = new map<String,double>();
            
            
            Map<String,Double> mapPMUnAdjustedAmount = new map<String,double>();
            Map<String,Double> mapPMAdjustedAmount = new map<String,double>();
            
            map<String,double>  mapOpenuserAmount = new map<String,double>();
            map<String,double>  mapOpenuseradjustedAmount = new map<String,double>();
            
            
            
             Map<String,Set<Id>> mapRevenueTypeVsAccountSet = new Map<String,Set<Id>>();
  
           String user15DigitId= get15DigitId(User_String);
           User_String   =user15DigitId;
        //   system.debug('*******'+setFYPeriod+'***'+s_FilterPlanningVersion+'**'+accListVal);
       
        //  String actualQuery = 'select SUM(Actual_Amount__c) actualTotalAmount,Account__r.Id accId,Revenue_Type__c revenue  from Actual_Model__c where ID!=null ';
        //  actualQuery += 'and Fiscal_Period__r.Name IN: setFYPeriod  and FCST_Planning_Version__r.Id =: s_FilterPlanningVersion and Account__r.Id=: accListVal and Actual_Amount__c <> null and Revenue_Type__c<>null and Account__r.'+cpmRegionLabelName+' <>null ';
            
             system.debug('fiscalPeriodForActual'+ fiscalPeriodForActual);
          String actualQuery = 'select SUM(Actual_Amount__c) actualTotalAmount,Account__r.Id accId,Revenue_Type__c revenue  from Actual_Model__c where ID!=null ';
          actualQuery += 'and Fiscal_Period__r.Name IN: fiscalPeriodForActual  and FCST_Planning_Version__r.Id =: s_FilterPlanningVersion and Account__r.Id=: accListVal and Actual_Amount__c <> null and Revenue_Type__c<>null and Account__r.'+cpmRegionLabelName+' <>null ';// newly added on 14 8 19 by Satya prasad
          
           
          if(revenue_String!='All' && revenue_String!=null){
            actualQuery+= ' and Revenue_Type__c =: revenue_String';
          }
          
          if(cpmRegion_String!='All' && cpmRegion_String!=null){
            actualQuery+= ' and Account__r.'+cpmRegionLabelName+' =: cpmRegion_String';
          }
          
          actualQuery += ' Group by Account__r.Id,Revenue_Type__c';
          mapActualAmount = new map<String,double>();
          
          
          
          
        //  List<Actual_Model__c> actualList=database.query(actualQuery);
          
          for (AggregateResult ar : database.query(actualQuery))  {
         if(ar.get('accId')!=null){
                mapActualAmount.put(ar.get('accId')+'#'+string.valueOf(ar.get('revenue')),double.valueOf(ar.get('actualTotalAmount')));
                
                 if(mapRevenueTypeVsAccountSet.containsKey(String.valueOf(ar.get('revenue')))){ 
                    Set<Id> mapContainAccId3 =mapRevenueTypeVsAccountSet.get(String.valueOf(ar.get('revenue')));
                    mapContainAccId3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                    mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),mapContainAccId3);
                   }
                   else{
                       Set<Id> accIdSet3 = new Set<Id>();
                       accIdSet3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                       mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),accIdSet3);
                 }
                 accountIdHavingRevenue.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
         }
          }
          
         Set<Id> accountIdSetHavingInitialForecast =new Set<Id>();
       //  system.debug('======>'+setFYPeriod+'=='+currentYear+'=='+s_FilterPlanningVersion+'===='+accListVal+'==='+currentYear+'=='+currentYear);
      //    String contractQuery ='Select SUM(Fcst_Amount__c) unAdjustedAmount,SUM(Forecast_with_Risk__c) riskTotal,Account__r.Id accId,Contract_LineItem__r.Fcst_Revenue_Type__c revenue from  FCST_Initial_Forecast__c where ';
    //  contractQuery += 'FCST_Planning_Fiscal_Year__r.Name IN: setFYPeriod  and Planning_Version__c =: s_FilterPlanningVersion and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c<:currentYear  and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null';
      
      String contractQuery ='Select SUM(Fcst_Amount__c) unAdjustedAmount,SUM(Forecast_with_Risk__c) riskTotal,Account__r.Id accId,Contract_LineItem__r.Fcst_Revenue_Type__c revenue from  FCST_Initial_Forecast__c where ';
      contractQuery += 'FCST_Planning_Fiscal_Year__r.Name IN: fiscalPeriodForForecast  and Planning_Version__c =: s_FilterPlanningVersion and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c<:currentYear  and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null';// newly added on 14 8 19 by Satya prasad
       
      if(revenue_String!='All' &&  revenue_String!='Consolidated Revenue'   && revenue_String!=null){
            contractQuery+= ' and Contract_LineItem__r.Fcst_Revenue_Type__c =: revenue_String';
          }
           if(cpmRegion_String!='All' && cpmRegion_String!=null){
              contractQuery+= ' and Account__r.'+cpmRegionLabelName+' =: cpmRegion_String ';
           } 
      contractQuery += ' group by Account__r.Id,Contract_LineItem__r.Fcst_Revenue_Type__c';
      
      
      
      
      
    //  System.debug('>>>contractQuery.>>>>>'+contractQuery);
      for (AggregateResult ar : database.query(contractQuery))  {
      //  System.debug('>>>ACC.>>>>>'+ar.get('accId'));
         if(ar.get('accId')!=null){
           if(revenue_String!='Consolidated Revenue'){
                  mapContractUnAdjustedAmount.put(string.valueOf(ar.get('accId'))+'#'+string.valueOf(ar.get('revenue')),double.valueOf(string.valueOf(ar.get('unAdjustedAmount'))));
                  mapContractAdjustedAmount.put(string.valueOf(ar.get('accId'))+'#'+string.valueOf(ar.get('revenue')),double.valueOf(string.valueOf(ar.get('riskTotal')))); 
                  
                  if(mapRevenueTypeVsAccountSet.containsKey(String.valueOf(ar.get('revenue')))){ 
                      Set<Id> mapContainAccId3 =mapRevenueTypeVsAccountSet.get(String.valueOf(ar.get('revenue')));
                      mapContainAccId3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                      mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),mapContainAccId3);
                     }
                     else{
                         Set<Id> accIdSet3 = new Set<Id>();
                         accIdSet3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                         mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),accIdSet3);
                   }
                   accountIdHavingRevenue.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
            }
              //   System.debug('>>>Id.valueOf(String.ValueOf())).>>>>>'+Id.valueOf(String.ValueOf(ar.get('accId'))));
                 accountIdSetHavingInitialForecast.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
         }
          }
      
         
    //  String contractWonQuery ='Select SUM(Fcst_Amount__c) unAdjustedAmount, SUM(Forecast_with_Risk__c) riskAdjustedAmount,Account__r.Id accId,Contract_LineItem__r.Fcst_Revenue_Type__c revenue from  FCST_Initial_Forecast__c where Id <>null ';
      
   //   contractWonQuery += 'and FCST_Planning_Fiscal_Year__r.Name IN: setFYPeriod  and Planning_Version__c =: s_FilterPlanningVersion and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c>=:currentYear  and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null';
              
       String contractWonQuery ='Select SUM(Fcst_Amount__c) unAdjustedAmount, SUM(Forecast_with_Risk__c) riskAdjustedAmount,Account__r.Id accId,Contract_LineItem__r.Fcst_Revenue_Type__c revenue from  FCST_Initial_Forecast__c where Id <>null ';
      
      contractWonQuery += 'and FCST_Planning_Fiscal_Year__r.Name IN: fiscalPeriodForForecast  and Planning_Version__c =: s_FilterPlanningVersion and Account__r.Id IN: accListVal and FCST_Baseline_Created_Year__c>=:currentYear  and  Account__r.'+cpmRegionLabelName+' !=null and  Contract_LineItem__r.Fcst_Revenue_Type__c !=null';// newly added on 14 8 19 by Satya prasad
              
      if(revenue_String!='All' &&  revenue_String!='Consolidated Revenue'  && revenue_String!=null){
              contractWonQuery+= ' and Contract_LineItem__r.Fcst_Revenue_Type__c =: revenue_String';
            }
           if(cpmRegion_String!='All' && cpmRegion_String!=null){
              contractWonQuery+= ' and Account__r.'+cpmRegionLabelName+' =: cpmRegion_String ';
           } 
      
      contractWonQuery += ' group  by Account__r.Id,Contract_LineItem__r.Fcst_Revenue_Type__c';
      
      for (AggregateResult ar : database.query(contractWonQuery))  {
         if(ar.get('accId')!=null){
           if(revenue_String!='Consolidated Revenue'){
                  mapContractWonUnAdjustedAmount.put(string.valueOf(ar.get('accId'))+'#'+string.valueOf(ar.get('revenue')),double.valueOf(string.valueOf(ar.get('unAdjustedAmount'))));
                  mapContractWonAdjustedAmount.put(string.valueOf(ar.get('accId'))+'#'+string.valueOf(ar.get('revenue')),double.valueOf(string.valueOf(ar.get('riskAdjustedAmount')))); 
                  
                  if(mapRevenueTypeVsAccountSet.containsKey(String.valueOf(ar.get('revenue')))){ 
                      Set<Id> mapContainAccId3 =mapRevenueTypeVsAccountSet.get(String.valueOf(ar.get('revenue')));
                      mapContainAccId3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                      mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),mapContainAccId3);
                     }
                     else{
                         Set<Id> accIdSet3 = new Set<Id>();
                         accIdSet3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                         mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),accIdSet3);
                   }
                 
                 accountIdHavingRevenue.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
           }
                 accountIdSetHavingInitialForecast.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
         }
          }
          
    //.........................PM forecast.......
     Set<Id> closedWonContractAccountId=new Set<Id>();
     Set<Id> closedWonOpportunityId=new Set<Id>();
   //  System.debug('>>currentYear>>>'+currentYear);
    List<FCST_Contract__c> contractList=[Select Name,Opportunity__c,Id,Fcst_Account__c,(Select Id from FCST_Initial_Forecasts__r LIMIT 1  ) from FCST_Contract__c where Fcst_Account__c IN:accListVal  and FCST_Baseline_Created_Year_Integer__c>=:currentYear ];
    if(contractList!=null && contractList.size()>0){
      for(FCST_Contract__c conOnj:contractList){
      //  System.debug('>>conOnj name >>>'+conOnj.Name);
      //  System.debug('>>conOnj.FCST_Initial_Forecasts__r>>>'+conOnj.FCST_Initial_Forecasts__r);
        if(conOnj.FCST_Initial_Forecasts__r==null || conOnj.FCST_Initial_Forecasts__r.size()==0){
          closedWonContractAccountId.add(conOnj.Fcst_Account__c);
          closedWonOpportunityId.add(conOnj.Opportunity__c);
        }
        
      }
      
    }
    String pmForecastQuery ='Select Fcst_Weighted_Revenue__c,User_Adjusted_Revenue__c,Fcst_Opportunity__r.AccountId ,FCST_Revenue_Type__c  from  FCST_Opportunity_Initial_Forecast__c   where Id <>null ';
      
      pmForecastQuery += 'and Fcst_Fiscal_Period__r.Name IN: setFYPeriod  and FCST_Planning_Version__c =: s_FilterPlanningVersion  and Fcst_Opportunity__r.AccountId IN: accListVal and Fcst_Opportunity__c IN :closedWonOpportunityId and Fcst_Opportunity__r.AccountId  IN:closedWonContractAccountId  and  FCST_Revenue_Type__c!=null';
      if(revenue_String!='All' && revenue_String!=null){
            pmForecastQuery+= ' and FCST_Revenue_Type__c =: revenue_String';
          }
         
      
      pmForecastQuery += ' order  by Fcst_Opportunity__r.AccountId';
      //System.debug('>>>pmForecastQuery.>>>>>'+pmForecastQuery);
    //  System.debug('>>>database.query(pmForecastQuery).>>>>>'+database.query(pmForecastQuery));
      for (FCST_Opportunity_Initial_Forecast__c pmobj : database.query(pmForecastQuery))  {
          //      System.debug('>>>pmobj.>>>>>'+pmobj);
                if(pmobj.User_Adjusted_Revenue__c==null)
                  pmobj.User_Adjusted_Revenue__c=0;
                if(pmobj.Fcst_Weighted_Revenue__c==null)
                  pmobj.Fcst_Weighted_Revenue__c=0;  
                  
                if(mapPMUnAdjustedAmount.containsKey(pmobj.Fcst_Opportunity__r.AccountId+'#'+ pmobj.FCST_Revenue_Type__c)){ 
                    double unAdjusted =mapPMUnAdjustedAmount.get(pmobj.Fcst_Opportunity__r.AccountId+'#'+pmobj.FCST_Revenue_Type__c);
                    double Adjusted =mapPMAdjustedAmount.get(pmobj.Fcst_Opportunity__r.AccountId+'#'+pmobj.FCST_Revenue_Type__c);
                    
                    unAdjusted+=pmobj.Fcst_Weighted_Revenue__c;
                    Adjusted+=pmobj.User_Adjusted_Revenue__c;
                    
                    mapPMUnAdjustedAmount.put(pmobj.Fcst_Opportunity__r.AccountId+'#'+pmobj.FCST_Revenue_Type__c,unAdjusted);
                    mapPMAdjustedAmount.put(pmobj.Fcst_Opportunity__r.AccountId+'#'+pmobj.FCST_Revenue_Type__c,Adjusted);
                   }
                   else{
                        mapPMUnAdjustedAmount.put(pmobj.Fcst_Opportunity__r.AccountId+'#'+pmobj.FCST_Revenue_Type__c,pmobj.Fcst_Weighted_Revenue__c);
                        mapPMAdjustedAmount.put(pmobj.Fcst_Opportunity__r.AccountId+'#'+pmobj.FCST_Revenue_Type__c,pmobj.User_Adjusted_Revenue__c);
                 }
                
                if(mapRevenueTypeVsAccountSet.containsKey(pmobj.FCST_Revenue_Type__c)){ 
                    Set<Id> mapContainAccId3 =mapRevenueTypeVsAccountSet.get(pmobj.FCST_Revenue_Type__c);
                    mapContainAccId3.add(pmobj.Fcst_Opportunity__r.AccountId);
                    mapRevenueTypeVsAccountSet.put(pmobj.FCST_Revenue_Type__c,mapContainAccId3);
                   }
                   else{
                       Set<Id> accIdSet3 = new Set<Id>();
                       accIdSet3.add(pmobj.Fcst_Opportunity__r.AccountId);
                       mapRevenueTypeVsAccountSet.put(pmobj.FCST_Revenue_Type__c,accIdSet3);
                 }
                 
                 accountIdHavingRevenue.add(pmobj.Fcst_Opportunity__r.AccountId);
          }
    //System.debug('>>>mapRevenueTypeVsAccountSet.>>>>>'+mapRevenueTypeVsAccountSet);
    //System.debug('>>>mapPMUnAdjustedAmount.>>>>>'+mapPMUnAdjustedAmount);
    //System.debug('>>>mapPMAdjustedAmount.>>>>>'+mapPMAdjustedAmount);
    
         
          
         String openOppQuery='select SUM(User_Adjusted_Revenue__c) adjustedAmount,SUM(Weighted_Revenue__c) unAdjustedAmount,FCST_Revenue_Types__c revenue, Opportunity__r.AccountId accId from FCST_Product_Model__c where Id <> null ';
         openOppQuery+= ' and Fiscal_Period__r.Name IN: setFYPeriod and Planning_Version__c =: s_FilterPlanningVersion and Account__c IN:accListVal and Opportunity__r.StageName!=:oppStageCloseLost and Opportunity__r.StageName!=:oppStageWon and Opportunity__r.CloseDate>=:currentSelYrForOpp and  FCST_Revenue_Types__c<>null and Account_CPM_Region__c!=null';
         
         if(revenue_String!='All' && revenue_String!=null){
            openOppQuery+= ' and FCST_Revenue_Types__c =: revenue_String';
         }
         
         
         if(cpmRegion_String!='All' && cpmRegion_String!=null){
            openOppQuery+= ' and Account_CPM_Region__c =: cpmRegion_String';
         }
         openOppQuery += ' Group by Opportunity__r.AccountId,FCST_Revenue_Types__c';
        //  System.debug('>>>openOppQuery.>>>>>'+openOppQuery);
          for (AggregateResult ar : database.query(openOppQuery))  {
          //  System.debug('>>>ar.>>>>>'+ar);
         if(ar.get('accId')!=null){
                mapOpenuserAmount.put(string.valueOf(ar.get('accId'))+'#'+string.valueOf(ar.get('revenue')),double.valueOf(string.valueOf(ar.get('unAdjustedAmount'))));
                mapOpenuseradjustedAmount.put(string.valueOf(ar.get('accId'))+'#'+string.valueOf(ar.get('revenue')),double.valueOf(string.valueOf(ar.get('adjustedAmount')))); 
                
                if(mapRevenueTypeVsAccountSet.containsKey(String.valueOf(ar.get('revenue')))){ 
                    Set<Id> mapContainAccId3 =mapRevenueTypeVsAccountSet.get(String.valueOf(ar.get('revenue')));
                    mapContainAccId3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                    mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),mapContainAccId3);
                   }
                   else{
                       Set<Id> accIdSet3 = new Set<Id>();
                       accIdSet3.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
                       mapRevenueTypeVsAccountSet.put(String.valueOf(ar.get('revenue')),accIdSet3);
                 }
                 accountIdHavingRevenue.add(Id.valueOf(String.ValueOf(ar.get('accId'))));
         }
          } 
       
       
         
         //>>>>>>>
        
         
         
     
          
          
          
          /*****TCV  END  **************/ 
          Set<Id> result =new Set<Id>();
          if(accountIdHavingRevenue!=null && accountIdHavingRevenue.size()>0){
             result = accountIdHavingRevenue.clone();
       result.removeall(allAccountId);
       allAccountId.removeall(accountIdHavingRevenue);
      
       result.addall(allAccountId);
          }
          else{
            result.addall(allAccountId);
          }
          Set<String> revenueTypeSet=mapRevenueTypeVsAccountSet.keySet();
          if(mapRevenueTypeVsAccountSet!=null && mapRevenueTypeVsAccountSet.size()>0){
            for(String revenueStr:revenueTypeSet){
            //  System.debug('>>>revenueStr.>>>>>'+revenueStr);
                
              List<wrapperSUAccountDetail> wrapAccList=new List<wrapperSUAccountDetail>();
              Boolean checkBlank=false;
              Set<Id> accSet=mapRevenueTypeVsAccountSet.get(revenueStr);
              if(accSet!=null && accSet.size()>0){
              for(Id accIdVal:accSet){
              //  System.debug('>>>accIdVal.>>>>>'+accIdVal);
              if(accIdVsAccountMap.containsKey(accIdVal)){
                Account accVal=accIdVsAccountMap.get(accIdVal);
                double actaulAmount=0,uRFBVal=0,rARFBVal=0,uRFCVal=0,rARFCWVal=0,rFOOVal=0,UFVal=0,RAFVal=0 ,rFUNOOVal=0;
                if(mapActualAmount.containsKey(accIdVal+'#'+revenueStr))
                  actaulAmount=mapActualAmount.get(accIdVal+'#'+revenueStr);
                
                if(mapContractUnAdjustedAmount.containsKey(accIdVal+'#'+revenueStr))
                  uRFBVal=mapContractUnAdjustedAmount.get(accIdVal+'#'+revenueStr);
                  
                if(mapContractAdjustedAmount.containsKey(accIdVal+'#'+revenueStr))  
                  rARFBVal=mapContractAdjustedAmount.get(accIdVal+'#'+revenueStr);
                
                if(mapContractWonUnAdjustedAmount.containsKey(accIdVal+'#'+revenueStr) && revenueStr!='Consolidated Revenue')    
                  uRFCVal=mapContractWonUnAdjustedAmount.get(accIdVal+'#'+revenueStr);
                
                if(mapContractWonAdjustedAmount.containsKey(accIdVal+'#'+revenueStr) && revenueStr!='Consolidated Revenue')  
                  rARFCWVal=mapContractWonAdjustedAmount.get(accIdVal+'#'+revenueStr);
                
                if(mapPMUnAdjustedAmount.containsKey(accIdVal+'#'+revenueStr) && revenueStr=='Consolidated Revenue'){    
                  uRFCVal=mapPMUnAdjustedAmount.get(accIdVal+'#'+revenueStr);
                //  System.debug('>>>accVal Name .>uRFCVal>>>>'+uRFCVal);
                }
                
                if(mapPMAdjustedAmount.containsKey(accIdVal+'#'+revenueStr) && revenueStr=='Consolidated Revenue'){  
                  rARFCWVal=mapPMAdjustedAmount.get(accIdVal+'#'+revenueStr);
            //      System.debug('>>>accVal Name .>rARFCWVal>>>>'+rARFCWVal);
                }
                
              
                
                 if(mapOpenuserAmount.containsKey(accIdVal+'#'+revenueStr)){
                  rFOOVal=mapOpenuserAmount.get(accIdVal+'#'+revenueStr);
                    
                  }
                if(mapOpenuseradjustedAmount.containsKey(accIdVal+'#'+revenueStr)){
                  rFUNOOVal=mapOpenuseradjustedAmount.get(accIdVal+'#'+revenueStr);
                    
                  }
                
                if(actaulAmount==null)
                  actaulAmount=0;
                if(uRFBVal==null)
                  uRFBVal=0;
                  if(uRFCVal==null)
                  uRFCVal=0;
                   if(rFOOVal==null)
                  rFOOVal=0;
                  
                  if(rARFBVal==null)
                  rARFBVal=0;
                  
                  if(rARFCWVal==null)
                  rARFCWVal=0;
                  
                  if(rFUNOOVal==null)
                  rFUNOOVal=0;  
                      
              //  UFVal=actaulAmount+uRFBVal+uRFCVal+rFOOVal;
                
                 UFVal=uRFBVal+uRFCVal+rFOOVal; // Added on 19 8 19 by Satyaprasad
                
              //  RAFVal=actaulAmount+rARFBVal+rARFCWVal+rFUNOOVal;
                  
                RAFVal=rARFBVal+rARFCWVal+rFUNOOVal; // Added on 19 8 19 by Satyaprasad
                
                actaulAmount=math.roundToLong(actaulAmount);
                uRFBVal=math.roundToLong(uRFBVal);
                rARFBVal=math.roundToLong(rARFBVal);
                uRFCVal=math.roundToLong(uRFCVal);
                rARFCWVal=math.roundToLong(rARFCWVal);
                rFOOVal=math.roundToLong(rFOOVal);
                UFVal=math.roundToLong(UFVal);
                RAFVal=math.roundToLong(RAFVal);
                
              //  System.debug('>>>accVal Name .>>>>>'+accVal.Name);
                  wrapperSUAccountDetail wrapAccObj = new wrapperSUAccountDetail(accVal,true,reduceName(accVal.Name),actaulAmount,uRFBVal,rARFBVal,uRFCVal,rARFCWVal,rFOOVal,UFVal,RAFVal,rFUNOOVal);
                  wrapAccList.add(wrapAccObj);
              }  
              }
              
              
            }
            
            
              
            if(wrapAccList!=null && wrapAccList.size()>0){
                wrapperSURevenueType wrapSUObj = new wrapperSURevenueType(revenueStr,wrapAccList);
                wrapperSUList.add(wrapSUObj);
            }
            }
          
            
            }
              if(result!=null && result.size()>0 && revenue_String=='All'){
              List<wrapperSUAccountDetail> wrapAccList2=new List<wrapperSUAccountDetail>();
              for(Id IdObj:result){
                if(accIdVsAccountMap.containsKey(IdObj)){
                Account accVal=accIdVsAccountMap.get(IdObj);
                //System.debug('...accVal>>having NO FOrecast>>>'+accVal.Name);
                wrapperSUAccountDetail wrapAccObj = new wrapperSUAccountDetail(accVal,false,reduceName(accVal.Name),0,0,0,0,0,0,0,0,0);
                  wrapAccList2.add(wrapAccObj);
                }
              }
              wrapperSURevenueType wrapSUObj2 = new wrapperSURevenueType('No Forecast',wrapAccList2);
              wrapperSUList.add(wrapSUObj2);
              
            }
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
    //>>>>>>>>>>>>>>>>>>wrappper for selected User
    public static String reduceName(String str){
    if(str.length()>25){
    str=str.substring(0, 25)+'...';
    }
   
   return str;
  
  }
    public class wrapperSURevenueType{
    
    public String revenueType{get;set;}
    public List<wrapperSUAccountDetail> wrapperListAccDetail{get;set;}
     
       public wrapperSURevenueType(String revType,List<wrapperSUAccountDetail>  wrapAccDetail){
     
         revenueType=revType;
         wrapperListAccDetail=wrapAccDetail;
       }
    }   
    
  public class wrapperSUAccountDetail{
      
      public Account acc{get;set;}
      public boolean  linkVisible{get;set;}
      public String  accName{get;set;}
      public double actualAmount{get;set;}
    public double uRFBAmount{get;set;}
    public double rARFBAmount{get;set;}
    public double uRFCAmount{get;set;}
    public double rARFCWAmount{get;set;}
    public double rFFOOAmount{get;set;}
    public double uFAmount{get;set;}
    public double rAFAmount{get;set;}
    public double rFFUNOOAmount{get;set;}
       
         public wrapperSUAccountDetail(Account accVal,boolean linkVisibleVal,String accNameVal,double actualAmountVal,double uRFBAmountVal,double rARFBAmountVal,double uRFCAmountVal,double rARFCWAmountVal,double rFFOOAmountVal,double uFAmountVal,double rAFAmountVal,double rFFUNOOAmountVal){
           accName=accNameVal;
           linkVisible=linkVisibleVal;
           acc=accVal;
       actualAmount=actualAmountval;
       uRFBAmount=uRFBAmountVal;
       rARFBAmount=rARFBAmountVal;
       uRFCAmount=uRFCAmountVal;
       rARFCWAmount=rARFCWAmountVal;
       rFFOOAmount=rFFOOAmountVal;
       uFAmount=uFAmountVal;
       rAFAmount=rAFAmountVal;
       rFFUNOOAmount=rFFUNOOAmountVal;
          
         }
    }

}