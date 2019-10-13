@isTest
private class Test_FCST_AfterPlanningVersionTrigger {

	private static testMethod void test() {
         FCST_UTIL.InsertTriggerMappingFields();
	    List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
	     List<Fiscal_Year_Model__c> lstPYearPeriod= new List<Fiscal_Year_Model__c>();
	    List<Fiscal_Year_Planning__c> fiscalYearPlanning = new List<Fiscal_Year_Planning__c>();
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            fiscalYearPlanning.add(fyp);
            insert fiscalYearPlanning;
            lstPYearPeriod = FCST_UTIL.createFiscalYearPeriods(fiscalYearPlanning);
            insert lstPYearPeriod;
            
	        Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fiscalYearPlanning[0].Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2018';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='In Progress';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            lstVersion.add(plversionObj);
            
            if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
                insert lstVersion;
            }
            
            Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2018';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fiscalYearPlanning[0].Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='In Progress';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            plversionObj1.Previous_Version__c = plversionObj.id;
            
            insert plversionObj1;

        List<Account> accList = new List<Account>();
            for(Integer i=0;i<4;i++){
                Account acc = new Account(Name='Test Account'+i);
                accList.add(acc);
            }
            if(accList!=null && accList.size()>0)
             insert accList;
              Date myDate = startDate.addDays(31);
                     List<Opportunity> oppList = new list<Opportunity>();
            for(Account acc :accList){
                System.debug('acc>>>>>>>>'+acc.Name+'>>>>>>>>>..acc.Id'+acc.Id);
                for(Integer i=1;i<5;i++){
                    Opportunity opp = new Opportunity();
                      opp.Name='Test Committed'+i; opp.AccountID=acc.Id; opp.Submitted_for_Planning_Version__c = plversionObj.id;opp.stageName = 'Prospecting'; opp.CloseDate=myDate;
                    oppList.add(opp);
                }
            }
           
            if(oppList!=null && oppList.size()>0)
             insert oppList;
             
             
            Planning_Version__c updatePlversionObj = new Planning_Version__c();
            updatePlversionObj.id = plversionObj1.id;
            updatePlversionObj.Version_Status__c = 'Open (Admin)';
            update updatePlversionObj;



	}

}