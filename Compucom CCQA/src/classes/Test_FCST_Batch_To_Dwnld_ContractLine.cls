@istest
public class Test_FCST_Batch_To_Dwnld_ContractLine {
     testMethod static void testCase1(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =1;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            cli.BSLA_Number__c = '2020320';
            cli.Cost_Center__c = 'Test Cost Center';
            cli.Cost_Center_Description__c ='Test Descr';
            cli.Fcst_Revenue_Type__c = 'Test Rev';
            cli.BSLA__c = 'Test BSLA';
            insert cli;
              
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
            FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
              
              
              
          } 
     }
     testMethod static void testCase2(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =2;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            cli.BSLA_Number__c = '2020320';
            cli.Cost_Center__c = 'Test Cost Center';
            cli.Cost_Center_Description__c ='Test Descr';
            cli.Fcst_Revenue_Type__c = 'Test Rev';
            cli.BSLA__c = 'Test BSLA';
            insert cli;
              
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
              
             
            
        Test.stopTest();
          }
     }
      testMethod static void testCase3(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =3;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            cli.BSLA_Number__c = '2020320';
            cli.Cost_Center__c = 'Test Cost Center';
            cli.Cost_Center_Description__c ='Test Descr';
            cli.Fcst_Revenue_Type__c = 'Test Rev';
            cli.BSLA__c = 'Test BSLA';
            insert cli;
              
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
	 testMethod static void testCase4(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =4;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            cli.BSLA_Number__c = '2020320';
            cli.Cost_Center__c = 'Test Cost Center';
            cli.Cost_Center_Description__c ='Test Descr';
            cli.Fcst_Revenue_Type__c = 'Test Rev';
            cli.BSLA__c = 'Test BSLA';
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
            FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase5(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
            List<FCST_Contract__c> contrList = new List<FCST_Contract__c>();
            FCST_Contract__c contracts1 = new FCST_Contract__c();
            contracts1.Contract__c = 'TestData';
            contracts1.Contract_Owner__c = thisUser.Id;
            contracts1.FCST_Q__c = 'Q000-035';
            contracts1.Contract_Description__c = 'Demo45';
            contracts1.Opportunity__c = optList[0].Id;
            contrList.add(contracts1);
              
              if(contrList!=null && !contrList.isEmpty()){
                  insert contrList;
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =5;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            cli.BSLA_Number__c = '2020320';
            cli.Cost_Center__c = 'Test Cost Center';
            cli.Cost_Center_Description__c ='Test Descr';
            cli.Fcst_Revenue_Type__c = 'Test Rev';
            cli.BSLA__c = 'Test BSLA';
            insert cli;
              
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            obj.Execute(NULL,contrList);
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase6(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =6;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase7(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =7;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase8(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =8;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase9(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =9;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase10(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =10;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     }
     testMethod static void testCase11(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 2;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =11;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          }
     
}
    testMethod static void testCase12(){
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          System.runAs(thisUser) {
               FCST_UTIL.InsertTriggerMappingFields();
         list<Contract_LineItem__c> contractlineitems = new list<Contract_LineItem__c>();
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
                opt.CloseDate = srtDate;
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }  
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Contract__c = 'TestData';
            contracts.Contract_Owner__c = thisUser.Id;
            contracts.FCST_Q__c = 'Q000-035';
            contracts.Contract_Description__c = 'Demo45';
            contracts.Opportunity__c = optList[0].Id;
            insert contracts;
              
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
                fym.Fiscal_Quarter__c = 'Q1';
                fym.Fiscal_Year__c = '2019';
                fym.Long_Label__c = 'February';
                fym.Period_Name__c = 'February';
                fym.Period_Number__c = 12;
                fym.Record_Source__c = 'Installation';
                fym.Short_Label__c = 'Feb';
                fym.Start_Date__c = srtDate;
                fym.Month_Number__c =12;
                fymList.add(fym);
            }
            if(fymList!=null && !fymList.isEmpty()){
                insert fymList;
            }
             Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Risk_Factor__c = 40;
            cli.FCST_Fiscal_Year_List__c = fypList[0].Id;
            insert cli;
         //  list<FCST_Initial_Forecast__c> FCSTinitialforecast = new list<FCST_Initial_Forecast__c>();   
              FCST_Initial_Forecast__c intFcst = new FCST_Initial_Forecast__c();
            intFCST.Name = 'TestInt';
            intFCST.Fcst_Amount__c = 20000;
            intFCST.FCST_Contract__c = contracts.Id;
            intFCST.FCST_Fiscal_Year_List__c = fypList[0].Id;
            intFCST.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
            intFCST.Contract_LineItem__c = cli.Id;
            intFCST.Planning_Version__c = plvList[0].Id;
          //  intFCST.FCST_Planning_Fiscal_Year__c= fymList[0].Id;
            insert intFCST;
              Test.startTest();

            FCST_HyperLinkUpload_Batch_Download obj = new FCST_HyperLinkUpload_Batch_Download('2019');
            DataBase.executeBatch(obj); 
            FCST_Batch_To_Dwnld_ContractLine obj23 = new FCST_Batch_To_Dwnld_ContractLine('2019');
            DataBase.executeBatch(obj23);
            
            FCST_Batch_ContractLine_Download obj223 = new FCST_Batch_ContractLine_Download('2019');
            DataBase.executeBatch(obj223);
              
        Test.stopTest();
          }
     
}
}