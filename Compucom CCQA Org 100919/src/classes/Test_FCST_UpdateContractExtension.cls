@isTest
public class Test_FCST_UpdateContractExtension {
    static testMethod void contractData(){
             FCST_UTIL.InsertTriggerMappingFields();
            Date srtDate = date.newInstance(2019,02,28);    
            Date endate = Date.newInstance(2019,01,19);
        
          Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',
                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='fcst_geo_codes__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='fcst_q__c	');
            insert setting;
            
        
                 String qnum = 'Q000-035';
                Account ac = new Account();
                ac.Name = 'Account';
                insert ac;
        
                Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
                opt.AccountId = ac.Id;
                opt.Fcst_Text_QNum__c = 'fcst_q__c';
                opt.StageName = 'Closed Won';
                opt.CloseDate = srtDate;
                insert opt;
        
        PageReference pgf = Page.FCST_Update_Contract;
            Test.setCurrentPage(pgf);
            
        pgf.getparameters().put('id',String.valueOf(opt.Id));
        
        List<Fcst_Cost_Center__c> costC = new List<Fcst_Cost_Center__c>();
        Fcst_Cost_Center__c costCentr = new Fcst_Cost_Center__c();
        costCentr.Name = '010A';
        costCentr.Cost_Center_Description__c = 'TestDataDESC';
        costCentr.BSLA__c = '203563';
        costCentr.BU_Level1__c = 'Corporate';
        costCentr.BU_Level_2__c = 'Corp';
        insert costCentr;
        costC.add(costCentr);
        
        Planning_Version__c plv = new Planning_Version__c();
        plv.Name = '2019-March';
        plv.Version_Status__c =  'Open (Admin)';
        insert plv;
        
        Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
            fyp.Name = '2019';
            fyp.StartDate__c = srtDate;
            fyp.EndDate__c = endate;
            insert fyp;
         
        List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
        for(Integer i=0;i<20;i++){
        Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
        fym.Short_Label__c = 'TestData';
        fym.Period_Number__c = 1;
        fym.Fiscal_Planning_Year__c = fyp.Id;
        fymList.add(fym);
        }
        
        if(fymList!=null && !fymList.isEmpty()){
            insert fymList;
        }
        
        Fiscal_Year_Model__c fym2 = new Fiscal_Year_Model__c();
        fym2.Short_Label__c = 'TestData2';
        fym2.Period_Number__c = 2;
        fym2.Fiscal_Planning_Year__c = fyp.Id;
        insert fym2;
        
       FCST_Contract__c contr = new FCST_Contract__c();
            contr.Fcst_Account__c = ac.Id;
            contr.Contract__c = 'TestContract';
            contr.Contract_Description__c = 'TestDescr';
           // contr.Contract_Owner__c = loginUser.id;
            contr.FCST_Contract_Created_Year__c = '2019';
            contr.Fcst_Geo_Name__c = 'geo name';
            contr.Fcst_Geo_Number__c = 99999;
            contr.FCST_Q__c = 'QData';
            contr.Opportunity__c = opt.Id;
            insert contr;
            
            Contract_LineItem__c contLineItem = new Contract_LineItem__c();
            contLineItem.FCST_Contract__c = contr.Id;
            contLineItem.FCST_Fiscal_Year_List__c = fyp.Id;
            contLineItem.Risk_Factor__c = 233;
            insert contLineItem;
        
        List<FCST_Initial_Forecast__c> intFcstList = new List<FCST_Initial_Forecast__c>();
        for(Integer i=0;i<20;i++){
        FCST_Initial_Forecast__c iniFcst = new FCST_Initial_Forecast__c();
        iniFcst.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
        iniFcst.FCST_Fiscal_Year_List__c = fymList[0].Fiscal_Planning_Year__c;
        iniFcst.Fcst_Amount__c = 0;
        iniFcst.Contract_LineItem__c = contLineItem.Id;
        iniFcst.FCST_Contract__c = contr.Id;
        iniFcst.Account__c = ac.Id;
        intFcstList.add(iniFcst);
        }
        if(intFcstList!=null && !intFcstList.isEmpty()){
            insert intFcstList;
        }
        
       // for(Fiscal_Year_Model__c fymm:fymList){
       /* FCST_Initial_Forecast__c iniFcst = new FCST_Initial_Forecast__c();
        iniFcst.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
        iniFcst.FCST_Fiscal_Year_List__c = fyp.Id;
        iniFcst.Fcst_Amount__c = 0;
        iniFcst.Contract_LineItem__c = contLineItem.Id;
        iniFcst.FCST_Contract__c = contr.Id;
        iniFcst.Account__c = ac.Id;
        insert iniFcst;*/
        // }

        FCST_Opportunity_Initial_Forecast__c oif = new FCST_Opportunity_Initial_Forecast__c();
        oif.Fcst_Fiscal_Period__c = fymList[0].Id;
        oif.Fcst_Weighted_Revenue__c = 84;
        oif.Fcst_Opportunity__c = opt.Id;
        oif.FCST_Planning_Version__c = plv.Id;
        oif.Fcst_Q__c =  opt.Fcst_Text_QNum__c;
        insert oif;
        
        FCST_Opportunity_Initial_Forecast__c oif2 = new FCST_Opportunity_Initial_Forecast__c();
        oif2.Fcst_Fiscal_Period__c = fym2.Id;
        oif2.Fcst_Weighted_Revenue__c = 1000;
        oif2.Fcst_Opportunity__c = opt.Id;
        oif2.FCST_Planning_Version__c = plv.Id;
        oif2.Fcst_Q__c =  opt.Fcst_Text_QNum__c;
        insert oif2;
        
       /* Fcst_Geo_Code__c geoCode = new Fcst_Geo_Code__c();
        geoCode.Name = 'fcst_geo_code__c';
        insert geoCode;*/
        
        ApexPages.StandardController std=new ApexPages.StandardController(opt);
        FCST_UpdateContractExtension  updContract = new FCST_UpdateContractExtension(std);
        FCST_UpdateContractExtension.WMonths months = new FCST_UpdateContractExtension.WMonths(2000,'Test');
        List<FCST_UpdateContractExtension.ContractLinewrapper> contLineWrpList = new List<FCST_UpdateContractExtension.ContractLinewrapper>();
        //FCST_UpdateContractExtension.ContractLinewrapper contrLine = new FCST_UpdateContractExtension.ContractLinewrapper('Test',contLineItem,intFcstList,true);
       // contLineWrpList.add(contrLine);
        FCST_UpdateContractExtension.Contractwrapper contrWrp = new FCST_UpdateContractExtension.Contractwrapper(contr,intFcstList,contLineWrpList);
        
        FCST_UpdateContractExtension.getOpportunityStage(String.valueOf(opt.Id));
        updContract.cfiscalyear = '2019';
        updContract.generateDynamicId();
        updContract.lineItemDuplicateValue();
        //updContract.costcentremethod();
        updContract.createInitialForecast(contr.Id,contLineItem.Id,ac.Id);
        updContract.getProduct();
        updContract.searchContract();
        updContract.getCostCentre();
        updContract.getFiscalYears();
        updContract.searchContract();
        updContract.getCostCentre();
        updContract.getOpportunityInitialTotal();
        updContract.lineItemInitialTotal();
        updContract.getBSLA();
        updContract.addContractLineItem();
        updContract.removeContractLineItem();
        updContract.RevertProduct();
        updContract.EditProduct();
        updContract.goBack();
        updContract.saveContract();

        }
    
    static testMethod void contractData2(){
             FCST_UTIL.InsertTriggerMappingFields();
            Date srtDate = date.newInstance(2019,02,28);    
            Date endate = Date.newInstance(2019,01,19);
        
          Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',
                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='fcst_geo_codes__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='fcst_q__c	');
            insert setting;
            
        
                 String qnum = 'Q000-035';
                Account ac = new Account();
                ac.Name = 'Account';
                insert ac;
        
                Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
                opt.AccountId = ac.Id;
                opt.Fcst_Text_QNum__c = 'fcst_q__c';
                opt.StageName = 'Closed Won';
                opt.CloseDate = srtDate;
                insert opt;
        
        PageReference pgf = Page.FCST_Update_Contract;
            Test.setCurrentPage(pgf);
            
        pgf.getparameters().put('id',String.valueOf(opt.Id));
        
        List<Fcst_Cost_Center__c> costC = new List<Fcst_Cost_Center__c>();
        Fcst_Cost_Center__c costCentr = new Fcst_Cost_Center__c();
        costCentr.Name = '010A';
        costCentr.Cost_Center_Description__c = 'TestDataDESC';
        costCentr.BSLA__c = '203563';
        costCentr.BU_Level1__c = 'Corporate';
        costCentr.BU_Level_2__c = 'Corp';
        insert costCentr;
        costC.add(costCentr);
        
        Planning_Version__c plv = new Planning_Version__c();
        plv.Name = '2019-March';
        plv.Version_Status__c =  'Open (Admin)';
        insert plv;
        
        Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c();
            fyp.Name = '2019';
            fyp.StartDate__c = srtDate;
            fyp.EndDate__c = endate;
            insert fyp;
         
        List<Fiscal_Year_Model__c> fymList = new List<Fiscal_Year_Model__c>();
        for(Integer i=0;i<20;i++){
        Fiscal_Year_Model__c fym = new Fiscal_Year_Model__c();
        fym.Short_Label__c = 'TestData';
        fym.Period_Number__c = 1;
        fym.Fiscal_Planning_Year__c = fyp.Id;
        fymList.add(fym);
        }
        
        if(fymList!=null && !fymList.isEmpty()){
            insert fymList;
        }
        
        Fiscal_Year_Model__c fym2 = new Fiscal_Year_Model__c();
        fym2.Short_Label__c = 'TestData2';
        fym2.Period_Number__c = 2;
        fym2.Fiscal_Planning_Year__c = fyp.Id;
        insert fym2;
        
       FCST_Contract__c contr = new FCST_Contract__c();
            contr.Fcst_Account__c = ac.Id;
            contr.Contract__c = 'TestContract';
            contr.Contract_Description__c = 'TestDescr';
           // contr.Contract_Owner__c = loginUser.id;
            contr.FCST_Contract_Created_Year__c = '2019';
            contr.Fcst_Geo_Name__c = 'geo name';
            contr.Fcst_Geo_Number__c = 99999;
            contr.FCST_Q__c = 'QData';
            contr.Opportunity__c = opt.Id;
            insert contr;
            
            Contract_LineItem__c contLineItem = new Contract_LineItem__c();
            contLineItem.FCST_Contract__c = contr.Id;
            contLineItem.FCST_Fiscal_Year_List__c = fyp.Id;
            contLineItem.Risk_Factor__c = 233;
            insert contLineItem;
        
        List<FCST_Initial_Forecast__c> intFcstList = new List<FCST_Initial_Forecast__c>();
        for(Integer i=0;i<20;i++){
        FCST_Initial_Forecast__c iniFcst = new FCST_Initial_Forecast__c();
        iniFcst.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
        iniFcst.FCST_Fiscal_Year_List__c = fymList[0].Fiscal_Planning_Year__c;
        iniFcst.Fcst_Amount__c = 0;
        iniFcst.Contract_LineItem__c = contLineItem.Id;
        iniFcst.FCST_Contract__c = contr.Id;
        iniFcst.Account__c = ac.Id;
        intFcstList.add(iniFcst);
        }
        if(intFcstList!=null && !intFcstList.isEmpty()){
            insert intFcstList;
        }
        
       // for(Fiscal_Year_Model__c fymm:fymList){
       /* FCST_Initial_Forecast__c iniFcst = new FCST_Initial_Forecast__c();
        iniFcst.FCST_Planning_Fiscal_Year__c = fymList[0].Id;
        iniFcst.FCST_Fiscal_Year_List__c = fyp.Id;
        iniFcst.Fcst_Amount__c = 0;
        iniFcst.Contract_LineItem__c = contLineItem.Id;
        iniFcst.FCST_Contract__c = contr.Id;
        iniFcst.Account__c = ac.Id;
        insert iniFcst;*/
        // }

        FCST_Opportunity_Initial_Forecast__c oif = new FCST_Opportunity_Initial_Forecast__c();
        oif.Fcst_Fiscal_Period__c = fymList[0].Id;
        oif.Fcst_Weighted_Revenue__c = 84;
        oif.Fcst_Opportunity__c = opt.Id;
        oif.FCST_Planning_Version__c = plv.Id;
        oif.Fcst_Q__c =  opt.Fcst_Text_QNum__c;
        insert oif;
        
        FCST_Opportunity_Initial_Forecast__c oif2 = new FCST_Opportunity_Initial_Forecast__c();
        oif2.Fcst_Fiscal_Period__c = fym2.Id;
        oif2.Fcst_Weighted_Revenue__c = 1000;
        oif2.Fcst_Opportunity__c = opt.Id;
        oif2.FCST_Planning_Version__c = plv.Id;
        oif2.Fcst_Q__c =  opt.Fcst_Text_QNum__c;
        insert oif2;
        
       /* Fcst_Geo_Code__c geoCode = new Fcst_Geo_Code__c();
        geoCode.Name = 'fcst_geo_code__c';
        insert geoCode;*/
        
        ApexPages.StandardController std=new ApexPages.StandardController(opt);
        FCST_UpdateContractExtension  updContract = new FCST_UpdateContractExtension(std);
        FCST_UpdateContractExtension.WMonths months = new FCST_UpdateContractExtension.WMonths(2000,'Test');
        List<FCST_UpdateContractExtension.ContractLinewrapper> contLineWrpList = new List<FCST_UpdateContractExtension.ContractLinewrapper>();
        //FCST_UpdateContractExtension.ContractLinewrapper contrLine = new FCST_UpdateContractExtension.ContractLinewrapper('Test',contLineItem,intFcstList,true);
       // contLineWrpList.add(contrLine);
        FCST_UpdateContractExtension.Contractwrapper contrWrp = new FCST_UpdateContractExtension.Contractwrapper(contr,intFcstList,contLineWrpList);
        
        FCST_UpdateContractExtension.getOpportunityStage(String.valueOf(opt.Id));
        updContract.cfiscalyear = '2019';
        updContract.generateDynamicId();
        updContract.lineItemDuplicateValue();
        //updContract.costcentremethod();
        updContract.createInitialForecast(contr.Id,contLineItem.Id,ac.Id);
        updContract.getProduct();
        updContract.searchContract();
        updContract.getCostCentre();
        updContract.getFiscalYears();
        updContract.searchContract();
        updContract.getCostCentre();
        updContract.getOpportunityInitialTotal();
        updContract.lineItemInitialTotal();
        updContract.getBSLA();
        updContract.addContractLineItem();
        updContract.removeContractLineItem();
        updContract.RevertProduct();
        updContract.EditProduct();
        updContract.goBack();
        updContract.saveContract();

        }
    }