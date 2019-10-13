@isTest
public class Test_FCSTBatchToHandleProductTrigger {
    static testMethod void Test_AccountTrigger(){
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
        
        List<Product2> prdList = new List<Product2>();
        Product2 prd = new Product2();
        prd.Name = 'Test Product';
        prdList.add(prd);
        insert prdList;
        
        FCST_Trigger__c tri = new FCST_Trigger__c();
        tri.Name = 'TriggerMapping';
        tri.Account_Trigger__c = true;
        tri.Product_Trigger__c  =true;
        insert tri;
        
        List<Account> acList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.FCST_CPM_Region__c = setting.Fcst_CPM__c;
        acList.add(ac);
        insert acList;
        
        List<Opportunity> optList = new List<Opportunity>();
        Opportunity opt = new Opportunity();
        opt.Name = 'Test Oppt';
        opt.CloseDate = System.today();
        opt.StageName = 'Prospecting';
        optList.add(opt);
        insert optList;
        
        List<FCST_Product_Model__c> modelList = new List<FCST_Product_Model__c>();
        FCST_Product_Model__c models = new FCST_Product_Model__c();
        models.Account_CPM_Region__c = setting.Fcst_CPM__c;
        models.Account__c = acList[0].Id;
        models.Opportunity__c = optList[0].Id;
        modelList.add(models);
        insert modelList;
        
        FCSTBatchToHandleProductTrigger batch = new FCSTBatchToHandleProductTrigger(prdList);
       // batch.Start(NULL);
        batch.Execute(NUll,modelList);
        batch.finish(NULL);
    }
    
    static testMethod void Test_ProductTrigger(){
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
        OpportunityLineItem oli = new OpportunityLineItem(Risk_Factor__c = 10,Product2=prod,Fcst_Auto_Script__c=true,OpportunityId = optList[0].Id,Quantity = 5,pricebookEntryId = pbEntry.Id,TotalPrice = 5 * pbEntry.UnitPrice);
        
        lstInsertOpp.add(oli);
        insert lstInsertOpp;

        prod.FCST_Revenue_Type__c = 'Excell';
        update prod;
}
}