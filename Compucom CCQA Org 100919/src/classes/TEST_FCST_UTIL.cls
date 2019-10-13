@isTest
public class TEST_FCST_UTIL {
    
    testMethod static void testCase1(){
        String cyear ='2018';
        String measure = 'Revenue';
        List<Fiscal_Year_Model__c> lstPYearPeriod= new List<Fiscal_Year_Model__c>();
        List<Opportunity> oppList = new list<Opportunity>();
        List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
        List<Product2> productList = new List<Product2>();
        List<Fiscal_Year_Planning__c> fiscalYearPlanning = new List<Fiscal_Year_Planning__c>();
        List<String> lstYears = new List<String>();
        lstYears.add(cyear);
        User loginUser = FCST_Util.createUser(); 
        System.runAs(loginUser){
             FCST_UTIL.InsertTriggerMappingFields();
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
            fiscalYearPlanning.add(fyp);
            insert fiscalYearPlanning;
          
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
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            
            insert plversionObj;
            
            
           
           

            lstPYearPeriod = FCST_Util.createFiscalYearPeriods(fiscalYearPlanning);
            insert lstPYearPeriod;
            
            List<Account> accList = new List<Account>();
            for(Integer i=0;i<4;i++){
                Account acc = new Account(Name='Test Account'+i,OwnerId=loginUser.id);
                accList.add(acc);
            }
            if(accList!=null && accList.size()>0)
             insert accList;
            Date myDate = date.newInstance(2018,05,22);
       
            
            for(Account acc :accList){
                System.debug('acc>>>>>>>>'+acc.Name+'>>>>>>>>>..acc.Id'+acc.Id);
                for(Integer i=1;i<5;i++){
                    Opportunity opp = new Opportunity();
                      opp.Name='Test Optimistic'+i; 
                      opp.AccountID=acc.Id; 
                      opp.stageName = 'Prospecting'; 
                      opp.CloseDate=myDate;
                      opp.Is_Submitted__c = false;
                      opp.Submitted_for_Planning_Version__c = plversionObj.id;
                     
                      oppList.add(opp);
                }
            }
            if(oppList!=null && oppList.size()>0)
             insert oppList;
            
               Id pricebookId = Test.getStandardPricebookId();
            
            
            for(Integer i=1;i<2;i++){
                Product2 prod = new Product2(Name = 'Product X'+i,ProductCode = 'Pro-X',isActive = true,Family='1.1 Fix Internet');
                productList.add(prod);
            }
            if(productList!=null && productList.size()>0)
               insert productList;
            
            List<PricebookEntry> pbEntryList = new List<PricebookEntry>();
            for(Integer i=1;i<2;i++){
                PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = productList[0].Id,UnitPrice = 100.00*i,IsActive = true);
                pbEntryList.add(pbEntry);
            }
            if(pbEntryList!=null && pbEntryList.size()>0)
               insert pbEntryList;
            
            System.debug('acclist>>>>'+accList);
            
            
        FCST_UTIL fc = new FCST_UTIL();
        FCST_UTIL.InsertMappingFields();
        FCST_UTIL.createAccount();
        FCST_UTIL.createConfigurationSettingObj(cyear);
        FCST_UTIL.createOpportunities();
        FCST_UTIL.createMeasure(measure);
        FCST_UTIL.CreateRevenueRegognization('Test','Test',1000);
       FCST_UTIL.createOpportunity('Test',accList[0].id,'Regular');
       FCST_UTIL.createOpportunity1('TestOpp',accList[0].id);
       FCST_UTIL.createOpportunityProduct(oppList[0],productList[0],pbEntryList[0]);
       FCST_UTIL.createPricebookEntry(pricebookId,productList[0]);    
        FCST_UTIL.createProduct('TestProd','8566',4566);
        FCST_UTIL.createFiscalYear(lstYears);
        FCST_UTIL.createPlanningVersion(fiscalYearPlanning);
        FCST_UTIL.createOpportunity1('TestOpp',accList[0].id);    
    }
  }

}