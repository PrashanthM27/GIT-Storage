@isTest
public class Test_FCST_CompucomSummaryWorkbench {
    
    static testmethod void getData1(){
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
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() AND isActive=true];
        
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(thisUser){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole ur = new UserRole(Name = 'CEO');
            insert ur;
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            User u = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
            insert u;
            
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2018P0'+string.valueOf(i)):('FY2018P'+string.valueOf(i));
                    fym.End_Date__c = fstartDate;
                fym.Start_Date__c = fendDate;
                fym.Fiscal_Planning_Year__c = fyp.Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2018';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'Feb';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = fstartDate;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            insert plversionObj1;
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            insert plversionObj;
            //  MappingFieldUtility mfu = new MappingFieldUtility();
            //   String prog = mfu.getQNum(); 
            // Account acc = new Account(Name='Test Account',FCST_Program_Manager__c = u.Id,FCST_CPM_Region__c='CAN-Canada');
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='CAN-Canada');
            
            insert acc;
            
            List<Account> acList = new List<Account>();
            Account ac = new Account();
            ac.Name = 'Test Account';
            ac.FCST_GeoCodes__c = 'Canada East';
            ac.FCST_CPM_Region__c = 'CAN-Canada';
            ac.FCST_Program_Executive__c = thisUser.Id;
            ac.FCST_Program_Manager__c = thisUser.Id;
            acList.add(ac);
            
            if(acList!=null && !acList.isEmpty()){
                insert acList;
            }
            
            Opportunity opt = new Opportunity();
            opt.Name = 'Lead (Above the Funnel)';
            opt.AccountId = acc.Id;
            opt.StageName = 'Prospecting';
            opt.CloseDate = System.today()+12;
            insert opt;
            
            Opportunity opt1 = new Opportunity();
            opt1.Name = 'Below the funnel';
            opt1.AccountId = acc.Id;
            opt1.StageName = 'Lead (Below the Funnel)';
            opt1.CloseDate = System.today();
            insert opt1;
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'FCST Gold',
                ProductCode = 'SL9060',
                FCST_Revenue_Type__c = 'Project',
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
            insert oli;
            
            Fiscal_Year_Model__c fym1 = new Fiscal_Year_Model__c();
            fym1.Name = 'FY2018P01';
            insert fym1;
            
            Fiscal_Year_Model__c fym2 = new Fiscal_Year_Model__c();
            fym2.Name = 'FY2018P02';
            insert fym2;
            
            Fiscal_Year_Model__c fym3 = new Fiscal_Year_Model__c();
            fym3.Name = 'FY2018P03';
            insert fym3;
            
            Fiscal_Year_Model__c fym4 = new Fiscal_Year_Model__c();
            fym4.Name = 'FY2018P04';
            insert fym4;
            
            Fiscal_Year_Model__c fym5 = new Fiscal_Year_Model__c();
            fym5.Name = 'FY2018P05';
            insert fym5;
            
            Fiscal_Year_Model__c fym6 = new Fiscal_Year_Model__c();
            fym6.Name = 'FY2018P06';
            insert fym6;
            
            Fiscal_Year_Model__c fym7 = new Fiscal_Year_Model__c();
            fym7.Name = 'FY2018P07';
            insert fym7;
            
            Fiscal_Year_Model__c fym8 = new Fiscal_Year_Model__c();
            fym8.Name = 'FY2018P08';
            insert fym8;
            
            Fiscal_Year_Model__c fym9 = new Fiscal_Year_Model__c();
            fym9.Name = 'FY2018P09';
            insert fym9;
            
            Fiscal_Year_Model__c fym10 = new Fiscal_Year_Model__c();
            fym10.Name = 'FY2018P10';
            insert fym10;
            
            Fiscal_Year_Model__c fym11 = new Fiscal_Year_Model__c();
            fym11.Name = 'FY2018P11';
            insert fym11;
            
            Fiscal_Year_Model__c fym12 = new Fiscal_Year_Model__c();
            fym12.Name = 'FY2018P12';
            insert fym12;
            
            
            FCST_Product_Model__c prdModel1 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym1.id);
            insert prdModel1;
            
            
            FCST_Product_Model__c prdModel2 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym2.id);
            insert prdModel2;
            
            FCST_Product_Model__c prdModel3 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym3.id);
            insert prdModel3;
            
            FCST_Product_Model__c prdModel4 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym4.id);
            insert prdModel4;
            
            FCST_Product_Model__c prdModel5 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym5.id);
            insert prdModel5;
            
            
            FCST_Product_Model__c prdModel6 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym6.id);
            insert prdModel6;
            
            
            FCST_Product_Model__c prdModel7 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym7.id);
            insert prdModel7;
            
            
            FCST_Product_Model__c prdModel8 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym8.id);
            insert prdModel8;
            
            
            FCST_Product_Model__c prdModel9 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                        Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                        Fiscal_Period__c = fym9.id);
            insert prdModel9;
            
            
            FCST_Product_Model__c prdModel10 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                         Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                         Fiscal_Period__c = fym10.id);
            insert prdModel10;
            
            
            FCST_Product_Model__c prdModel11 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                         Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                         Fiscal_Period__c = fym11.id);
            insert prdModel11;
            
            
            FCST_Product_Model__c prdModel12 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
                                                                         Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
                                                                         Fiscal_Period__c = fym12.id);
            insert prdModel12;
            
            
            /* FCST_Product_Model__c prdM1 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym1.id);
insert prdM1;

FCST_Product_Model__c prdM2 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym2.id);
insert prdM2;

FCST_Product_Model__c prdM3 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym3.id);
insert prdM3;

FCST_Product_Model__c prdM4 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym4.id);
insert prdM4;

FCST_Product_Model__c prdM5 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym5.id);
insert prdM5;

FCST_Product_Model__c prdM6 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym6.id);
insert prdM6;

FCST_Product_Model__c prdM7 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym7.id);
insert prdM7;

FCST_Product_Model__c prdM8 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym8.id);
insert prdM8;

FCST_Product_Model__c prdM9 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym9.id);
insert prdM9;

FCST_Product_Model__c prdM10 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym10.id);
insert prdM10;

FCST_Product_Model__c prdM11 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym11.id);
insert prdM11;

FCST_Product_Model__c prdM12 = new FCST_Product_Model__c(Account__c = acc.Id,Opportunity__c = opt1.Id,FCST_Product_Line_ID__c=oli.id,
Planning_Version__c =plversionObj.Id,User_Adjusted_Revenue__c=100,Weighted_Revenue__c = 100,Amount__c = 100,Product__c = prod.id,
Fiscal_Period__c = fym12.id);
insert prdM12;*/
            
            FCST_Contract__c contr = new FCST_Contract__c();
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';   
            contr.Contract_Owner__c= u.id;
            insert contr;
            
            
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            fcl.FCST_Contract__c = contr.id;
            fcl.Risk_Factor__c = 100;
            insert fcl;
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Baseline';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.Fiscal_Period__c = fymmap.get(i).id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                amlist.add(actModel);
            }
            insert amlist;
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.FCST_CompucomSummaryWorkBench')); 
            System.currentPageReference().getParameters().put('pv', plversionObj.id);
            System.currentPageReference().getParameters().put('AccId', acc.id);
            System.currentPageReference().getParameters().put('su', u.id);
            System.currentPageReference().getParameters().put('getincreaseValue', '5');
            System.currentPageReference().getParameters().put('id', initial_flist[0].id);
            System.currentPageReference().getParameters().put('planningModelAmount', '10');
            FCST_CompucomSummaryWorkBench cc = new FCST_CompucomSummaryWorkBench();
            cc.strPlanningVersion = '2018';
            cc.StrCPMRegion = 'fcst_cpm_region__c';
            cc.productFamilyStr = 'Test';
            cc.strProduct = 'Testprd';
            cc.strPlanningYear = '2018';
            cc.checkTotal = true;
            cc.strOpportunity = 'TestStrOpp';
            cc.cpID = 'TestC';
            cc.strContract = 'TestContr';
            cc.strLine ='StrTest';
            cc.getPlanningYearOptionList();
            cc.getCPMRegionList();
            cc.getUserChange();
            cc.mainfetchOppRecord();
            cc.gotohomepage();
            cc.BackPage();
            test.stopTest();
        }
    }
    static testmethod void getData3(){
        FCST_UTIL.InsertTriggerMappingFields(); FCST_UTIL.InsertTriggerMappingFields();
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
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(u){
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2018P0'+string.valueOf(i)):('FY2018P'+string.valueOf(i));
                    fym.End_Date__c = fstartDate;
                fym.Start_Date__c = fendDate;
                fym.Fiscal_Planning_Year__c = fyp.Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = fstartDate;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            insert plversionObj1;
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            insert plversionObj;
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='CAN-Canada');
            insert acc;
            Opportunity opt = new Opportunity();
            opt.Name = '1Oppy for Closed';
            opt.AccountId = acc.Id;
            opt.StageName = 'Lead (Above the Funnel)';
            opt.CloseDate = fendDate;
            insert opt;
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family = 'Hosted Services'
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
            insert oli;
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
                FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
                prdModel.Account__c = acc.Id;
                prdModel.Opportunity__c = opt.Id;
                prdModel.FCST_Product_Line_ID__c=oli.id;
                prdModel.Planning_Version__c =plversionObj.Id;
                prdModel.Weighted_Revenue__c = 10;
                prdModel.Amount__c = 100;
                prdModel.Product__c = prod.id;
                prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist; 
            
            FCST_Contract__c contr = new FCST_Contract__c();
            contr.Fcst_Account__c = acc.Id;
            contr.Contract_Owner__c = u.Id;
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';   
            insert contr;
            
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            fcl.FCST_Contract__c = contr.id;
            insert fcl;
            
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Baseline';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.Fiscal_Period__c = fymmap.get(i).id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                amlist.add(actModel);
            }
            insert amlist;
            
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.FCST_CompucomSummaryWorkBench')); 
            System.currentPageReference().getParameters().put('pv', plversionObj.id);
            System.currentPageReference().getParameters().put('AccId', acc.id);
            System.currentPageReference().getParameters().put('su', u.id);
            System.currentPageReference().getParameters().put('getincreaseValue', '5');
            System.currentPageReference().getParameters().put('id', initial_flist[0].id);
            System.currentPageReference().getParameters().put('planningModelAmount', '10');
            FCST_CompucomSummaryWorkBench cc = new FCST_CompucomSummaryWorkBench();
            cc.getPlanningYearOptionList();
            cc.getCPMRegionList();
            cc.getUserChange();
            cc.mainfetchOppRecord();
            cc.gotohomepage();
            cc.BackPage();
            test.stopTest();
            
        }
    }
    static testmethod void getData2(){
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
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(u){
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2018P0'+string.valueOf(i)):('FY2018P'+string.valueOf(i));
                    fym.End_Date__c = fstartDate;
                fym.Start_Date__c = fendDate;
                fym.Fiscal_Planning_Year__c = fyp.Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = fstartDate;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            insert plversionObj1;
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            insert plversionObj;
            Account acc = new Account(Name='Test Account',ownerid=u.id,FCST_CPM_Region__c='CAN-Canada');
            insert acc;
            Opportunity opt = new Opportunity();
            opt.Name = '1Oppy for Closed';
            opt.AccountId = acc.Id;
            opt.StageName = 'Closed Won';
            opt.CloseDate = fendDate;
            insert opt;
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family = 'Hosted Services'
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
            insert oli;
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
                FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
                prdModel.Account__c = acc.Id;
                prdModel.Opportunity__c = opt.Id;
                prdModel.FCST_Product_Line_ID__c=oli.id;
                prdModel.Planning_Version__c =plversionObj.Id;
                prdModel.Weighted_Revenue__c = 10;
                prdModel.Amount__c = 100;
                prdModel.Product__c = prod.id;
                prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist;   
            FCST_Contract__c contr = new FCST_Contract__c();
            contr.Opportunity__c = opt.id;
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2019';   
            contr.Contract_Owner__c= u.id;
            insert contr;
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            fcl.FCST_Contract__c = contr.id;
            fcl.Risk_Factor__c = 100;
            insert fcl;
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            // }
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Closed Won';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.Fiscal_Period__c = fymmap.get(i).id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                amlist.add(actModel);
            }
            insert amlist;
            
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.FCST_CompucomSummaryWorkBench')); 
            System.currentPageReference().getParameters().put('pv', plversionObj.id);
            System.currentPageReference().getParameters().put('AccId', acc.id);
            System.currentPageReference().getParameters().put('su', u.id);
            System.currentPageReference().getParameters().put('getincreaseValue', '5');
            System.currentPageReference().getParameters().put('id', initial_flist[0].id);
            System.currentPageReference().getParameters().put('planningModelAmount', '10');
            FCST_CompucomSummaryWorkBench cc = new FCST_CompucomSummaryWorkBench();
            cc.getPlanningYearOptionList();
            cc.strAccount = 'Test Account';
            cc.getCPMRegionList();
            cc.getUsersRoleChange();
            cc.getUserChange();
            cc.UserChange();
            cc.getCPMResionVal();
            cc.gotohomepage();
            cc.BackPage();
            
            /* FCST_CompucomSummaryWorkBenchC csw = new FCST_CompucomSummaryWorkBenchC();
Test.setCurrentPageReference(new PageReference('Page.FCST_CompucomSummaryWorkBenchC')); 
System.currentPageReference().getParameters().put('getincreaseValue', '6');
csw.StrCPMRegion = 'CPMRegion';
csw.productFamilyStr = 'PrdFamilyStr';
csw.strProduct = 'Prd';
csw.strPlanningYear = '2019';
csw.checkTotal = true;
//csw.getPlanningYearOptionList();
// csw.UserChange();
//csw.getUserChange();
//csw.getCPMRegionList();
//csw.getUsersRoleChange();
// csw.getCPMResionVal();
// csw.getCPMResionVal();
// csw.getFromPlanningVersion();
// csw.mainfetchOppRecord();
csw.gotohomepage();
csw.BackPage();*/
            
            test.stopTest();
        }
    }
    static testmethod void getData4(){
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
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(u){
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2018P0'+string.valueOf(i)):('FY2018P'+string.valueOf(i));
                    fym.End_Date__c = fstartDate;
                fym.Start_Date__c = fendDate;
                fym.Fiscal_Planning_Year__c = fyp.Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = fstartDate;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            
            Fiscal_Year_Model__c fym1 = new Fiscal_Year_Model__c();
            fym1.Name = 'FY2019P01';
            insert fym1;
            
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            insert plversionObj1;
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            insert plversionObj;
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='CAN-Canada');
            insert acc;
            Opportunity opt = new Opportunity();
            opt.Name = '1Oppy for Closed';
            opt.AccountId = acc.Id;
            opt.StageName = 'Lead (Above the Funnel)';
            opt.CloseDate = fendDate;
            insert opt;
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family = 'Hosted Services'
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
            insert oli;
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
                FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
                prdModel.Account__c = acc.Id;
                prdModel.Opportunity__c = opt.Id;
                prdModel.FCST_Product_Line_ID__c=oli.id;
                prdModel.Planning_Version__c =plversionObj.Id;
                prdModel.Weighted_Revenue__c = 10;
                prdModel.Amount__c = 100;
                prdModel.Product__c = prod.id;
                prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist; 
            
            FCST_Contract__c contr = new FCST_Contract__c();
            contr.Fcst_Account__c = acc.Id;
            contr.Contract_Owner__c = u.Id;
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';   
            insert contr;
            
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            fcl.FCST_Contract__c = contr.id;
            insert fcl;
            
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fym1.id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Baseline';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.Fiscal_Period__c = fym1.id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                amlist.add(actModel);
            }
            insert amlist;
            
            FCST_CompucomSummaryWorkBench cc = new FCST_CompucomSummaryWorkBench();
            cc.getPlanningYearOptionList();
            cc.strAccount = 'Test Account';
            cc.getCPMRegionList();
            cc.getUsersRoleChange();
            cc.getUserChange();
            cc.UserChange();
            cc.getCPMResionVal();
            cc.gotohomepage();
            cc.BackPage();
        }
    }
    
    static testmethod void getData5(){
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
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(u){
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2018P0'+string.valueOf(i)):('FY2018P'+string.valueOf(i));
                    fym.End_Date__c = fstartDate;
                fym.Start_Date__c = fendDate;
                fym.Fiscal_Planning_Year__c = fyp.Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = fstartDate;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            insert plversionObj1;
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            insert plversionObj;
            Account acc = new Account(Name='Test Account',ownerid=u.id,FCST_CPM_Region__c='CAN-Canada');
            insert acc;
            Opportunity opt = new Opportunity();
            opt.Name = '1Oppy for Closed';
            opt.AccountId = acc.Id;
            opt.StageName = 'Closed Won';
            opt.CloseDate = fendDate;
            insert opt;
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family = 'Hosted Services'
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
            insert oli;
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
                FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
                prdModel.Account__c = acc.Id;
                prdModel.Opportunity__c = opt.Id;
                prdModel.FCST_Product_Line_ID__c=oli.id;
                prdModel.Planning_Version__c =plversionObj.Id;
                prdModel.Weighted_Revenue__c = 10;
                prdModel.Amount__c = 100;
                prdModel.Product__c = prod.id;
                prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist;   
            FCST_Contract__c contr = new FCST_Contract__c();
            contr.Opportunity__c = opt.id;
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2019';   
            contr.Contract_Owner__c= u.id;
            insert contr;
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            fcl.FCST_Contract__c = contr.id;
            fcl.Risk_Factor__c = 100;
            insert fcl;
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            // }
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Closed Won';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.Fiscal_Period__c = fymmap.get(i).id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                amlist.add(actModel);
            }
            insert amlist;
            
            test.startTest();
            FCST_CompucomSummaryWorkBench cc = new FCST_CompucomSummaryWorkBench();
            cc.getPlanningYearOptionList();
            cc.strAccount = 'Test Account';
            cc.getCPMRegionList();
            cc.getUsersRoleChange();
            cc.getUserChange();
            cc.UserChange();
            cc.getCPMResionVal();
            cc.gotohomepage();
            cc.BackPage();
            test.stopTest();
        }
    }
    
    
    
    static testmethod void OptyLineTriggerHandler(){
         FCST_Trigger__c trig = new FCST_Trigger__c();
        trig.Name = 'TriggerMapping';
        trig.Account_Trigger__c = true;
        insert trig;
        
        FCST_UTIL.InsertTriggerMappingFields();
        Mapping_Setting__c setting = new Mapping_Setting__c();
        setting.Name = 'FCST Mapping Data';
        setting.FCST_BSLA__c = 'fcst_bsla__c';
        setting.Cost_Center__c = 'fcst_cost_center__c';
        setting.Fcst_BusinessUnit__c = 'Test_Picklist__c';
        setting.Fcst_CPM__c = 'fcst_cpm_region__c';
        setting.Fcst_EndDate__c = 'fcst_end_date__c';
        setting.FCST_Program_Executive__c  = 'fcst_program_executive__c';
        setting.FCST_ProgramManager__c  = 'fcst_program_manager__c';
        setting.Fcst_SalesRegion__c  = 'fcst_account_region_vertical__c';
        setting.Fcst_StartDate__c  = 'fcst_start_date__c';
        setting.Fcst_SubRegion__c  = 'fcst_account_sub_region__c';
        setting.FCST_GeoCodes__c  = 'fcst_geocodes__c';
        setting.Fcst_Q__c  = 'fcst_q__c';
        setting.Fcst_Revenue_Type__c  = 'fcst_revenue_type__c';
        setting.Geo__c  = 'fcst_geo_codes__c';
        setting.Geo_Name__c  = 'geo_name__c';
        setting.Term_In_Months__c  = 'Deal_Duration__c';
        setting.Transition_Date__c  = 'CloseDate';
        setting.Opportunity_SVC_YR1__c='amount';
        setting.Opportunity_TCV__c='deal_tcv__c';
        setting.Opportunity_RecordType_Api__c = 'Division__c';
        insert setting;
        
       
        
        user u=[select id from user where id=:userinfo.getUserId()];
        system.runAs(u){
            Date fstartDate = Date.newInstance(2020,1,1);
            Date fendDate = Date.newInstance(2020,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2018P0'+string.valueOf(i)):('FY2018P'+string.valueOf(i));
                    fym.End_Date__c = fstartDate;
                fym.Start_Date__c = fendDate;
                fym.Fiscal_Planning_Year__c = fyp.Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = fstartDate;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='US-Target',
                                      FCST_Program_Manager__c=u.Id,FCST_Program_Executive__c=u.Id,FCST_GeoCodes__c='fcst_geocodes__c');
            insert acc;
            
            List<Opportunity> optList = new List<Opportunity>();
            opportunity op= new opportunity();
            op.Name='test opty';
            op.StageName='Prospecting';
            op.accountid=acc.id;
            op.CloseDate= fstartDate;
            op.FCST_Script__c = true;
            optList.add(op);
            insert optList;
            
            Product2 prod = new Product2(Name = 'Product X', ProductCode = 'Pro-X', isActive = true, Family = 'Hosted Services');
            insert prod;
            
            id pbid=test.getStandardPricebookId();
            
            pricebookentry pbe= new pricebookentry(Product2Id=prod.id, Pricebook2Id=pbid, UnitPrice=100.00, IsActive=true);
            insert pbe;
            
            opportunitylineitem oli= new opportunitylineitem(opportunityid=optList[0].Id,quantity=5,pricebookentryid=pbe.Id);
            oli.TotalPrice=oli.Quantity*pbe.UnitPrice;
            oli.Risk_Factor__c=0;
            oli.Fcst_Auto_Script__c=true;
            insert oli;
            // oli.Fcst_Auto_Script__c=true;
            // update oli;
            
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            update oli;
            op.FCST_Script__c = false;
            optList.add(op);
            update op;
            List<Opportunity> optList2 = [Select Id,FCST_Script__c,(Select OpportunityId,Fcst_Auto_Script__c from OpportunityLineItems) from Opportunity where Id=:optList[0].Id];
            
            
            
            FCST_AccountTriggerHandler trigHandler = new FCST_AccountTriggerHandler();
            FCST_AccountTriggerHandler.HandlerMethod();
            FCST_AccountTriggerHandler.RecursionHandler = false;
            FCST_AccountTriggerHandler.updateMOdelCPM(optList2);
            
            
        }   
    }    
    
    
}