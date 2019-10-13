@isTest
public class Test_ActualModelCSVImportController {
   /* static String csvBody = 'Revenue_Stream,amount,Current_Month_Expected_Revenue,Contract_Id,CDR_Description,CDR,CC_Description,CC,BSLA,Geo_Description,Geo,BSLA,Period,Type \n TestBSLA,2000,Managed Service - Billable COGS,Services,123,123,123,678,Geo Description, ,Revenue,1,P-001 #### BSL,3000,Service - Billable,Ser,123,123,53,123,123, , ,Rev,1,P-002 ####';
    public static String[] csvFileLines;
    public static Blob csvFileBody;

    static testmethod void testfileupload(){
                   
        csvFileBody = Blob.valueOf(csvBody);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('####'); 
        String str = '",",';
        
        
          Date srtDate = date.newInstance(2019,02,28);    
          Date endate = Date.newInstance(2019,01,19);
            
        
        PageReference pref = Page.ActualModelCSVImport;
        Test.setCurrentPage(pref);
        String strYear = '2019';
        
         Planning_Version__c plv = new Planning_Version__c();
        plv.Name = '2018';
        plv.Data_Entry_Start_Date__c = srtDate;
        plv.Is_this_a_Budget_Planning_Version__c = false;
        plv.Is_this_a_Gap_Planning_Version__c = false;
        plv.Version_Status__c = 'Open (Admin)';
        insert plv;
        
        List<Account> acList = new List<Account>();
            for(Integer i=0;i<20;i++){
                Account ac = new Account();
                ac.Name = 'Account';
                acList.add(ac);
            }
            if(acList!=null && !acList.isEmpty()){
                insert acList;
            }
        
        Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
        fyp.Name = strYear;
        fyp.EndDate__c = endate;
        fyp.StartDate__c = srtDate;
        insert fyp;

        Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
        fym.Name = ' FYRevenueP01';
        fym.Fiscal_Planning_Year__c = fyp.Id;
        insert fym;
        
        FCST_Contract__c contr = new FCST_Contract__c();
        contr.Fcst_Account__c = acList[0].Id;
        contr.Contract__c = 'TestContract';
        contr.Contract_Description__c = 'TestDescr';
        // contr.Contract_Owner__c = loginUser.id;
        contr.FCST_Contract_Created_Year__c = '2019';
        contr.Fcst_Geo_Name__c = 'geo name';
        contr.Fcst_Geo_Numbers__c = 'Test GeoNum';
        contr.FCST_Q__c = 'QData';
        insert contr;
            
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contr.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Fcst_Revenue_Type__c = 'TestRev';
            insert cli;
        Decimal dec = 2.97876;
        
       /* Actual_Model__c actModel = new Actual_Model__c();
            actModel.Fiscal_Year__c = '';
                actModel.Account__c = '';
                actModel.Actual_Type__c= '';
                actModel.FCST_Contract__c= '';
                actModel.Contract_LineItem__c= '';
                actModel.Revenue_Type__c= '';
                actModel.Revenue_Stream__c= '';
                actModel.CDR_Description__c= '';
                actModel.CDR__c= dec;
                actModel.CC__c= dec;
                actModel.CC_Description__c= '';
                actModel.GEO__c= dec;
                actModel.GEO_Description__c= '';
                actModel.BSLA__c= '';
                actModel.Fiscal_Period__c= '';
                actModel.Actual_Amount__c= dec;
                actModel.FCST_Planning_Version__c= '';
                actModel.Fiscal_Period__c= '';
                actModel.Opportunity__c= '';
               // actModel.Contract__c= '';
                
            insert actModel;
        
        ActualModelCSVImportController_CLONED importData = new ActualModelCSVImportController_CLONED();
        List<ActualModelCSVImportController_CLONED.WrapperModel> wrapList = new List<ActualModelCSVImportController_CLONED.WrapperModel>();
        ActualModelCSVImportController_CLONED.WrapperModel wrap = new ActualModelCSVImportController_CLONED.WrapperModel();
       
           wrap.BSLA = '';
           wrap.CC = '';
            wrap.CC_Description = '';
            wrap.CDR = '';
            wrap.CDR_Description= '';
            wrap.Contract_Id= '';
            wrap.Current_Month_Expected_Revenue = dec;
            wrap.Geo= '';
            wrap.Geo_Description= '';
            wrap.Revenue_Stream= '';
            wrap.CurrencyISO= '';
            wrap.Period= '';
            wrap.periodNumber= '';
            wrap.year= '';
            wrap.revenueType= '';
         wrapList.add(wrap);
        
        importData.fileName = 'TestFiles';
       // ActualModelCSVImportController_CLONED.getStringToNumber('Test');
        importData.getErrorFile();
        ActualModelCSVImportController_CLONED.getStringToNumber(',');
        importData.csvFileBody = csvFileBody;
        importData.getAmountFromString(csvAsString);
        importData.uploadCSV();
        importData.getErrorFile();
        importData.blobToString(csvFileBody,'Test');
        
    } 

    static testmethod void testfileuploadNegative(){
        Test.startTest();       
        csvFileBody = Blob.valueOf(csvBody);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('####'); 
        
        String str = '",",';
        
        ActualModelCSVImportController_CLONED importData = new ActualModelCSVImportController_CLONED();
        importData.getAmountFromString(str);
        importData.uploadCSV();
        importData.getErrorFile();
        ActualModelCSVImportController_CLONED.getStringToNumber(null);
        importData.getErrorFile();
        Test.stopTest();
    }*/

    static String csvBody = 'Account_Manager,BSLA_Description",BSLA_Number,CC_PLevel,Annuity_Project,GEO_Number,GEO_Name,Client_Name,Contract_Number,Contract_Name_Description,Business_Unit,Jan-19,Feb-19,Mar-19,Apr-19,May-19,JUN-19,Jul-19,Aug-19,Sep-19,Oct-19,Nov-19,Dec-19,Baseline_year,Planning_version,Year #### Testing,testBSL,203563 123,5363 TEST,52,225,TestClient,123,K180504-00001,Annuity Revenue,123,1,2,3,4,5,6,7,8,9,10,11,12,2019,2019,2019';
  
  public static String[] csvFileLines;
    public static Blob csvFileBody;

    static testmethod void testfileupload(){
        User loginUser = FCST_Util.createUser(); 
        System.runAs(loginUser){
         FCST_UTIL.InsertTriggerMappingFields();
        csvFileBody = Blob.valueOf(csvBody);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        String str = '",",';
        
        
          Date srtDate = date.newInstance(2019,02,28);    
          Date endate = Date.newInstance(2019,01,19);
            
        
       PageReference pref = Page.ContractDataCSVImport_v2;
        Test.setCurrentPage(pref);
        String strYear = '2019';
        
        Planning_Version__c plv = new Planning_Version__c();
        plv.Name = '2019';
        plv.Data_Entry_Start_Date__c = srtDate;
        plv.Is_this_a_Budget_Planning_Version__c = false;
        plv.Is_this_a_Gap_Planning_Version__c = false;
        plv.Version_Status__c = 'Open (Admin)';
        insert plv;
        
        List<Account> acList = new List<Account>();
            for(Integer i=0;i<20;i++){
                Account ac = new Account();
                ac.Name = 'TestClient';
                acList.add(ac);
            }
            if(acList!=null && !acList.isEmpty()){
                insert acList;
            }
        
        List<Opportunity> opList = new List<Opportunity>();
        for(Integer i=0;i<20;i++){
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        opp.CloseDate = System.today();
        opp.StageName = 'Prospecting';
        opList.add(opp);
        }
        if(opList!=null && !opList.isEmpty()){
            insert opList;
        }

        Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
        fyp.Name = '2019';
        fyp.EndDate__c = endate;
        fyp.StartDate__c = srtDate;
        insert fyp;

        Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
        fym.Name = ' FY2019P01';
        fym.Fiscal_Planning_Year__c = fyp.Id;
        insert fym;
        
            FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Fcst_Account__c = acList[0].id;
            contracts.Contract__c = 'K180504-00001';
            contracts.Contract_Description__c = 'OMS Staff Aug';
            contracts.FCST_Contract_Created_Year__c = '2018';
            contracts.Fcst_Geo_Name__c = 'GE HEALTHCARE';
            contracts.Fcst_Geo_Number__c = 225;
            contracts.FCST_Q__c = 'fcst_q__c';
            contracts.Opportunity__c = opList[0].Id;
            contracts.Contract_Owner__c = loginUser.Id;
            contracts.Contract__c ='123';
            insert contracts;
            
            Contract_LineItem__c cli = new Contract_LineItem__c();
            cli.FCST_Contract__c = contracts.Id;
            cli.Line_Description__c = 'testDesc';
            cli.Fcst_Revenue_Type__c = 'TestRev';
            cli.Cost_Center__c = '12';
            insert cli;

        ActualModelCSVImportController importData = new ActualModelCSVImportController();
        ActualModelCSVImportController.WrapperModel wrpModel = new  ActualModelCSVImportController.WrapperModel();
        ActualModelCSVImportController.getStringToNumber(null);
        importData.fileName = 'TestFiles';
      //  wrpModel.errorMessage = 'TestFiles';
       
        importData.csvFileBody = csvFileBody;
        importData.getAmountFromString(str);
        importData.uploadCSV();
        importData.uploadCSV();
        importData.getErrorFile();
            
             // ActualModelCSVImportController_CLONED.setErrorMessage(wrpModel,'Test');
           // ContactsDataCSVImportController_v2.setErrorMessage(null,'test');
        
    }
    }
    static testmethod void testfileuploadNegative(){
         FCST_UTIL.InsertTriggerMappingFields();
        Test.startTest();       
        csvFileBody = Blob.valueOf(csvBody);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        
        String str = '",",';
        
         List<Account> acList = new List<Account>();
            for(Integer i=0;i<20;i++){
                Account ac = new Account();
                ac.Name = 'TestA';
                acList.add(ac);
            }
            if(acList!=null && !acList.isEmpty()){
                insert acList;
            }
        
        FCST_Contract__c contracts = new FCST_Contract__c();
            contracts.Fcst_Account__c = null;
            contracts.Contract__c = 'Contract-0002';
            contracts.Contract_Description__c = 'OMS Staff Aug';
           // contracts.FCST_Contract_Created_Year__c = '2018';
            //contracts.Fcst_Geo_Name__c = 'GE HEALTHCARE';
            //contracts.Fcst_Geo_Number__c = 225;
            //contracts.FCST_Q__c = 'fcst_q__c';
            //contracts.Opportunity__c = opList[0].Id;
            //contracts.Contract_Owner__c = loginUser.Id;
                
            insert contracts;
        
        ActualModelCSVImportController importData = new ActualModelCSVImportController();
        ActualModelCSVImportController.getStringToNumber('(');
       // importData.getAmountFromString(str);
        importData.uploadCSV();
        importData.getErrorFile();
        Test.stopTest();
    }
    
}