@isTest
public class Test_FCST_Data_Extract_Controller {
    
    static testmethod void getData(){
        
        user usr=[select id from user where id=:userinfo.getUserId()];
        system.assertNotEquals(usr.Id,null);
        system.runAs(usr){
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
            
            // PE user creation 
            user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole ur = new UserRole(Name = 'Program Executive (PE) - Canada',ParentRoleId = u.UserRoleId);
            insert ur;
            
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            
            User u1 = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
            insert u1; 
            
            // PM User creation
            
            user u2=[select id,UserRoleId from user where id=:userinfo.getUserId()];
            
            Profile p2 = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole ur2 = new UserRole(Name = 'Program Manager (PM) - Canada',ParentRoleId = u2.UserRoleId);
            insert ur2;
            
            
            String orgId2 = UserInfo.getOrganizationId();
            String dateString2 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt2 = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName2 = orgId2 + dateString2 + randomInt2;
            
            User u3 = new User(Alias = 'standt', Email=uniqueName2+'@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p2.Id,UserRoleId = ur2.id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName2+'@testorg.com');
            insert u3; 
            system.debug('user role id '+u3.UserRoleId);
            
            
            
            Account ac= new Account(name='Test Acc',FCST_GeoCodes__c='Test Codes 1234',FCST_CPM_Region__c='CAN-CANADA',
                                    FCST_Program_Executive__c=u1.Id,FCST_Program_Manager__c=u3.Id); insert ac;
            Account ac1= new Account(name='Test Acc1',FCST_GeoCodes__c='Test Codes 1234',FCST_CPM_Region__c='CAN-CANADA',
                                     FCST_Program_Executive__c=u1.Id,FCST_Program_Manager__c=u3.Id); insert ac1;
            
            system.debug('ac '+ac);
            Geo_Test__c geotest = new Geo_Test__c(name='Test Geo'); insert geotest;
            Opportunity op= new opportunity(name='Test opty',stagename='Qualification',
                                            closedate=system.today()+15,
                                            accountid=ac.Id,
                                            fcst_start_date__c=date.newInstance(2019,01,01),
                                            fcst_end_date__c=date.newInstance(2019,12,01),
                                            deal_duration__c=11,
                                            deal_tcv__c=25000,
                                            amount=100000,
                                            geo_test__c=geotest.Id);
            
            insert op;
            
            Opportunity op1= new opportunity(name='Test opty',
                                             stagename='Lead (Above the Funnel)',
                                             closedate=system.today()+15,
                                             accountid=ac.Id);
            insert op1;
            
            date sdate= date.newInstance(2019,01,01);
            date edate= date.newInstance(2019,12,31);
            
            Fiscal_Year_Planning__c fyp= new Fiscal_Year_Planning__c(name='2019',StartDate__c=sdate,EndDate__c=edate); 
            insert fyp;
            
            Fiscal_Year_Planning__c fyp1= new Fiscal_Year_Planning__c(name='2019',StartDate__c=sdate,EndDate__c=edate); 
            insert fyp1; //s_filter planning year=2019(name)
            
            Planning_Version__c pv1= new Planning_Version__c(name='2019-April',Version_Status__c='Open (Admin)',Planning_Version_Fiscal_Year__c='2019',
                                                             Fiscal_Year_Planning__c=fyp.Id,Is_this_a_Budget_Planning_Version__c = false,
                                                             Is_this_a_Gap_Planning_Version__c = false);
            insert pv1;// initial forecast, name=2019-April, product model
            
            Planning_Version__c pv2= new Planning_Version__c(name='2019-April',Version_Status__c='Open (Admin)',Planning_Version_Fiscal_Year__c='2019',
                                                             Fiscal_Year_Planning__c=fyp1.Id,Is_this_a_Budget_Planning_Version__c = false,
                                                             Is_this_a_Gap_Planning_Version__c = false);
            insert pv2;// s_filter planning year=2019(fyp1.name)
            
            Planning_Version__c pv3= new Planning_Version__c(name='2019-April',Version_Status__c='Open (Admin)',Planning_Version_Fiscal_Year__c='2019',
                                                             Fiscal_Year_Planning__c=fyp1.Id,Is_this_a_Budget_Planning_Version__c = false,
                                                             Is_this_a_Gap_Planning_Version__c = false);
            insert pv3;// s_filterplanning year=2019 (fyp1)
            // open admin version=2019-April
            
            
            FCST_Contract__c contr= new FCST_Contract__c(Contract_Description__c='Test Desc',Opportunity__c=op.id,
                                                         FCST_Contract_Created_Year__c='2021'); insert contr;
            
            FCST_Contract__c contr1= new FCST_Contract__c(Contract_Description__c='Test Desc',Opportunity__c=op.id,
                                                          FCST_Contract_Created_Year__c='2018'); insert contr1;
            
            FCST_Contract__c contr2= new FCST_Contract__c(Contract_Description__c='Test Desc',Opportunity__c=null,
                                                          FCST_Contract_Created_Year__c='2017',Fcst_Account__c=ac.id); 
            insert contr2;
            
            
            List<FCST_Contract__c> contrList = new List<FCST_Contract__c>();
            FCST_Contract__c contr3= new FCST_Contract__c(Contract_Description__c='Test Desc',Opportunity__c=null,
                                                          FCST_Contract_Created_Year__c='2017',Fcst_Account__c=ac.id); 
            contrList.add(contr3);
            
            
            Fiscal_Year_Model__c fym= new Fiscal_Year_Model__c(name='2019',Month_Number__c=1,Fiscal_Year__c='2019');
            insert fym;
            
            
            Fiscal_Year_Model__c fym1= new Fiscal_Year_Model__c(name='2019',Month_Number__c=2,Fiscal_Year__c='2019');
            
            insert fym1;
            
            Fiscal_Year_Model__c fym2= new Fiscal_Year_Model__c(name='2019',Month_Number__c=3,Fiscal_Year__c='2019');
            insert fym2;
            
            Fiscal_Year_Model__c fym3= new Fiscal_Year_Model__c(name='2019',Month_Number__c=12,Fiscal_Year__c='2019');
            insert fym3;
            
            Fiscal_Year_Model__c fym4= new Fiscal_Year_Model__c(name='2019',Month_Number__c=4,Fiscal_Year__c='2019');
            insert fym4;
            
            Fiscal_Year_Model__c fym5= new Fiscal_Year_Model__c(name='2019',Month_Number__c=5,Fiscal_Year__c='2019');
            insert fym5;
            
            Fiscal_Year_Model__c fym6= new Fiscal_Year_Model__c(name='2019',Month_Number__c=6,Fiscal_Year__c='2019');
            insert fym6;
            
            Fiscal_Year_Model__c fym7= new Fiscal_Year_Model__c(name='2019',Month_Number__c=7,Fiscal_Year__c='2019');
            insert fym7;
            
            Fiscal_Year_Model__c fym8= new Fiscal_Year_Model__c(name='2019',Month_Number__c=8,Fiscal_Year__c='2019');
            insert fym8;
            
            Fiscal_Year_Model__c fym9= new Fiscal_Year_Model__c(name='2019',Month_Number__c=9,Fiscal_Year__c='2019');
            insert fym9;
            
            Fiscal_Year_Model__c fym10= new Fiscal_Year_Model__c(name='2019',Month_Number__c=10,Fiscal_Year__c='2019');
            insert fym10;
            
            Fiscal_Year_Model__c fym11= new Fiscal_Year_Model__c(name='2019',Month_Number__c=11,Fiscal_Year__c='2019');
            insert fym11;
            List<Fiscal_Year_Model__c> FYList = new List<Fiscal_Year_Model__c>();
            for(Integer i=0;i<12;i++){
                Fiscal_Year_Model__c fym12= new Fiscal_Year_Model__c(name='2020',Month_Number__c=i+1,Fiscal_Year__c='2020');
                FYList.add(fym12);
            }
            insert FYList;
            System.debug('FYList'+FYList);
            
            Contract_LineItem__c cli= new Contract_LineItem__c(Fcst_Revenue_Type__c='prod-commodity',FCST_Contract__c=contr1.Id); 
            insert cli;
            
            Contract_LineItem__c cli1= new Contract_LineItem__c(Fcst_Revenue_Type__c='prod-commodity',FCST_Contract__c=contr.Id); 
            insert cli1;
            
            Contract_LineItem__c cli2= new Contract_LineItem__c(Fcst_Revenue_Type__c='prod-commodity',
                                                                FCST_Contract__c=contr2.Id); 
            insert cli2;
            
            FCST_Initial_Forecast__c ifcc20 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr2.id,Contract_LineItem__c=cli2.id,
                                                                           FCST_Planning_Fiscal_Year__c=fym1.id,
                                                                           Account__c=ac.Id,
                                                                           Planning_Version__c=pv1.Id,
                                                                           Fcst_Amount__c=25000,
                                                                           Risk_Factor__c=1);
            insert ifcc20;
            // for next full year
            
            list<FCST_Initial_Forecast__c> iflist2= new list<FCST_Initial_Forecast__c>();
            for(integer i=0;i<12;i++){
                FCST_Initial_Forecast__c ifc2 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr2.id,Contract_LineItem__c=cli1.id,
                                                                             FCST_Planning_Fiscal_Year__c=FYList[i].id,
                                                                             Account__c=ac.Id,
                                                                             Planning_Version__c=pv1.Id,
                                                                             Fcst_Amount__c=25000,
                                                                             Risk_Factor__c=1);
                iflist2.add(ifc2);
            }
            insert iflist2; 
            
            
            
            list<FCST_Initial_Forecast__c> iflist1= new list<FCST_Initial_Forecast__c>();
            
            for(integer i=0;i<12;i++){
                FCST_Initial_Forecast__c ifc1 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                             FCST_Planning_Fiscal_Year__c=FYList[i].id,
                                                                             Account__c=ac.Id,
                                                                             Planning_Version__c=pv1.Id,
                                                                             Fcst_Amount__c=25000,
                                                                             Risk_Factor__c=1);
                iflist1.add(ifc1);
            }
            insert iflist1; 
            // for current full year
            
            FCST_Initial_Forecast__c ifc13 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym1.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc13;
            
            FCST_Initial_Forecast__c ifc24 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym2.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc24;
            
            FCST_Initial_Forecast__c ifc15 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym3.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc15;
            
            FCST_Initial_Forecast__c ifc16 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym4.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc16;
            
            FCST_Initial_Forecast__c ifc17 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym5.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc17;
            
            FCST_Initial_Forecast__c ifc18 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym6.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc18;
            
            FCST_Initial_Forecast__c ifc19 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym7.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc19;
            
            FCST_Initial_Forecast__c ifc20 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym8.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc20;
            
            FCST_Initial_Forecast__c ifc21 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym9.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc21;
            
            FCST_Initial_Forecast__c ifc22 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym10.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc22;
            
            FCST_Initial_Forecast__c ifc23 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym11.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            insert ifc23;
            
            FCST_Initial_Forecast__c ifc0 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            insert ifc0;
            
            FCST_Initial_Forecast__c ifc = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                        FCST_Planning_Fiscal_Year__c=fym1.id,
                                                                        Account__c=ac.Id,
                                                                        Planning_Version__c=pv1.Id,
                                                                        Fcst_Amount__c=25000,
                                                                        Risk_Factor__c=1);
            
            insert ifc;
            
            FCST_Initial_Forecast__c ifc1 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli1.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            insert ifc1;
            
            FCST_Initial_Forecast__c ifc2 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym1.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            insert ifc2;
            
            
            FCST_Initial_Forecast__c ifc3 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym2.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            insert ifc3;
            
            FCST_Initial_Forecast__c ifc4 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym3.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            
            insert ifc4; 
            
            FCST_Initial_Forecast__c ifc5 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym4.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            
            insert ifc5; 
            FCST_Initial_Forecast__c ifc6 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym5.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            
            insert ifc6; 
            FCST_Initial_Forecast__c ifc7 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym6.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            
            insert ifc7; 
            FCST_Initial_Forecast__c ifc8 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym7.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            
            insert ifc8; 
            FCST_Initial_Forecast__c ifc9 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                         FCST_Planning_Fiscal_Year__c=fym8.id,
                                                                         Account__c=ac.Id,
                                                                         Planning_Version__c=pv1.Id,
                                                                         Fcst_Amount__c=25000,
                                                                         Risk_Factor__c=1);
            
            
            insert ifc9; 
            FCST_Initial_Forecast__c ifc10 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym9.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            
            
            insert ifc10; 
            FCST_Initial_Forecast__c ifc11 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym10.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            
            
            insert ifc11; 
            
            FCST_Initial_Forecast__c ifc12 = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                          FCST_Planning_Fiscal_Year__c=fym11.id,
                                                                          Account__c=ac.Id,
                                                                          Planning_Version__c=pv1.Id,
                                                                          Fcst_Amount__c=25000,
                                                                          Risk_Factor__c=1);
            
            
            insert ifc12; 
            List<FCST_Initial_Forecast__c> InitiForeList = new List<FCST_Initial_Forecast__c>();
            for(Integer i=0;i<FYList.size();i++){
                FCST_Initial_Forecast__c ifc14   = new FCST_Initial_Forecast__c(FCST_Contract__c=contr.id,Contract_LineItem__c=cli.id,
                                                                                FCST_Planning_Fiscal_Year__c=FYList[i].id,
                                                                                Account__c=ac.Id,
                                                                                Planning_Version__c=pv1.Id,
                                                                                Fcst_Amount__c=25000,
                                                                                Risk_Factor__c=1);
                InitiForeList.add(ifc14);
            }             
            insert InitiForeList; 
            
            
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family = 'Hosted Services');
            insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            ); insert pbEntry;
            OpportunityLineItem oppprod = new OpportunityLineItem(OpportunityId=op.id,PricebookEntryId = pbEntry.Id, Quantity = 5);
            oppprod.TotalPrice = oppprod.quantity * pbEntry.UnitPrice; 
            oppprod.Risk_Factor__c = 0;
            insert oppprod;
            system.debug('product');
            /* FCST_Product_Model__c pm= new FCST_Product_Model__c(FCST_Product_Line_ID__c='00k1U00000tIiwhQAC',Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym.id,
Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
insert pm;
list<FCST_Product_Model__c> pmlist= new list<FCST_Product_Model__c>{pm};
system.debug('pm '+pm);*/
            
            FCST_Product_Model__c pm1= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm1; 
            FCST_Product_Model__c pmf1= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op1.Id,Fiscal_Period__c=fym.id,
                                                                  Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                  FCST_Revenue_Types__c='Commodity',FCST_Product_Line_ID__c=oppprod.id,Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pmf1;
            list<FCST_Product_Model__c> pmlist1= new list<FCST_Product_Model__c>();
            for(integer i=0;i<12;i++){
                FCST_Product_Model__c pm2= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=FYList[i].id,
                                                                     Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                     FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
                pmlist1.add(pm2);
            }
            insert pmlist1;
            
            FCST_Product_Model__c pm3= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym1.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm3;
            
            FCST_Product_Model__c pm4= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym2.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm4;
            FCST_Product_Model__c pm5= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym3.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm5;
            FCST_Product_Model__c pm6= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym4.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm6;
            FCST_Product_Model__c pm7= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym5.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm7;
            FCST_Product_Model__c pm8= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym6.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm8;
            FCST_Product_Model__c pm9= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym7.id,
                                                                 Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                 FCST_Revenue_Types__c='Annuity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm9;
            FCST_Product_Model__c pm10= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym8.id,
                                                                  Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                  FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm10;
            FCST_Product_Model__c pm11= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym9.id,
                                                                  Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                  FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm11;
            FCST_Product_Model__c pm12= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym10.id,
                                                                  Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                  FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm12;
            FCST_Product_Model__c pm13= new FCST_Product_Model__c(Product__c=prod.Id,Opportunity__c=op.Id,Fiscal_Period__c=fym11.id,
                                                                  Account__c=ac1.id,User_Adjusted_Revenue__c=1000,Weighted_Revenue__c=25000,
                                                                  FCST_Revenue_Types__c='Commodity',Planning_Version__c=pv1.Id,Account_CPM_Region__c='CAN-CANADA');
            insert pm13;
            
            
            Actual_Model__c actuals = new Actual_Model__c();
            actuals.Account__c = ac.Id;
            actuals.FCST_Planning_Version__c = pv1.Id;
            actuals.Contract_LineItem__c = cli.Id;
            actuals.Fiscal_Period__c = fym.Id;
            actuals.Fiscal_Year__c = fyp.Id;
            actuals.Actual_Amount__c = 20000;
           // actuals.Cost_Center__c='fcst_cost_center__c';
            actuals.GEO_Description__c='fcst_geo_codes__c';
            actuals.FCST_GEO__c='fcst_geo_codes__c';
           // actuals.Contract__c=contr.Id;
            //actuals.Line_Description__c = 'Test Desc';
            insert actuals;
            
             Actual_Model__c actuals2 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym1.Id,Fiscal_Year__c = fyp.Id,Actual_Amount__c = 20000);
             insert actuals2;
            
             Actual_Model__c actuals3 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym2.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals3;

            Actual_Model__c actuals4 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym3.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals4;
            
            Actual_Model__c actuals5 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym4.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals5;
            
            Actual_Model__c actuals6 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym5.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals6;
            
            Actual_Model__c actuals7 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym6.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals7;
            
            Actual_Model__c actuals8 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym7.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals8;
            
            Actual_Model__c actuals9 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym8.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals9;
            
            Actual_Model__c actuals10 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym9.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals10;
            
            Actual_Model__c actuals11 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym10.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals11;
            
            Actual_Model__c actuals12 = new Actual_Model__c(Account__c = ac.Id,FCST_Planning_Version__c = pv1.Id,Contract_LineItem__c = cli.Id,Fiscal_Period__c = fym11.Id,Actual_Amount__c = 20000,Fiscal_Year__c = fyp.Id);
             insert actuals12;
            
            test.startTest();
            FCST_Data_Extract_Controller decont= new FCST_Data_Extract_Controller();
            // decont.s_FilterPlanningYear='2019';
            FCST_Data_Extract_Controller.reduceName('TEST nAME');
            decont.Beginning();
            decont.callBatchClass();
            decont.End();
            decont.getDisableNext();
            decont.getDisablePrevious();
            // decont.getFilterPlanningVersion();
            decont.getFilterPlanningYear();
            decont.getPageNumber();
            decont.getTotal_size();
            decont.getTotalPages();
            decont.gotohomepage();
            decont.loadLandingUI();
            decont.Next();
            decont.onChangeYear();
            decont.Previous();
            decont.updateWrapperList();
            
            test.stopTest();
            List<Opportunity> optList = new List<Opportunity>();
            Opportunity opp= new opportunity(name='Test opty',stagename='Qualification',
                                            closedate=system.today()+15,
                                            accountid=ac.Id,
                                            fcst_start_date__c=date.newInstance(2019,01,01),
                                            fcst_end_date__c=date.newInstance(2019,12,01),
                                            deal_duration__c=11,
                                            deal_tcv__c=25000,
                                            amount=100000,
                                            geo_test__c=geotest.Id);
            
            optList.add(opp);
            insert optList;
            
            
            FCST_ActualData_Extract_Batch_Download actualBatch = new FCST_ActualData_Extract_Batch_Download('2019','2019-August');
            DataBase.executeBatch(actualBatch,200);
            
           
        }
        
    }
    
}