/*
 Class      ConfigurationSettingControllerV1
 CreatedBy  Habimoon Shaik  17th feb 2018
*/
@isTest
public class TEST_FCST_ConfiguratnSettingControllerV1 {

    //Constructor
    public testMethod static void onLoadTest(){  
        user u = FCST_Util.createUser();                
        System.assertNotEquals(u.Id,null); 
        System.runAs(u)
        {
            List<FS_Calendar__c> lstCalender1 = new List<FS_Calendar__c>();
            FS_Calendar__c customFSCalender1 = new FS_Calendar__c();
            customFSCalender1.Name = '1';
            customFSCalender1.Short_Label__c = 'January';
            customFSCalender1.long_Label__c = 'Jan';
            
            FS_Calendar__c customFSCalender2 = new FS_Calendar__c();
            customFSCalender2.Name = '2';
            customFSCalender2.Short_Label__c = 'February';
            customFSCalender2.long_Label__c = 'Feb';
            
            FS_Calendar__c customFSCalender3 = new FS_Calendar__c();
            customFSCalender3.Name = '3';
            customFSCalender3.Short_Label__c = 'March';
            customFSCalender3.long_Label__c = 'Mar';
            
            FS_Calendar__c customFSCalender4 = new FS_Calendar__c();
            customFSCalender4.Name = '4';
            customFSCalender4.Short_Label__c = 'April';
            customFSCalender4.long_Label__c = 'Apr';
            
            lstCalender1.add(customFSCalender1);
            lstCalender1.add(customFSCalender2);
            lstCalender1.add(customFSCalender3);
            lstCalender1.add(customFSCalender4);
            
            insert lstCalender1;
            
            FCST_FiscalSynchronization.Init();
            List<Fiscal_Year_Planning__c> lstFiscalYears = [select Id from Fiscal_Year_Planning__c LIMIT 1];
            system.assertEquals(lstFiscalYears.size(),1);
            
            List<Fiscal_Year_Model__c> lstFiscalPeriods = [select Id from Fiscal_Year_Model__c LIMIT 12];
            system.assertEquals(lstFiscalPeriods.size(),12);
            
            List<Planning_Version__c> lstFiscalVersions = [select Id from Planning_Version__c LIMIT 15];
            system.assertEquals(lstFiscalVersions.size(),15);
            
            PageReference pageRef = Page.FCST_ConfigurationSettingV1;
            FCST_configurationSettingControllerV1 config = new FCST_configurationSettingControllerV1();
            config.batchRun();
            config.getFYears();
            config.ResetFiscalYears();
            config.saveconfigurationSetting();
            config.saveOppStage();
            config.redirectToFinancialMeasure();
            config.redirectToAddPlan();
            config.resetStages();
            config.getAllSelectedStage();
            config.SaveNewFiscalYears();
            config.getOrgFiscalSetting();
            config.isCustomFiscalYearEnable = false;        
            config.addAdditionalPlanningVersion();
            config.addFinancialMeasure();
            config.addPlanning12Version();
            config.addPlanning15Version();
            config.UpdateConfigureRecord();
            config.DefaultScriptModel();
            
              
            config.getFS_FPMLabel();
            config.getFS_FPMClass();
            config.getFS_FPMLabel();
            config.getFS_FPMDetail();
            config.getFS_OPPLabel();
            config.getFS_OPPClass();
            config.getFS_OPPDetail();
            config.getFS_PMsLabel();
            config.getFS_PMsClass();
            config.getFS_PMsDetail();
            config.getFS_BVsLabel();
            config.getFS_BVsClass();
            config.getFS_BVsDetail();
            config.getFS_PFPLabel();
            config.getFS_PFPClass();
            config.getFS_PFPDetail();
            config.getFS_PVsLabel();
            config.getFS_PVsClass();
            config.getFS_PVsDetail();
           
            
            config.getInstanceURL();
            config.getforecast_BacklogFiscaYear();
            config.getforecast_OpportunityStages();
            config.getforecast_BudgetVersions();
            config.getforecast_PlanningFiscalPeriods();
            config.getforecast_PlanningVersions();
            config.getforecast_PlanningMeasures();
            config.getforecast_M_BacklogFiscaYear();
            config.getforecast_M_OpportunityStages();
            config.getforecast_M_BudgetVersions();
            config.getforecast_M_PlanningFiscalPeriods();
            config.getforecast_M_PlanningVersions();
            config.getforecast_M_PlanningMeasures();
            config.getforecast_M_Warning();
            config.getaddplanningVersionlistview();
            config.getstrStages();
            config.getstrCategories();
            config.getstrSavedStages();
            config.getstrSavedCategories();
            config.getFiscalYear();
            config.getfinancelistview();
            
            FCST_configurationSettingControllerV1.WOpportunityFiscalYear w = new FCST_configurationSettingControllerV1.WOpportunityFiscalYear(null,false,'test');

        }     
    }
    
   public testMethod static void onLoadTest1(){  
        user u = FCST_Util.createUser();                
        System.assertNotEquals(u.Id,null); 
        System.runAs(u)
        {
        List<Fiscal_Year_Planning__c> fiscalYearPlanning = new List<Fiscal_Year_Planning__c>();
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            Fiscal_Year_Planning__c fyp1 = new Fiscal_Year_Planning__c(Name = '2019',StartDate__c = fstartDate,EndDate__c = fendDate);
            fiscalYearPlanning.add(fyp);
            fiscalYearPlanning.add(fyp1);
            insert fiscalYearPlanning;
            
            Gap_Planning_Version__c objGapVersion = new Gap_Planning_Version__c();
            objGapVersion.Name = 'Q1 Gap';
            objGapVersion.Version_Description__c = 'This is Test';
            
            insert objGapVersion;
            
              
            Additional_Planning_Versions__c addversion1 = new Additional_Planning_Versions__c(Name = 'Budget01', Version_Description__c = 'test');
            insert addversion1;
            
            Map<id,Additional_Planning_Versions__c> mapAddData = new  Map<id,Additional_Planning_Versions__c>();
            mapAddData.put(addversion1.id,addversion1);
            
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018-January';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fiscalYearPlanning[0].Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Is_this_a_Gap_Planning_Version__c = true;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            plversionObj.Additional_Planning_Version__c = addversion1.id;
            
            insert plversionObj;
          
            
            set<string> setFYesr = new set<string> {'2018','2019'};
            FCST_FiscalSynchronization.CreatePlanningVersionForAdditional(setFYesr);
            FCST_FiscalSynchronization.CreatePlanningVersionForGap(setFYesr);
            FCST_FiscalSynchronization.deleteAddPlanningVersion(mapAddData);
        }
    }
    }