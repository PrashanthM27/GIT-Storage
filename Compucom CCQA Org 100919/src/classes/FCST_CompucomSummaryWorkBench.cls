public with sharing class FCST_CompucomSummaryWorkBench { 
   
    public string strPlanningVersion{get;set;}
    public string strUserRole{get;set;}
    public string currentUserRoleName;
    public string strUserName{get;set;}
    public string StrCPMRegion{get;set;}
    public string CPMRegionLabelname{get;set;} 
    public string productFamilyStr{get;set;}
    public string strProduct   {get;set;}
    public string strPlanningYear{get;set;}
    public Set<Id> lowerlevelUserIdSet;
    public String planningPeriod{get;set;}
    public Transient string tableBlock{get;set;} 
    public Integer globalYear{get;set;}
    private Id currentUserIdval;
    public boolean checkTotal{get;set;} 
    private string currentUserName;
    private Id currentRoleId;
    private Set<Id> allSetUser;
    public Set<String> userRoleSet{get;set;}
    public Set<String> userNameSet{get;set;}
    public Set<String> accountSet{get;set;}
    public Set<String> CPMAccountSet = new Set<String>();
    public string strAccount{get;set;}
    public string strOpportunity{get;set;}
    public Set<string> opportunitySet{get;set;}
    private Date yearCloseDate;
    private Date YearStartDate;
    Integer increaseVal;
    Set<String> productFamilySet;
    Set<String> productSet;
    public boolean IsTableDataPresent{get;set;}
    public id acciD;
    public String globalMonth{get;set;}
    public string strPlanYear{get;set;}
    public Integer lastYear{get;set;}
    public Integer cYear{get;set;}
    public Integer initialYear{get;set;}
    public String cpID{get;set;}
    public List<Integer> yearList{get;set;}
    
    public Set<String> ConaccountSet{get;set;}
    Public String strContract{get;set;}
    public Set<id> contractidSet{get;set;}
    public Set<id> ClosedWoncontractidSet{get;set;}
    public Set<string> ConopportunitySet{get;set;}
    
    List<FCST_Contract__c> conList;
    List<FCST_Contract__c> ClosedWonconList;
    List<Contract_LineItem__c> lineList;
    public String strLine   {get;set;}
    public Set<String> lineSet {get;set;}
    public  id AccIdd;
    public  id UserI;
    public Set<String> PMSet{get;set;}
    Public String partner ;
  
   
    
       public String pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
       public String AccountN = apexpages.currentpage().getparameters().get('AccId');
       public String UserStringId = apexpages.currentpage().getparameters().get('su');
    
  //  public list<Planning_Version__c> pverlst{get;set;}
      public Integer Year = System.Today().year();
    //  public String currentYear=String.valueOf(Year);
       public String currentYear=String.valueOf(Year);
       public Date currentYearSDate=date.newInstance(Integer.ValueOf(currentYear),01,01);
      
       MappingFieldUtility mfu = new MappingFieldUtility();
   	   
       
    
    public FCST_CompucomSummaryWorkBench(){  
           IsTableDataPresent = true;
           partner ='Partner';
           productSet= new Set<String>();
        	
        /*  pverlst= [select Month_Number__c,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c='Open (Admin)'];
          Year= Integer.valueof(pverlst[0].Planning_Version_Fiscal_Year__c);
          currentYear=String.valueOf(Year);
          currentYearSDate=date.newInstance(Integer.ValueOf(currentYear),01,01);*/
           ClosedWoncontractidSet = new Set<id>();
           
           
       try{ 
                 List<Product2> prdList;
                 prdList = [Select id,name from Product2 where isActive=true];
       
                 for(Product2 p : prdList){
                   productSet.add(p.Name);
                 }
          
         
            increaseVal=0;
            globalYear=0;
            List<Account> NewAccountList = new List<Account>();
            List<Account> ConNewAccountList = new List<Account>();
            List<Account> ConaccountList = new List<Account>();
            List<Account> AccsList = new List<Account>();
            set<id> accid = new set<id>();
            PMSet= new Set<String>();
            
            List<User> userList = new List<User>();
            List<Account> accountList = new List<Account>();
            List<Opportunity> oppList = new List<Opportunity>();
            Set<Id> userRoleIdSet = new Set<Id>();
            userNameSet = new Set<String>();
            opportunitySet = new Set<String>();
            accountSet = new Set<String>();
            CPMAccountSet = new Set<String>();
            userRoleSet = new Set<String>();
            yearList= new List<Integer>(); 
            contractidSet=new Set<id>();
            lineSet=new Set<String>();
            
            planningPeriod='Planning Period';
            
            String strPlanningVersion,strPlanningYear;
            Date yearCloseDate,YearStartDate;
            
            String pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
            String UserStringId = apexpages.currentpage().getparameters().get('su');
            if(pVVersionStringId!=null){
                Planning_Version__c planningVersionobj=[Select Name from Planning_Version__c where Id=:Id.valueOf(pVVersionStringId) LIMIT 1];
                strPlanningVersion=planningVersionobj.Name;
            }
            if(strPlanningVersion!=null)
                strPlanningYear=strPlanningVersion.left(4);
                     if(strPlanningYear.isNumeric())
                         globalYear=Integer.ValueOf(strPlanningYear);
                           if(increaseVal!=null){
                           globalYear=globalYear+increaseVal;
                   }  
                String likeStr='FY'+globalYear+'%';
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
           User currentuserobj = new User();
           
           if(UserStringId!=null){
                currentuserobj=[Select id,Name,UserRoleId,UserRole.Name from User where Id=:Id.valueOf(UserStringId) and UserType!='Partner' and isActive=true ORDER BY Name LIMIT 1];
                currentRoleId=currentuserobj.UserRoleId;
                strUserRole=currentuserobj.UserRole.Name;
                strUserName=currentuserobj.Name;
                 UserI = currentuserobj.id;
                userNameSet.add(strUserName);
                userRoleSet.add(strUserRole); 
           }
           if(currentRoleId!=null){
                userRoleIdSet.addAll(FCST_RoleHierarchySetUp.getAllSubRoleIds(new set<Id>{currentRoleId}));
            }
         
          
            String userQuery = 'Select Id,Name,UserRoleId,UserRole.Name from User where UserRoleId IN:userRoleIdSet and UserType!=:partner and isActive=true ORDER BY Name LIMIT 10000';
            if(YearStartDate!=null && yearCloseDate!=null && strPlanningVersion!=null && userRoleIdSet!=null && userRoleIdSet.size()>0){
                userList = Database.query(userQuery);
                userList.add(currentuserobj);
                if(userList!=null && userList.size()>0){   
                    for(User userObj:userList){
                         userRoleSet.add(userObj.UserRole.Name);
                    }
                } 
            }
            userList.add(currentuserobj);
            userNameSet.add(currentuserobj.Name);
            userRoleSet.add(currentuserobj.UserRole.Name);
            userList.add(currentuserobj);
            
           String accQuery1= 'Select Id,'+mfu.getProgramManager()+',Name from Account where Id =:AccountN and '+mfu.getCPMRegion()+'!=null ORDER BY Name'; 
           NewAccountList= Database.query(accQuery1);
           if(NewAccountList!=null && NewAccountList.size()>0){   
                    for(Account accObj:NewAccountList){
                         accountSet.add(accObj.Name);
                         straccount=accObj.Name;
                         String fieldValue = (String) accObj.get(mfu.getProgramManager());
                         PMSet.add(fieldValue);
                    }
            }
             
          String OppQuery ='select id,Account.Name,StageName, name from opportunity where Account.Name=:straccount and CloseDate >=: currentYearSDate and Id IN(select Opportunity__c from FCST_Product_Model__c where Id<>null and Planning_Version__r.Name=:strPlanningVersion and  Product__r.Name  IN :productSet and Fiscal_Period__r.Name  LIKE :likeStr) ORDER BY Name LIMIT 15000';
             oppList = Database.query(OppQuery);
               if(oppList!=null && oppList.size()>0){   
                 for(opportunity opp: oppList){
                    accountSet.add(opp.Account.Name);
                    
                }
               }             
             
 // Contact Account**********************************************************************************************************************************************************
             String conQuery ='Select id,name,Fcst_Account__c,Contract__c,Contract_Owner__c,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.name=:straccount and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and FCST_Contract_Created_Year__c <: currentYear ORDER BY Name LIMIT 15000';
             conList = Database.query(conQuery);
               if(conList!=null && conList.size()>0){   
                 for(FCST_Contract__c conObj: conList){
                    contractidSet.add(conObj.id);
                    accountSet.add(conObj.Fcst_Account__r.name);
                    
                }
               }
               
           
            String ClosedWonconQuery ='Select id,name,Fcst_Account__c,Contract__c,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.name=:straccount and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr ) and FCST_Contract_Created_Year__c >=: currentYear ORDER BY Name LIMIT 15000';
            ClosedWonconList = Database.query(ClosedWonconQuery);
            if(ClosedWonconList!=null && ClosedWonconList.size()>0){
             for(FCST_Contract__c conObj: ClosedWonconList){
                 ClosedWoncontractidSet.add(conObj.id);
                 accountSet.add(conObj.Fcst_Account__r.name);
            }}
           
 // Account**********************************************************************************************************************************************************
  String AccounttQuery ='select id,name from Account where '+mfu.getProgramManager()+' IN:PMSet and Id IN(select Account__c from FCST_Product_Model__c where Id<>null and Planning_Version__r.Name=:strPlanningVersion and  Product__r.Name  IN :productSet and Fiscal_Period__r.Name  LIKE :likeStr) ORDER BY Name LIMIT 15000';
             AccsList = Database.query(AccounttQuery);
               if(AccsList!=null && AccsList.size()>0){   
                 for(Account opp: AccsList){
                    accountSet.add(opp.Name);
                    
                }
               }         
  String conAccountQuery ='Select id,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.'+mfu.getProgramManager()+' IN:PMSet and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) ORDER BY Name LIMIT 15000';        
     List<FCST_Contract__c> ContactAccsList = Database.query(conAccountQuery);
               if(ContactAccsList!=null && ContactAccsList.size()>0){   
                 for(FCST_Contract__c opp: ContactAccsList){
                    accountSet.add(opp.Fcst_Account__r.name);
                    
                }
               }               
        
            userList.clear();
            accountList.clear();
             
            oppList.clear();
            userRoleIdSet.clear();
            //userRoleSet.clear();
           if(pVVersionStringId!=null){
                getFromPlanningVersion();
                fetchOppRecord();
            }
        
        
            //Production Limits
            System.debug('accountSet>>>>>>>: ' + accountSet.size());
            System.debug('opportunitySet>>>>> ' + opportunitySet.size());
            
            //USAGE
            System.debug('controller 1.getQueries>>>>>>>: ' + Limits.getQueries());
            System.debug('controller 2.getQueryRows>>>>> ' + Limits.getQueryRows());
            System.debug('controller 3.getDmlRows>>>>>>> ' + Limits.getDmlRows());
            System.debug('controller 4.getDmlStatements>>>>> ' + Limits.getDmlStatements());
            System.debug('controller 5.getCpuTime>>>>>>>>>' + Limits.getCpuTime());
            System.debug('controller 6.getHeapSize>>>>>>>>>' + Limits.getHeapSize());
             
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
/***********************************Constructor End***********************************************/
/***********************************Filter List Start ********************************************/ 
    
        public List<SelectOption> getPlanningYearOptionList() {
        List<SelectOption> PlanningYearoptions = new List<SelectOption>();
         Integer myear = (system.today()).year();
        //  Integer myear =Integer.valueof(pverlst[0].Planning_Version_Fiscal_Year__c);
        set<string> setYear = new set<string>();
        set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
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
    
 /***************************************************** Planning Version Start **************************************************************************************/    

    public List<SelectOption> getFromPlanningVersion(){
        List<SelectOption> planningVersionOption = new List<SelectOption>();
        String pVVersionStringId = apexpages.currentpage().getparameters().get('pv');
            
        if(pVVersionStringId!=null){
            Planning_Version__c planningVersionobj=[Select Name from Planning_Version__c where Id=:Id.valueOf(pVVersionStringId) LIMIT 1];
            strPlanningVersion=planningVersionobj.Name;
        }
        if(strPlanningVersion <> null){
            planningVersionOption.add(new SelectOption(strPlanningVersion,strPlanningVersion));
        }
        
        for(Planning_Version__c pvObj:[Select Name,Version_Status__c from Planning_Version__c where (Version_Status__c='Open (Admin)') and Id!=null ]){
                if(strPlanningVersion!=pvObj.Name){
                    planningVersionOption.add(new SelectOption(pvObj.Name,pvObj.Name));
                }
          }
        return planningVersionOption;
     }
    
  
 /***************************************************** Planning Version End **************************************************************************************/    
   
    
 /***************************************************** User role change start **************************************************************************************/    
 
   public void getUsersRoleChange(){
    
       try{ 
            List<User> userList = new List<User>();
            List<Account> accountList = new List<Account>();
            List<Opportunity> oppList = new List<Opportunity>();
            Set<Id> userRoleIdSet = new Set<Id>();
            Set<Id> userRoleIdSetForCheck = new Set<Id>();
            CPMAccountSet = new Set<String>();
            List<Account> AccsList = new List<Account>();
            PMSet= new Set<String>();
            accountSet.clear();
            set<id>accid=new set<id>();
            userNameSet = new Set<String>();
            opportunitySet = new Set<String>();
            accountSet = new Set<String>();
            Id selectedRoleId;
            String likeStr='FY'+globalYear+'%';
            straccount='';
           Id UserSAId;
            
            String strPlanningYear;
            Date yearCloseDate,YearStartDate; 
            String StAccountbase='',StAccountCWon='',StAccountOpen='';
            String UserStringId = apexpages.currentpage().getparameters().get('su');
            system.debug('straccount1>>>>>'+straccount);
     //Restricting above role users  
       if(strUserRole!=null && strUserRole!=''){
            User currentuserobjCheck=[Select Name,UserRoleId,UserRole.Name from User where Id=:Id.valueOf(UserStringId) and UserType!='Partner' and isActive=true ORDER BY Name LIMIT 1];
           Id currentRoleId=currentuserobjCheck.UserRoleId;
            userRoleIdSetForCheck.addAll(FCST_RoleHierarchySetUp.getAllSubRoleIds(new set<Id>{currentRoleId}));
           userRoleIdSetForCheck.add(currentRoleId);
       }
            if(strPlanningVersion!=null) 
                strPlanningYear=strPlanningVersion.left(4);
            
            if(strPlanningYear!=null){  
                List<Fiscal_Year_Planning__c> fiscalYearList=[Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c where Name=:strPlanningYear LIMIT 1];
                if(fiscalYearList!=null && fiscalYearList.size()>0){
                    YearStartDate=fiscalYearList[0].StartDate__c;
                    yearCloseDate=fiscalYearList[0].EndDate__c;
                }
            }
       
            if(strUserRole!=null && strUserRole!=''){
                List<UserRole> selectUserRoleObj=[SELECT id,Name FROM UserRole WHERE Name=:strUserRole and PortalType!='Partner' ORDER BY Name LIMIT 1];
                if(selectUserRoleObj!=null && selectUserRoleObj.size()>0 && userRoleIdSetForCheck.contains(selectUserRoleObj[0].id)){
                selectedRoleId=selectUserRoleObj[0].Id;
                }
            }
         
            if(selectedRoleId!=null && userRoleIdSetForCheck.contains(selectedRoleId)){
                userRoleIdSet.addAll(FCST_RoleHierarchySetUp.getAllSubRoleIds(new set<Id>{selectedRoleId}));
            }
            if(selectedRoleId!=currentRoleId && userRoleIdSetForCheck.contains(selectedRoleId)){
                userRoleIdSet.add(selectedRoleId);
            }
           
            User currentuserobj = new User();
           
           if(UserStringId!=null && selectedRoleId==currentRoleId){
            
                currentuserobj=[Select id,Name,UserRoleId,UserRole.Name from User where Id=:Id.valueOf(UserStringId) and UserType!='Partner' and isActive=true ORDER BY Name LIMIT 1];
                strUserName=currentuserobj.Name;
                userNameSet.add(strUserName);
                userRoleSet.add(strUserRole);
                UserI = currentuserobj.id;
               
           }
          system.debug('jbkbkjbibiu>>>>'+strUserName);
          system.debug('userRoleSetuserRoleSet>>>>'+userRoleSet);
            String userQuery = 'Select Id,Name,UserRoleId,UserRole.Name from User where UserRoleId IN:userRoleIdSet and UserType!=:partner and isActive=true ORDER BY Name LIMIT 10000';
            if(selectedRoleId!=currentRoleId && userRoleIdSet!=null && userRoleIdSet.size()>0){
                userList = Database.query(userQuery);
                if(userList!=null && userList.size()>0){   
                    for(User userObj:userList){
                         strUserName=userObj.Name;
                         userNameSet.add(userObj.Name);
                         UserI = userObj.id;  
                          
                         
                           
                    }
                }
            }
           if(selectedRoleId==currentRoleId && currentuserobj!=null){
               userList.add(currentuserobj);
            }
          system.debug('USERIdddddd>>>>'+UserI);  
         system.debug('straccount2>>>>>'+straccount);      
 String OppQuery ='select id,Account.Name,StageName, name from opportunity where Account.'+mfu.getProgramManager()+'=:UserI and  CloseDate >=: currentYearSDate and Id IN(select Opportunity__c from FCST_Product_Model__c where Id<>null and  Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name  LIKE :likeStr and  Product__r.Name  IN :productSet) ORDER BY Name LIMIT 15000';
             oppList = Database.query(OppQuery);
               if(oppList!=null && oppList.size()>0){   
                 for(opportunity opp: oppList){
                    accountSet.add(opp.Account.Name);
                   StAccountOpen=opp.Account.Name; 
                }
               }            
            system.debug('AaaaCCountSet>>>>>'+accountSet);
            system.debug('straccountQ>>>>>'+StAccountOpen); 
             String conQuery ='Select id,name,Fcst_Account__c,Contract__c,Fcst_Account__r.name from FCST_Contract__c where  Fcst_Account__r.'+mfu.getProgramManager()+' =:UserI and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Id<>null ) and FCST_Contract_Created_Year__c <: currentYear ORDER BY Name LIMIT 15000';
             conList = Database.query(conQuery);
               if(conList!=null && conList.size()>0){   
                 for(FCST_Contract__c conObj: conList){
                    contractidSet.add(conObj.id);
                    accountSet.add(conObj.Fcst_Account__r.name);
                    StAccountbase=conObj.Fcst_Account__r.name;
                }
               }
               system.debug('AaaaCCountSet2>>>>>'+accountSet);
               system.debug('straccountQ2>>>>>'+StAccountbase); 
            String ClosedWonconQuery ='Select id,name,Fcst_Account__c,Contract__c,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.'+mfu.getProgramManager()+'=:UserI and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Id<>null) and FCST_Contract_Created_Year__c >=: currentYear ORDER BY Name  LIMIT 15000';
            ClosedWonconList = Database.query(ClosedWonconQuery);
             for(FCST_Contract__c conObj: ClosedWonconList){
                 ClosedWoncontractidSet.add(conObj.id);
                 accountSet.add(conObj.Fcst_Account__r.name);
                 StAccountCWon=conObj.Fcst_Account__r.name; 
            }
            
            system.debug('AaaaCCountSet2>>>>>'+accountSet);  
         system.debug('straccountQ3>>>>>'+StAccountCWon); 
            
          if(StAccountCWon!=null && StAccountCWon!=''){
          straccount=StAccountCWon;
          }
          else if(StAccountbase!=null && StAccountbase!=''){
          straccount=StAccountbase;
          }
          else if(StAccountOpen!=null && StAccountOpen!=''){
          straccount=StAccountOpen;
          }
          
          
            
            System.debug('getUserRoleChange 1.accountSet>>>>>>>: ' + accountSet.size());
            System.debug('getUserRoleChange 1.opportunitySet>>>>>>>: ' + opportunitySet.size());
            System.debug('getUserRoleChange 1.userNameSet>>>>>>>: ' + userNameSet.size());
            System.debug('getUserRoleChange 1.userRoleSet>>>>>>>: ' + userRoleSet.size());
            
            
           
                  
            userList.clear();
            accountList.clear();
            oppList.clear();
            userRoleIdSet.clear();
            
           
            
            //USAGE
            System.debug('getUserRoleChange 1.getQueries>>>>>>>: ' + Limits.getQueries());
            System.debug('getUserRoleChange 2.getQueryRows>>>>> ' + Limits.getQueryRows());
            System.debug('getUserRoleChange 3.getDmlRows>>>>>>> ' + Limits.getDmlRows());
            System.debug('getUserRoleChange 4.getDmlStatements>>>>> ' + Limits.getDmlStatements());
            System.debug('getUserRoleChange 5.getCpuTime>>>>>>>>>' + Limits.getCpuTime());
            System.debug('getUserRoleChange 6.getHeapSize>>>>>>>>>' + Limits.getHeapSize());
             //LIMITS
             
            System.debug('getUserRoleChange 1. TOtal LIMITs getQueries>>>>>>>: ' + Limits.getLimitQueries());
            System.debug('getUserRoleChange 2.  TOtal LIMITs getQueryRows>>>>> ' + Limits.getLimitQueryRows());
            System.debug('getUserRoleChange 3.  TOtal LIMITs getDmlRows>>>>>>> ' + Limits.getLimitDmlRows());
            System.debug('getUserRoleChange 4.  TOtal LIMITs getDmlStatements>>>>> ' + Limits.getLimitDmlStatements());
            System.debug('getUserRoleChange 5.  TOtal LIMITs getCpuTime>>>>>>>>>' + Limits.getLimitCpuTime());
            System.debug('getUserRoleChange 6.  TOtal LIMITs getHeapSize>>>>>>>>>' + Limits.getLimitHeapSize());
            
        
       }
       catch(Exception e){
           System.debug('getUserRoleChange Exception error Message>>>>>>> '+e.getLineNumber());
           System.debug('getUserRoleChange Exception error Message>>>>>>> '+e);
        }        
   }
   
   
   Public void UserChange(){
    getUserChange();
   }
   //>>>>>>>>>>>>>>>>>>>>>>>User role change End//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    //>>>>>>>>>>>>>>>>>>>>>>>User  change start//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   public void getUserChange(){
       try{ 
        accountSet.clear();
        userNameSet.clear();
        straccount='';
            List<User> userList = new List<User>();
            List<Account> accountList = new List<Account>();
            List<Opportunity> oppList = new List<Opportunity>();
            CPMAccountSet = new Set<String>();
            List<Account> AccsList = new List<Account>();
            Set<Id> userRoleIdSet = new Set<Id>();
            opportunitySet = new Set<String>();
            accountSet = new Set<String>();
            Id selectedRoleId;
            set<id>accid=new set<id>();
             String likeStr='FY'+globalYear+'%';
            
            String strPlanningYear;
            Date yearCloseDate,YearStartDate;
            String StAccountbase='',StAccountCWon='',StAccountOpen='';
            
            
            if(strPlanningVersion!=null)
                strPlanningYear=strPlanningVersion.left(4);
            
            if(strPlanningYear!=null){  
                
                List<Fiscal_Year_Planning__c> fiscalYearList=[Select Name,EndDate__c,StartDate__c from Fiscal_Year_Planning__c where Name=:strPlanningYear LIMIT 1];
                if(fiscalYearList!=null && fiscalYearList.size()>0){
                    YearStartDate=fiscalYearList[0].StartDate__c;
                    yearCloseDate=fiscalYearList[0].EndDate__c;
                }
                
            }
           
         if(String.IsNotBlank(strUserRole)){
                UserRole selectUserRoleObj=[SELECT id,Name FROM UserRole WHERE Name=:strUserRole and PortalType!='Partner' ORDER BY Name LIMIT 1];
                selectedRoleId=selectUserRoleObj.Id;
            }
         
            
            if(selectedRoleId!=null){
                userRoleIdSet.addAll(FCST_RoleHierarchySetUp.getAllSubRoleIds(new set<Id>{selectedRoleId}));
            }
            if(selectedRoleId!=currentRoleId){
                userRoleIdSet.add(selectedRoleId);
            }
       
           
       
            User currentuserobj = new User();
           
           if(UserStringId!=null){
                currentuserobj=[Select Name,UserRoleId,UserRole.Name from User where Id=:Id.valueOf(UserStringId) and UserType!='Partner' and isActive=true ORDER BY Name LIMIT 1]; 
           }
            
            
          String userQuery = 'Select Id,Name,UserRoleId,UserRole.Name from User where Name=:strUserName and UserType!=:partner and isActive=true ORDER BY Name LIMIT 10000'; 
               if(strPlanningVersion!=null && userRoleIdSet!=null && userRoleIdSet.size()>0){
                userList = Database.query(userQuery);
                 
                if(userList!=null && userList.size()>0){   
                    for(User userObj:userList){
                         strUserName=userObj.Name;
                         UserI = userObj.id;
                         
                        
                         
                    }
                }
            }
 String OppQuery ='select id,Account.Name from opportunity where  CloseDate >=: currentYearSDate and Id IN(select Opportunity__c from FCST_Product_Model__c where Id<>null and Account__r.'+mfu.getProgramManager()+' =:UserI and Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name  LIKE :likeStr and  Product__r.Name  IN :productSet) ORDER BY Name LIMIT 15000';
             oppList = Database.query(OppQuery);
               if(oppList!=null && oppList.size()>0){    
                 for(opportunity opp: oppList){
                    accountSet.add(opp.Account.Name); 
                    StAccountOpen=opp.Account.Name;
                }
               }           
 String conQuery ='Select id,name,Fcst_Account__c,Contract__c,Fcst_Account__r.name from FCST_Contract__c where  Fcst_Account__r.'+mfu.getProgramManager()+' =:UserI and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Id<>null) and FCST_Contract_Created_Year__c <: currentYear ORDER BY Name LIMIT 15000';
             conList = Database.query(conQuery);
               if(conList!=null && conList.size()>0){   
                 for(FCST_Contract__c conObj: conList){
                    contractidSet.add(conObj.id);
                    accountSet.add(conObj.Fcst_Account__r.name);
                    StAccountbase=conObj.Fcst_Account__r.name;
                }
               }
            
String ClosedWonconQuery ='Select id,name,Fcst_Account__c,Contract__c,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.'+mfu.getProgramManager()+' =:UserI and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Id<>null) and FCST_Contract_Created_Year__c >=: currentYear ORDER BY Name LIMIT 15000';
            ClosedWonconList = Database.query(ClosedWonconQuery);
             if(ClosedWonconList !=null && ClosedWonconList .size()>0){
            for(FCST_Contract__c conObj: ClosedWonconList){
                  ClosedWoncontractidSet.add(conObj.id);
                  accountSet.add(conObj.Fcst_Account__r.name);
                   StAccountCWon=conObj.Fcst_Account__r.name; 
            }
            }
          if(StAccountCWon!=null && StAccountCWon!=''){
          straccount=StAccountCWon;
          }
          else if(StAccountbase!=null && StAccountbase!=''){
          straccount=StAccountbase;
          }
          else if(StAccountOpen!=null && StAccountOpen!=''){
          straccount=StAccountOpen;
          } 
            userList.clear();
            accountList.clear();
            oppList.clear();
            userRoleIdSet.clear();
            
            //USAGE
            System.debug('getUserChange 1.getQueries>>>>>>>: ' + Limits.getQueries());
            System.debug('getUserChange 2.getQueryRows>>>>> ' + Limits.getQueryRows());
            System.debug('getUserChange 3.getDmlRows>>>>>>> ' + Limits.getDmlRows());
            System.debug('getUserChange 4.getDmlStatements>>>>> ' + Limits.getDmlStatements());
            System.debug('getUserChange 5.getCpuTime>>>>>>>>>' + Limits.getCpuTime());
            System.debug('getUserChange 6.getHeapSize>>>>>>>>>' + Limits.getHeapSize());
             //LIMITS
             
            System.debug('getUserChange 1. TOtal LIMITs getQueries>>>>>>>: ' + Limits.getLimitQueries());
            System.debug('getUserChange 2.  TOtal LIMITs getQueryRows>>>>> ' + Limits.getLimitQueryRows());
            System.debug('getUserChange 3.  TOtal LIMITs getDmlRows>>>>>>> ' + Limits.getLimitDmlRows());
            System.debug('getUserChange 4.  TOtal LIMITs getDmlStatements>>>>> ' + Limits.getLimitDmlStatements());
            System.debug('getUserChange 5.  TOtal LIMITs getCpuTime>>>>>>>>>' + Limits.getLimitCpuTime());
            System.debug('getUserChange 6.  TOtal LIMITs getHeapSize>>>>>>>>>' + Limits.getLimitHeapSize());
            
        
       }
       catch(Exception e){
            System.debug('getUserChange Exception error Message>>>>>>> '+e.getLineNumber());
           System.debug('getUserChange Exception error Message>>>>>>> '+e);
       }  
   }
   //>>>>>>>>>>>>>>>>>>>>>>>User  change End//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
/***********************************CPM Region Start********************************************/    
   
    Public list<SelectOption> getCPMRegionList(){
       List<SelectOption> options = new List<SelectOption>();
       Mapping_Setting__c customRecord = Mapping_Setting__c.getValues('FCST Mapping Data');
        if(customRecord!=null){
        String CPMRegionLabelname=customRecord.Fcst_CPM__c;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get('Account');
        Map<String, Schema.SObjectField> schemaFieldMap = ObjectSchema.getDescribe().fields.getMap();
        if( CPMRegionLabelname <> null && CPMRegionLabelname !='--None--' && CPMRegionLabelname !=''){
          String RegionD='SELECT id,Name,'+CPMRegionLabelname+' from Account where Name=: strAccount';   
          List<Account> AccounList =database.query(RegionD);
             for(Account pk: AccounList){              
                 String CPMRe = (STRING)pk.get(CPMRegionLabelname);
                 if(CPMRe!=null){
                 options.add(new SelectOption(CPMRe,CPMRe));
                 } }  }
        }
        return options;
    }
    
        public void getCPMResionVal(){
         getCPMRegionList();
    }
    
/***********************************CPM Region End********************************************/  
 
  public pagereference mainfetchOppRecord(){
            increaseVal=0;
            String increaseValStr = ApexPages.CurrentPage().getParameters().get('getincreaseValue');
              
            if(increaseValStr!=null)
                increaseVal= Integer.ValueOf(increaseValStr);
            fetchOppRecord();
            return null;
            }
   
   
   
   
    public pagereference  fetchOppRecord(){
       try{
           
      //*****************************************************************************************************************************

        Mapping_Setting__c mtr = Mapping_Setting__c.getValues('FCST Mapping Data');
        if(mtr <> null){
        String CPMRegionLabel = mtr.Fcst_CPM__c;
        Map<String, Schema.SObjectType> schemaMapOppLine = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchemaOppLine = schemaMapOppLine.get('Account');
        Map<String, Schema.SObjectField> schemaFieldMapOppLine = ObjectSchemaOppLine.getDescribe().fields.getMap(); 
            for(String fieldName : schemaFieldMapOppLine.keySet()){
             if(CPMRegionLabel == fieldName){  
                CPMRegionLabelname = schemaFieldMapOppLine.get(fieldName).getDescribe().getLabel();
            } }} 
         
    //*****************************************************************************************************************************
   
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
        String j = 'FY'+globalYear+'%';
        Set<Id> pagSet= new Set<Id>();
        //system.debug('likeStrlikeStrmain>>>'+likeStr);
       
       
       
           //*****************************************************************************************************
       
      List<Opportunity> opportunityList =new  List<Opportunity>();
      List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
      opportunitySet = new Set<String>();
      Map<String,List<Actual_Model__c>> AccIdVsActualList = new Map<String,List<Actual_Model__c>>();
      Map<Id,List<Opportunity>> mapAccIdVsBestOppList = new Map<Id,List<Opportunity>>();
      Map<Id,List<Opportunity>> mapAccIdVsWorstOppList = new Map<Id,List<Opportunity>>();
      Map<Id,List<Opportunity>> mapAccIdVsBestLineOppList = new Map<Id,List<Opportunity>>();
      Map<Id,List<Opportunity>> mapAccIdVsFunelOppList = new Map<Id,List<Opportunity>>();     
      Map<Id,List<Opportunity>> mapAccIdVsMostLikelyOppList = new Map<Id,List<Opportunity>>();
      Map<String,List<OpportunityLineItem>> mapOppIdvsOpplineItemList = new Map<String,List<OpportunityLineItem>>();
      Map<Id,String> oppHavingAccountIdName = new Map<Id,String>();
      Map<String,Set<String>> OppVsProdCode = new Map<String,Set<String>>();
      Map<id,List<FCST_Product_Model__c>> mapProductIdOppIdVsProductList = new Map<id,List<FCST_Product_Model__c>>();
      Map<id,List<FCST_Product_Model__c>> mapProductIdOppIdVsProductListFunnel = new Map<id,List<FCST_Product_Model__c>>();
      Set<Id> oppHavingProductIdSet = new Set<Id>();
       
       
    
    //*******************************************************************Baseline map start******************************************************************************************      
      contractidSet = new Set<id>();
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
      //*******************************************************************Baseline map end******************************************************************************************      
    
    
    
    
    
    //*******************************************************************Closed Won map start******************************************************************************************      
      ClosedWoncontractidSet = new Set<id>();
      Map<String,List<Contract_LineItem__c>> mapClosedWonConIdvsConlineItemList = new Map<String,List<Contract_LineItem__c>>();
      Map<Id,String> ClosedWonConHavingAccountIdName = new Map<Id,String>();
      Map<Id,String> ClosedWonLineHavingLineItemName = new Map<Id,String>();
      Map<String,Set<String>> ClosedWonConVsLineItemName = new Map<String,Set<String>>();
      Map<String,List<FCST_Initial_Forecast__c>> ClosedWonmapLineNameVsContactList = new Map<String,List<FCST_Initial_Forecast__c>>();
      Set<Id> ClosedWonConHavingLineItemIdSet = new Set<Id>();
      List<Contract_LineItem__c> ClosedWonConLineItemList = new List<Contract_LineItem__c>();
      Map<id,Set<String>> ClosedWonConidVsLineItem = new Map<id,Set<String>>();
      Map<Id,List<FCST_Contract__c>> ClosedWonConVsLineItem = new Map<Id,List<FCST_Contract__c>>();
      Map<String,List<Actual_Model__c>> ClosedWonLineItemIdVsActualList = new Map<String,List<Actual_Model__c>>();
      //*******************************************************************Closed Won map end******************************************************************************************      
        
    
    
    
     Map<Id,String> AccountName = new Map<Id,String>();
           String AccountMainQuery ='Select Id,Name from Account where name =:strAccount and '+mfu.getProgramManager()+'=:UserI and '+mfu.getCPMRegion()+'!=null ORDER BY Name';
          if(strUserRole!=null && strUserRole!='' && strUserName!=null && strUserName!=''){
           List<Account> AccountMainList =Database.query(AccountMainQuery);
             for(Account acOBJ:AccountMainList){   
          pagSet.add(acOBJ.Id);
                      if(acOBJ.Id!=null && acOBJ.Name!=null){
            AccountName.put(acOBJ.Id,acOBJ.Name);
            AccIdd=acOBJ.Id;    
            }
          
     } 
}

    


	String  OppType2 = 'Renewal Annuity';
  String modelQuery ='Select Account__c,Fiscal_Period__r.Name,Weighted_Revenue__c,User_Adjusted_Revenue__c,Opportunity_StageName__c,Planning_Version__r.Name, Amount__c from  FCST_Product_Model__c where Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name  LIKE :likeStr and Account__r.name=:strAccount and Opportunity__r.CloseDate >=: currentYearSDate and Opportunity__r.Type!=:OppType2 and Account__r.'+mfu.getCPMRegion()+'!=null ORDER BY Name LIMIT 30000';
       
       
             for(FCST_Product_Model__c productObj: Database.query(modelQuery)){
            if( productObj.Opportunity_StageName__c!='Closed Won' && productObj.Opportunity_StageName__c!='Closed/No Action' && productObj.Opportunity_StageName__c!='Closed Lost' && productObj.Opportunity_StageName__c!='Lead (Above the Funnel)'){
              if(mapProductIdOppIdVsProductList.containsKey(productObj.Account__c) ){
                   List<FCST_Product_Model__c> mapContainProductModel =mapProductIdOppIdVsProductList.get(productObj.Account__c); 
                   mapContainProductModel.add(productObj);
                   mapProductIdOppIdVsProductList.put(productObj.Account__c,mapContainProductModel);
             }
             else {
                   List<FCST_Product_Model__c> newProductList = new List<FCST_Product_Model__c>();
                   newProductList.add(productObj);
                   mapProductIdOppIdVsProductList.put(productObj.Account__c,newProductList); 
            
           }
            }
            if( productObj.Opportunity_StageName__c=='Lead (Above the Funnel)'){
                   if(mapProductIdOppIdVsProductListFunnel.containsKey(productObj.Account__c) ){
                   List<FCST_Product_Model__c> mapContainProductModel =mapProductIdOppIdVsProductListFunnel.get(productObj.Account__c);
                   mapContainProductModel.add(productObj);
                   mapProductIdOppIdVsProductListFunnel.put(productObj.Account__c,mapContainProductModel);
             }
             else {
                   List<FCST_Product_Model__c> newProductList = new List<FCST_Product_Model__c>();
                   newProductList.add(productObj);
                   mapProductIdOppIdVsProductListFunnel.put(productObj.Account__c,newProductList); 
             }
            }
            
          }
        
            
      
        
              
    
/*  ******************************************************************Open / Above the funnel half end ****************************************************************************************** */     
    
     /*  ******************************************************************Renewal Start ****************************************************************************************** */     
		Map<Id,List<FCST_Product_Model__c>> mapProductIdOppIdVsProductListRenewal = new Map<Id,List<FCST_Product_Model__c>>();
           String  OppType = 'Renewal Annuity';
           String RenewalmodelQuery ='Select Account__c,Opportunity__r.Type,Fiscal_Period__r.Name,Weighted_Revenue__c,User_Adjusted_Revenue__c,Opportunity_StageName__c,Planning_Version__r.Name, Amount__c from  FCST_Product_Model__c where Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name  LIKE :likeStr and Account__r.name=:strAccount and Opportunity__r.CloseDate >=: currentYearSDate and Opportunity__r.Type=:OppType and Account__r.'+mfu.getCPMRegion()+'!=null ORDER BY Name LIMIT 30000';    
          List<FCST_Product_Model__c> listprod = Database.query(RenewalmodelQuery);
           System.debug('listprod'+listprod);
           for(FCST_Product_Model__c prodob : Database.query(RenewalmodelQuery)){
               System.debug('prodob'+prodob);
               if(prodob.Opportunity_StageName__c!='Closed Won' && prodob.Opportunity_StageName__c!='Closed/No Action' && prodob.Opportunity_StageName__c!='Closed Lost'){
                   System.debug('Inside Renewal');
                        if(mapProductIdOppIdVsProductListRenewal.containsKey(prodob.Account__c) ){
                   List<FCST_Product_Model__c> mapContainProductModel =mapProductIdOppIdVsProductListRenewal.get(prodob.Account__c);
                   mapContainProductModel.add(prodob);
                   mapProductIdOppIdVsProductListRenewal.put(prodob.Account__c,mapContainProductModel);
             }
             else {
                   List<FCST_Product_Model__c> newProductList = new List<FCST_Product_Model__c>();
                   newProductList.add(prodob);
                   mapProductIdOppIdVsProductListRenewal.put(prodob.Account__c,newProductList); 
             }
               }
           }
           
           
           
          /* for(FCST_Product_Model__c productObj: Database.query(RenewalmodelQuery)){
                 //Renewal Map    
                 if(productObj.Opportunity__r.Type =='Renewal Annuity' && productObj.Opportunity_StageName__c!='Closed Won' && productObj.Opportunity_StageName__c!='Closed/No Action' && productObj.Opportunity_StageName__c!='Closed Lost' && productObj.Opportunity_StageName__c!='Lead (Above the Funnel)'){
                   System.debug('Inside Renewal');
                     if(mapProductIdOppIdVsProductListRenewal.containsKey(productObj.Account__c) ){
                   List<FCST_Product_Model__c> mapContainProductModel =mapProductIdOppIdVsProductListRenewal.get(productObj.Account__c);
                   mapContainProductModel.add(productObj);
                   mapProductIdOppIdVsProductListRenewal.put(productObj.Account__c,mapContainProductModel);
             }
             else {
                   List<FCST_Product_Model__c> newProductList = new List<FCST_Product_Model__c>();
                   newProductList.add(productObj);
                   mapProductIdOppIdVsProductListRenewal.put(productObj.Account__c,newProductList); 
             }
            }
            
           }*/





/*  ******************************************************************Renewal End ****************************************************************************************** */     











 /*  ******************************************************************Closed Won table start****************************************************************************************** */     
// system.debug('strUserName>>>>>'+strUserName);
        String ClosedWoncontQuery ='Select id from FCST_Contract__c where Fcst_Account__r.name =:strAccount and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Id<>null ) and id<>null and FCST_Contract_Created_Year__c >=: currentYear  LIMIT 15000';
        List<FCST_Contract__c> ClosedWonContactList=database.query(ClosedWoncontQuery);
        if(ClosedWonContactList!=null && ClosedWonContactList.size()>0){  
        for(FCST_Contract__c cont:ClosedWonContactList){
        ClosedWoncontractidSet.add(cont.id);
            
        }
        }
//system.debug('ClosedWonContactList>>>>>'+CloseWonAccoutList);
        String ClosedWonlineInnerQuery ='Select id,name,FCST_Contract__c,FCST_Contract__r.name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.id IN:ClosedWoncontractidSet and  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where FCST_Contract__r.id IN:ClosedWoncontractidSet and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr ) ORDER BY Name  LIMIT 15000';

            List<Contract_LineItem__c> ClosedWonlLineItemList=database.query(ClosedWonlineInnerQuery); 
              for(Contract_LineItem__c ConLine:ClosedWonlLineItemList){
            if(ConLine.Id!=null && ConLine.Name!=null){
            ClosedWonLineHavingLineItemName.put(ConLine.Id,ConLine.Name);    
            }
              }
          
          
              
          String ClosedWonContactQuery='Select id,name,Contract_Description__c,Fcst_Account__r.id,Fcst_Account__r.Name,Contract__c,Fcst_Account__c from FCST_Contract__c where Fcst_Account__r.name =:strAccount and id IN:ClosedWoncontractidSet and Id<>null  and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr ) and FCST_Contract_Created_Year__c >=: currentYear ORDER BY Name LIMIT 15000 ';
           
            List<FCST_Contract__c> ClosedWonContactLisst=database.query(ClosedWonContactQuery); 
           for(FCST_Contract__c Con:ClosedWonContactLisst){

             if(Con.Fcst_Account__r.Id!=null && Con.Fcst_Account__r.Name!=null){
                     ClosedWonConHavingAccountIdName.put(Con.Fcst_Account__r.Id,Con.Fcst_Account__r.Name);    
                   }
             if(ClosedWonConVsLineItem.containsKey(Con.Fcst_Account__r.id)){
                   List<FCST_Contract__c> mapContainCon =ClosedWonConVsLineItem.get(Con.Fcst_Account__r.id);
                   mapContainCon.add(Con);
                   ClosedWonConVsLineItem.put(Con.Fcst_Account__r.id,mapContainCon);
             }else {
                   List<FCST_Contract__c> newConList = new List<FCST_Contract__c>();
                   newConList.add(Con);
                   ClosedWonConVsLineItem.put(Con.Fcst_Account__r.id,newConList);
             }
           }
                    
                    
                    
                    
    for(Contract_LineItem__c ConLineObj:[select Id,Name,Line_Description__c,Cost_Center__c,FCST_Contract__c,FCST_Fiscal_Year_List__c,FCST_Contract__r.Contract__c from Contract_LineItem__c  where FCST_Contract__r.id IN:ClosedWoncontractidSet and  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and id<>null and ID IN:ClosedWonLineHavingLineItemName.keySet() order by Name]){   
          ClosedWonConHavingLineItemIdSet.add(ConLineObj.Id);
               
                   
              if(mapClosedWonConIdvsConlineItemList.containsKey(ConLineObj.FCST_Contract__r.id+ConLineObj.name) ){
                     List<Contract_LineItem__c> mapContainConline =mapClosedWonConIdvsConlineItemList.get(ConLineObj.FCST_Contract__r.id+ConLineObj.name);
                    mapContainConline.add(ConLineObj);
                    mapClosedWonConIdvsConlineItemList.put(ConLineObj.FCST_Contract__r.id+ConLineObj.name,mapContainConline); 
             }
             else {
                   List<Contract_LineItem__c> newConLineList = new List<Contract_LineItem__c>();
                   newConLineList.add(ConLineObj);
                   mapClosedWonConIdvsConlineItemList.put(ConLineObj.FCST_Contract__r.id+ConLineObj.name,newConLineList);
             }
             
             
               if(ClosedWonConVsLineItemName.containsKey(ConLineObj.FCST_Contract__r.id)){
                   Set<String> mapContainFam =ClosedWonConVsLineItemName.get(ConLineObj.FCST_Contract__r.id); 
                   mapContainFam.add(ConLineObj.Name+ConLineObj.FCST_Contract__r.id);
                   ClosedWonConVsLineItemName.put(ConLineObj.FCST_Contract__r.id,mapContainFam); 
                }else{
                   Set<String> newFamList = new Set<String>();
                   newFamList.add(ConLineObj.Name+ConLineObj.FCST_Contract__r.id);
                   ClosedWonConVsLineItemName.put(ConLineObj.FCST_Contract__r.id,newFamList);
                }
                
                   if(ClosedWonConidVsLineItem.containsKey(ConLineObj.FCST_Contract__r.id)){
                   Set<String> mapContainFam =ClosedWonConidVsLineItem.get(ConLineObj.FCST_Contract__r.id);
                   mapContainFam.add(ConLineObj.FCST_Contract__r.id+ConLineObj.name);
                   ClosedWonConidVsLineItem.put(ConLineObj.FCST_Contract__r.id,mapContainFam); 
                }else{
                   Set<String> newFamList = new Set<String>();
                   newFamList.add(ConLineObj.FCST_Contract__r.id+ConLineObj.name);
                   ClosedWonConidVsLineItem.put(ConLineObj.FCST_Contract__r.id,newFamList);
                }
                
        }
        
        
        
        
        
        
     String ClosedWonInitialForecastQuery = 'Select Planning_Version__r.Name,Forecast_with_Risk__c,FCST_Contract__r.id,FCST_Planning_Fiscal_Year__r.Name,Contract_LineItem__r.id,Contract_LineItem__r.Name,Contract_LineItem__c,Fcst_Amount__c,FCST_Contract__c,FCST_Fiscal_Year_List__c,FCST_Planning_Fiscal_Year__c,Fiscal_Period__c,FCST_Contract__r.Contract__c,RiskAmount__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Contract__r.id=:ClosedWoncontractidSet  and Contract_LineItem__r.id IN:ClosedWonConHavingLineItemIdSet and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and id<>null  ';
     
      List<FCST_Initial_Forecast__c>ClosedWonInitialForecastList=database.query(ClosedWonInitialForecastQuery);
      
              for(FCST_Initial_Forecast__c productObj:ClosedWonInitialForecastList){
                
              if(ClosedWonmapLineNameVsContactList.containsKey(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name) ){
                   List<FCST_Initial_Forecast__c> mapContainInitialForecastModel =ClosedWonmapLineNameVsContactList.get(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name);
                   mapContainInitialForecastModel.add(productObj);
                   ClosedWonmapLineNameVsContactList.put(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name,mapContainInitialForecastModel);
             }
             else {
                   List<FCST_Initial_Forecast__c> newInitialForecastList = new List<FCST_Initial_Forecast__c>();
                   newInitialForecastList.add(productObj);
                   ClosedWonmapLineNameVsContactList.put(productObj.FCST_Contract__r.id+productObj.Contract_LineItem__r.Name,newInitialForecastList); 
             }
            
        } 
           
                    
                    
                    


//><>>>>>>>>>>>>>>>>>>>>>>>>>>Actual calculation>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     
        String ClosedWonactualQuery = 'select id,Name,Account__c,FCST_Contract__c,Actual_Amount__c,Contract_LineItem__r.Name,FCST_Contract__r.id,FCST_Planning_Version__r.Name,Fiscal_Period__r.Name from Actual_Model__c where  FCST_Contract__r.id IN:ClosedWoncontractidSet and Account__c IN:pagSet and Contract_LineItem__r.id IN:ClosedWonConHavingLineItemIdSet and FCST_Contract__r.FCST_Contract_Created_Year__c =: currentYear  and FCST_Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name LIKE :j and id!=null LIMIT 15000';            
          List<Actual_Model__c> ClosedWonactualnewList = database.query(ClosedWonactualQuery);
          
     if(ClosedWonactualnewList.size()>0){  
        for(Actual_Model__c actualObj:ClosedWonactualnewList){
            
              if(ClosedWonLineItemIdVsActualList.containsKey(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name)){
                   List<Actual_Model__c> mapContainActualModel =ClosedWonLineItemIdVsActualList.get(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name);   
                   mapContainActualModel.add(actualObj);
                   ClosedWonLineItemIdVsActualList.put(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name,mapContainActualModel);
             }
             else{
                   List<Actual_Model__c> newActualModelList = new List<Actual_Model__c>();
                   newActualModelList.add(actualObj);
                   ClosedWonLineItemIdVsActualList.put(actualObj.FCST_Contract__r.id+actualObj.Contract_LineItem__r.name,newActualModelList);
             }
         }
       } 


 /*  ******************************************************************Closed Won Half table end****************************************************************************************** */     




    
    
 /*  ******************************************************************Baseline table start****************************************************************************************** */     
     
               
       
         String coontactQuery ='Select id,name,Fcst_Account__c,Contract__c,FCST_Contract_Created_Year__c,Fcst_Account__r.name from FCST_Contract__c where Fcst_Account__r.name =:strAccount and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Id<>null ) and FCST_Contract_Created_Year__c <: currentYear  LIMIT 15000';
        List<FCST_Contract__c> totalContactList=database.query(coontactQuery);
        for(FCST_Contract__c cont:totalContactList){
        contractidSet.add(cont.id);
            
        }
         
        String ContactlineInnerQuery ='Select id,name,FCST_Contract__c,FCST_Contract__r.name,FCST_Contract__r.Contract__c from Contract_LineItem__c where FCST_Contract__r.id IN:contractidSet and  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where FCST_Contract__r.id IN:contractidSet and Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr ) ORDER BY Name  LIMIT 15000';
            List<Contract_LineItem__c> totalLineItemList=database.query(ContactlineInnerQuery);
             
            for(Contract_LineItem__c ConLine:totalLineItemList){
            if(ConLine.Id!=null && ConLine.Name!=null){
            LineHavingLineItemName.put(ConLine.Id,ConLine.Name);    
            }
              }
        
          String ContactQuery='Select id,name,Contract_Description__c,Fcst_Account__r.id,Fcst_Account__r.Name,Contract__c,Fcst_Account__c from  FCST_Contract__c where Fcst_Account__r.name =:strAccount and id IN:contractidSet and Id<>null  and Id IN(Select FCST_Contract__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and FCST_Contract_Created_Year__c <: currentYear ORDER BY Name LIMIT 15000 ';
            List<FCST_Contract__c> ContactLisst=database.query(ContactQuery); 
           for(FCST_Contract__c Con:ContactLisst){

             if(Con.Fcst_Account__r.Id!=null && Con.Fcst_Account__r.Name!=null){
                     ConHavingAccountIdName.put(Con.Fcst_Account__r.Id,Con.Fcst_Account__r.Name);    
                   }
             if(ConVsLineItem.containsKey(Con.Fcst_Account__r.id)){
                   List<FCST_Contract__c> mapContainCon =ConVsLineItem.get(Con.Fcst_Account__r.id);
                   mapContainCon.add(Con);
                   ConVsLineItem.put(Con.Fcst_Account__r.id,mapContainCon);
             }else {
                   List<FCST_Contract__c> newConList = new List<FCST_Contract__c>();
                   newConList.add(Con);
                   ConVsLineItem.put(Con.Fcst_Account__r.id,newConList);
             }
           }
           
    for(Contract_LineItem__c ConLineObj:[select Id,Name,Line_Description__c,Cost_Center__c,FCST_Contract__c,FCST_Fiscal_Year_List__c,FCST_Contract__r.Contract__c from Contract_LineItem__c  where FCST_Contract__r.id IN:contractidSet and  Id IN(Select Contract_LineItem__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr) and id<>null and ID IN:LineHavingLineItemName.keySet() order by Name]){   
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
              
            
      String InitialForecastQuery = 'Select Planning_Version__r.Name,Forecast_with_Risk__c,FCST_Contract__r.id,FCST_Planning_Fiscal_Year__r.Name,Contract_LineItem__r.id,Contract_LineItem__r.Name,Contract_LineItem__c,Fcst_Amount__c,FCST_Contract__c,FCST_Fiscal_Year_List__c,FCST_Planning_Fiscal_Year__c,Fiscal_Period__c,FCST_Contract__r.Contract__c,RiskAmount__c from FCST_Initial_Forecast__c where Planning_Version__r.Name=:strPlanningVersion and Contract_LineItem__r.id IN:ConHavingLineItemIdSet and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and id<>null  ';
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
       
 //><>>>>>>>>>>>>>>>>>>>>>>>>>>Actual calculation>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        String actualQuery = 'select id,Name,Account__c,Actual_Amount__c,Contract_LineItem__r.Name,FCST_Contract__r.id,FCST_Planning_Version__r.Name,Fiscal_Period__r.Name from Actual_Model__c where  FCST_Contract__r.id IN:contractidSet and Account__c IN:pagSet and Contract_LineItem__r.id IN:ConHavingLineItemIdSet and FCST_Contract__r.FCST_Contract_Created_Year__c <: currentYear  and FCST_Planning_Version__r.Name=:strPlanningVersion and Fiscal_Period__r.Name LIKE :j and id!=null LIMIT 15000';            
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



/*  ******************************************************************Baseline table half closed****************************************************************************************** */     
    
    
    
    
    
    
     
      //********************************************* Table start  *************************************************************************
      
       
           String  tableRecord='<table id="table_id" class="slds-table slds-table--bordered slds-table--cell-buffer"><tr class="slds-text-title--caps"><th  style="background-color: #313A8B;width:20%;text-align: center;" rowspan="2"><label  style="color: white;" >Account</label></th><th  colspan="13" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" ><b>Planning Year</b><b class="Ram"  style="color: white;"> - '+globalYear+'</b></label></th></tr><tr class="slds-text-title--caps"><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label style="color: white;" >Jan</label></th><th   class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Feb</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Mar</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Apr</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >May</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jun</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Jul</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Aug</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Sep</label></th><th  class="w_f"  style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Oct</label></th><th  class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Nov</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Dec</label></th><th   class="w_f" style="background-color: #313A8B;text-align: center;"><label  style="color: white;" >Total</label></th></tr>';        
           String tableBody='';
           List<String> args2 = new String[]{'0','number','###,###,###'};
           
           
             Decimal TotalFunnelTotalAdjustedForecasAmount=0,FunnelTotalAdjustedForecasAmount1=0,FunnelTotalAdjustedForecasAmount2=0,FunnelTotalAdjustedForecasAmount3=0,FunnelTotalAdjustedForecasAmount4=0,FunnelTotalAdjustedForecasAmount5=0,FunnelTotalAdjustedForecasAmount6=0,FunnelTotalAdjustedForecasAmount7=0,FunnelTotalAdjustedForecasAmount8=0,FunnelTotalAdjustedForecasAmount9=0,FunnelTotalAdjustedForecasAmount10=0,FunnelTotalAdjustedForecasAmount11=0,FunnelTotalAdjustedForecasAmount12=0;
             Decimal TotalFunnelTotalUnAdjustedForecasAmount=0,FunnelTotalUnAdjustedForecasAmount1=0,FunnelTotalUnAdjustedForecasAmount2=0,FunnelTotalUnAdjustedForecasAmount3=0,FunnelTotalUnAdjustedForecasAmount4=0,FunnelTotalUnAdjustedForecasAmount5=0,FunnelTotalUnAdjustedForecasAmount6=0,FunnelTotalUnAdjustedForecasAmount7=0,FunnelTotalUnAdjustedForecasAmount8=0,FunnelTotalUnAdjustedForecasAmount9=0,FunnelTotalUnAdjustedForecasAmount10=0,FunnelTotalUnAdjustedForecasAmount11=0,FunnelTotalUnAdjustedForecasAmount12=0;
             Decimal TotalComitTotalAdjustedForecasAmount=0,ComitTotalAdjustedForecasAmount1=0,ComitTotalAdjustedForecasAmount2=0,ComitTotalAdjustedForecasAmount3=0,ComitTotalAdjustedForecasAmount4=0,ComitTotalAdjustedForecasAmount5=0,ComitTotalAdjustedForecasAmount6=0,ComitTotalAdjustedForecasAmount7=0,ComitTotalAdjustedForecasAmount8=0,ComitTotalAdjustedForecasAmount9=0,ComitTotalAdjustedForecasAmount10=0,ComitTotalAdjustedForecasAmount11=0,ComitTotalAdjustedForecasAmount12=0;
             Decimal TotalComitTotalUnadjustedForecastAmount=0,ComitTotalUnadjustedForecastAmount1=0,ComitTotalUnadjustedForecastAmount2=0,ComitTotalUnadjustedForecastAmount3=0,ComitTotalUnadjustedForecastAmount4=0,ComitTotalUnadjustedForecastAmount5=0,ComitTotalUnadjustedForecastAmount6=0,ComitTotalUnadjustedForecastAmount7=0,ComitTotalUnadjustedForecastAmount8=0,ComitTotalUnadjustedForecastAmount9=0,ComitTotalUnadjustedForecastAmount10=0,ComitTotalUnadjustedForecastAmount11=0,ComitTotalUnadjustedForecastAmount12=0;
             
     for(Id acciD :pagSet){  
            
        String BaseLineRowBody='';
         
        Decimal totalFinalactualAmount=0,AccFinalactualAmount1=0,AccFinalactualAmount2=0,AccFinalactualAmount3=0,AccFinalactualAmount4=0,AccFinalactualAmount5=0,AccFinalactualAmount6=0,AccFinalactualAmount7=0,AccFinalactualAmount8=0,AccFinalactualAmount9=0,AccFinalactualAmount10=0,AccFinalactualAmount11=0,AccFinalactualAmount12=0;
        Decimal totalAccLevelActual=0,AccLevelactualAmount1=0,AccLevelactualAmount2=0,AccLevelactualAmount3=0,AccLevelactualAmount4=0,AccLevelactualAmount5=0,AccLevelactualAmount6=0,AccLevelactualAmount7=0,AccLevelactualAmount8=0,AccLevelactualAmount9=0,AccLevelactualAmount10=0,AccLevelactualAmount11=0,AccLevelactualAmount12=0;
        Decimal totalAccLevelWonActual=0,AccLevelWonActual1=0,AccLevelWonActual2=0,AccLevelWonActual3=0,AccLevelWonActual4=0,AccLevelWonActual5=0,AccLevelWonActual6=0,AccLevelWonActual7=0,AccLevelWonActual8=0,AccLevelWonActual9=0,AccLevelWonActual10=0,AccLevelWonActual11=0,AccLevelWonActual12=0;
        

         





/*  ******************************************************************Closed Won table Main start****************************************************************************************** */     
         Decimal ClosedMAmount1=0,ClosedMAmount2=0,ClosedMAmount3=0,ClosedMAmount4=0,ClosedMAmount5=0,ClosedMAmount6=0,ClosedMAmount7=0,ClosedMAmount8=0,ClosedMAmount9=0,ClosedMAmount10=0,ClosedMAmount11=0,ClosedMAmount12=0,TotalClosedMAmount=0;
         Decimal ClosedFwithRisk1=0,ClosedFwithRisk2=0,ClosedFwithRisk3=0,ClosedFwithRisk4=0,ClosedFwithRisk5=0,ClosedFwithRisk6=0,ClosedFwithRisk7=0,ClosedFwithRisk8=0,ClosedFwithRisk9=0,ClosedFwithRisk10=0,ClosedFwithRisk11=0,ClosedFwithRisk12=0,TotalClosedFwithRisk=0;
         Decimal totalActual=0,actualAmount1=0,actualAmount2=0,actualAmount3=0,actualAmount4=0,actualAmount5=0,actualAmount6=0,actualAmount7=0,actualAmount8=0,actualAmount9=0,actualAmount10=0,actualAmount11=0,actualAmount12=0;



       
       if(ClosedWonConVsLineItem.containsKey(acciD)){
                    
       for(FCST_Contract__c Con :ClosedWonConVsLineItem.get(acciD)){
                        Decimal totalConLevelActual=0,ConLevelactualAmount1=0,ConLevelactualAmount2=0,ConLevelactualAmount3=0,ConLevelactualAmount4=0,ConLevelactualAmount5=0,ConLevelactualAmount6=0,ConLevelactualAmount7=0,ConLevelactualAmount8=0,ConLevelactualAmount9=0,ConLevelactualAmount10=0,ConLevelactualAmount11=0,ConLevelactualAmount12=0;
       if(ClosedWonConidVsLineItem.containsKey(Con.Id)){
                            
       for(String str :ClosedWonConidVsLineItem.get(Con.Id)){
                            
                            
       if(mapClosedWonConIdvsConlineItemList.containsKey(str)){
                              List<Contract_LineItem__c> ContactLineItemList=mapClosedWonConIdvsConlineItemList.get(str);
                              
       for(Contract_LineItem__c ConLineItemObj:ContactLineItemList){
        
        
                                
//************************************** Actual string calculation Start ************************************************                
                         
       if(ClosedWonLineItemIdVsActualList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name)){
                        List<Actual_Model__c> getClosedWonActualList=ClosedWonLineItemIdVsActualList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name);

       for(Actual_Model__c actobj:getClosedWonActualList){
                     String fiscalPeriod=actobj.Fiscal_Period__r.Name;
                     String planningP = fiscalPeriod.split('P')[1];
                    
                     if( planningP=='01'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount1+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount1=actualAmount1;
                                     AccLevelWonActual1=ConLevelactualAmount1;
                                    
                    }
                    else if( planningP=='02'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount2+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount2=actualAmount2;
                                      AccLevelWonActual2=ConLevelactualAmount2;
                       
                        
                    }
                    else if( planningP=='03'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount3+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount3=actualAmount3;
                                     AccLevelWonActual3=ConLevelactualAmount3;
                                    
                       
                    }
                    else if( planningP=='04'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount4+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount4=actualAmount4;
                                      AccLevelWonActual4=ConLevelactualAmount4;
                        
                    }
                    else if( planningP=='05'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount5+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount5=actualAmount5;
                                      AccLevelWonActual5=ConLevelactualAmount5;
                       
                    }
                    else if( planningP=='06'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount6+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount6=actualAmount6;
                                     AccLevelWonActual6=ConLevelactualAmount6;
                       
                    }
                    else if( planningP=='07'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                    actualAmount7+=actobj.Actual_Amount__c; 
                                    ConLevelactualAmount7=actualAmount7;
                                    AccLevelWonActual7=ConLevelactualAmount7;
                    }
                    else if( planningP=='08'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount8+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount8=actualAmount8;
                                      AccLevelWonActual8=ConLevelactualAmount8;
                    }
                    else if( planningP=='09'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount9+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount9=actualAmount9;
                                     AccLevelWonActual9=ConLevelactualAmount9;
                    }
                    else if( planningP=='10'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount10+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount10=actualAmount10;
                                     AccLevelWonActual10=ConLevelactualAmount10;
                    }
                    else if( planningP=='11'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     actualAmount11+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount11=actualAmount11;
                                     AccLevelWonActual11=ConLevelactualAmount11;
                    }
                    else if( planningP=='12'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      actualAmount12+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount12=actualAmount12;
                                      AccLevelWonActual12=ConLevelactualAmount12;
                    }

                    }
                    }
                              totalActual=actualAmount1+actualAmount2+actualAmount3+actualAmount4+actualAmount5+actualAmount6+actualAmount7+actualAmount8+actualAmount9+actualAmount10+actualAmount11+actualAmount12;
                             totalAccLevelWonActual=AccLevelWonActual1+AccLevelWonActual2+AccLevelWonActual3+AccLevelWonActual4+AccLevelWonActual5+AccLevelWonActual6+AccLevelWonActual7+AccLevelWonActual8+AccLevelWonActual9+AccLevelWonActual10+AccLevelWonActual11+AccLevelWonActual12;
                
                
//***************************************************************** Actual string calculation end *********************************************************************************** 
                                
                                
                  
                                      
                   

      if(ClosedWonmapLineNameVsContactList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name)){
                    
                    Decimal MAmount1=0,MAmount2=0,MAmount3=0,MAmount4=0,MAmount5=0,MAmount6=0,MAmount7=0,MAmount8=0,MAmount9=0,MAmount10=0,MAmount11=0,MAmount12=0,TotalMAmount=0;
                    Decimal ForecastwithRisk1=0,ForecastwithRisk2=0,ForecastwithRisk3=0,ForecastwithRisk4=0,ForecastwithRisk5=0,ForecastwithRisk6=0,ForecastwithRisk7=0,ForecastwithRisk8=0,ForecastwithRisk9=0,ForecastwithRisk10=0,ForecastwithRisk11=0,ForecastwithRisk12=0,TotalForecastwithRisk=0;
                  
                     List<FCST_Initial_Forecast__c> getClosedWonInitialForecastModelList=ClosedWonmapLineNameVsContactList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name);
                    
                    
      for(FCST_Initial_Forecast__c InitialForecastModelObj:getClosedWonInitialForecastModelList){ 
                          Decimal RiskAmount=0; 
      if(InitialForecastModelObj.RiskAmount__c!=null){
                          RiskAmount=InitialForecastModelObj.RiskAmount__c*(-1);   
                         }
                          String fiscalPeriod=InitialForecastModelObj.FCST_Planning_Fiscal_Year__r.Name; 
                          String planningP = fiscalPeriod.split('P')[1];
                         
                          
             if( planningP=='01' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount1=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount1+=MAmount1;
                                        ForecastwithRisk1=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk1+=ForecastwithRisk1;
                                         
                                     }
             else if( planningP=='02'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount2=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount2+=MAmount2;
                                        ForecastwithRisk2=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk2+=ForecastwithRisk2;
                                     }
           else if( planningP=='03'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount3=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount3+=MAmount3;
                                        ForecastwithRisk3=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk3+=ForecastwithRisk3;
                                     }
          else if( planningP=='04'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount4=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount4+=MAmount4;
                                        ForecastwithRisk4=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk4+=ForecastwithRisk4;
                                     }
          else if( planningP=='05'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount5=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount5+=MAmount5;
                                        ForecastwithRisk5=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk5+=ForecastwithRisk5;
                                     }
         else if( planningP=='06'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount6=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount6+=MAmount6;
                                        ForecastwithRisk6=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk6+=ForecastwithRisk6;
                                     }
         else if( planningP=='07'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount7=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount7+=MAmount7;
                                        ForecastwithRisk7=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk7+=ForecastwithRisk7;
                                     }
         else if( planningP=='08'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount8=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount8+=MAmount8;
                                        ForecastwithRisk8=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk8+=ForecastwithRisk8;
                                          
                                     }
         else if( planningP=='09' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount9=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount9+=MAmount9;
                                        ForecastwithRisk9=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk9+=ForecastwithRisk9;
                                     }
         else if( planningP=='10' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount10=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount10+=MAmount10;
                                        ForecastwithRisk10=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk10+=ForecastwithRisk10;
                                     }
         else if( planningP=='11' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount11=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount11+=MAmount11;
                                        ForecastwithRisk11=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk11+=ForecastwithRisk11;
                                        
                                     }
          else if( planningP=='12' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount12=InitialForecastModelObj.Fcst_Amount__c;
                                        ClosedMAmount12+=MAmount12;
                                        ForecastwithRisk12=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ClosedFwithRisk12+=ForecastwithRisk12;
                                     }
                         
                         
                         
                                     }//itrretion closed
                                     
                                  }//model if closed

                              }//Lineitem for loop Closed
                              }//Lineitem If Closed
                         }//ConidVsLineItem for loop closed
                        
                         }//ConidVsLineItem if Closed
                        }//Contact for loop closed 
                      }//Contact if Closed
                      
                      
                    //  system.debug('UserIUserI>>>>'+UserI);
           TotalClosedFwithRisk=ClosedFwithRisk1+ClosedFwithRisk2+ClosedFwithRisk3+ClosedFwithRisk4+ClosedFwithRisk5+ClosedFwithRisk6+ClosedFwithRisk7+ClosedFwithRisk8+ClosedFwithRisk9+ClosedFwithRisk10+ClosedFwithRisk11+ClosedFwithRisk12;
           TotalClosedMAmount=ClosedMAmount1+ClosedMAmount2+ClosedMAmount3+ClosedMAmount4+ClosedMAmount5+ClosedMAmount6+ClosedMAmount7+ClosedMAmount8+ClosedMAmount9+ClosedMAmount10+ClosedMAmount11+ClosedMAmount12;
         //  String  WonforcasttWithRisk='<tr><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalClosedFwithRisk.setscale(0).format(), args2)+'</th></tr>';  
                  String Z1,Z2,Z3,Z4,Z5,Z6,Z7,Z8,Z9,Z10,Z11,Z12,Z13;
                        String  WonforcasttWithRisk='<tr><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th>';
                        if(ClosedFwithRisk1<0){
                        Z1='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z1='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk1.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk2<0){
                        Z2='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z2='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk2.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk3<0){
                        Z3='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z3='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk3.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk4<0){
                        Z4='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                       Z4='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk4.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk5<0){
                        Z5='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z5='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk5.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk6<0){
                        Z6='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z6='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk6.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ClosedFwithRisk7<0){
                        Z7='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z7='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk7.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ClosedFwithRisk8<0){
                        Z8='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z8='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk8.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk9<0){
                        Z9='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z9='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk9.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk10<0){
                        Z10='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z10='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk10.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk11<0){
                        Z11='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z11='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk11.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ClosedFwithRisk12<0){
                        Z12='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedFwithRisk12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z12='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedFwithRisk12.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(TotalClosedFwithRisk<0){
                        Z13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalClosedFwithRisk*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        Z13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalClosedFwithRisk.setscale(0).format(), args2)+'</th>';
                         }
                         
                         WonforcasttWithRisk+=Z1+Z2+Z3+Z4+Z5+Z6+Z7+Z8+Z9+Z10+Z11+Z12+Z13; 
          
          
          // String  WonWithouttRisk='<tr><th title="Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast without Risk</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalClosedMAmount.setscale(0).format(), args2)+'</th></tr>';  
         String L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13;
           
           String  WonWithouttRisk='<tr><th title="Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast without Risk</th>';
           
           if(ClosedMAmount1<0){
           L1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(ClosedMAmount2<0){
           L2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(ClosedMAmount3<0){
           L3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount4<0){
           L4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount5<0){
           L5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(ClosedMAmount6<0){
           L6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(ClosedMAmount7<0){
           L7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount8<0){
           L8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount9<0){
           L9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount10<0){
           L10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount11<0){
           L11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(ClosedMAmount12<0){
           L12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ClosedMAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ClosedMAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(TotalClosedMAmount<0){
           L13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalClosedMAmount*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           L13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalClosedMAmount.setscale(0).format(), args2)+'</th>';
           }


        WonWithouttRisk+=L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12+L13;           
         //  String  ClosedWonActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(actualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(actualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalActual.setscale(0).format(), args2)+'</th></tr>';   
         String Tv1,Tv2,Tv3,Tv4,Tv5,Tv6,Tv7,Tv8,Tv9,Tv10,Tv11,Tv12,Tv13;
           
          String  ClosedWonActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th>';
           
           if(actualAmount1<0){
           Tv1='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv1='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(actualAmount2<0){
           Tv2='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv2='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
            if(actualAmount3<0){
           Tv3='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv3='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount4<0){
           Tv4='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv4='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount5<0){
           Tv5='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv5='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(actualAmount6<0){
           Tv6='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv6='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(actualAmount7<0){
           Tv7='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv7='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount8<0){
           Tv8='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          Tv8='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount9<0){
           Tv9='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv9='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount10<0){
           Tv10='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv10='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount11<0){
           Tv11='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv11='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(actualAmount12<0){
           Tv12='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((actualAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          Tv12='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(actualAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(totalActual<0){
           Tv13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((totalActual*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           Tv13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(totalActual.setscale(0).format(), args2)+'</th>';
           }


        ClosedWonActualAmount+=Tv1+Tv2+Tv3+Tv4+Tv5+Tv6+Tv7+Tv8+Tv9+Tv10+Tv11+Tv12+Tv13;           
          
           String  ClosedWonRow='<tr><th title="Forecast Category" class=worstRow'+acciD+'  style="background-color:#8EA9DB;color:black;size: 10%;font-size: 110%;"><b><center>Closed Won</center></b><a href="/apex/Fcst_ClosedWonSW_V2?pv='+pVVersionStringId+'&su='+UserI+'&AccId='+AccIdd+'" target="_blank">(Click here to view detailed Forecast)</a></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#8EA9DB;border-right-color: #8EA9DB;"></th></tr>';
          
                        
/*  ******************************************************************Closed Won table Main End****************************************************************************************** */     
                 







/*  ******************************************************************Baseline table Main start****************************************************************************************** */     
         Decimal totalBaselineActual=0,BaselineactualAmount1=0,BaselineactualAmount2=0,BaselineactualAmount3=0,BaselineactualAmount4=0,BaselineactualAmount5=0,BaselineactualAmount6=0,BaselineactualAmount7=0,BaselineactualAmount8=0,BaselineactualAmount9=0,BaselineactualAmount10=0,BaselineactualAmount11=0,BaselineactualAmount12=0;
         Decimal ConLevelMAmount1=0,ConLevelMAmount2=0,ConLevelMAmount3=0,ConLevelMAmount4=0,ConLevelMAmount5=0,ConLevelMAmount6=0,ConLevelMAmount7=0,ConLevelMAmount8=0,ConLevelMAmount9=0,ConLevelMAmount10=0,ConLevelMAmount11=0,ConLevelMAmount12=0,TotalConLevelMAmount=0;
         Decimal ConForecastwithRisk1=0,ConForecastwithRisk2=0,ConForecastwithRisk3=0,ConForecastwithRisk4=0,ConForecastwithRisk5=0,ConForecastwithRisk6=0,ConForecastwithRisk7=0,ConForecastwithRisk8=0,ConForecastwithRisk9=0,ConForecastwithRisk10=0,ConForecastwithRisk11=0,ConForecastwithRisk12=0,TotalConForecastwithRisk=0;
               
       if(ConVsLineItem.containsKey(acciD)){
                    
       for(FCST_Contract__c Con :ConVsLineItem.get(acciD)){
                        Decimal totalConLevelActual=0,ConLevelactualAmount1=0,ConLevelactualAmount2=0,ConLevelactualAmount3=0,ConLevelactualAmount4=0,ConLevelactualAmount5=0,ConLevelactualAmount6=0,ConLevelactualAmount7=0,ConLevelactualAmount8=0,ConLevelactualAmount9=0,ConLevelactualAmount10=0,ConLevelactualAmount11=0,ConLevelactualAmount12=0;
                        
       if(ConidVsLineItem.containsKey(Con.Id)){
                            
       for(String str :ConidVsLineItem.get(Con.Id)){
                            
                            
       if(mapConIdvsConlineItemList.containsKey(str)){
                              List<Contract_LineItem__c> ContactLineItemList=mapConIdvsConlineItemList.get(str);
                              
       for(Contract_LineItem__c ConLineItemObj:ContactLineItemList){
                                
//************************************** Actual string calculation Start ************************************************                
                         
       if(LineItemIdVsActualList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name)){
                        List<Actual_Model__c> getActualList=LineItemIdVsActualList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.Name);

       for(Actual_Model__c actobj:getActualList){
                     String fiscalPeriod=actobj.Fiscal_Period__r.Name;
                     String planningP = fiscalPeriod.split('P')[1];
                    
                     if( planningP=='01'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     BaselineactualAmount1+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount1=BaselineactualAmount1;
                                     AccLevelactualAmount1=ConLevelactualAmount1;
                                    
                    }
                    else if( planningP=='02'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      BaselineactualAmount2+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount2=BaselineactualAmount2;
                                      AccLevelactualAmount2=ConLevelactualAmount2;
                       
                        
                    }
                    else if( planningP=='03'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     BaselineactualAmount3+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount3=BaselineactualAmount3;
                                     AccLevelactualAmount3=ConLevelactualAmount3;
                                    
                       
                    }
                    else if( planningP=='04'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      BaselineactualAmount4+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount4=BaselineactualAmount4;
                                      AccLevelactualAmount4=ConLevelactualAmount4;
                        
                    }
                    else if( planningP=='05'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     BaselineactualAmount5+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount5=BaselineactualAmount5;
                                     AccLevelactualAmount5=ConLevelactualAmount5;
                       
                    }
                    else if( planningP=='06'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     BaselineactualAmount6+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount6=BaselineactualAmount6;
                                     AccLevelactualAmount6=ConLevelactualAmount6;
                       
                    }
                    else if( planningP=='07'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                    BaselineactualAmount7+=actobj.Actual_Amount__c; 
                                    ConLevelactualAmount7=BaselineactualAmount7;
                                    AccLevelactualAmount7=ConLevelactualAmount7;
                    }
                    else if( planningP=='08'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      BaselineactualAmount8+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount8=BaselineactualAmount8;
                                      AccLevelactualAmount8=ConLevelactualAmount8;
                    }
                    else if( planningP=='09'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      BaselineactualAmount9+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount9=BaselineactualAmount9;
                                      AccLevelactualAmount9=ConLevelactualAmount9;
                    }
                    else if( planningP=='10'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     BaselineactualAmount10+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount10=BaselineactualAmount10;
                                     AccLevelactualAmount10=ConLevelactualAmount10;
                    }
                    else if( planningP=='11'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                     BaselineactualAmount11+=actobj.Actual_Amount__c;
                                     ConLevelactualAmount11=BaselineactualAmount11;
                                     AccLevelactualAmount11=ConLevelactualAmount11;
                    }
                    else if( planningP=='12'  && actobj.FCST_Planning_Version__r.Name==strPlanningVersion && actobj.Actual_Amount__c!=null){
                                      BaselineactualAmount12+=actobj.Actual_Amount__c;
                                      ConLevelactualAmount12=BaselineactualAmount12;
                                      AccLevelactualAmount12=ConLevelactualAmount12;
                    }

                    }
                    }

                totalBaselineActual=BaselineactualAmount1+BaselineactualAmount2+BaselineactualAmount3+BaselineactualAmount4+BaselineactualAmount5+BaselineactualAmount6+BaselineactualAmount7+BaselineactualAmount8+BaselineactualAmount9+BaselineactualAmount10+BaselineactualAmount11+BaselineactualAmount12;
                
//***************************************************************** Actual string calculation end *********************************************************************************** 
                                
                                
                  
                                      
                   

      if(mapLineNameVsContactList.containsKey(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name)){
                    
                    Decimal MAmount1=0,MAmount2=0,MAmount3=0,MAmount4=0,MAmount5=0,MAmount6=0,MAmount7=0,MAmount8=0,MAmount9=0,MAmount10=0,MAmount11=0,MAmount12=0,TotalMAmount=0;
                    Decimal ForecastwithRisk1=0,ForecastwithRisk2=0,ForecastwithRisk3=0,ForecastwithRisk4=0,ForecastwithRisk5=0,ForecastwithRisk6=0,ForecastwithRisk7=0,ForecastwithRisk8=0,ForecastwithRisk9=0,ForecastwithRisk10=0,ForecastwithRisk11=0,ForecastwithRisk12=0,TotalForecastwithRisk=0;
                  
                     List<FCST_Initial_Forecast__c> getInitialForecastModelList=mapLineNameVsContactList.get(ConLineItemObj.FCST_Contract__r.id+ConLineItemObj.name);
                    
                    
      for(FCST_Initial_Forecast__c InitialForecastModelObj:getInitialForecastModelList){ 
                          Decimal RiskAmount=0; 
      if(InitialForecastModelObj.RiskAmount__c!=null){
                          RiskAmount=InitialForecastModelObj.RiskAmount__c*(-1);   
                         }
                          String fiscalPeriod=InitialForecastModelObj.FCST_Planning_Fiscal_Year__r.Name; 
                          String planningP = fiscalPeriod.split('P')[1];
                         
                          
             if( planningP=='01' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount1=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount1+=MAmount1;
                                        ForecastwithRisk1=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk1+=ForecastwithRisk1;
                                         
                                     }
             else if( planningP=='02'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount2=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount2+=MAmount2;
                                        ForecastwithRisk2=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk2+=ForecastwithRisk2;
                                     }
           else if( planningP=='03'  && InitialForecastModelObj.Fcst_Amount__c!=null){
                                        MAmount3=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount3+=MAmount3;
                                        ForecastwithRisk3=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk3+=ForecastwithRisk3;
                                     }
          else if( planningP=='04'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount4=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount4+=MAmount4;
                                        ForecastwithRisk4=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk4+=ForecastwithRisk4;
                                     }
          else if( planningP=='05'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount5=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount5+=MAmount5;
                                        ForecastwithRisk5=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk5+=ForecastwithRisk5;
                                     }
         else if( planningP=='06'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount6=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount6+=MAmount6;
                                        ForecastwithRisk6=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk6+=ForecastwithRisk6;
                                     }
         else if( planningP=='07'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount7=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount7+=MAmount7;
                                        ForecastwithRisk7=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk7+=ForecastwithRisk7;
                                     }
         else if( planningP=='08'  && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount8=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount8+=MAmount8;
                                        ForecastwithRisk8=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk8+=ForecastwithRisk8;
                                          
                                     }
         else if( planningP=='09' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount9=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount9+=MAmount9;
                                        ForecastwithRisk9=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk9+=ForecastwithRisk9;
                                     }
         else if( planningP=='10' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount10=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount10+=MAmount10;
                                        ForecastwithRisk10=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk10+=ForecastwithRisk10;
                                     }
         else if( planningP=='11' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount11=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount11+=MAmount11;
                                        ForecastwithRisk11=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk11+=ForecastwithRisk11;
                                        
                                     }
          else if( planningP=='12' && InitialForecastModelObj.Fcst_Amount__c!=null ){
                                        MAmount12=InitialForecastModelObj.Fcst_Amount__c;
                                        ConLevelMAmount12+=MAmount12;
                                        ForecastwithRisk12=InitialForecastModelObj.Forecast_with_Risk__c;
                                        ConForecastwithRisk12+=ForecastwithRisk12;
                                     }
                         
                         
                         
                                     }//itrretion closed
                                     
                                  }//model if closed

                              }//Lineitem for loop Closed
                              }//Lineitem If Closed
                         }//ConidVsLineItem for loop closed
                        
                         }//ConidVsLineItem if Closed
                        }//Contact for loop closed 
                      }//Contact if Closed
                      
                      
                      //system.debug('UserIUserI>>>>'+UserI);
           TotalConForecastwithRisk= ConForecastwithRisk1+ConForecastwithRisk2+ConForecastwithRisk3+ConForecastwithRisk4+ConForecastwithRisk5+ConForecastwithRisk6+ConForecastwithRisk7+ConForecastwithRisk8+ConForecastwithRisk9+ConForecastwithRisk10+ConForecastwithRisk11+ConForecastwithRisk12;
           TotalConLevelMAmount= ConLevelMAmount1+ConLevelMAmount2+ConLevelMAmount3+ConLevelMAmount4+ConLevelMAmount5+ConLevelMAmount6+ConLevelMAmount7+ConLevelMAmount8+ConLevelMAmount9+ConLevelMAmount10+ConLevelMAmount11+ConLevelMAmount12;
           totalAccLevelActual= AccLevelactualAmount1+AccLevelactualAmount2+AccLevelactualAmount3+AccLevelactualAmount4+AccLevelactualAmount5+AccLevelactualAmount6+AccLevelactualAmount7+AccLevelactualAmount8+AccLevelactualAmount9+AccLevelactualAmount10+AccLevelactualAmount11+AccLevelactualAmount12;
          // String  TotalforcasttWithRisk='<tr><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th></tr>';  
                       String s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13;
                        String  TotalforcasttWithRisk='<tr><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th>';
                        if(ConForecastwithRisk1<0){
                        s1='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s1='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk1.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         
                         
                         if(ConForecastwithRisk2<0){
                        s2='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s2='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk2.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk3<0){
                        s3='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s3='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk3.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk4<0){
                        s4='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                       s4='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk4.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk5<0){
                        s5='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s5='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk5.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk6<0){
                        s6='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s6='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk6.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ConForecastwithRisk7<0){
                        s7='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s7='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk7.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(ConForecastwithRisk8<0){
                        s8='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s8='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk8.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk9<0){
                        s9='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s9='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk9.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk10<0){
                        s10='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s10='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk10.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk11<0){
                        s11='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s11='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk11.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(ConForecastwithRisk12<0){
                        s12='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConForecastwithRisk12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s12='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConForecastwithRisk12.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(TotalConForecastwithRisk<0){
                        s13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalConForecastwithRisk*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        s13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConForecastwithRisk.setscale(0).format(), args2)+'</th>';
                         }
                         
                         TotalforcasttWithRisk+=s1+s2+s3+s4+s5+s6+s7+s8+s9+s10+s11+s12+s13;   
                                   
           //String  TotalforWithouttRisk='<tr><th title="Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th></tr>';  
        String B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13;
           
           String  TotalforWithouttRisk='<tr><th title="Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Forecast without Risk</th>';
           
           if(ConLevelMAmount1<0){
           B1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(ConLevelMAmount2<0){
           B2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
                   if(ConLevelMAmount3<0){
           B3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount4<0){
           B4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount5<0){
           B5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelMAmount6<0){
           B6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(ConLevelMAmount7<0){
           B7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount8<0){
           B8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount9<0){
           B9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount10<0){
           B10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount11<0){
           B11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(ConLevelMAmount12<0){
           B12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((ConLevelMAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(ConLevelMAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(TotalConLevelMAmount<0){
           B13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((TotalConLevelMAmount*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           B13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(TotalConLevelMAmount.setscale(0).format(), args2)+'</th>';
           }


        TotalforWithouttRisk+=B1+B2+B3+B4+B5+B6+B7+B8+B9+B10+B11+B12+B13;           
          
          
         //  String  ActuallAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalBaselineActual.setscale(0).format(), args2)+'</th></tr>';   
         String TT1,TT2,TT3,TT4,TT5,TT6,TT7,TT8,TT9,TT10,TT11,TT12,TT13;
           
          String  ActuallAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th>';
           
           if(BaselineactualAmount1<0){
           TT1='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT1='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(BaselineactualAmount2<0){
           TT2='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT2='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
            if(BaselineactualAmount3<0){
           TT3='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT3='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount4<0){
           TT4='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT4='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount5<0){
           TT5='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT5='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(BaselineactualAmount6<0){
           TT6='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT6='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(BaselineactualAmount7<0){
           TT7='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT7='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount8<0){
           TT8='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          TT8='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount9<0){
           TT9='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT9='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount10<0){
           TT10='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT10='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount11<0){
           TT11='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT11='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(BaselineactualAmount12<0){
           TT12='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((BaselineactualAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          TT12='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(BaselineactualAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(totalBaselineActual<0){
           TT13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((totalBaselineActual*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TT13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(totalBaselineActual.setscale(0).format(), args2)+'</th>';
           }


        ActuallAmount+=TT1+TT2+TT3+TT4+TT5+TT6+TT7+TT8+TT9+TT10+TT11+TT12+TT13;                               
                        
/*  ******************************************************************Baseline table Main End****************************************************************************************** */     
                 
 
 
 
 
 //********************************************************************* Committed Opportunity row start************************************************        
         
         
           if(mapProductIdOppIdVsProductList.containsKey(acciD)){
                          ID ModelIdd,ModelIdd1,ModelIdd2,ModelIdd3,ModelIdd4,ModelIdd5,ModelIdd6,ModelIdd7,ModelIdd8,ModelIdd9,ModelIdd10,ModelIdd11,ModelIdd12 ;
                          Decimal AdjustedForecastAmount=0,TotalAdjustedForecast=0,AdjustedForecast1=0,AdjustedForecast2=0,AdjustedForecast3=0,AdjustedForecast4=0,AdjustedForecast5=0,AdjustedForecast6=0,AdjustedForecast7=0,AdjustedForecast8=0,AdjustedForecast9=0,AdjustedForecast10=0,AdjustedForecast11=0,AdjustedForecast12=0;
                          Decimal UnadjustedForecastAmount=0,TotalUnadjustedForecastAmount=0,UnadjustedForecastAmount1=0,UnadjustedForecastAmount2=0,UnadjustedForecastAmount3=0,UnadjustedForecastAmount4=0,UnadjustedForecastAmount5=0,UnadjustedForecastAmount6=0,UnadjustedForecastAmount7=0,UnadjustedForecastAmount8=0,UnadjustedForecastAmount9=0,UnadjustedForecastAmount10=0,UnadjustedForecastAmount11=0,UnadjustedForecastAmount12=0;
    
                             List<FCST_Product_Model__c> getproductModelList=mapProductIdOppIdVsProductList.get(acciD);

          for(FCST_Product_Model__c productModelObj:getproductModelList){

                                    String fiscalPeriod=productModelObj.Fiscal_Period__r.Name; 
                                    String planningP = fiscalPeriod.split('P')[1];
                                   if(productModelObj.User_Adjusted_Revenue__c!=null && productModelObj.Weighted_Revenue__c!=null){
                                     AdjustedForecastAmount=Math.round(productModelObj.User_Adjusted_Revenue__c);
                                     UnadjustedForecastAmount=Math.round(productModelObj.Weighted_Revenue__c);
                                     
                                    }  
         if( planningP=='01' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        
                                        AdjustedForecast1=AdjustedForecastAmount;
                                        UnadjustedForecastAmount1=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount1+=AdjustedForecast1;
                                        ComitTotalUnadjustedForecastAmount1+=UnadjustedForecastAmount1;
                                     }
         else if( planningP=='02' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast2=AdjustedForecastAmount;
                                        UnadjustedForecastAmount2=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount2+=AdjustedForecast2;
                                        ComitTotalUnadjustedForecastAmount2+=UnadjustedForecastAmount2;
                                     }
         else if( planningP=='03' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast3=AdjustedForecastAmount;
                                        UnadjustedForecastAmount3=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount3+=AdjustedForecast3;
                                        ComitTotalUnadjustedForecastAmount3+=UnadjustedForecastAmount3;
                                     }
         else if( planningP=='04' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast4=AdjustedForecastAmount;
                                        UnadjustedForecastAmount4=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount4+=AdjustedForecast4;
                                        ComitTotalUnadjustedForecastAmount4+=UnadjustedForecastAmount4;
                                     }
        else if( planningP=='05' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast5=AdjustedForecastAmount;
                                        UnadjustedForecastAmount5=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount5+=AdjustedForecast5;
                                        ComitTotalUnadjustedForecastAmount5+=UnadjustedForecastAmount5;
                                     }
        else if( planningP=='06' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast6=AdjustedForecastAmount;
                                        UnadjustedForecastAmount6=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount6+=AdjustedForecast6;
                                        ComitTotalUnadjustedForecastAmount6+=UnadjustedForecastAmount6;
                                     }
       else if( planningP=='07' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast7=AdjustedForecastAmount;
                                        UnadjustedForecastAmount7=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount7+=AdjustedForecast7;
                                        ComitTotalUnadjustedForecastAmount7+=UnadjustedForecastAmount7;
                                     }
       else if( planningP=='08' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast8=AdjustedForecastAmount;
                                        UnadjustedForecastAmount8=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount8+=AdjustedForecast8;
                                        ComitTotalUnadjustedForecastAmount8+=UnadjustedForecastAmount8;
                                          
                                     }
       else if( planningP=='09' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast9=AdjustedForecastAmount;
                                        UnadjustedForecastAmount9=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount9+=AdjustedForecast9;
                                        ComitTotalUnadjustedForecastAmount9+=UnadjustedForecastAmount9;
                                     }
       else if( planningP=='10' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                         AdjustedForecast10=AdjustedForecastAmount;
                                         UnadjustedForecastAmount10=UnadjustedForecastAmount;
                                         ComitTotalAdjustedForecasAmount10+=AdjustedForecast10;
                                         ComitTotalUnadjustedForecastAmount10+=UnadjustedForecastAmount10;
                                     }
       else if( planningP=='11' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast11=AdjustedForecastAmount;
                                        UnadjustedForecastAmount11=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount11+=AdjustedForecast11;
                                        ComitTotalUnadjustedForecastAmount11+=UnadjustedForecastAmount11;
                                     }
        else if( planningP=='12' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast12=AdjustedForecastAmount;
                                        UnadjustedForecastAmount12=UnadjustedForecastAmount;
                                        ComitTotalAdjustedForecasAmount12+=AdjustedForecast12;
                                        ComitTotalUnadjustedForecastAmount12+=UnadjustedForecastAmount12;
                                     }
                                  
                                     }//itrretion closed
                                     
          }// mapProductIdOppIdVsProductList if closed
       
       
       
        TotalComitTotalAdjustedForecasAmount=ComitTotalAdjustedForecasAmount1+ComitTotalAdjustedForecasAmount2+ComitTotalAdjustedForecasAmount3+ComitTotalAdjustedForecasAmount4+ComitTotalAdjustedForecasAmount5+ComitTotalAdjustedForecasAmount6+ComitTotalAdjustedForecasAmount7+ComitTotalAdjustedForecasAmount8+ComitTotalAdjustedForecasAmount9+ComitTotalAdjustedForecasAmount10+ComitTotalAdjustedForecasAmount11+ComitTotalAdjustedForecasAmount12;
        TotalComitTotalUnadjustedForecastAmount=ComitTotalUnadjustedForecastAmount1+ComitTotalUnadjustedForecastAmount2+ComitTotalUnadjustedForecastAmount3+ComitTotalUnadjustedForecastAmount4+ComitTotalUnadjustedForecastAmount5+ComitTotalUnadjustedForecastAmount6+ComitTotalUnadjustedForecastAmount7+ComitTotalUnadjustedForecastAmount8+ComitTotalUnadjustedForecastAmount9+ComitTotalUnadjustedForecastAmount10+ComitTotalUnadjustedForecastAmount11+ComitTotalUnadjustedForecastAmount12;
        String  CommittedRow='<tr><th title="Forecast Category" class=worstRow'+acciD+'  style="background-color:#B4C6E7;border-right-color: white;color:black;size: 10%;font-size: 110%;"><center><b>Commit/Bestcase/Pipeline</b></center><a href="/apex/Fcst_OpenSW?pv='+pVVersionStringId+'&su='+UserI+'&AccId='+AccIdd+'" target="_blank">(Click here to view detailed Forecast)</a></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#B4C6E7;border-right-color: #B4C6E7;"></th></tr>';
        String  TotalAdjustedForecast='<tr ><th title=" Adjusted Forecast" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Adjusted Forecast</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalAdjustedForecasAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( TotalComitTotalAdjustedForecasAmount.setscale(0).format(), args2)+'</th></tr>';   
        String  TotalUnadjustedForecast='<tr ><th title=" Unadjusted Forecast" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Unadjusted Forecast</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( ComitTotalUnadjustedForecastAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( TotalComitTotalUnadjustedForecastAmount.setscale(0).format(), args2)+'</th></tr>';   
       
    
    
    
//*************************************************************************** Committed Opportunity row end*********************************************************
                 




//****************************************************************Above the Funel Opportunity row Start*********************************************************   
         
             
                   
	                   

     if(mapProductIdOppIdVsProductListFunnel.containsKey(acciD)){

                          Decimal AdjustedForecastAmount=0,AdjustedForecast=0,AdjustedForecast1=0,AdjustedForecast2=0,AdjustedForecast3=0,AdjustedForecast4=0,AdjustedForecast5=0,AdjustedForecast6=0,AdjustedForecast7=0,AdjustedForecast8=0,AdjustedForecast9=0,AdjustedForecast10=0,AdjustedForecast11=0,AdjustedForecast12=0;
                          Decimal UnadjustedForecastAmount=0,TotalUnadjustedForecastAmount=0,UnadjustedForecastAmount1=0,UnadjustedForecastAmount2=0,UnadjustedForecastAmount3=0,UnadjustedForecastAmount4=0,UnadjustedForecastAmount5=0,UnadjustedForecastAmount6=0,UnadjustedForecastAmount7=0,UnadjustedForecastAmount8=0,UnadjustedForecastAmount9=0,UnadjustedForecastAmount10=0,UnadjustedForecastAmount11=0,UnadjustedForecastAmount12=0;
                          ID ModelIdd,ModelIdd1,ModelIdd2,ModelIdd3,ModelIdd4,ModelIdd5,ModelIdd6,ModelIdd7,ModelIdd8,ModelIdd9,ModelIdd10,ModelIdd11,ModelIdd12 ;
    
      List<FCST_Product_Model__c> getproductModelList=mapProductIdOppIdVsProductListFunnel.get(acciD);
      for(FCST_Product_Model__c productModelObj:getproductModelList){
          System.debug('productModelObj'+productModelObj);
                                    String fiscalPeriod=productModelObj.Fiscal_Period__r.Name;
                                    String planningP = fiscalPeriod.split('P')[1];
                                    
                                     if(productModelObj.User_Adjusted_Revenue__c!=null && productModelObj.Weighted_Revenue__c!=null){
                                     AdjustedForecastAmount=Math.round(productModelObj.User_Adjusted_Revenue__c);
                                     UnadjustedForecastAmount=Math.round(productModelObj.Weighted_Revenue__c);
                                     }  
                         
                         
                         
                         
        if( planningP=='01' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast1=AdjustedForecastAmount;
                                        UnadjustedForecastAmount1=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount1+=AdjustedForecast1;
                                        FunnelTotalUnAdjustedForecasAmount1+=UnadjustedForecastAmount1;
                                        }
        else if( planningP=='02' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast2=AdjustedForecastAmount;
                                        UnadjustedForecastAmount2=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount2+=AdjustedForecast2;
                                        FunnelTotalUnAdjustedForecasAmount2+=UnadjustedForecastAmount2;
                                     }
        else if( planningP=='03' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast3=AdjustedForecastAmount;
                                        UnadjustedForecastAmount3=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount3+=AdjustedForecast3;
                                        FunnelTotalUnAdjustedForecasAmount3+=UnadjustedForecastAmount3;
                                     }
        else if( planningP=='04' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast4=AdjustedForecastAmount;
                                        UnadjustedForecastAmount4=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount4+=AdjustedForecast4;
                                        FunnelTotalUnAdjustedForecasAmount4+=UnadjustedForecastAmount4;
                                     }
        else if( planningP=='05' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast5=AdjustedForecastAmount;
                                        UnadjustedForecastAmount5=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount5+=AdjustedForecast5;
                                        FunnelTotalUnAdjustedForecasAmount5+=UnadjustedForecastAmount5;
                                     }
        else if( planningP=='06' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast6=AdjustedForecastAmount;
                                        UnadjustedForecastAmount6=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount6+=AdjustedForecast6;
                                        FunnelTotalUnAdjustedForecasAmount6+=UnadjustedForecastAmount6;
                                     }
        else if( planningP=='07' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast7=AdjustedForecastAmount;
                                        UnadjustedForecastAmount7=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount7+=AdjustedForecast7;
                                        FunnelTotalUnAdjustedForecasAmount7+=UnadjustedForecastAmount7;
                                     }
        else if( planningP=='08' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast8=AdjustedForecastAmount;
                                        UnadjustedForecastAmount8=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount8+=AdjustedForecast8;
                                        FunnelTotalUnAdjustedForecasAmount8+=UnadjustedForecastAmount8;
                                     }
        else if( planningP=='09' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast9=AdjustedForecastAmount;
                                        UnadjustedForecastAmount9=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount9+=AdjustedForecast9;
                                        FunnelTotalUnAdjustedForecasAmount9+=UnadjustedForecastAmount9;
                                     }
       else if( planningP=='10' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast10=AdjustedForecastAmount;
                                        UnadjustedForecastAmount10=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount10+=AdjustedForecast10;
                                        FunnelTotalUnAdjustedForecasAmount10+=UnadjustedForecastAmount10;
                                     }
       else if( planningP=='11' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast11=AdjustedForecastAmount;
                                        UnadjustedForecastAmount11=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount11+=AdjustedForecast11;
                                        FunnelTotalUnAdjustedForecasAmount11+=UnadjustedForecastAmount11;
                                     }
       else if( planningP=='12' && productModelObj.Planning_Version__r.Name==strPlanningVersion){
                                        AdjustedForecast12=AdjustedForecastAmount;
                                        UnadjustedForecastAmount12=UnadjustedForecastAmount;
                                        FunnelTotalAdjustedForecasAmount12+=AdjustedForecast12;
                                        FunnelTotalUnAdjustedForecasAmount12+=UnadjustedForecastAmount12;
                                     }
                                     }//itrretion closed
                                     
                     }   //mapProductIdOppIdVsProductList closed
           
        
       
       
       
       
       
        TotalFunnelTotalUnAdjustedForecasAmount=FunnelTotalUnAdjustedForecasAmount1+FunnelTotalUnAdjustedForecasAmount2+FunnelTotalUnAdjustedForecasAmount3+FunnelTotalUnAdjustedForecasAmount4+FunnelTotalUnAdjustedForecasAmount5+FunnelTotalUnAdjustedForecasAmount6+FunnelTotalUnAdjustedForecasAmount7+FunnelTotalUnAdjustedForecasAmount8+FunnelTotalUnAdjustedForecasAmount9+FunnelTotalUnAdjustedForecasAmount10+FunnelTotalUnAdjustedForecasAmount11+FunnelTotalUnAdjustedForecasAmount12;
        TotalFunnelTotalAdjustedForecasAmount=FunnelTotalAdjustedForecasAmount1+FunnelTotalAdjustedForecasAmount2+FunnelTotalAdjustedForecasAmount3+FunnelTotalAdjustedForecasAmount4+FunnelTotalAdjustedForecasAmount5+FunnelTotalAdjustedForecasAmount6+FunnelTotalAdjustedForecasAmount7+FunnelTotalAdjustedForecasAmount8+FunnelTotalAdjustedForecasAmount9+FunnelTotalAdjustedForecasAmount10+FunnelTotalAdjustedForecasAmount11+FunnelTotalAdjustedForecasAmount12;
        String  AboveTheFunelRow='<tr><th title="Forecast Category" class=worstRow'+acciD+'  style="background-color:#D9E1F2;color:black;size: 10%;font-size: 110%;"><b><center>Above the Funnel</center></b><a href="/apex/Fcst_funnelSW?pv='+pVVersionStringId+'&su='+UserI+'&AccId='+AccIdd+'" target="_blank">(Click here to view detailed Forecast)</a></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th></tr>';
        String  TotalAdjustedFunnel='<tr ><th title="Adjusted Forecast" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Adjusted Forecast</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalAdjustedForecasAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( TotalFunnelTotalAdjustedForecasAmount.setscale(0).format(), args2)+'</th></tr>';   
        String  TotalUnAdjustedFunnel='<tr ><th title="Unadjusted Forecast" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Unadjusted Forecast</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( FunnelTotalUnAdjustedForecasAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( TotalFunnelTotalUnAdjustedForecasAmount.setscale(0).format(), args2)+'</th></tr>';   
       
       String RenewalFinal = FCST_RenewalsUtil.RenewalsSum(args2,AccIdd,UserI,pVVersionStringId,strPlanningVersion,pagSet,mapProductIdOppIdVsProductListRenewal);
         System.debug('RenewalFinal'+RenewalFinal);
//**************************************************************** Above the Funel Opportunity row end*************************************************





                 

           AccFinalactualAmount1=AccLevelWonActual1+AccLevelactualAmount1; AccFinalactualAmount2=AccLevelWonActual2+AccLevelactualAmount2;AccFinalactualAmount3=AccLevelWonActual3+AccLevelactualAmount3;AccFinalactualAmount4=AccLevelWonActual4+AccLevelactualAmount4;AccFinalactualAmount5=AccLevelWonActual5+AccLevelactualAmount5;AccFinalactualAmount6=AccLevelWonActual6+AccLevelactualAmount6;AccFinalactualAmount7=AccLevelWonActual7+AccLevelactualAmount7;AccFinalactualAmount8=AccLevelWonActual8+AccLevelactualAmount8;AccFinalactualAmount9=AccLevelWonActual9+AccLevelactualAmount9;AccFinalactualAmount10=AccLevelWonActual10+AccLevelactualAmount10;AccFinalactualAmount11=AccLevelWonActual11+AccLevelactualAmount11;AccFinalactualAmount12=AccLevelWonActual12+AccLevelactualAmount12;
           totalFinalactualAmount=AccFinalactualAmount1+AccFinalactualAmount2+AccFinalactualAmount3+AccFinalactualAmount4+AccFinalactualAmount5+AccFinalactualAmount6+AccFinalactualAmount7+AccFinalactualAmount8+AccFinalactualAmount9+AccFinalactualAmount10+AccFinalactualAmount11+AccFinalactualAmount12;
          
           Decimal totalFinalMMAmount=0,AccFinalMMAmount1=0,AccFinalMMAmount2=0,AccFinalMMAmount3=0,AccFinalMMAmount4=0,AccFinalMMAmount5=0,AccFinalMMAmount6=0,AccFinalMMAmount7=0,AccFinalMMAmount8=0,AccFinalMMAmount9=0,AccFinalMMAmount10=0,AccFinalMMAmount11=0,AccFinalMMAmount12=0;
           AccFinalMMAmount1=ClosedMAmount1+ConLevelMAmount1;AccFinalMMAmount2=ClosedMAmount2+ConLevelMAmount2;AccFinalMMAmount3=ClosedMAmount3+ConLevelMAmount3;AccFinalMMAmount4=ClosedMAmount4+ConLevelMAmount4;AccFinalMMAmount5=ClosedMAmount5+ConLevelMAmount5;AccFinalMMAmount6=ClosedMAmount6+ConLevelMAmount6;AccFinalMMAmount7=ClosedMAmount7+ConLevelMAmount7;AccFinalMMAmount8=ClosedMAmount8+ConLevelMAmount8;AccFinalMMAmount9=ClosedMAmount9+ConLevelMAmount9;AccFinalMMAmount10=ClosedMAmount10+ConLevelMAmount10;AccFinalMMAmount11=ClosedMAmount11+ConLevelMAmount11;AccFinalMMAmount12=ClosedMAmount12+ConLevelMAmount12;
           totalFinalMMAmount=AccFinalMMAmount1+AccFinalMMAmount2+AccFinalMMAmount3+AccFinalMMAmount4+AccFinalMMAmount5+AccFinalMMAmount6+AccFinalMMAmount7+AccFinalMMAmount8+AccFinalMMAmount9+AccFinalMMAmount10+AccFinalMMAmount11+AccFinalMMAmount12;
          
           Decimal totalFinalFwithRisk=0,AccFinalFwithRisk1=0,AccFinalFwithRisk2=0,AccFinalFwithRisk3=0,AccFinalFwithRisk4=0,AccFinalFwithRisk5=0,AccFinalFwithRisk6=0,AccFinalFwithRisk7=0,AccFinalFwithRisk8=0,AccFinalFwithRisk9=0,AccFinalFwithRisk10=0,AccFinalFwithRisk11=0,AccFinalFwithRisk12=0;
           AccFinalFwithRisk1=ClosedFwithRisk1+ConForecastwithRisk1;AccFinalFwithRisk2=ClosedFwithRisk2+ConForecastwithRisk2;AccFinalFwithRisk3=ClosedFwithRisk3+ConForecastwithRisk3;AccFinalFwithRisk4=ClosedFwithRisk4+ConForecastwithRisk4;AccFinalFwithRisk5=ClosedFwithRisk5+ConForecastwithRisk5;AccFinalFwithRisk6=ClosedFwithRisk6+ConForecastwithRisk6;AccFinalFwithRisk7=ClosedFwithRisk7+ConForecastwithRisk7;AccFinalFwithRisk8=ClosedFwithRisk8+ConForecastwithRisk8;AccFinalFwithRisk9=ClosedFwithRisk9+ConForecastwithRisk9;AccFinalFwithRisk10=ClosedFwithRisk10+ConForecastwithRisk10;AccFinalFwithRisk11=ClosedFwithRisk11+ConForecastwithRisk11;AccFinalFwithRisk12=ClosedFwithRisk12+ConForecastwithRisk12;
           totalFinalFwithRisk=AccFinalFwithRisk1+AccFinalFwithRisk2+AccFinalFwithRisk3+AccFinalFwithRisk4+AccFinalFwithRisk5+AccFinalFwithRisk6+AccFinalFwithRisk7+AccFinalFwithRisk8+AccFinalFwithRisk9+AccFinalFwithRisk10+AccFinalFwithRisk11+AccFinalFwithRisk12;
          
           Decimal totalAccLevelAdjested=0,AccLevelAdjested1=0,AccLevelAdjested2=0,AccLevelAdjested3=0,AccLevelAdjested4=0,AccLevelAdjested5=0,AccLevelAdjested6=0,AccLevelAdjested7=0,AccLevelAdjested8=0,AccLevelAdjested9=0,AccLevelAdjested10=0,AccLevelAdjested11=0,AccLevelAdjested12=0;
           AccLevelAdjested1=FunnelTotalAdjustedForecasAmount1+ComitTotalAdjustedForecasAmount1;AccLevelAdjested2=FunnelTotalAdjustedForecasAmount2+ComitTotalAdjustedForecasAmount2;AccLevelAdjested3=FunnelTotalAdjustedForecasAmount3+ComitTotalAdjustedForecasAmount3;AccLevelAdjested4=FunnelTotalAdjustedForecasAmount4+ComitTotalAdjustedForecasAmount4;AccLevelAdjested5=FunnelTotalAdjustedForecasAmount5+ComitTotalAdjustedForecasAmount5;AccLevelAdjested6=FunnelTotalAdjustedForecasAmount6+ComitTotalAdjustedForecasAmount6;AccLevelAdjested7=FunnelTotalAdjustedForecasAmount7+ComitTotalAdjustedForecasAmount7;AccLevelAdjested8=FunnelTotalAdjustedForecasAmount8+ComitTotalAdjustedForecasAmount8;AccLevelAdjested9=FunnelTotalAdjustedForecasAmount9+ComitTotalAdjustedForecasAmount9;AccLevelAdjested10=FunnelTotalAdjustedForecasAmount10+ComitTotalAdjustedForecasAmount10;AccLevelAdjested11=FunnelTotalAdjustedForecasAmount11+ComitTotalAdjustedForecasAmount11;AccLevelAdjested12=FunnelTotalAdjustedForecasAmount12+ComitTotalAdjustedForecasAmount12;
           totalAccLevelAdjested=AccLevelAdjested1+AccLevelAdjested2+AccLevelAdjested3+AccLevelAdjested4+AccLevelAdjested5+AccLevelAdjested6+AccLevelAdjested7+AccLevelAdjested8+AccLevelAdjested9+AccLevelAdjested10+AccLevelAdjested11+AccLevelAdjested12;
           
           Decimal totalAccLevelUnAdjested=0,AccLevelUnAdjested1=0,AccLevelUnAdjested2=0,AccLevelUnAdjested3=0,AccLevelUnAdjested4=0,AccLevelUnAdjested5=0,AccLevelUnAdjested6=0,AccLevelUnAdjested7=0,AccLevelUnAdjested8=0,AccLevelUnAdjested9=0,AccLevelUnAdjested10=0,AccLevelUnAdjested11=0,AccLevelUnAdjested12=0;
           AccLevelUnAdjested1=FunnelTotalUnAdjustedForecasAmount1+ComitTotalUnadjustedForecastAmount1;AccLevelUnAdjested2=FunnelTotalUnAdjustedForecasAmount2+ComitTotalUnadjustedForecastAmount2;AccLevelUnAdjested3=FunnelTotalUnAdjustedForecasAmount3+ComitTotalUnadjustedForecastAmount3;AccLevelUnAdjested4=FunnelTotalUnAdjustedForecasAmount4+ComitTotalUnadjustedForecastAmount4;AccLevelUnAdjested5=FunnelTotalUnAdjustedForecasAmount5+ComitTotalUnadjustedForecastAmount5;AccLevelUnAdjested6=FunnelTotalUnAdjustedForecasAmount6+ComitTotalUnadjustedForecastAmount6;AccLevelUnAdjested7=FunnelTotalUnAdjustedForecasAmount7+ComitTotalUnadjustedForecastAmount7;AccLevelUnAdjested8=FunnelTotalUnAdjustedForecasAmount8+ComitTotalUnadjustedForecastAmount8;AccLevelUnAdjested9=FunnelTotalUnAdjustedForecasAmount9+ComitTotalUnadjustedForecastAmount9;AccLevelUnAdjested10=FunnelTotalUnAdjustedForecasAmount10+ComitTotalUnadjustedForecastAmount10;AccLevelUnAdjested11=FunnelTotalUnAdjustedForecasAmount11+ComitTotalUnadjustedForecastAmount11;AccLevelUnAdjested12=FunnelTotalUnAdjustedForecasAmount12+ComitTotalUnadjustedForecastAmount12;
           totalAccLevelUnAdjested=AccLevelUnAdjested1+AccLevelUnAdjested2+AccLevelUnAdjested3+AccLevelUnAdjested4+AccLevelUnAdjested5+AccLevelUnAdjested6+AccLevelUnAdjested7+AccLevelUnAdjested8+AccLevelUnAdjested9+AccLevelUnAdjested10+AccLevelUnAdjested11+AccLevelUnAdjested12;
                   String  AccountFinalName = AccountName.get(acciD);
                            
                            if(AccountFinalName.length()>25){
                                AccountFinalName = AccountFinalName.substring(0,25)+'...';
                            }
           
           String accountRow='<tr style="background-color:#F2F2F2;"><th style="background-color:#F2F2F2;size: 10%;text-align: center;"><b><a title='+AccountName.get(acciD)+' style="color:black; target="_blank"  href="/'+acciD+'" target="_blank">'+AccountFinalName+'</a></b><th style="background-color:#F2F2F2;size: 10%;"></th> </th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;font-weight: bold;"></th><th style="text-align: center;font-weight: bold;background-color:#F2F2F2;border-right-color: #F2F2F2;Color:#F2F2F2;"></th></tr>';  
           //String  TotallforcastWithRisk='<tr><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;border-right-color: #D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(totalFinalFwithRisk.setscale(0).format(), args2)+'</th></tr>';  
                 String RR1,RR2,RR3,RR4,RR5,RR6,RR7,RR8,RR9,RR10,RR11,RR12,RR13;
                        String  TotallforcastWithRisk='<tr><th title="Forecast with Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast with Risk</th>';
                        if(AccFinalFwithRisk1<0){
                        RR1='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk1*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR1='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk1.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         
                         
                         if(AccFinalFwithRisk2<0){
                        RR2='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk2*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR2='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk2.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk3<0){
                        RR3='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk3*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR3='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk3.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk4<0){
                        RR4='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk4*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                       RR4='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk4.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk5<0){
                        RR5='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk5*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR5='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk5.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk6<0){
                        RR6='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk6*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR6='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk6.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(AccFinalFwithRisk7<0){
                        RR7='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk7*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR7='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk7.setscale(0).format(), args2)+'</th>';
                         }
                         
                         
                         if(AccFinalFwithRisk8<0){
                        RR8='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk8*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR8='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk8.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk9<0){
                        RR9='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk9*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR9='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk9.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk10<0){
                        RR10='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk10*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR10='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk10.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk11<0){
                        RR11='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk11*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR11='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk11.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(AccFinalFwithRisk12<0){
                        RR12='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalFwithRisk12*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR12='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalFwithRisk12.setscale(0).format(), args2)+'</th>';
                         }
                         
                         if(totalFinalFwithRisk<0){
                        RR13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$ ('+String.format((totalFinalFwithRisk*-1).setscale(0).format(), args2)+')'+'</th>';
                         } else{
                        RR13='<th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(totalFinalFwithRisk.setscale(0).format(), args2)+'</th>';
                         }
                         
                         TotallforcastWithRisk+=RR1+RR2+RR3+RR4+RR5+RR6+RR7+RR8+RR9+RR10+RR11+RR12+RR13;            
           
           //String  TotallforWithoutRisk='<tr></th><th title="Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast without Risk</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format(totalFinalMMAmount.setscale(0).format(), args2)+'</th></tr>';  
         String D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13;
           
           String  TotallforWithoutRisk='<tr></th><th title="Forecast without Risk" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Forecast without Risk</th>';
           
           if(AccFinalMMAmount1<0){
           D1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D1='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(AccFinalMMAmount2<0){
           D2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D2='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(AccFinalMMAmount3<0){
           D3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D3='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount4<0){
           D4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D4='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount5<0){
           D5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D5='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(AccFinalMMAmount6<0){
           D6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D6='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(AccFinalMMAmount7<0){
           D7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D7='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount8<0){
           D8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D8='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount9<0){
           D9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D9='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount10<0){
           D10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D10='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount11<0){
           D11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D11='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalMMAmount12<0){
           D12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((AccFinalMMAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D12='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(AccFinalMMAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(totalFinalMMAmount<0){
           D13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$ ('+String.format((totalFinalMMAmount*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           D13='<th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format(totalFinalMMAmount.setscale(0).format(), args2)+'</th>';
           }


        TotallforWithoutRisk+=D1+D2+D3+D4+D5+D6+D7+D8+D9+D10+D11+D12+D13;           
          
          
          // String  ActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalFinalactualAmount.setscale(0).format(), args2)+'</th></tr>';   
         String TM1,TM2,TM3,TM4,TM5,TM6,TM7,TM8,TM9,TM10,TM11,TM12,TM13;
           
          String  ActualAmount='<tr><th  title="Actual Amount" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Actual Amount</th>';
           
           if(AccFinalactualAmount1<0){
           TM1='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount1*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM1='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount1.setscale(0).format(), args2)+'</th>';
           }
           
           
           if(AccFinalactualAmount2<0){
           TM2='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount2*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM2='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount2.setscale(0).format(), args2)+'</th>';
           }
           
           
            if(AccFinalactualAmount3<0){
           TM3='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount3*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM3='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount3.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount4<0){
           TM4='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount4*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM4='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount4.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount5<0){
           TM5='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount5*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM5='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount5.setscale(0).format(), args2)+'</th>';
           }


           if(AccFinalactualAmount6<0){
           TM6='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount6*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM6='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount6.setscale(0).format(), args2)+'</th>';
           }


           if(AccFinalactualAmount7<0){
           TM7='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount7*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM7='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount7.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount8<0){
           TM8='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount8*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          TM8='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount8.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount9<0){
           TM9='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount9*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM9='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount9.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount10<0){
           TM10='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount10*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM10='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount10.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount11<0){
           TM11='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount11*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM11='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount11.setscale(0).format(), args2)+'</th>';
           }



           if(AccFinalactualAmount12<0){
           TM12='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((AccFinalactualAmount12*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
          TM12='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccFinalactualAmount12.setscale(0).format(), args2)+'</th>';
           }


           if(totalFinalactualAmount<0){
           TM13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$ ('+String.format((totalFinalactualAmount*-1).setscale(0).format(), args2)+')'+'</th>';
           
           } else{
           
           TM13='<th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(totalFinalactualAmount.setscale(0).format(), args2)+'</th>';
           }


        ActualAmount+=TM1+TM2+TM3+TM4+TM5+TM6+TM7+TM8+TM9+TM10+TM11+TM12+TM13;           
          
           String OpenCatRow='<tr style="background-color:#313A8B;"><th style="background-color:#313A8B;color: white;size: 10%;text-align: center;" colspan="14"><b>Closed Opportunities</b></th></tr>';
           String  BaseLineRow='<tr><th title="Forecast Category" class=worstRow'+acciD+'  style="background-color:#FFE699;color:black;size: 10%;font-size: 110%;"><b><center>Baseline Amount</center></b><a href="/apex/FCST_CompucomBaseLineWorkbenchC?pv='+pVVersionStringId+'&su='+UserI+'&AccId='+AccIdd+'" target="_blank">(Click here to view detailed Forecast)</a></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#FFE699;border-right-color: #FFE699;"></th></tr>';
           String  AdjustedForecastOPEN='<tr><th  title="Adjusted Forecast - OPEN" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Adjusted Forecast - OPEN</th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelAdjested12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalAccLevelAdjested.setscale(0).format(), args2)+'</th></tr>';   
           String  unAdjustedForecastOPEN='<tr><th  title="Unadjusted Forecast - OPEN" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">Unadjusted Forecast - OPEN</th><th style="background-color:#D0CECE;text-align: center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;"class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align:center;" class=BaseloneCon'+acciD+'>$'+String.format(AccLevelUnAdjested12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=BaseloneCon'+acciD+'>$'+String.format(totalAccLevelUnAdjested.setscale(0).format(), args2)+'</th></tr>';   

       
    
    
       
       
         tableBody+=accountRow+ActualAmount+TotallforWithoutRisk+TotallforcastWithRisk+unAdjustedForecastOPEN+AdjustedForecastOPEN+OpenCatRow+BaseLineRow+ActuallAmount+TotalforWithouttRisk+TotalforcasttWithRisk+ClosedWonRow+ClosedWonActualAmount+WonWithouttRisk+WonforcasttWithRisk+RenewalFinal+CommittedRow+TotalUnadjustedForecast+TotalAdjustedForecast+AboveTheFunelRow+TotalUnAdjustedFunnel+TotalAdjustedFunnel;    
         
         }  
    
     
        
        
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
        PageReference pg = new Pagereference('/apex/FCST_Landing_UI?pv='+pVVersionStringId+'&su='+UserStringId+'&AccId='+AccountN);
        pg.setredirect(true);
        return pg;
    }
        
   
}