@isTest
public class Test_FCST_Actuals_DataExtract {

    static testmethod void getData(){
        
        user u=[select id from user where id=:userinfo.getUserId()];
        system.runAs(u){
            string TestString='TestString TestString TestString TestString TestString TestString TestString TestString TestString TestString';
            
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
            
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(name='2019',StartDate__c=date.newInstance(2019,01,01),
                                                                     EndDate__c=date.newInstance(2019,12,31)); insert fyp;
            
            Planning_Version__c plvr = new Planning_Version__c();
            plvr.Name = '2019-August';
            plvr.Is_this_a_Budget_Planning_Version__c = false;
            plvr.Is_this_a_Gap_Planning_Version__c = false;
            plvr.Version_Status__c = 'Open (Admin)';
            plvr.Planning_Version_Fiscal_Year__c = '2019';
            plvr.Fiscal_Year_Planning__c=fyp.id;
            insert plvr;
            
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='US-DC Area');insert acc;
            
            Opportunity opt = new Opportunity(AccountId = acc.Id,Amount = 20000,Name = 'Test Oppt',StageName = 'Lead (Above the Funnel)',
                                              CloseDate = System.today());insert opt;
            
            
             FCST_Contract__c contr1 = new FCST_Contract__c(Contract__c = 'TestData',Contract_Owner__c = u.Id,FCST_Q__c = 'Q000-035',
                                                              Contract_Description__c = 'Demo45',Opportunity__c = opt.Id,
                                                              FCST_Contract_Created_Year__c = '2019');            
            insert contr1;
            
                       
            Contract_LineItem__c cli = new Contract_LineItem__c(FCST_Contract__c = contr1.Id,Line_Description__c = 'testDesc',
                                                                Cost_Center__c='cost center',
                                                                Risk_Factor__c = 40,Fcst_Revenue_Type__c = 'test');insert cli;
            
            Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c(name='FY2019P08',Fiscal_Quarter__c='Q3',Fiscal_Year__c='2019',
                                                                Month_Number__c=8);insert fym;
            
            
             Actual_Model__c actModel = new Actual_Model__c();
            actModel.Actual_Amount__c = 20000;
            actModel.Account__c = acc.Id;
            actModel.Fiscal_Period__c = fym.Id;
            actModel.FCST_Planning_Version__c = plvr.Id;
            actModel.Revenue_Type__c = 'fcst_type__c';
            actModel.FCST_Contract__c=contr1.id;
            actModel.Contract_LineItem__c = cli.Id;
            actModel.Fiscal_Year__c = fyp.Id;
            actModel.GEO_Description__c='Geo Desc';
            actModel.FCST_GEO__c='Geo';
            actModel.Revenue_Stream__c='Revenue Stream';
            insert actModel;
            
            Test.startTest();
            FCST_Actuals_DataExtract ade= new FCST_Actuals_DataExtract();
            FCST_Actuals_DataExtract.reduceName(TestString);
            ade.getFilterPlanningYear();
            ade.Beginning();
            ade.Previous();
            ade.Next();
            ade.getTotalPages();
            ade.End();
            ade.getDisablePrevious();
            ade.getDisableNext();
            ade.getTotal_size();
            ade.getPageNumber();
            ade.onChangeYear();
            ade.loadLandingUI();
            ade.planningVersion();
            ade.updateWrapperList();
            ade.gotohomepage();
            ade.callBatchClass();
            Test.stopTest();
        }
        
    }
    
}