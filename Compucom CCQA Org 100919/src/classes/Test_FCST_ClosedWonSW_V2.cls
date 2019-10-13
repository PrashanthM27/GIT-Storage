@isTest
public class Test_FCST_ClosedWonSW_V2 {
    static testMethod void getPlData(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        FCST_UTIL.InsertTriggerMappingFields();
        System.runAs(thisUser) {
            
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
                opt.StageName = 'Closed Won';
                opt.CloseDate = System.today();
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }
            
            List<Planning_Version__c> plvList = new List<Planning_Version__c>();
            for(Integer i=0;i<20;i++){
                Planning_Version__c plv = new Planning_Version__c();
                plv.Name = '2019';
                // plv.Version_Status__c = 'Open (Admin)';
                plvList.add(plv);
            }
            insert plvList;
            
            List<Fiscal_Year_Planning__c> fypList = new List<Fiscal_Year_Planning__c>();
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
            fyp.Name = '2019';
            fyp.EndDate__c = endate;
            fyp.StartDate__c = srtDate;
            fypList.add(fyp);
            
            if(fypList!=null && !fypList.isEmpty()){
                insert fypList;
            }

            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            for(Integer i=1;i<12;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = 'FY2019P0'+i;
                fym.End_Date__c = endate;
                fym.Start_Date__c = srtDate;
                fym.Fiscal_Planning_Year__c = fypList[0].Id;
                fym.Fiscal_Period_Id__c = '20';
                if(i==1 || i==2 || i==3)
                fym.Fiscal_Quarter__c = 'Q1';
                
                 if(i==4 || i==5 || i==6)
                fym.Fiscal_Quarter__c = 'Q2';
                
                if(i==7 || i==8 || i==9)
                fym.Fiscal_Quarter__c = 'Q3';
                
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
            
            Fiscal_Year_Model__c fym1 = new Fiscal_Year_Model__c();
                fym1.Name = 'FY2019P01';
            insert fym1;
            
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
            
            Planning_Version__c plvVersion = new Planning_Version__c();
            plvVersion.Planning_Version_Fiscal_Year__c = '2019';
            plvVersion.Is_this_a_Budget_Planning_Version__c = false;
            plvVersion.Is_this_a_Gap_Planning_Version__c = false;
            plvVersion.Version_Status__c = 'Open (Admin)';
            insert plvVersion;
            
            FCST_Opportunity_Initial_Forecast__c oif = new FCST_Opportunity_Initial_Forecast__c();
            oif.Name = 'a0R1U000001Kt0a';
            oif.Fcst_Fiscal_Period__c = fym1.Id;
            oif.Fcst_Q__c = 'fcst_q__c';
            oif.Fcst_Weighted_Revenue__c = 2000;
            oif.Fcst_Opportunity__c = optList[0].Id;
            oif.FCST_Planning_Version__c = plvVersion.Id;
            oif.User_Adjusted_Revenue__c = 20000;
            insert oif;
            
            
            
            
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'fcst_q__c';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            contracts.Fcst_Account__c = acList[0].Id;
            contracts.FCST_Contract_Created_Year__c = '2019';
            insert contracts;
            
            
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            insert cli;
            
             Fiscal_Year_Model__c fym2 = new Fiscal_Year_Model__c();
            fym2.Name = 'FY2019P02';
            insert fym2;
            
            Fiscal_Year_Model__c fym3 = new Fiscal_Year_Model__c();
            fym3.Name = 'FY2019P03';
            insert fym3;
            
             Fiscal_Year_Model__c fym4 = new Fiscal_Year_Model__c();
            fym4.Name = 'FY2019P04';
            insert fym4;
            
             Fiscal_Year_Model__c fym5 = new Fiscal_Year_Model__c();
            fym5.Name = 'FY2019P05';
            insert fym5;
            
             Fiscal_Year_Model__c fym6 = new Fiscal_Year_Model__c();
            fym6.Name = 'FY2019P06';
            insert fym6;
            
              Fiscal_Year_Model__c fym7 = new Fiscal_Year_Model__c();
            fym7.Name = 'FY2019P07';
            insert fym7;
            
              Fiscal_Year_Model__c fym8 = new Fiscal_Year_Model__c();
            fym8.Name = 'FY2019P08';
            insert fym8;
            
            Fiscal_Year_Model__c fym9 = new Fiscal_Year_Model__c();
            fym9.Name = 'FY2019P09';
            insert fym9;
            
            Fiscal_Year_Model__c fym10 = new Fiscal_Year_Model__c();
            fym10.Name = 'FY2019P10';
            insert fym10;
            
            Fiscal_Year_Model__c fym11 = new Fiscal_Year_Model__c();
            fym11.Name = 'FY2019P11';
            insert fym11;
            
            Fiscal_Year_Model__c fym12 = new Fiscal_Year_Model__c();
            fym12.Name = 'FY2019P12';
            insert fym12;
            
             Fiscal_Year_Model__c fym13 = new Fiscal_Year_Model__c();
            fym13.Name = 'FY2019P13';
            insert fym13;
            
            Fiscal_Year_Model__c fym14 = new Fiscal_Year_Model__c();
            fym14.Name = 'FY2019P14';
            insert fym14;
            
            Fiscal_Year_Model__c fym15 = new Fiscal_Year_Model__c();
            fym15.Name = 'FY2019P15';
            insert fym15;
            
            Fiscal_Year_Model__c fym16 = new Fiscal_Year_Model__c();
            fym16.Name = 'FY2019P16';
            insert fym16;
            
            Fiscal_Year_Model__c fym17 = new Fiscal_Year_Model__c();
            fym17.Name = 'FY2019P17';
            insert fym17;
            
            Fiscal_Year_Model__c fym18 = new Fiscal_Year_Model__c();
            fym18.Name = 'FY2019P18';
            insert fym18;
            
            FCST_Opportunity_Initial_Forecast__c oif2 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym2.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 20000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,User_Adjusted_Revenue__c = 20000,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif2;
            
            FCST_Opportunity_Initial_Forecast__c oif3 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym3.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif3;
            
            FCST_Opportunity_Initial_Forecast__c oif4 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym4.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif4;
            
            FCST_Opportunity_Initial_Forecast__c oif5 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym5.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif5;
            
            FCST_Opportunity_Initial_Forecast__c oif6 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym6.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif6;
            
            FCST_Opportunity_Initial_Forecast__c oif7 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym7.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif7;
            
            FCST_Opportunity_Initial_Forecast__c oif8 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym8.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif8;
            
            FCST_Opportunity_Initial_Forecast__c oif9 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym9.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif9;
            
            FCST_Opportunity_Initial_Forecast__c oif10 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym10.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif10;
            
            FCST_Opportunity_Initial_Forecast__c oif11 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym11.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif11;
            
            FCST_Opportunity_Initial_Forecast__c oif12 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym12.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif12;
            
            
             Actual_Model__c actModel1 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fymList[0].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel1;
            
            
            Actual_Model__c actModel2 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fymList[1].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel2;
            
            
            
            Actual_Model__c actModel3 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fymList[2].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel3;
            
           
            
            Actual_Model__c actModel4 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fymList[3].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel4;
            
            
            Actual_Model__c actModel5 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym5.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel5;
            
            
            Actual_Model__c actModel6 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym6.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel6;
            
            Actual_Model__c actModel7 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym7.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel7;
            
            Actual_Model__c actModel8 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym8.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel8;
            
            Actual_Model__c actModel9 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym9.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel9;
            
            Actual_Model__c actModel10 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym10.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel10;
            
            Actual_Model__c actModel11 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym11.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel11;
            
             Actual_Model__c actModel12 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = 20000,Fiscal_Period__c = fym12.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel12;
            
            
            
    FCST_Initial_Forecast__c intFcst1 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fymList[0].Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst1;
            
   FCST_Initial_Forecast__c intFcst2 = new FCST_Initial_Forecast__c(Name = 'TestInt2',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fymList[1].Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst2;
            
    FCST_Initial_Forecast__c intFcst3 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fymList[2].Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst3;
            
    FCST_Initial_Forecast__c intFcst4 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym3.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst4;
            
    FCST_Initial_Forecast__c intFcst5 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym4.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst5;
            
    FCST_Initial_Forecast__c intFcst6 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym5.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst6;
            
    FCST_Initial_Forecast__c intFcst7 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym6.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst7;
            
    FCST_Initial_Forecast__c intFcst8 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym7.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst8;
            
    FCST_Initial_Forecast__c intFcst9 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym8.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst9;        
            
    FCST_Initial_Forecast__c intFcst10 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym9.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst10;
            
    FCST_Initial_Forecast__c intFcst11 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym10.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst11;
            
     FCST_Initial_Forecast__c intFcst12 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym11.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst12;
            
     FCST_Initial_Forecast__c intFcst13 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym12.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst13;
            
           
            
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acList[0].Id;
            prdModel.Opportunity__c = optList[0].Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c = plvList[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdmodel.Fiscal_Period__c = fymList[0].id;
            insert prdModel;
            
            PageReference pgf = Page.FCST_ClosedWonSW_V2;
            Test.setCurrentPage(pgf);
            
            pgf.getparameters().put('pv',String.valueOf(plvList[0].Id));
            pgf.getparameters().put('AccId',String.valueOf(acList[0].Id));
            pgf.getparameters().put('su',String.valueOf(thisUser.Id));
            pgf.getParameters().put('getincreaseValue',String.valueOf(20));
            pgf.getParameters().put('id',String.valueOf(cli.Id));
            pgf.getParameters().put('id',String.valueOf(intFcst1.Id));
            pgf.getParameters().put('riskFactor',String.valueOf(40));
            pgf.getparameters().put('planningModelAmount',String.valueOf(20000));
            
            Test.startTest();
            FCST_ClosedWonSW_V2 fcp = new FCST_ClosedWonSW_V2();
            fcp.pVVersionStringId = 'Test';
            fcp.cYear = 2018;
            fcp.strLine = 'TestLine';
            fcp.strContract  = 'fcst_q__c';
            fcp.likeStr = 'FY2019P01';
            fcp.strPlanYear = '2017';
            fcp.strPlanningYear = 'Test';
            fcp.strOpportunity = optList[0].Name;
            fcp.strAccount = acList[0].Name;
            fcp.strPlanningVersion = plvList[0].Name;
            fcp.globalMonth = 'testMonth';
            fcp.totalProductString = 'PrdStr';
            fcp.conName = 'TestData';
            fcp.StageNameSet.add('Closed Won');
            fcp.Beginning();
            //fcp.Previous();
            fcp.Next();
            //fcp.End();
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
            fcp.getPlanningYearOptionList();
            fcp.mainfetchOppRecord();
            fcp.getContractChange();
            fcp.fetchOppRecord();
            fcp.opportunitySet.add('Test Oppt');
            fcp.likeStr = 'FY2019P03';
            for(Integer i=0 ;i<13;i++){
            	fcp.getmonthName(i);
            }
            
            Test.stopTest();
            
        }
    } 
     static testMethod void getPlData2(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
         FCST_UTIL.InsertTriggerMappingFields();
        System.runAs(thisUser) {
            
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
                opt.StageName = 'Closed Won';
                opt.CloseDate = System.today();
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }
            
            List<Planning_Version__c> plvList = new List<Planning_Version__c>();
            for(Integer i=0;i<20;i++){
                Planning_Version__c plv = new Planning_Version__c();
                plv.Name = '2019';
                // plv.Version_Status__c = 'Open (Admin)';
                plvList.add(plv);
            }
            insert plvList;
            
            List<Fiscal_Year_Planning__c> fypList = new List<Fiscal_Year_Planning__c>();
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
            fyp.Name = '2019';
            fyp.EndDate__c = endate;
            fyp.StartDate__c = srtDate;
            fypList.add(fyp);
            
            if(fypList!=null && !fypList.isEmpty()){
                insert fypList;
            }

            List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
            for(Integer i=1;i<12;i++){
                Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
                fym.Name = 'FY2019P0'+i;
                fym.End_Date__c = endate;
                fym.Start_Date__c = srtDate;
                fym.Fiscal_Planning_Year__c = fypList[0].Id;
                fym.Fiscal_Period_Id__c = '20';
                if(i==1 || i==2 || i==3)
                fym.Fiscal_Quarter__c = 'Q1';
                
                 if(i==4 || i==5 || i==6)
                fym.Fiscal_Quarter__c = 'Q2';
                
                if(i==7 || i==8 || i==9)
                fym.Fiscal_Quarter__c = 'Q3';
                
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
            
            Fiscal_Year_Model__c fym1 = new Fiscal_Year_Model__c();
                fym1.Name = 'FY2019P01';
            insert fym1;
            
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
            
            Planning_Version__c plvVersion = new Planning_Version__c();
            plvVersion.Planning_Version_Fiscal_Year__c = '2019';
            plvVersion.Is_this_a_Budget_Planning_Version__c = false;
            plvVersion.Is_this_a_Gap_Planning_Version__c = false;
            plvVersion.Version_Status__c = 'Open (Admin)';
            insert plvVersion;
            
            FCST_Opportunity_Initial_Forecast__c oif = new FCST_Opportunity_Initial_Forecast__c();
            oif.Name = 'a0R1U000001Kt0a';
            oif.Fcst_Fiscal_Period__c = fym1.Id;
            oif.Fcst_Q__c = 'fcst_q__c';
            oif.Fcst_Weighted_Revenue__c = 2000;
            oif.Fcst_Opportunity__c = optList[0].Id;
            oif.FCST_Planning_Version__c = plvVersion.Id;
            oif.User_Adjusted_Revenue__c = 20000;
            insert oif;
            
            
            
            
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'fcst_q__c';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            contracts.Fcst_Account__c = acList[0].Id;
            contracts.FCST_Contract_Created_Year__c = '2019';
            insert contracts;
            
            
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            insert cli;
            
             Fiscal_Year_Model__c fym2 = new Fiscal_Year_Model__c();
            fym2.Name = 'FY2019P02';
            insert fym2;
            
            Fiscal_Year_Model__c fym3 = new Fiscal_Year_Model__c();
            fym3.Name = 'FY2019P03';
            insert fym3;
            
             Fiscal_Year_Model__c fym4 = new Fiscal_Year_Model__c();
            fym4.Name = 'FY2019P04';
            insert fym4;
            
             Fiscal_Year_Model__c fym5 = new Fiscal_Year_Model__c();
            fym5.Name = 'FY2019P05';
            insert fym5;
            
             Fiscal_Year_Model__c fym6 = new Fiscal_Year_Model__c();
            fym6.Name = 'FY2019P06';
            insert fym6;
            
              Fiscal_Year_Model__c fym7 = new Fiscal_Year_Model__c();
            fym7.Name = 'FY2019P07';
            insert fym7;
            
              Fiscal_Year_Model__c fym8 = new Fiscal_Year_Model__c();
            fym8.Name = 'FY2019P08';
            insert fym8;
            
            Fiscal_Year_Model__c fym9 = new Fiscal_Year_Model__c();
            fym9.Name = 'FY2019P09';
            insert fym9;
            
            Fiscal_Year_Model__c fym10 = new Fiscal_Year_Model__c();
            fym10.Name = 'FY2019P10';
            insert fym10;
            
            Fiscal_Year_Model__c fym11 = new Fiscal_Year_Model__c();
            fym11.Name = 'FY2019P11';
            insert fym11;
            
            Fiscal_Year_Model__c fym12 = new Fiscal_Year_Model__c();
            fym12.Name = 'FY2019P12';
            insert fym12;
            
             Fiscal_Year_Model__c fym13 = new Fiscal_Year_Model__c();
            fym13.Name = 'FY2019P13';
            insert fym13;
            
            Fiscal_Year_Model__c fym14 = new Fiscal_Year_Model__c();
            fym14.Name = 'FY2019P14';
            insert fym14;
            
            Fiscal_Year_Model__c fym15 = new Fiscal_Year_Model__c();
            fym15.Name = 'FY2019P15';
            insert fym15;
            
            Fiscal_Year_Model__c fym16 = new Fiscal_Year_Model__c();
            fym16.Name = 'FY2019P16';
            insert fym16;
            
            Fiscal_Year_Model__c fym17 = new Fiscal_Year_Model__c();
            fym17.Name = 'FY2019P17';
            insert fym17;
            
            Fiscal_Year_Model__c fym18 = new Fiscal_Year_Model__c();
            fym18.Name = 'FY2019P18';
            insert fym18;
            
            FCST_Opportunity_Initial_Forecast__c oif2 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym2.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 20000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,User_Adjusted_Revenue__c = 20000,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif2;
            
            FCST_Opportunity_Initial_Forecast__c oif3 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym3.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif3;
            
            FCST_Opportunity_Initial_Forecast__c oif4 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym4.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif4;
            
            FCST_Opportunity_Initial_Forecast__c oif5 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym5.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif5;
            
            FCST_Opportunity_Initial_Forecast__c oif6 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym6.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif6;
            
            FCST_Opportunity_Initial_Forecast__c oif7 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym7.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif7;
            
            FCST_Opportunity_Initial_Forecast__c oif8 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym8.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif8;
            
            FCST_Opportunity_Initial_Forecast__c oif9 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym9.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif9;
            
            FCST_Opportunity_Initial_Forecast__c oif10 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym10.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif10;
            
            FCST_Opportunity_Initial_Forecast__c oif11 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym11.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif11;
            
            FCST_Opportunity_Initial_Forecast__c oif12 = new FCST_Opportunity_Initial_Forecast__c( Name = 'a0R1U000001Kt0a',Fcst_Fiscal_Period__c = fym12.Id,Fcst_Q__c = 'fcst_q__c',Fcst_Weighted_Revenue__c = 2000,
                                                                                                 Fcst_Opportunity__c = optList[0].Id,FCST_Planning_Version__c = plvVersion.Id);
           
            insert oif12;
            
            
             Actual_Model__c actModel1 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fymList[0].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel1;
            
            
            Actual_Model__c actModel2 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fymList[1].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel2;
            
            
            
            Actual_Model__c actModel3 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fymList[2].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel3;
            
           
            
            Actual_Model__c actModel4 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fymList[3].Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel4;
            
            
            Actual_Model__c actModel5 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym5.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel5;
            
            
            Actual_Model__c actModel6 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym6.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel6;
            
            Actual_Model__c actModel7 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym7.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel7;
            
            Actual_Model__c actModel8 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym8.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel8;
            
            Actual_Model__c actModel9 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym9.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel9;
            
            Actual_Model__c actModel10 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym10.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel10;
            
            Actual_Model__c actModel11 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym11.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel11;
            
             Actual_Model__c actModel12 = new Actual_Model__c(Account__c = acList[0].Id,Contract_LineItem__c = cli.Id,Actual_Amount__c = -20000,Fiscal_Period__c = fym12.Id,
                                                          FCST_Planning_Version__c = plvList[0].Id,Fiscal_Year__c = fypList[0].Id);
            insert actModel12;
            
            
            
    FCST_Initial_Forecast__c intFcst1 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fymList[0].Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst1;
            
   FCST_Initial_Forecast__c intFcst2 = new FCST_Initial_Forecast__c(Name = 'TestInt2',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fymList[1].Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst2;
            
    FCST_Initial_Forecast__c intFcst3 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fymList[2].Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst3;
            
    FCST_Initial_Forecast__c intFcst4 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym3.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst4;
            
    FCST_Initial_Forecast__c intFcst5 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym4.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst5;
            
    FCST_Initial_Forecast__c intFcst6 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym5.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst6;
            
    FCST_Initial_Forecast__c intFcst7 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym6.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst7;
            
    FCST_Initial_Forecast__c intFcst8 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym7.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst8;
            
    FCST_Initial_Forecast__c intFcst9 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym8.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst9;        
            
    FCST_Initial_Forecast__c intFcst10 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym9.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst10;
            
    FCST_Initial_Forecast__c intFcst11 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym10.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst11;
            
     FCST_Initial_Forecast__c intFcst12 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym11.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst12;
            
     FCST_Initial_Forecast__c intFcst13 = new FCST_Initial_Forecast__c(Name = 'TestInt',Fcst_Amount__c = 20000,FCST_Contract__c = contracts.Id,FCST_Fiscal_Year_List__c = fypList[0].Id,
                                               FCST_Planning_Fiscal_Year__c = fym12.Id, Contract_LineItem__c = cli.Id,Planning_Version__c = plvList[0].Id);
    insert intFcst13;
            
           
            
            FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = acList[0].Id;
            prdModel.Opportunity__c = optList[0].Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c = plvList[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
            prdmodel.Fiscal_Period__c = fymList[0].id;
            insert prdModel;
            
            PageReference pgf = Page.FCST_ClosedWonSW_V2;
            Test.setCurrentPage(pgf);
            
            pgf.getparameters().put('pv',String.valueOf(plvList[0].Id));
            pgf.getparameters().put('AccId',String.valueOf(acList[0].Id));
            pgf.getparameters().put('su',String.valueOf(thisUser.Id));
            pgf.getParameters().put('getincreaseValue',String.valueOf(20));
            pgf.getParameters().put('id',String.valueOf(cli.Id));
            pgf.getParameters().put('id',String.valueOf(intFcst1.Id));
            pgf.getParameters().put('riskFactor',String.valueOf(40));
            pgf.getparameters().put('planningModelAmount',String.valueOf(20000));
            
            Test.startTest();
            FCST_ClosedWonSW_V2 fcp = new FCST_ClosedWonSW_V2();
            fcp.pVVersionStringId = 'Test';
            fcp.cYear = 2018;
            fcp.strLine = 'TestLine';
            fcp.strContract  = 'fcst_q__c';
            fcp.likeStr = 'FY2019P01';
            fcp.strPlanYear = '2017';
            fcp.strPlanningYear = 'Test';
            fcp.strOpportunity = optList[0].Name;
            fcp.strAccount = acList[0].Name;
            fcp.strPlanningVersion = plvList[0].Name;
            fcp.globalMonth = 'testMonth';
            fcp.totalProductString = 'PrdStr';
            fcp.conName = 'TestData';
            fcp.StageNameSet.add('Closed Won');
            fcp.Beginning();
            //fcp.Previous();
            fcp.Next();
            //fcp.End();
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
            fcp.getPlanningYearOptionList();
            fcp.mainfetchOppRecord();
            fcp.getContractChange();
            fcp.fetchOppRecord();
            fcp.opportunitySet.add('Test Oppt');
            fcp.likeStr = 'FY2019P03';
            for(Integer i=0 ;i<13;i++){
            	fcp.getmonthName(i);
            }
            
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
         
             Test.startTest();
        FCST_ClosedWonSW_V2 fcp = new FCST_ClosedWonSW_V2();
            fcp.Beginning();
            fcp.Previous();
            fcp.Next();
           // fcp.End();
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
            fcp.getPlanningYearOptionList();
            fcp.mainfetchOppRecord();
            fcp.getContractChange();
            fcp.opportunitySet.add('Test Oppt');
            fcp.likeStr = 'FY2019P01';
            Test.stopTest();
        
       
        
        
    }
}