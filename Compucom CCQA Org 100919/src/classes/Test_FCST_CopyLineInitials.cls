@istest
public class Test_FCST_CopyLineInitials {
   testMethod static void testCase1(){
        FCST_UTIL.InsertTriggerMappingFields();
   Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',

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
          List<Id> userId = new List<Id>();
       // User loginUser = FCST_Util.createUser(); 
        
        
       
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
       userId.add(u.Id);
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(u){
            Fcst_Batch_Status__c FBS = new Fcst_Batch_Status__c(User_Id__c=string.valueOf(u.id),name='Mahesh');
            insert FBS;
     
            Date fstartDate = Date.newInstance(2018,1,1);
            Date fendDate = Date.newInstance(2018,12,31);
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
           Map<Id,Id> mapVersions =new Map<Id,Id>();
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
           Set<Id> plvId = new Set<Id>();
            Planning_Version__c plversionObj = new Planning_Version__c();
            plversionObj.Name='2018';
            plversionObj.Data_Entry_Start_Date__c=startDate;
            plversionObj.Data_Entry_Closed_Date__c=endDate;
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
            mapVersions.put(plversionObj.id,plversionObj.id);
            plvId.add(plversionObj.Id);
             Planning_Version__c plversionObj1 = new Planning_Version__c();
            plversionObj1.Name='2019';
            plversionObj1.Data_Entry_Start_Date__c=startDate;
            plversionObj1.Data_Entry_Closed_Date__c=endDate;
            plversionObj1.Fiscal_Year_Planning__c=fyp.Id;
            plversionObj1.Planning_Version_Fiscal_Year__c='2018';
            plversionObj1.Long_Label__c='January';
            plversionObj1.Version_Status__c='Open (Admin)';
            plversionObj1.Month_Number__c=1;
            plversionObj1.MonthName__c='January';
            plversionObj1.Period_Number__c=1;
            plversionObj1.Planning_Version_Current_Period__c='1';
            plversionObj1.SequenceNo__c=1;
            plversionObj1.Previous_Version__c=plversionObj.Id;
            insert plversionObj1;
            mapVersions.put(plversionObj1.id,plversionObj1.id);
            Account acc = new Account(Name='Test Account');
            insert acc;
            Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
                opt.AccountId = acc.Id;
                opt.StageName = 'Prospecting';
                opt.CloseDate = fendDate;
            insert opt;
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family = 'Hosted Services'
            );
            insert prod;
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            );
            insert pbEntry;
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opt.Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id
                
            );
            oli.TotalPrice = oli.quantity * pbEntry.UnitPrice;
            oli.Risk_Factor__c = 0;
            insert oli;
            list<FCST_Product_Model__c> pmlist = new list<FCST_Product_Model__c>();
            for(Integer i=1;i<20;i++){
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acc.Id;
            prdModel.Opportunity__c = opt.Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c =plversionObj.Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdModel.Product__c = prod.id;
            prdmodel.Fiscal_Period__c = fymmap.get(i).id;
                pmlist.add(prdmodel);
            }
            insert pmlist;   
            FCST_Contract__c contr = new FCST_Contract__c();
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';   
            contr.Contract_Owner__c= u.id;
            insert contr;
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            fcl.FCST_Contract__c = contr.id;
            fcl.Risk_Factor__c = 100;
            insert fcl;
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                flist.name='Contract412368';
                flist.Account__c =acc.id;
                flist.FCST_Contract__c = contr.id;
                flist.Contract_LineItem__c = fcl.id;
                flist.Planning_Version__c = plversionObj.Id;
                flist.FCST_Planning_Fiscal_Year__c=fymmap.get(i).id;
                flist.Fcst_Amount__c = 2000;
                
                initial_flist.add(flist);
            }
            insert initial_flist; 
            // }
             Planning_Financial_Measure__c measureObj = FCST_Util.createMeasure('Revenue');
            insert measureObj;
            
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Baseline';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.Fiscal_Period__c = fymmap.get(i).id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                //  insert actModel;
                amlist.add(actModel);
            }
            insert amlist;
            
            List<FCST_Opportunity_Initial_Forecast__c> optIFList = new List<FCST_Opportunity_Initial_Forecast__c>();
            FCST_Opportunity_Initial_Forecast__c oppfcst= new FCST_Opportunity_Initial_Forecast__c(Fcst_Fiscal_Period__c=fymList[0].Id,FCST_Planning_Version__c=plversionObj.id,
                                                                                                  Fcst_Q__c='123',Fcst_Opportunity__c=opt.id);
            optIFList.add(oppfcst);
            insert optIFList;
            
              Test.startTest();

            FCST_CopyLineInitials obj = new FCST_CopyLineInitials(mapVersions);
             // obj.execute(NULL,intiFcst);
              obj.LEFT15Digit('test1');
              obj.sendMailToAdmin();
            obj.sendErrorTemplate(new List<Id>{u.id},'Test1','Test2');
            DataBase.executeBatch(obj); 
             
           FCST_BatchVersionConvert cb = new FCST_BatchVersionConvert(mapVersions);
           // Id btch = Database.executeBatch(cb);
            cb.Execute(NULL,pmlist);
            cb.LEFT15Digit('Test');
            cb.sendMailToAdmin();
            cb.sendErrorTemplate(new List<Id>{u.id},'Test1','Test2');
            
            
            FCST_ActualCopyBatch actBatch = new FCST_ActualCopyBatch(mapVersions);
            Id btchId = Database.executeBatch(actBatch);
          //  actBatch.Execute(NULL,actualList);
            actBatch.LEFT15Digit('Test1');
            actBatch.sendMailToAdmin();
            actBatch.sendErrorTemplate(userId,'Test4','Test5');
            
            Fcst_CopyPMForecast copyPM = new Fcst_CopyPMForecast(mapVersions);
            copyPM.Execute(NULL,optIFList);
            copyPM.sendMailToAdmin();
            copyPM.sendErrorTemplate(new List<Id>{u.id},'Test1','Test2');
            
            
            FCST_NextPlanningVersionOpen nextPlnVer = new FCST_NextPlanningVersionOpen();
            FCST_NextPlanningVersionOpen.updateStatus(plvId);
            
        Test.stopTest();
              
              
              
          } 
     }
}