@isTest
public class test_fcst_landing_ui_controller {
    static testMethod void getUIData(){
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        List<User> usrId = new List<User>();
       // user loginUser = FCST_Util.createUser();        
        user loginUser = [select id,UserRoleId from user where id=:userinfo.getUserId()];
        usrId.add(loginUser);
        System.runAs(loginUser) {
             FCST_UTIL.InsertTriggerMappingFields();
        Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c',
                                                         	  Fcst_BusinessUnit__c='fcst_revenue_types__c');
            insert setting;
            document  document = new Document();
            document.Body = Blob.valueOf('Some Text');
            document.ContentType = 'application/pdf';
            document.DeveloperName = 'my_document';
            document.IsPublic = true;
            document.Name = 'Revenue Navigator User Guide V1.0';
            document.FolderId = [select id from folder][0].id;
            insert document;
            
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            
            UserRole ur = new UserRole(Name = 'CEO',ParentRoleId = loginUser.UserRoleId);
            insert ur;         
            FCST_RoleHierarchySetUp.getHierarchycalUserList();
            FCST_RoleHierarchySetUp.getRoleHierarchy(loginUser.UserRoleId);
            List<Id> userId = new List<Id>();
            set<id> setroleids= new set<id>();
            user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
            user uRoleId=[select id,UserRoleId from user where id=:userinfo.getUserId()];
            setroleids.add(uRoleId.Id);
            userId.add(u.Id);
            Id urRolesId = u.Id;
            userrole urole=[select id,parentRoleId from userrole where id=:u.userroleid];
            
                
            List<Fiscal_Year_Planning__c> fypList = new List<Fiscal_Year_Planning__c>();
            for(Integer i=0;i<20;i++){
                Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(name='2019',EndDate__c=fendDate,StartDate__c=fstartDate);
                fypList.add(fyp);
            }        
            insert fypList;
            List<Opportunity> oppList = new List<Opportunity>();
            
            Planning_Version__c plvr = new Planning_Version__c();
            plvr.Name = '2019';
            plvr.Is_this_a_Budget_Planning_Version__c = false;
            plvr.Is_this_a_Gap_Planning_Version__c = false;
            plvr.Version_Status__c = 'In Progress';
            plvr.Planning_Version_Fiscal_Year__c = '2019';
            insert plvr;
            
            user u1=[select id from user where id=:userinfo.getUserId()];
            
            List<Account> accList = new List<Account>();
            for(Integer i=0;i<10;i++){
                Account act = new Account();
                act.Name = 'TestAccount';
                act.FCST_CPM_Region__c = 'US-DC Area';
                act.FCST_Program_Manager__c=u1.id;
                
                accList.add(act);
            }
            if(accList!=null && accList.size()>0)
                insert accList;
          
            Date myDate = date.newInstance(2018,05,22);
            
            for(Account acc :accList){
                for(Integer i=1;i<2;i++){
                    Opportunity opp = new Opportunity();
                    opp.Name='Test Opportunity'+i;opp.OwnerId=loginUser.id;opp.Submitted_for_Planning_Version__c = null; opp.AccountID=accList[0].Id; opp.stageName = 'Prospecting';opp.Reason__c='Government Timing'; opp.CloseDate=myDate;opp.ForecastCategoryName='Pipeline';
                    oppList.add(opp);
                }
            }
            if(oppList!=null && oppList.size()>0)
                insert oppList;
            oppList[0].ApprovalStatus__c = 'Reject';
            update oppList[0];
            
           List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            for(Integer i=0;i<5;i++){
            Fiscal_Year_Model__c fyp2 = new Fiscal_Year_Model__c();
            fyp2.name='FY2019P08';
            fyp2.Fiscal_Quarter__c='Q3';
            fymList.add(fyp2);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }

            Opportunity opt = new Opportunity(AccountId = accList[0].Id,Amount = 20000,Name = 'Test Oppt',StageName = 'Lead (Above the Funnel)',
                                              CloseDate = System.today());
            insert opt; 
            
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(Name = 'Hardware',IsActive = true,ProductCode='1.0');
            insert prod;
            
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            );
            insert pbEntry;
            
            List<OpportunityLineItem> lstInsertOpp = new List<OpportunityLineItem>();
            OpportunityLineItem oli = new OpportunityLineItem( ServiceDate = fstartDate,Product2=prod,OpportunityId = opt.Id,Quantity = 5,PricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
            OpportunityLineItem oli1 = new OpportunityLineItem( ServiceDate = fstartDate,Product2=prod,OpportunityId = opt.Id,Quantity = 5,PricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
            
            lstInsertOpp.add(oli);
            lstInsertOpp.add(oli1);
            insert lstInsertOpp;
            
            FCST_Contract__c contr =new FCST_Contract__c();
            contr.Fcst_Account__c = accList[0].Id;
            contr.Contract_Owner__c = loginUser.Id;
            insert contr;
            
             Fiscal_Year_Model__c fypl= new Fiscal_Year_Model__c(name='FY2019P07',Fiscal_Quarter__c='Q1');
            insert fypl;
            /*Fiscal_Year_Model__c fypp1= new Fiscal_Year_Model__c(name='FY2019P01',Fiscal_Quarter__c='Q2');
            insert fypp1;
            Fiscal_Year_Model__c fypp2= new Fiscal_Year_Model__c(name='FY2019P02',Fiscal_Quarter__c='Q3');
            insert fypp2;
            Fiscal_Year_Model__c fypp3= new Fiscal_Year_Model__c(name='FY2019P03',Fiscal_Quarter__c='Q4');
            insert fypp3;
            Fiscal_Year_Model__c fypp4= new Fiscal_Year_Model__c(name='FY2019P04',Fiscal_Quarter__c='Q5');
            insert fypp4;*/
            
            FCST_Opportunity_Initial_Forecast__c opif = new 
                FCST_Opportunity_Initial_Forecast__c(Fcst_Weighted_Revenue__c=25000,User_Adjusted_Revenue__c=1000,
                                                               Fcst_Opportunity__c=oppList[0].Id,Fcst_Fiscal_Period__c=fypl.id,
                                                               FCST_Planning_Version__c=plvr.id);
            insert opif;
            
            FCST_Opportunity_Initial_Forecast__c opif2 = new 
                FCST_Opportunity_Initial_Forecast__c(Fcst_Opportunity__c=oppList[0].Id,Fcst_Fiscal_Period__c=fypl.id,
                                                               FCST_Planning_Version__c=plvr.id);
            insert opif2;
            
            
            PageReference pgf = Page.FCST_Landing_UI;
            Test.setCurrentPage(pgf);
            
            pgf.getparameters().put('SUId',String.valueOf(loginUser.Id));
            
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = accList[0].Id;
            prdModel.Account_CPM_Region__c = 'fcst_cpm_region__c';
            prdModel.Opportunity__c = opt.Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c = plvr.Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdModel.Fiscal_Period__c = fymList[0].id;
            prdModel.Planning_Version__c = plvr.id;
            prdModel.FCST_Revenue_Types__c = 'Project';
            insert prdModel;  
            
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = loginUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Fcst_Account__c=accList[0].Id;
            contracts.Opportunity__c = oppList[0].Id;
            contracts.FCST_Contract_Created_Year__c = '2020';
            insert contracts;
            
            FCST_Contract__c contracts1 = new FCST_Contract__c();
            contracts1.Contract__c = 'TestData 2';
            contracts1.Contract_Owner__c = loginUser.Id;
            contracts1.FCST_Q__c = 'Q000-035';
            contracts1.Contract_Description__c = 'Demo45';
            contracts1.Fcst_Account__c=accList[0].Id;
            contracts1.Opportunity__c = oppList[0].Id;
            contracts1.FCST_Contract_Created_Year__c = '2018';
            insert contracts1;
            
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts1.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.Fcst_Revenue_Type__c = 'fcst_type__c';
            insert cli;
            
            /* Contract_LineItem__c cli1 = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.Fcst_Revenue_Type__c = 'fcst_type__c';
            insert cli1;*/
            
            Actual_Model__c actModel = new Actual_Model__c();
            actModel.Actual_Amount__c = 20000;
            actModel.Account__c = accList[0].Id;
            actModel.Fiscal_Period__c = fymList[0].Id;
            actModel.FCST_Planning_Version__c = plvr.Id;
            actModel.Revenue_Type__c = 'fcst_type__c';
            actModel.Contract_LineItem__c = cli.Id;
            actModel.Fiscal_Year__c = fypList[0].Id;
            insert actModel;
            
            FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.Account__c = accList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Planning_Version__c = plvr.Id;
            intFCST.FCST_Contract__c = contracts1.Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Risk_Factor__c=1;
           // intFCST.FCST_Baseline_Created_Year__c ='2017';
            insert intFCST;   
            
         /*    FCST_Initial_Forecast__c intFcst1 = new FCST_Initial_Forecast__c();// for closed won
            intFcst1.Name = 'TestInt';
            intFcst1.Fcst_Amount__c = 20000;
            intFcst1.Account__c = accList[0].Id;
            intFcst1.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFcst1.Planning_Version__c = plvr.Id;
            intFcst1.FCST_Contract__c = contracts.Id;
            intFcst1.Contract_LineItem__c = cli1.Id;
            intFcst1.Risk_Factor__c=1;
           // intFCST.FCST_Baseline_Created_Year__c ='2017';
            insert intFcst1; */
            
        
            
            Test.startTest();
            List<String> quarters = new List<String>{'Q1'};
            
FCST_Landing_UI_Controller fluc = new FCST_Landing_UI_Controller();
            List<String> strList = new List<String>();
            strList.add('2018-Q1');strList.add('2018-Q2');strList.add('2018-Q3');strList.add('2018-Q4');
             strList.add('2019-Q1');strList.add('2019-Q2');strList.add('2019-Q3');strList.add('2019-Q4');
            fluc.getFYPeriodFromQuarter(strList);
            fluc.RevenueTypeLabelName = 'fcst_revenue_type__c';
            fluc.BusinessUnitLabelName = 'business_unit__c';
            fluc.cpmRegionLabelName = 'fcst_cpm_region__c';
            fluc.PMTypeLabelName = 'fcst_program_manager__c';            
            fluc.s_FilterUser = 'TestStr';
            fluc.revenue_String = 'fcst_type__c';
            fluc.business_String = 'TestData';
            fluc.RevenueName = 'fcstType';
            fluc.s_filterQuarter = quarters;
            fluc.BusinessUnitName = 'BusinessStr';
            fluc.cpmRegion_String = 'fcst_cpm_region__c';
            fluc.User_String = String.valueOf(loginUser.Id);
            fluc.S_FilterPlanningVersion ='2019';
            fluc.getFiscalYearFromQuarter(new List<string>{'2019'});
            fluc.getQuarterFromQuarter(new List<string>{'FY2019P01'});
            FCST_Landing_UI_Controller.get15DigitId('');
            
            fluc.Initialization();
            fluc.onChangeYear();
            fluc.getUserRole();
            fluc.gotohomepage();
            fluc.getUserRole();
            fluc.getRoleUsers(new list<user>{loginUser});
            fluc.onReportLoad();
         	 fluc.getRevenueType();
            fluc.getCPMRegionType();
           // fluc.SelectedUserDetail();
            fluc.getHierarchycalUsers(loginUser);
            fluc.getPicklistValues('Account','Industry');
            fluc.onChangeRole();
            fluc.getRoleRoles(usrId);
            fluc.RolesParentString('TestStr',ur.Id);
            fluc.getImageSRC('Test1','Test2');
            //fluc.getAllSubRoleIds(setroleids);
            //fluc.fiscalPeriod();
            fluc.s_FilterPlanningYear = '2018';
            Fcst_Rev_Rec_Revenue_Type__c p = new Fcst_Rev_Rec_Revenue_Type__c(name='Project',Fcst_12_Month_Duration__c=true);
            insert p;
            
            List<FCST_Landing_UI_Controller.wrapperSUAccountDetail> fccList = new List<FCST_Landing_UI_Controller.wrapperSUAccountDetail>();
            FCST_Landing_UI_Controller.wrapperSUAccountDetail fcc = new FCST_Landing_UI_Controller.wrapperSUAccountDetail(accList[0],true,'testAcc',29999,29999,29999,29999,29999,29999,29999,29999,2999);
            
            fccList.add(fcc);
            FCST_Landing_UI_Controller.wrapperSURevenueType wrp = new FCST_Landing_UI_Controller.wrapperSURevenueType('Test',fccList);
            Test.stopTest();
            
        }
    }
    static testMethod void getUIData1(){
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        List<User> usrId = new List<User>();
        user loginUser = FCST_Util.createUser();        
        usrId.add(loginUser);
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        UserRole ur = new UserRole(Name = 'CEO');
        String uniqueName = orgId + dateString + randomInt;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
        insert u;
        
        System.runAs(u) {
             FCST_UTIL.InsertTriggerMappingFields();
        Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='fcst_geo_code_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
            User usr = [select Id,UserRoleId from User where id=: userInfo.getUserId()];
            FCST_RoleHierarchySetUp.getHierarchycalUserList();
            FCST_RoleHierarchySetUp.getRoleHierarchy(usr.UserRoleId);
            List<Planning_Version__c> plvList = new List<Planning_Version__c>();
            for(Integer i=0;i<20;i++){
                Planning_Version__c plv = new Planning_Version__c(Name  = '2019'+i);
                plvList.add(plv);    
            }
            insert plvList;
            
            List<Fiscal_Year_Planning__c> ftpList = new List<Fiscal_Year_Planning__c>();
            for(Integer i=0;i<20;i++){
                Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(name='2019',EndDate__c=System.today()+2,StartDate__c=System.today());
                ftpList.add(fyp);
            }        
            insert ftpList;
            List<Opportunity> oppList = new List<Opportunity>();
            List<Account> accList = new List<Account>();
            for(Integer i=0;i<4;i++){
                Account acc = new Account(Name='Test Account');
                accList.add(acc);
            }
            if(accList!=null && accList.size()>0)
                insert accList;
            
            Planning_Version__c plvr = new Planning_Version__c();
            plvr.Name = '2019';
            plvr.Is_this_a_Budget_Planning_Version__c = false;
            plvr.Is_this_a_Gap_Planning_Version__c = false;
            plvr.Version_Status__c = 'In Progress';
            plvr.Planning_Version_Fiscal_Year__c = '2019';
            insert plvr;
            
            Account ac = new Account();
            ac.Name = 'Test Account';
            insert ac;
            Planning_Version__c pv= new Planning_Version__c(name='2019'); insert pv;
            
            Fiscal_Year_Model__c fypl= new Fiscal_Year_Model__c(name='FY2019P01',Fiscal_Quarter__c='Q1');
            insert fypl;
            Opportunity opt = new Opportunity();
            opt.AccountId = ac.Id;
            opt.Amount = 20000;
            opt.Name = 'Test Oppt';
            opt.StageName = 'Closed Won';
            opt.CloseDate = System.today();
            insert opt; 
            
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true
            );
            insert prod;
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            );
            insert pbEntry;
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opt.Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id
                
            );
            oli.TotalPrice = oli.quantity * pbEntry.UnitPrice;
            oli.Risk_Factor__c = 0;
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = ac.Id;
            prdModel.Opportunity__c = opt.Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c = plvList[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdmodel.Fiscal_Period__c = fypl.id;
            prdmodel.Planning_Version__c = plvr.id;
            insert prdModel;  
            Set<Id> setIds = new Set<Id>();
            List<String> strList = new List<String>{'Quarter1','Quarter2'};            
                
                Test.startTest();
            
            
FCST_Landing_UI_Controller fluc = new FCST_Landing_UI_Controller();
            fluc.cpmRegion_String = 'fcst_cpm_region__c';
            fluc.revenue_String = 'fcst_type_c';
            fluc.User_String = 'TestStr';
            fluc.getQuarterFromQuarter(new List<string>{'20'});
            fluc.gotohomepage();
           // fluc.getCPMRegionType();
           // fluc.SelectedUserDetail();
            //fluc.onReportLoad();
            fluc.getHierarchycalUsers(u);
            fluc.getFiscalYearFromQuarter(strList);
            fluc.getRoleUsers(usrId );
            fluc.s_FilterPlanningYear = '2018';
            fluc.getAllSubRoleIds(setIds);
            
            FCST_Landing_UI_Controller.wrapperSUAccountDetail fcc = new FCST_Landing_UI_Controller.wrapperSUAccountDetail(ac,true,'Test',29999,29999,29999,29999,29999,29999,29999,29999,2999);
            
            Test.stopTest();
        }
    }
    
    
    static testMethod void getUIDataContV1(){
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        List<User> usrId = new List<User>();
        user loginUser = FCST_Util.createUser();        
        usrId.add(loginUser);
        System.runAs(loginUser) {
             FCST_UTIL.InsertTriggerMappingFields();
        Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',
                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c',
                                                         		Fcst_BusinessUnit__c='fcst_revenue_types__c');
            insert setting;
            document  document = new Document();
            document.Body = Blob.valueOf('Some Text');
            document.ContentType = 'application/pdf';
            document.DeveloperName = 'my_document';
            document.IsPublic = true;
            document.Name = 'Revenue Navigator User Guide V1.0';
            document.FolderId = [select id from folder][0].id;
            insert document;
            
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            
            UserRole ur = new UserRole(Name = 'CEO',ParentRoleId = loginUser.UserRoleId);
            insert ur; 
            
            FCST_RoleHierarchySetUp.getHierarchycalUserList();
            FCST_RoleHierarchySetUp.getRoleHierarchy(loginUser.UserRoleId);
            List<Id> userId = new List<Id>();
            user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
            userId.add(u.Id);
            Id urRolesId = u.Id;
            userrole urole=[select id,parentRoleId from userrole where id=:u.userroleid];
            set<id> setroleids= new set<id>{urole.id};
            
            List<Planning_Version__c> plvList = new List<Planning_Version__c>();
            for(Integer i=0;i<20;i++){
                Planning_Version__c plv = new Planning_Version__c(Name  = '2019'+i);
                plvList.add(plv);    
            }
            insert plvList;
            
            List<Fiscal_Year_Planning__c> fypList = new List<Fiscal_Year_Planning__c>();
            for(Integer i=0;i<20;i++){
                Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(name='2019',EndDate__c=fendDate,StartDate__c=fstartDate);
                fypList.add(fyp);
            } insert fypList;
            List<Opportunity> oppList = new List<Opportunity>();
            
Planning_Version__c plvr = new Planning_Version__c(Name = '2019',Is_this_a_Budget_Planning_Version__c = false,
                                                                         Is_this_a_Gap_Planning_Version__c = false,Version_Status__c = 'In Progress',
                                                                         Planning_Version_Fiscal_Year__c = '2019');
            insert plvr;
            List<Account> accList = new List<Account>();
            for(Integer i=0;i<10;i++){
                Account act = new Account(Name = 'TestAccount',FCST_CPM_Region__c = 'US-DC Area');
                accList.add(act);
            }insert accList;
           
            Date myDate = date.newInstance(2018,05,22);
            
            for(Account acc :accList){
                for(Integer i=1;i<2;i++){
                    Opportunity opp = new Opportunity();
                    opp.Name='Test Opportunity'+i;opp.OwnerId=loginUser.id;opp.Submitted_for_Planning_Version__c = null; opp.AccountID=acc.Id; opp.stageName = 'Prospecting';opp.Reason__c='Government Timing'; opp.CloseDate=myDate;opp.ForecastCategoryName='Pipeline';
                    oppList.add(opp);
                }
            } insert oppList;
            oppList[0].ApprovalStatus__c = 'Reject';
            update oppList[0];
            
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            for(Integer i=0;i<5;i++){
            Fiscal_Year_Model__c fyp2 = new Fiscal_Year_Model__c(name='FY2019P07',Fiscal_Quarter__c='Q2');
            fymList.add(fyp2);
            } insert fymList;
            
            Opportunity opt = new Opportunity(AccountId = accList[0].Id,Amount = 20000,Name = 'Test Oppt',StageName = 'Lead (Above the Funnel)',
                                              CloseDate = System.today());
            insert opt; 
            
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(Name = 'Hardware',IsActive = true,ProductCode='1.0');
            insert prod;
            
            PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true);
            insert pbEntry;
            
            List<OpportunityLineItem> lstInsertOpp = new List<OpportunityLineItem>();
            OpportunityLineItem oli = new OpportunityLineItem( ServiceDate = fstartDate,Product2=prod,OpportunityId = opt.Id,Quantity = 5,PricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
            OpportunityLineItem oli1 = new OpportunityLineItem( ServiceDate = fstartDate,Product2=prod,OpportunityId = opt.Id,Quantity = 5,PricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
            lstInsertOpp.add(oli);
            lstInsertOpp.add(oli1);
            insert lstInsertOpp;
            
            PageReference pgf = Page.FCST_Landing_UI;
            Test.setCurrentPage(pgf);
            pgf.getparameters().put('SUId',String.valueOf(loginUser.Id));
            
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c(Account__c = accList[0].Id,Account_CPM_Region__c = 'fcst_cpm_region__c',
                                                                       Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,Weighted_Revenue__c = 10,Amount__c = 100,
                                                                       Fiscal_Period__c = fymList[0].id,Planning_Version__c = plvr.id,FCST_Revenue_Types__c='Project');
            insert prdModel;  
            
            FCST_Contract__c contracts = new FCST_Contract__c(Contract__c = 'TestData',Contract_Owner__c = loginUser.Id,FCST_Q__c = 'Q000-035',
                                                              Contract_Description__c = 'Demo45',Opportunity__c = oppList[0].Id,
                                                              FCST_Contract_Created_Year__c = '2019');            
            insert contracts;
            
              
            FCST_Contract__c contracts1 = new FCST_Contract__c(Contract__c = 'TestData',Contract_Owner__c = loginUser.Id,FCST_Q__c = 'Q000-035',
                                                              Contract_Description__c = 'Demo45',Opportunity__c = oppList[0].Id,
                                                              FCST_Contract_Created_Year__c = '2019');            
            insert contracts1;
            
            Contract_LineItem__c cli = new Contract_LineItem__c(FCST_Contract__c = contracts1.Id,Line_Description__c = 'testDesc',
                                                                Risk_Factor__c = 40,Fcst_Revenue_Type__c = 'test');
            insert cli;
            
            Actual_Model__c actModel = new Actual_Model__c(Actual_Amount__c = 20000,Account__c = accList[0].Id,Fiscal_Period__c = fymList[0].Id,
                                                           FCST_Planning_Version__c = plvr.Id,Revenue_Type__c = 'fcst_type__c',
                                                           Contract_LineItem__c = cli.Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel;
            
            FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,Account__c = accList[0].Id,
                                                                            FCST_Planning_Fiscal_Year__c = fymList[0].Id,Planning_Version__c = plvr.Id,
                                                                            FCST_Contract__c = contracts1.Id,Contract_LineItem__c = cli.Id);
            insert intFCST; 
            
             FCST_Opportunity_Initial_Forecast__c opif = new 
                FCST_Opportunity_Initial_Forecast__c(Fcst_Weighted_Revenue__c=25000,User_Adjusted_Revenue__c=1000,
                                                               Fcst_Opportunity__c=oppList[0].Id,Fcst_Fiscal_Period__c=fymList[0].id,
                                                               FCST_Planning_Version__c=plvr.id);
            insert opif;
            
            Test.startTest();
            FCST_Landing_UI_ControllerV1 fluc = new FCST_Landing_UI_ControllerV1();
            fluc.getFYPeriodFromQuarter(new List<String>{'2018-Q1','2018-Q2','2018-Q3','2018-Q4','2019-Q1','2019-Q2','2019-Q3','2019-Q4'});
            fluc.s_FilterUser = 'TestStr';
            fluc.business_String = 'TestData';
            fluc.RevenueName = 'fcstType';
            fluc.s_filterQuarter = new List<String>{'Q1'};
            fluc.BusinessUnitName = 'BusinessStr';
            fluc.User_String = String.valueOf(loginUser.Id);
            fluc.S_FilterPlanningVersion ='2019';
            fluc.getFiscalYearFromQuarter(new List<string>{'2019'});
            fluc.getQuarterFromQuarter(new List<string>{'FY2019P01'});
            FCST_Landing_UI_Controller.get15DigitId('');
            fluc.Initialization();
            fluc.onChangeYear();
            fluc.getUserRole();
            fluc.gotohomepage();
            fluc.getUserRole();
            fluc.getRoleUsers(new list<user>{loginUser});
            fluc.onReportLoad();
         	 fluc.getRevenueType();
            fluc.getCPMRegionType();
            fluc.getHierarchycalUsers(loginUser);
            fluc.getPicklistValues('Account','Industry');
            fluc.onChangeRole();
            fluc.getRoleRoles(usrId);
            fluc.RolesParentString('TestStr',ur.Id);
            fluc.getImageSRC('Test1','Test2');
            fluc.s_FilterPlanningYear = '2018';
            Fcst_Rev_Rec_Revenue_Type__c p = new Fcst_Rev_Rec_Revenue_Type__c(name='Project',Fcst_12_Month_Duration__c=true);
            insert p;
            List<FCST_Landing_UI_ControllerV1.wrapperSUAccountDetail> fccList = new List<FCST_Landing_UI_ControllerV1.wrapperSUAccountDetail>();
            FCST_Landing_UI_ControllerV1.wrapperSUAccountDetail fcc = new FCST_Landing_UI_ControllerV1.wrapperSUAccountDetail(accList[0],true,'testAcc',29999,29999,29999,29999,29999,29999,29999,29999,2999);
            fccList.add(fcc);
            FCST_Landing_UI_ControllerV1.wrapperSURevenueType wrp = new FCST_Landing_UI_ControllerV1.wrapperSURevenueType('Test',fccList);
            Test.stopTest();
        }
    }
    
}