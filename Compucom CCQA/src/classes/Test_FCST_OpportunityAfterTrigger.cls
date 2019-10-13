@isTest
public class Test_FCST_OpportunityAfterTrigger {
    static testMethod void getOpptData(){
         FCST_UTIL.InsertTriggerMappingFields();
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        Date myDate1 = date.newInstance(2018,12,18);
        Date fstartDate = date.newInstance(2020,02,28);    
        Date fendDate = Date.newInstance(2020,01,19);
        
        FCST_Trigger__c trig = new FCST_Trigger__c();
        
        trig.Name = 'TriggerMapping';
       // trig.Account_Trigger__c = true;
       // trig.FCST_LineItem_Trigger__c = true;
       // trig.Product_Trigger__c = true;
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
        
        
       /* Mapping_Setting__c theCustomSet = new Mapping_Setting__c();
        theCustomSet.Name = 'FCST Mapping Data';
      
        
        insert theCustomSet;*/
        
        Opportunity opt = new Opportunity();
        opt.Name = 'Test Opportunity';
        opt.AccountId = a.Id;
        opt.Is_Submitted__c = true;
        opt.CloseDate=System.today();
        opt.StageName='Prospecting';
        insert opt;
        opt.Is_Submitted__c = false;
        update opt;
       // FCST_OpportunityClosed.DeleteProductModel(optList,opMap);
        
        Product2 testProduct = new Product2(Name = 'Hardware', IsActive = true);
        insert testProduct;
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        update standardPricebook;
        
         PricebookEntry p = new PricebookEntry(Pricebook2Id = standardPricebook.id,Product2Id = testProduct.id,UnitPrice = 1000,IsActive = true);
        insert p;
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        
        OpportunityLineItem item = new OpportunityLineItem();
        item.TotalPrice = 1000;     
        item.OpportunityId = opt.Id;
        item.PricebookEntryId = p.Id;
        item.Quantity = 2;
        item.ServiceDate = myDate1;
        item.Product2Id=testProduct.Id;
        item.Risk_Factor__c = 10;
        insert item;   
     item.Quantity = 3;
       update item;
        
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
        
        Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=fstartDate;
            plversionObj1.Data_Entry_Closed_Date__c=fendDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            insert plversionObj1;

        list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
                FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
                prdModel.Account__c = a.Id;
                prdModel.Opportunity__c = opt.Id;
                prdModel.FCST_Product_Line_ID__c= 'Test Product';
                prdModel.Planning_Version__c =plversionObj1.Id;
                prdModel.Weighted_Revenue__c = 10;
                prdModel.Amount__c = 100;
                prdModel.Product__c = testProduct.id;
                prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist;       
        
        FCST_Product_Model__c prdModels= [select Id,Model_Name__c,Product__c,Opportunity__c,FCST_Product_Line_ID__c from FCST_Product_Model__c where Id =: pmlist[0].Id];
   delete prdModels;
        
         item.Quantity = 4;
       update item;
    
    }
    static testMethod void getOpptData2(){
         FCST_UTIL.InsertTriggerMappingFields();
        Account ac = new Account();
        ac.Name = 'Test Account';
        insert ac;
        Date myDate1 = date.newInstance(2018,12,18);
        Mapping_Setting__c theCustomSet = new Mapping_Setting__c();
        theCustomSet.Name = 'FCST Mapping Data';
      	theCustomSet.Geo__c='geo_test__c';
        insert theCustomSet;      
           
        
       // FCST_OpportunityClosed.DeleteProductModel(optList,opMap);
        
        Product2 testProduct = new Product2(Name = 'Hardware', IsActive = true);
        insert testProduct;
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        update standardPricebook;
        
         PricebookEntry testPbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert testPbe;
        Opportunity opt2 = new Opportunity();
        opt2.Name = 'Test Opportunity2';
        opt2.AccountId = ac.Id;
        opt2.CloseDate=System.today();
        opt2.StageName='Prospecting';
        insert opt2;
        opt2.StageName ='Closed Lost';
        Update opt2;
     
        FCST_Product_Model__c prodModel1 = new FCST_Product_Model__c();
           // prodModel1.Forecast_Categeory__c = 'Test Category';
            prodModel1.Opportunity__c = opt2.id;
            prodModel1.Product__c = testProduct.id;
            insert prodModel1;
        
    }
}