@isTest
public class Test_FCSTBatchHandleAccountTrigger {
    static testMethod void Test_AccountTrigger(){
        user usr=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        FCST_UTIL.InsertTriggerMappingFields();
        FCST_Trigger__c tri = new FCST_Trigger__c();
        tri.Name = 'TriggerMapping';
        tri.Account_Trigger__c = true;
       // tri.Product_Trigger__c  =true;
        insert tri;
        Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                          Fcst_BusinessUnit__c = 'deal_duration__c',
                                                          Fcst_EndDate__c = 'fcst_end_date__c',
                                                          FCST_Program_Executive__c = 'fcst_program_executive__c',
                                                          FCST_BSLA__c = 'fcst_bsla__c',
                                                          FCST_GeoCodes__c = 'fcst_geocodes__c',
                                                          Opportunity_SVC_YR1__c = 'amount',
                                                          Opportunity_TCV__c = 'deal_tcv__c',
                                                          Term_In_Months__c = 'deal_duration__c',
                                                          Transition_Date__c = 'closedate',
                                                          Cost_Center__c='fcst_cost_center__c',
                                                          Fcst_CPM__c='fcst_cpm_region__c',
                                                          Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                          Fcst_StartDate__c='fcst_start_date__c',
                                                          Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                          FCST_ProgramManager__c= 'lastmodifiedbyid',
                                                          Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                          Geo__c='geo_test__c',
                                                          Geo_Name__c='geo_name__c',
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        Date srtDate = date.newInstance(2020,02,28);    
        Date endate = Date.newInstance(2020,01,19); 
        
        
        
        List<Account> acList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.FCST_CPM_Region__c = 'US-DC Area';
        ac.FCST_Program_Executive__c = usr.Id;
        ac.FCST_Account_Sub_Region__c = 'Canada East';
        ac.FCST_GeoCodes__c = 'Test GEO';
        ac.FCST_Program_Manager__c = usr.Id;
        acList.add(ac);
        insert acList;
        
        List<Opportunity> optList = new List<Opportunity>();
        Opportunity opt = new Opportunity();
        opt.Name = 'Test Oppt1';
        opt.CloseDate = srtDate;
        opt.StageName = 'Prospecting';
        opt.FCST_Script__c = true;
        optList.add(opt);
        insert optList;
        
        List<FCST_Product_Model__c> modelList = new List<FCST_Product_Model__c>();
        FCST_Product_Model__c models = new FCST_Product_Model__c();
        models.Account_CPM_Region__c = setting.Fcst_CPM__c;
        models.Account__c = acList[0].Id;
        models.Opportunity__c = optList[0].Id;
        modelList.add(models);
        insert modelList;
        
        FCSTBatchToHandleAccountTrigger batch = new FCSTBatchToHandleAccountTrigger(acList);
        // batch.Start(NULL);
        database.executeBatch(batch,200);
        
        //  FCST_AccountTriggerHandler.updateMOdelCPM(optList);
    }
    
    static testMethod void Test_AccountTriggerHandler(){
        user usr=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        FCST_UTIL.InsertTriggerMappingFields();
        Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                          Fcst_BusinessUnit__c = 'deal_duration__c',
                                                          Fcst_EndDate__c = 'fcst_end_date__c',
                                                          FCST_Program_Executive__c = 'fcst_program_executive__c',
                                                          FCST_BSLA__c = 'fcst_bsla__c',
                                                          FCST_GeoCodes__c = 'fcst_geocodes__c',
                                                          Opportunity_SVC_YR1__c = 'amount',
                                                          Opportunity_TCV__c = 'deal_tcv__c',
                                                          Term_In_Months__c = 'deal_duration__c',
                                                          Transition_Date__c = 'closedate',
                                                          Cost_Center__c='fcst_cost_center__c',
                                                          Fcst_CPM__c='fcst_cpm_region__c',
                                                          Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                          Fcst_StartDate__c='fcst_start_date__c',
                                                          Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                          FCST_ProgramManager__c= 'lastmodifiedbyid',
                                                          Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                          Geo__c='geo_test__c',
                                                          Geo_Name__c='geo_name__c',
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        
        
        Date srtDate = date.newInstance(2020,02,28);    
        Date endate = Date.newInstance(2020,01,19);
        
        List<Account> acList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.FCST_CPM_Region__c = 'US-DC Area';
        ac.FCST_Program_Executive__c = usr.Id;
        ac.FCST_Account_Sub_Region__c = 'Canada East';
        ac.FCST_GeoCodes__c = 'Test GEO';
        ac.FCST_Program_Manager__c = usr.Id;
        acList.add(ac);
        insert acList;
        
        List<Opportunity> optList = new List<Opportunity>();
        Opportunity opt = new Opportunity();
        opt.Name = 'Test Oppt';
        opt.CloseDate = srtDate;
        opt.AccountId = acList[0].Id;
        opt.StageName = 'Prospecting';
        opt.FCST_Script__c = true;
        optList.add(opt);
        insert optList;
        
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true,FCST_Revenue_Type__c ='Software'
        );
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        List<OpportunityLineItem> lstInsertOpp = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(Risk_Factor__c = 10,Product2=prod,Fcst_Auto_Script__c=false,OpportunityId = optList[0].Id,Quantity = 5,pricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
        
        lstInsertOpp.add(oli);
        insert lstInsertOpp;
        
        ac.FCST_CPM_Region__c='US-West';
        update ac;
        oli.Fcst_Auto_Script__c=false;
        update oli;
        
        // FCST_InsertProductModel.AddModels(lstInsertOpp);
        
    }
    
    static testMethod void Test_FCSTOpportunityLineTrigger(){
        user usr=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        FCST_Trigger__c trig = new FCST_Trigger__c();
        
        trig.Name = 'TriggerMapping';
        trig.Account_Trigger__c = true;
        trig.FCST_LineItem_Trigger__c = true;
        trig.Product_Trigger__c = true;
        trig.FCST_Opportunity_Trigger__c = true;
        insert trig;
        
        FCST_UTIL.InsertTriggerMappingFields();
        Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                          Fcst_BusinessUnit__c = 'deal_duration__c',
                                                          Fcst_EndDate__c = 'fcst_end_date__c',
                                                          FCST_Program_Executive__c = 'fcst_program_executive__c',
                                                          FCST_BSLA__c = 'fcst_bsla__c',
                                                          FCST_GeoCodes__c = 'fcst_geocodes__c',
                                                          Opportunity_SVC_YR1__c = 'amount',
                                                          Opportunity_TCV__c = 'deal_tcv__c',
                                                          Term_In_Months__c = 'deal_duration__c',
                                                          Transition_Date__c = 'closedate',
                                                          Cost_Center__c='fcst_cost_center__c',
                                                          Fcst_CPM__c='fcst_cpm_region__c',
                                                          Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                          Fcst_StartDate__c='fcst_start_date__c',
                                                          Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                          FCST_ProgramManager__c= 'lastmodifiedbyid',
                                                          Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                          Geo__c='geo_test__c',
                                                          Geo_Name__c='geo_name__c',
                                                          Fcst_Q__c='division__c');
        insert setting;
        
        
        
        
        Date fstartDate = date.newInstance(2020,02,28);    
        Date fendDate = Date.newInstance(2020,01,19);
        
        List<Account> acList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.FCST_CPM_Region__c = 'US-DC Area';
        ac.FCST_Program_Executive__c = usr.Id;
        ac.FCST_Account_Sub_Region__c = 'Canada East';
        ac.FCST_GeoCodes__c = 'Test GEO';
        ac.FCST_Program_Manager__c = usr.Id;
        acList.add(ac);
        insert acList;
        
        List<Opportunity> optList = new List<Opportunity>();
        Opportunity opt = new Opportunity();
        opt.Name = 'Test Oppt';
        opt.CloseDate = fstartDate;
        opt.AccountId = acList[0].Id;
        opt.StageName = 'Prospecting';
        opt.FCST_Script__c = true;
        optList.add(opt);
        insert optList;
        
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
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true,FCST_Revenue_Type__c ='Software'
        );
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        List<OpportunityLineItem> lstInsertOpp = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(Risk_Factor__c = 10,Product2=prod,Fcst_Auto_Script__c=false,OpportunityId = optList[0].Id,Quantity = 5,pricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
        
        lstInsertOpp.add(oli);
        insert lstInsertOpp;
        
        
        Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=fstartDate;
            plversionObj.Data_Entry_Closed_Date__c=fendDate;
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
        
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
                FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
                prdModel.Account__c = acList[0].Id;
                prdModel.FCST_Product_Line_ID__c = 'Test Product';
                prdModel.Opportunity__c = optList[0].Id;
                prdModel.FCST_Product_Line_ID__c=oli.id;
                prdModel.Planning_Version__c =plversionObj.Id;
                prdModel.User_Adjusted_Revenue__c = 2000;
                prdModel.Weighted_Revenue__c = 10;
                prdModel.Amount__c = 100;
                prdModel.Product__c = prod.id;
                prdmodel.Fiscal_Period__c = fymList[0].Id;
                pmlist.add(prdmodel);
            }
            insert pmlist; 
        
        List<FCST_Product_Model__c> prdModelList = [select Id,Model_Name__c,Product__c,Opportunity__c,FCST_Product_Line_ID__c from FCST_Product_Model__c where Opportunity__c =: optList[0].Id];
         
        
        oli.Fcst_Auto_Script__c=True;
        //lstInsertOpp.add(oli);
        upsert lstInsertOpp;
        
        delete prdModelList;
        
    }
}