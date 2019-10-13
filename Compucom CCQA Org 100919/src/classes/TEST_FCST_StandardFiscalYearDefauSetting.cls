@isTest
public with sharing class TEST_FCST_StandardFiscalYearDefauSetting {
    
    public testMethod static void UnitTest(){  
        user u = FCST_Util.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            Configuration_Setting__c confsett = FCST_Util.createConfigurationSettingObj(string.valueOf(system.today().year()));  
            FCST_Util.createOpportunities();
            Date startDate = System.today();
            
            Date endDate = startDate.addDays(30);
            map<Integer,String> mapMonthString  = new map<Integer,String>();
            mapMonthString .put(1,'January');
            mapMonthString .put(2,'February');
            mapMonthString .put(3,'March');
            mapMonthString .put(4,'April');
            mapMonthString .put(5,'May');
            mapMonthString .put(6,'June');
            mapMonthString .put(7,'July');
            mapMonthString .put(8,'August');
            mapMonthString .put(9,'September');
            mapMonthString .put(10,'October');
            mapMonthString .put(11,'November');
            mapMonthString .put(12,'December');
            
            List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
            for(Integer i = 1;i<13;i++){
            
                    lstVersion.add(
                        new Planning_Version__c(
                            Is_this_a_Budget_Planning_Version__c = false,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = '2001',
                            Planning_Version_Current_Period__c= i+'',
                            MonthName__c = mapMonthString.get(i)
                        ));
                 lstVersion.add(
                        new Planning_Version__c(
                            Is_this_a_Budget_Planning_Version__c = true,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = '2001',
                            Planning_Version_Current_Period__c= i+'',
                            MonthName__c = mapMonthString.get(i)
                        ));
                        startDate  = endDate.addDays(1);
                        endDate = startDate.addDays(30);
            } 

            if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
            insert lstVersion;
                System.debug(lstVersion.size());
            System.assertEquals(lstVersion.size(),24);
            }
            
            Date fstartDate = Date.newInstance(2001,1,1);
            Date fendDate = Date.newInstance(2001,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
            if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
            insert fyp;
            }
            
            Additional_Planning_Versions__c addversion1 = new Additional_Planning_Versions__c(Name = 'Budget01', Version_Description__c = 'test');
            if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()){
            insert addversion1;
            }
            
            Additional_Planning_Versions__c addversion2 = new Additional_Planning_Versions__c(Name = 'Budget02', Version_Description__c = 'test');
             if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()){
            insert addversion2;
             }
              
            FCST_configurationSettingControllerV1 config = new FCST_configurationSettingControllerV1();
            test.startTest();
            
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
            config.isCustomFiscalYearEnable = true;        
            config.addAdditionalPlanningVersion();
            config.addFinancialMeasure();
            config.addPlanning12Version();
            config.addPlanning15Version();        
            config.batchRun();
            config.DefaultScriptModel();
           
            
            
            config.getFS_FPMLabel();
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
             test.stopTest();
              
            List<FCST_configurationSettingControllerV1.Org_Period> lstCon = new List<FCST_configurationSettingControllerV1.Org_Period>();
            FCST_configurationSettingControllerV1.Org_Period wclass1 = new FCST_configurationSettingControllerV1.Org_Period(1,'1','2001',1,date.today(),date.today(),2001,'101','jun');
            FCST_configurationSettingControllerV1.Org_Period wclass2 = new FCST_configurationSettingControllerV1.Org_Period(1,'1','2001',1,date.today(),date.today(),2001,'101','jun');
            lstCon.add(wclass1);
            lstCon.add(wclass2);
            lstCon.sort();
        }
    }
}