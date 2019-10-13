@isTest
public class test_FCST_HyperLinkUpload_Controller {
    @TestSetup static void TestData(){
        
             FCST_UTIL.InsertTriggerMappingFields();
            Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',
                                                              FCST_BSLA__c='fcst_bsla__c',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
         Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2019',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<13;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2019P0'+string.valueOf(i)):('FY2019P'+string.valueOf(i));
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
                fym.Month_Number__c = i;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30); Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='January-2019';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2019';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            plversionObj.Is_this_a_Budget_Planning_Version__c = false;
            plversionObj.Is_this_a_Gap_Planning_Version__c = false;
            insert plversionObj;
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='US-DC Area');
            insert acc;
            Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
                opt.AccountId = acc.Id;
            	opt.FCST_BSLA__c='10C363';
                opt.StageName = 'Prospecting';
                opt.CloseDate = fendDate;
            insert opt;
            
            Product2 prod = new Product2(Name = 'Product X', ProductCode = 'Pro-X', isActive = true, Family = 'Hosted Services',
                                        fcst_cost_center__c='US');
       	    insert prod;
            
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<13;i++){
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acc.Id;
            prdModel.Opportunity__c = opt.Id;
            //prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c =plversionObj.Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdModel.User_Adjusted_Revenue__c=25000;
            prdModel.FCST_Revenue_Types__c='Annuity';
            prdModel.Product__c = prod.id;
            prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist;   
            FCST_Contract__c contr = new FCST_Contract__c();
            // contr.name = 'Contract412368';
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';	
            contr.Contract_Owner__c= u.id;
            insert contr;
            
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            //  fcl.name = 'sample test';
            fcl.FCST_Contract__c = contr.id;
            fcl.Risk_Factor__c = 100;
            fcl.FCST_Fiscal_Year_List__c = fyp.id;
            fcl.BSLA_Number__c = '20';
            fcl.Cost_Center__c = 'Test Center';
            fcl.Cost_Center_Description__c = 'Test Descr';  
            fcl.Fcst_Revenue_Type__c = 'Test Rev';
            fcl.BSLA__c = 'BSLA';
            insert fcl;
            
         list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
            for(Integer i=1;i<13;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                //for(integer i=0;i<101;i++){
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.FCST_Fiscal_Year_List__c = fyp.id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            
            
            FCST_Initial_Forecast__c flist1= new FCST_Initial_Forecast__c();
                //for(integer i=0;i<101;i++){
                flist1.name='Contract412368';
                flist1.Account__c =acc.id;
                flist1.FCST_Contract__c = contr.id;
                flist1.Contract_LineItem__c = fcl.id;
                flist1.Planning_Version__c = plversionObj.Id;
                flist1.FCST_Planning_Fiscal_Year__c=fymList[0].id;
                flist1.FCST_Fiscal_Year_List__c = fyp.id;
                flist1.Fcst_Amount__c = 2000;
            insert flist1;
    }
    
    static testmethod void getData1(){
         user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        system.runAs(u){
         test.startTest();
        FCST_HyperLinkUpload_Controller.wrapperContractLineItem wrap = new FCST_HyperLinkUpload_Controller.wrapperContractLineItem('','','','','','',
                                                                      new list<Double>{2.99884,3.45323});
            FCST_HyperLinkUpload_Controller hlc = new FCST_HyperLinkUpload_Controller();    
            hlc.OnChangeYear();
            hlc.getFilterPlanningYear();
            hlc.updateWrapperList();
            hlc.gotohomepage();
            hlc.callBatchClass();
         test.stopTest();
        }
    }
    
    static testmethod void HyperLinkBatch(){
         user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        system.runAs(u){
            Account acc=[select id,name from account];
            Opportunity opt=[select id,name from opportunity];
            Fiscal_Year_Planning__c fyp=[select Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c];
            list<Planning_Version__c> plversionObj=[select Name,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Fiscal_Year_Planning__c,Planning_Version_Fiscal_Year__c,Long_Label__c,
                                    Version_Status__c,Month_Number__c,MonthName__c,Period_Number__c,Planning_Version_Current_Period__c,SequenceNo__c,
                                    Is_this_a_Budget_Planning_Version__c,Is_this_a_Gap_Planning_Version__c from Planning_Version__c];
            product2 prod=[select Name,ProductCode,isActive,Family,fcst_cost_center__c from product2];
            
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
         
            for(Integer i=1;i<13;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2019P0'+string.valueOf(i)):('FY2019P'+string.valueOf(i));
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
                fym.Month_Number__c = i;              
                fymList.add(fym);
                
            }
            system.debug('fymList.size() '+fymList.size());
                insert fymList;
           
            list<FCST_Product_Model__c> pmlist= new list<FCST_Product_Model__c>();
            for(integer i=0;i<12;i++){
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acc.Id;
            prdModel.Opportunity__c = opt.Id;
            //prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c =plversionObj[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdModel.User_Adjusted_Revenue__c=25000;
            prdModel.FCST_Revenue_Types__c='Annuity';
            prdModel.Product__c = prod.id;
        
              prdmodel.Fiscal_Period__c = fymList[i].id;
                pmlist.add(prdmodel);}
            system.debug('pmlist.size() '+pmlist.size());
            insert pmlist;   
            
 Opportunity opt1 = new Opportunity(Name = 'oppy1',StageName ='Qualify',CloseDate = fendDate,type='Annuity');insert opt1;
 FCST_Product_Model__c pm1 = new FCST_Product_Model__c(FCST_Revenue_Types__c='eXcell',Opportunity__c = opt1.Id);insert pm1; 
             
            FCST_HyperLinkUpload_Batchs_Download HLB = new FCST_HyperLinkUpload_Batchs_Download('2019');
            Database.executeBatch(HLB);
            HLB.revenueTypeGetValue(pm1);
        }
    }
    
    static testMethod void Test_HyperLink_Batch_Download(){
        
             FCST_UTIL.InsertTriggerMappingFields();
            Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',
                                                              FCST_BSLA__c='fcst_bsla__c',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
         Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2019',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            map<integer,Fiscal_Year_Model__c> fymmap = new map<integer,Fiscal_Year_Model__c>();
            for(Integer i=1;i<13;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = i<10?('FY2019P0'+string.valueOf(i)):('FY2019P'+string.valueOf(i));
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
                fym.Month_Number__c = i;
                fymmap.put(i,fym);
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30); Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='January-2019';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
            plversionObj.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj.Planning_Version_Fiscal_Year__c='2019';
            plversionObj.Long_Label__c='January';
            plversionObj.Version_Status__c='Open (Admin)';
            plversionObj.Month_Number__c=1;
            plversionObj.MonthName__c='January';
            plversionObj.Period_Number__c=1;
            plversionObj.Planning_Version_Current_Period__c='1';
            plversionObj.SequenceNo__c=1;
            plversionObj.Is_this_a_Budget_Planning_Version__c = false;
            plversionObj.Is_this_a_Gap_Planning_Version__c = false;
            insert plversionObj;
            Account acc = new Account(Name='Test Account',FCST_CPM_Region__c='US-DC Area');
            insert acc;
            Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
                opt.AccountId = acc.Id;
            	opt.FCST_BSLA__c='10C363';
                opt.StageName = 'Prospecting';
                opt.CloseDate = fendDate;
            insert opt;
            
            Product2 prod = new Product2(Name = 'Product X', ProductCode = 'Pro-X', isActive = true, Family = 'Hosted Services',
                                        fcst_cost_center__c='US');
       	    insert prod;
            
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<13;i++){
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acc.Id;
            prdModel.Opportunity__c = opt.Id;
            //prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c =plversionObj.Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdModel.User_Adjusted_Revenue__c=25000;
            prdModel.FCST_Revenue_Types__c='Annuity';
            prdModel.Product__c = prod.id;
            prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist;
        
            
            FCST_Contract__c contr = new FCST_Contract__c();
            // contr.name = 'Contract412368';
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';	
            contr.Contract_Owner__c= u.id;
            insert contr;
        
         List<FCST_Contract__c> contrList = new List<FCST_Contract__c>();
           FCST_Contract__c contr1 = new FCST_Contract__c();
            // contr.name = 'Contract412368';
            contr1.Fcst_Account__c = acc.Id;
            contr1.Contract__c = 'Contract412368';
            contr1.FCST_Contract_Created_Year__c = '2018';	
            contr1.Contract_Owner__c= u.id;
            contrList.add(contr1);
            insert contrList;
            
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            //  fcl.name = 'sample test';
            fcl.FCST_Contract__c = contr.id;
            fcl.Risk_Factor__c = 100;
            fcl.FCST_Fiscal_Year_List__c = fyp.id;
            fcl.BSLA_Number__c = '20';
            fcl.Cost_Center__c = 'Test Center';
            fcl.Cost_Center_Description__c = 'Test Descr';  
            fcl.Fcst_Revenue_Type__c = 'Test Rev';
            fcl.BSLA__c = 'BSLA';
            insert fcl;
            
         list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
            for(Integer i=1;i<13;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                //for(integer i=0;i<101;i++){
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.FCST_Fiscal_Year_List__c = fyp.id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            
            
            FCST_Initial_Forecast__c flist1= new FCST_Initial_Forecast__c();
                //for(integer i=0;i<101;i++){
                flist1.name='Contract412368';
                flist1.Account__c =acc.id;
                flist1.FCST_Contract__c = contr.id;
                flist1.Contract_LineItem__c = fcl.id;
                flist1.Planning_Version__c = plversionObj.Id;
                flist1.FCST_Planning_Fiscal_Year__c=fymList[0].id;
                flist1.FCST_Fiscal_Year_List__c = fyp.id;
                flist1.Fcst_Amount__c = 2000;
            insert flist1;
        
        FCST_HyperLinkUpload_Batch_Download batch = new FCST_HyperLinkUpload_Batch_Download('2019');
        Database.executeBatch(batch);
    }
}