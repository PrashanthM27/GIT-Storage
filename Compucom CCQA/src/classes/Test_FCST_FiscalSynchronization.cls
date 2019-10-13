@isTest
public class Test_FCST_FiscalSynchronization {

    static testmethod void getData1(){
      user u = [select id from user where id=:userinfo.getUserId()];                
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
            FCST_FiscalSynchronization.Init();
            FCST_FiscalSynchronization.CreatePlanningVersionForAdditional(setFYesr);
            FCST_FiscalSynchronization.CreatePlanningVersionForGap(setFYesr);
            FCST_FiscalSynchronization.deleteAddPlanningVersion(mapAddData);
        }
    }  
    
    
}