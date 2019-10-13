@isTest
public class TEST_FCST_CompucomBaseLineWorkbench {
    static testmethod void getData1(){
        user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
         FCST_UTIL.InsertTriggerMappingFields();
        system.runAs(u){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole ur = new UserRole(Name = 'CEO',ParentRoleId = u.UserRoleId);
            insert ur;
            
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            
            User u1 = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
            insert u1;
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
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
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
            Account acc = new Account(Name='Test Account',fcst_cpm_region__c='US-DC Area');
            insert acc;
            FCST_Product_Model__c pm = new FCST_Product_Model__c(Account_CPM_Region__c='US-DC Area',Account__c=acc.Id);
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
            insert fcl;
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                //for(integer i=0;i<101;i++){
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
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.FCST_CompucomBaseLineWorkbenchNewPage')); 
            System.currentPageReference().getParameters().put('pv', plversionObj.id);
            System.currentPageReference().getParameters().put('AccId', acc.id);
            System.currentPageReference().getParameters().put('su', u.id);
            System.currentPageReference().getParameters().put('getincreaseValue', '5');
            System.currentPageReference().getParameters().put('id', initial_flist[0].id);
            System.currentPageReference().getParameters().put('planningModelAmount', '10');
            FCST_CompucomBaseLineWorkbenchNewPage cc = new FCST_CompucomBaseLineWorkbenchNewPage();
            cc.total_size =10;
            cc.getPlanningYearOptionList();
            cc.getContractChange();
            cc.mainfetchOppRecord();
            cc.updatePlanningModel();
           // cc.updateRiskFector();
            cc.gotohomepage();
            cc.BackPage();
            cc.Beginning();
            cc.Previous();
            cc.Next();
            cc.End();
            cc.getDisablePrevious();
            cc.getDisableNext();
            cc.getTotal_size();
            cc.getPageNumber();
            cc.getTotalPages();
            
            test.stopTest();
        }
    }


   static testmethod void getData2(){
        FCST_UTIL.InsertTriggerMappingFields();
            user u=[select id,UserRoleId from user where id=:userinfo.getUserId()];
        list<FCST_Initial_Forecast__c> initial_flist = new list<FCST_Initial_Forecast__c>();
        system.runAs(u){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole ur = new UserRole(Name = 'CEO',ParentRoleId = u.UserRoleId);
            insert ur;
            
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            
            User u1 = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
            insert u1;
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
            Date startDate = Date.newInstance(2018,1,1);
            Date endDate = startDate.addDays(30);
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
            Account acc = new Account(Name='Test Account');
            insert acc;
            FCST_Contract__c contr = new FCST_Contract__c();
            // contr.name = 'Contract412368';
            contr.Fcst_Account__c = acc.Id;
            contr.Contract__c = 'Contract412368';
            contr.FCST_Contract_Created_Year__c = '2018';   
            contr.Contract_Owner__c= u.id;
            contr.Fcst_Geo_Numbers__c = 'TestNum';
            insert contr;
            
            List<Contract_LineItem__c> cliList = new List<Contract_LineItem__c>();
            Contract_LineItem__c fcl = new Contract_LineItem__c();
            //  fcl.name = 'sample test';
            fcl.FCST_Contract__c = contr.id;
            fcl.BSLA_Number__c = '20';
            fcl.Cost_Center__c = 'Test CC';
            cliList.add(fcl);
            
            insert cliList;
            
            for(Integer i=1;i<20;i++){
                FCST_Initial_Forecast__c flist= new FCST_Initial_Forecast__c();
                //for(integer i=0;i<101;i++){
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
            list<Actual_Model__c> amlist = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel = new Actual_Model__c();
                actModel.Account__c = acc.Id;
                actModel.FCST_Contract__c=contr.id;
                actModel.Actual_Type__c = 'Baseline';
                actModel.Contract_LineItem__c = fcl.Id;
                actModel.Actual_Amount__c = 20000;
                actModel.BSLA__c =  fcl.BSLA_Number__c;
                actModel.FCST_CC__c = fcl.Cost_Center__c;
                actModel.Fiscal_Year__c = fymList[0].Fiscal_Planning_Year__c;
                actModel.Fiscal_Period__c = fymmap.get(i).id;
                actModel.FCST_Planning_Version__c = plversionObj.Id;
                actModel.Fiscal_Year__c = fyp.Id;
                actModel.Contract_LineItem__c = cliList[0].Id;
                actModel.FCST_GEO__c = contr.Fcst_Geo_Numbers__c;
                //  insert actModel;
                amlist.add(actModel);
            }
            insert amlist;
            
            
             list<Actual_Model__c> amlist1 = new list<Actual_Model__c>();
            for(Integer i=1;i<20;i++){
                Actual_Model__c actModel1 = new Actual_Model__c();
                actModel1.Account__c = acc.Id;
                actModel1.FCST_Contract__c=contr.id;
                actModel1.Actual_Type__c = 'Baseline';
                actModel1.Contract_LineItem__c = fcl.Id;
                actModel1.Actual_Amount__c = 0;
                actModel1.BSLA__c =  fcl.BSLA_Number__c;
                actModel1.FCST_CC__c = fcl.Cost_Center__c;
                actModel1.Fiscal_Year__c = fymList[0].Fiscal_Planning_Year__c;
                actModel1.Fiscal_Period__c = fymmap.get(i).id;
                actModel1.FCST_Planning_Version__c = plversionObj.Id;
                actModel1.Fiscal_Year__c = fyp.Id;
                actModel1.Contract_LineItem__c = cliList[0].Id;
                actModel1.FCST_GEO__c = contr.Fcst_Geo_Numbers__c;
                //  insert actModel;
                amlist1.add(actModel1);
            }
            insert amlist1;
            
            
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.FCST_CompucomBaseLineWorkbenchNewPage')); 
            System.currentPageReference().getParameters().put('pv', plversionObj.id);
            System.currentPageReference().getParameters().put('AccId', acc.id);
            System.currentPageReference().getParameters().put('su', u.id);
            System.currentPageReference().getParameters().put('getincreaseValue', '5');
            System.currentPageReference().getParameters().put('id', initial_flist[0].id);
            System.currentPageReference().getParameters().put('planningModelAmount', '10');
            System.currentPageReference().getParameters().put('lineItemId', fcl.Id);
            System.currentPageReference().getParameters().put('periodnumber', plversionObj.Id);
            System.currentPageReference().getParameters().put('actualAmount', '20000');
            
            FCST_CompucomBaseLineWorkbenchC cc = new FCST_CompucomBaseLineWorkbenchC();
            cc.strPlanningVersion = '2018';
            cc.strPlanningVersion = '2019';
            cc.total_size =10;
            cc.Beginning();
            //cc.Previous();
            cc.Next();
            cc.End();
            cc.getDisablePrevious();
            cc.getDisableNext();
            cc.getTotal_size();
            cc.getPageNumber();
            cc.getTotalPages();
            cc.getPlanningYearOptionList();
            cc.getContractChange();
            cc.mainfetchOppRecord();
            cc.fetchOppRecord();
            cc.updatePlanningModel();
            cc.updateRiskFactor();
            cc.gotohomepage();
            cc.updateActualModel();
            cc.BackPage();
}
}
}