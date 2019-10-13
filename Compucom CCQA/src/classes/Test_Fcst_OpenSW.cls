@isTest
public class Test_Fcst_OpenSW {
    static testMethod void getPlData(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser) {
             FCST_UTIL.InsertTriggerMappingFields();
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole ur = new UserRole(Name = 'CEO');
            insert ur;
            
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            
            User u = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
            insert u;

             Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              FCST_ProgramManager__c= 'lastmodifiedbyid',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
            
            Date srtDate = date.newInstance(2019,02,28);    
            Date endate = Date.newInstance(2019,01,19);
            
            List<Account> acList = new List<Account>();
            for(Integer i=0;i<20;i++){
                Account ac = new Account();
                ac.Name = 'Account';
                acList.add(ac);
            }
            if(acList!=null && !acList.isEmpty()){
                insert acList;
            }
            
            List<Opportunity> optList = new List<Opportunity>();
            for(Integer i=0;i<20;i++){
                Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
                opt.AccountId = acList[0].Id;
                opt.Amount = 40000;
                opt.StageName = 'Contracting/Closing';
                opt.CloseDate = System.today();
                optList.add(opt);
            }
                if(optList!=null && !optList.isEmpty()){
                insert optList;
            }
            
            List<Planning_Version__c> plvList = new List<Planning_Version__c>();
            for(Integer i=0;i<20;i++){
                Planning_Version__c plv = new Planning_Version__c();
                plv.Name = '2019-March';
                plv.Version_Status__c = 'Open (Admin)';
                plvList.add(plv);
            }
            insert plvList;
            
            List<Fiscal_Year_Planning__c> fypList = new List<Fiscal_Year_Planning__c>();
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
            fyp.Name = '2019';
            fyp.EndDate__c = endate;
           // fyp.Record_Source__c = 'test';
            fyp.StartDate__c = srtDate;
            fypList.add(fyp);
            
            if(fypList!=null && !fypList.isEmpty()){
                insert fypList;
            }
              List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
             for(Integer i=0;i<20;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = 'FY2019P02';
                fym.End_Date__c = srtDate;
                fym.Start_Date__c = endate;
                fym.Fiscal_Planning_Year__c = fypList[0].Id;
                fym.Fiscal_Period_Id__c = '20';
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true
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
                OpportunityId = optList[0].Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id
                
            );
            oli.TotalPrice = oli.quantity * pbEntry.UnitPrice;
            oli.Risk_Factor__c = 0;
            insert oli;
               
           /* Planning_Version__c plvVersion = new Planning_Version__c();
            plvVersion.Planning_Version_Fiscal_Year__c = '2017';
            plvVersion.Is_this_a_Budget_Planning_Version__c = false;
            plvVersion.Is_this_a_Gap_Planning_Version__c = false;
            plvVersion.Version_Status__c = 'In Progress';
            insert plvVersion;*/
            
            Planning_Version__c plvVersion = new Planning_Version__c();
            plvVersion.Planning_Version_Fiscal_Year__c = '2019';
            plvVersion.Is_this_a_Budget_Planning_Version__c = false;
            plvVersion.Is_this_a_Gap_Planning_Version__c = false;
            plvVersion.Version_Status__c = 'In Progress';
            insert plvVersion;
            
            
            
            MappingFieldUtility mfu = new MappingFieldUtility();
            
           FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acList[0].Id;
            prdModel.Opportunity__c = optList[0].Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c = plvList[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
          //  prdmodel.Fiscal_Period__c = plv.id;
            prdmodel.Fiscal_Period__c = fymList[0].id;
            prdmodel.Planning_Version__c = plvList[0].id;
            insert prdModel;   
            
            Fiscal_Year_Model__c fypl0= new Fiscal_Year_Model__c(name='FY2019P01');
            insert fypl0;
            FCST_Product_Model__c prdModel0 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl0.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel0; 
            
            Fiscal_Year_Model__c fypl1= new Fiscal_Year_Model__c(name='FY2019P03');
            insert fypl1;
            FCST_Product_Model__c prdModel1 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl1.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel1; 
            
            Fiscal_Year_Model__c fypl2= new Fiscal_Year_Model__c(name='FY2019P04');
            insert fypl2;
            FCST_Product_Model__c prdModel2 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl2.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel2;
            
            Fiscal_Year_Model__c fypl3= new Fiscal_Year_Model__c(name='FY2019P05');
            insert fypl3;
            FCST_Product_Model__c prdModel3 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl3.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel3;
            Fiscal_Year_Model__c fypl4= new Fiscal_Year_Model__c(name='FY2019P06');
            insert fypl4;
            FCST_Product_Model__c prdModel4 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl4.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel4;
            
              Fiscal_Year_Model__c fypl5= new Fiscal_Year_Model__c(name='FY2019P07');
            insert fypl5;
            FCST_Product_Model__c prdModel5 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl5.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel5;
            Fiscal_Year_Model__c fypl6= new Fiscal_Year_Model__c(name='FY2019P08');
            insert fypl6;
            FCST_Product_Model__c prdModel6 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl6.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel6;
            Fiscal_Year_Model__c fypl7= new Fiscal_Year_Model__c(name='FY2019P09');
            insert fypl7;
            FCST_Product_Model__c prdModel7 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl7.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel7;
            Fiscal_Year_Model__c fypl8= new Fiscal_Year_Model__c(name='FY2019P10');
            insert fypl8;
            FCST_Product_Model__c prdModel8 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl8.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel8;
            Fiscal_Year_Model__c fypl9= new Fiscal_Year_Model__c(name='FY2019P11');
            insert fypl9;
            FCST_Product_Model__c prdModel9 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl9.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel9;
            Fiscal_Year_Model__c fypl10= new Fiscal_Year_Model__c(name='FY2019P12');
            insert fypl10;
            FCST_Product_Model__c prdModel10 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl10.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel10;
             Fiscal_Year_Model__c fypl11= new Fiscal_Year_Model__c(name='FY2019P02');
            insert fypl11;
            FCST_Product_Model__c prdModel11 = new FCST_Product_Model__c(Account__c = acList[0].Id,Opportunity__c = optList[0].Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl11.id,
            Planning_Version__c = plvList[0].id);
            insert prdModel11;
            
             PageReference pgf = Page.Fcst_OpenSW;
            Test.setCurrentPage(pgf);
            
            pgf.getparameters().put('pv',String.valueOf(plvList[0].Id));
            pgf.getparameters().put('AccId',String.valueOf(acList[0].Id));
            pgf.getparameters().put('su',String.valueOf(u.Id));
            pgf.getparameters().put('id',String.valueOf(prdModel.Id));
            pgf.getparameters().put('planningModelAmount',String.valueOf(20000));
            Test.startTest();
            
            Fcst_OpenSW fcp = new Fcst_OpenSW();
            fcp.pVVersionStringId = 'Test';
            fcp.cYear = 2018;
            fcp.strPlanYear = '2017';
           // fcp.myear = '2018';
            fcp.strPlanningYear = 'Test';
            fcp.strOpportunity = 'TestOppt';
            fcp.strPlanningVersion = '2019-March';
            fcp.globalMonth = 'testMonth';
            fcp.totalProductString = 'PrdStr';
            fcp.Beginning();
            fcp.Previous();
            fcp.Next();
            fcp.End();
            fcp.counter=2;
            fcp.getDisablePrevious();
            fcp.getDisableNext();
            fcp.getTotal_size();
            fcp.getPageNumber();
            fcp.getTotalPages();
            fcp.mainfetchOppRecord();
            fcp.updatePlanningModel();
            fcp.gotohomepage();
            fcp.BackPage();
            //fcp.getPlanningYearOptionList();

            //fcp.getPlanningYearOptionList();
            fcp.StageNameSet.add('Lead (Above the funnel)');
            fcp.opportunitySet.add('Test Oppt');
            fcp.likeStr = 'FY2019P01';
            Test.stopTest();
            
        }
    }        
        static testMethod void getWBdata(){
            Planning_Version__c plvVersion = new Planning_Version__c();
            plvVersion.Planning_Version_Fiscal_Year__c = '2019';
            plvVersion.Is_this_a_Budget_Planning_Version__c = true;
            plvVersion.Is_this_a_Gap_Planning_Version__c = true;
            plvVersion.Version_Status__c = 'Open (Admin)';
            insert plvVersion;
            
         Fcst_OpenSW fcp = new Fcst_OpenSW();
         //fcp.strPlanYear = null;
        

        }
 
    static testmethod void AccountTrigger(){
        
     user u=[select id from user where id=:userinfo.getUserId()];
        system.runas(u){
             Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              FCST_ProgramManager__c= 'lastmodifiedbyid',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
            
            account ac= new account(name='test',FCST_CPM_Region__c='US-DC Area');
            insert ac;
            
            FCST_Trigger__c ft= new FCST_Trigger__c();
            ft.name='TriggerMapping';
            ft.Account_Trigger__c=true;
            ft.FCST_LineItem_Trigger__c=true;
            ft.FCST_Opportunity_Trigger__c=true;
            ft.Product_Trigger__c=true;
            insert ft;
            
            list<account> alist=[select name,FCST_CPM_Region__c from account];
            system.debug('alist '+alist);
            for(account a: alist){
                a.name='test account';
                a.FCST_CPM_Region__c='US-Mid-Atlantic';
            }
            update alist;
            system.debug('alist '+alist[0].name);
        }
     }
}