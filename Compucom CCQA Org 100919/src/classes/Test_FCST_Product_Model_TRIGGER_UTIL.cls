@isTest
public class Test_FCST_Product_Model_TRIGGER_UTIL {
    static testMethod void getPrdData(){
         FCST_UTIL.InsertTriggerMappingFields();
        List<Fiscal_Year_Planning__c> fiscalYearPlanning = new List<Fiscal_Year_Planning__c>();
        Date fstartDate = Date.newInstance(2018,1,1);
        Date fendDate = Date.newInstance(2018,12,31);
        Date myDate = date.newInstance(2018,05,22);
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
            
        
        
        list<Fcst_Rev_Rec_Revenue_Type__c> plist = new list<Fcst_Rev_Rec_Revenue_Type__c>();
        Set<Id> fymId = new Set<Id>();
        Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c(Name='FY2018P01',Fiscal_Year__c='2018',Start_Date__c=system.today(),End_Date__c=system.today()+1,Period_Number__c=1);
        insert fym;
        fymId.add(fym.Id);
        
        Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2018',StartDate__c = fstartDate,EndDate__c = fendDate);
        fiscalYearPlanning.add(fyp);
        insert fiscalYearPlanning;
        Configuration_Setting__c theConfigSetting = new Configuration_Setting__c();
        theConfigSetting.Name = '2018';
        
        theConfigSetting.Stage__c = 'Negotiation/Review,Closed Won,Proposal/Price Quote,Perception Analysis,Id. Decision Makers,Value Proposition,Needs Analysis,Qualification,Prospecting,';
        
        insert theConfigSetting;
        String str = '12-11-2012';
        Set<Id> setIds = new Set<Id>();
        
        Account ac = new Account();
        ac.Name = 'Test';
        ac.FCST_CPM_Region__c = 'fcst_cpm_region__c';
        //ac.FCST_Account_Sub_Region__c = 'fcst_account_sub_region__c';
        //ac.FCST_Account_Sub_Region__c = 'fcstAccReg';
        insert ac;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        update standardPricebook;
        
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.assertEquals(true, standardPricebook.IsStandard, 'The Standard Pricebook should now return IsStandard = true');
        
        Product2 testProduct = new Product2(Name = 'Hardware',IsActive = true,ProductCode='1.0');
        insert testProduct;
        
        
        PricebookEntry testPbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert testPbe;
        
        PricebookEntry prd = [Select Id,Name from PricebookEntry where Product2.Name='Hardware' AND isActive=true LIMIT 1];
        System.assertEquals('Hardware',prd.Name);
        
        Set<Id> oppId = new Set<Id>();
        
        Opportunity opt = new Opportunity();
        opt.Name = 'Test Opportunity';
        opt.AccountId= ac.Id;
        opt.Partial_Shipments__c = 'Yes';
        opt.Fcst_Type__c = 'Project';
        //opt.Fcst_Text_QNum__c = 'tfcst_q__cest';
        opt.CloseDate=System.today();
        opt.StageName='Closed Won';
        insert opt;
        oppId.add(opt.Id);

        List<Planning_Version__c> plVersion = new List<Planning_Version__c>();
       Set<Id> plvId = new Set<Id>();
        Planning_Version__c plversionObj = new Planning_Version__c();
        plversionObj.Name='2018-January';
        plversionObj.Data_Entry_Start_Date__c=fstartDate;
        plversionObj.Data_Entry_Closed_Date__c=fendDate;
        plversionObj.Is_this_a_Budget_Planning_Version__c=false;
        plversionObj.Is_this_a_Gap_Planning_Version__c=false;
        plversionObj.Version_Status__c='Open (Admin)';
       // plVersion.add(plversionObj);
        insert plversionObj;
        plvId.add(plversionObj.Id);
        
        List<Planning_Financial_Measure__c> plmList = new List<Planning_Financial_Measure__c>();
        for(Integer i=0;i<10;i++){
            Planning_Financial_Measure__c plm = new Planning_Financial_Measure__c();
            plm.Name = 'Revenue';
            plmList.add(plm);
        }
        if(plmList!=null && !plmList.isEmpty()){
            insert plmList;
        }
        
      List<FCST_Product_Model__c> prdModelList = new List<FCST_Product_Model__c>();
        for(Integer i=0;i<10;i++){
        FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = ac.Id;
            prdModel.Amount__c = 20000;
            prdModel.Product__c = testProduct.Id;
            prdModel.Planning_Version__c = plversionObj.Id;
            prdModel.Comments__c = 'TestData';
            prdModel.Fiscal_Period__c = fym.Id;
            prdModel.Planning_Measure__c = plmList[0].Id;
            prdModel.Opportunity__c = opt.Id;
            prdModelList.add(prdModel);
        }
        if(prdModelList!=null && !prdModelList.isEmpty()){
           insert prdModelList;
        }
        FCST_Product_Model_Trigger_Util.AddOpporunityInitailModels(oppId,fymId,plvId,prdModelList);
        
    }
}