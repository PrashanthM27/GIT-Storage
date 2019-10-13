@isTest
public class Test_Fcst_RevRecognizationRules {
    static testMethod void productData(){
           Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='fcst_geo_code_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
        
        Fcst_Rev_Rec_Revenue_Type__c revType = new Fcst_Rev_Rec_Revenue_Type__c();
        revType.Name = 'Prod - Commodity';
        revType.Fcst_12_Month_Duration__c = true;
        insert revType;
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                Family = 'Hosted Services',
                isActive = true
            );
            insert prod;
              
            
        FCST_Revenue_Recognization_Product__c revPrd = new FCST_Revenue_Recognization_Product__c();
        revPrd.Amount__c = 100;
        revPrd.Date_del__c = true;
      //  revPrd.Offering_Category__c = 'Hosted Services';
        revPrd.Product__c = prod.Id;
        revPrd.Period__c = 'M+4';
        revPrd.Product_Code__c = 'TestPrd';
        revPrd.Revenue_Type__c = 'Prod - Commodity';
        insert revPrd;
        FCST_RevRecognizationRules frevrec = new FCST_RevRecognizationRules();
        frevrec.intTotalVal = Integer.valueOf('100');
        frevrec.strMonths= 'Test1';
        frevrec.getCategeoryFields();
        frevrec.oppType= revPrd.Revenue_Type__c ;
        frevrec.getActiveProducts();
         frevrec.strPrd = prod.id;
        frevrec.getTermsMonths();
        List<FCST_RevRecognizationRules.WrapperTermsMonth> wtmList = new List<FCST_RevRecognizationRules.WrapperTermsMonth>();
        FCST_RevRecognizationRules.WrapperTermsMonth wtm = new FCST_RevRecognizationRules.WrapperTermsMonth('M+1','100%',String.valueOf(revPrd.Id));
        List<FCST_RevRecognizationRules.WrapperPeriod> wrpList = new List<FCST_RevRecognizationRules.WrapperPeriod>();
        FCST_RevRecognizationRules.WrapperPeriod wrpData = new FCST_RevRecognizationRules.WrapperPeriod('M+4',revPrd);
        wrpList.add(wrpData);
        wrpData.compareTo(wrpData);
        wrpData.rev = revPrd; 
        wtmList.add(wtm);
        FCST_RevRecognizationRules.WrapperRegime wrg = new FCST_RevRecognizationRules.WrapperRegime('Test2',2,wrpList);
        list<FCST_RevRecognizationRules.WrapperRegime> testWrapper = new list<FCST_RevRecognizationRules.WrapperRegime>();
        testWrapper.add(wrg);     
        frevrec.lstRegime = testWrapper;
        frevrec.lstWrapperTermsMonth = wtmList;
        frevrec.selProductId = 'TestPrd';
        frevrec.blnCheck = true;
        frevrec.getIsClassic();
        frevrec.save();
        FCST_RevRecognizationRules.getPicklistValues('Account','Industry');
        frevrec.getRevenuePlanning();
        frevrec.getRegimeCalculation();
        //frevrec.getProductFamilys();
        frevrec.getTotals();
        
        
        frevrec.getTotalVal();
        frevrec.customSave();
        
         PageReference pgf = Page.FCST_RevRecognizationRules;
            Test.setCurrentPage(pgf);
            
            pgf.getparameters().put('pageMessage','Test');
        
    }
    
        static testMethod void productData2(){
             Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='fcst_geo_code_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
        Fcst_Rev_Rec_Revenue_Type__c revType = new Fcst_Rev_Rec_Revenue_Type__c();
        revType.Name = 'Prod - Commodity';
        revType.Fcst_12_Month_Duration__c = true;
        insert revType;
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                Family = 'Hosted Services',
                isActive = true
            );
            insert prod;
           
        
        FCST_RevRecognizationRules frevrec = new FCST_RevRecognizationRules();
        frevrec.intTotalVal = Integer.valueOf('100');
        frevrec.strMonths= 'Test1';
        frevrec.getCategeoryFields();
        frevrec.oppType= 'Prod - Commodity' ;
        frevrec.getActiveProducts();
         frevrec.strPrd = prod.id;
        frevrec.getTermsMonths();
        List<FCST_RevRecognizationRules.WrapperTermsMonth> wtmList = new List<FCST_RevRecognizationRules.WrapperTermsMonth>();
        FCST_RevRecognizationRules.WrapperTermsMonth wtm = new FCST_RevRecognizationRules.WrapperTermsMonth('M+1','test','');
       // FCST_RevRecognizationRules.WrapperTermsMonth wtm1 = new FCST_RevRecognizationRules.WrapperTermsMonth('M+1','100',String.valueOf(revPrd.Id));
        List<FCST_RevRecognizationRules.WrapperPeriod> wrpList = new List<FCST_RevRecognizationRules.WrapperPeriod>();
        FCST_RevRecognizationRules.WrapperPeriod wrpData = new FCST_RevRecognizationRules.WrapperPeriod('M+4',null);
        wrpList.add(wrpData);
        wrpData.compareTo(wrpData);
       // wrpData.rev = revPrd; 
        wtmList.add(wtm);
      //  wtmList.add(wtm1);

        FCST_RevRecognizationRules.WrapperRegime wrg = new FCST_RevRecognizationRules.WrapperRegime('Test2',2,wrpList);
        list<FCST_RevRecognizationRules.WrapperRegime> testWrapper = new list<FCST_RevRecognizationRules.WrapperRegime>();
        testWrapper.add(wrg);     
        frevrec.lstRegime = testWrapper;
        frevrec.lstWrapperTermsMonth = wtmList;
        frevrec.selProductId = 'TestPrd';
       
        frevrec.blnCheck = true;
        frevrec.getIsClassic();
        frevrec.save();
        FCST_RevRecognizationRules.getPicklistValues('Account','Industry');
        frevrec.getRevenuePlanning();
        frevrec.getRegimeCalculation();
        //frevrec.getProductFamilys();
        frevrec.getTotals();
        
        
        frevrec.getTotalVal();
        frevrec.customSave();
        
         PageReference pgf = Page.FCST_RevRecognizationRules;
            Test.setCurrentPage(pgf);
            
            pgf.getparameters().put('pageMessage','Test');
        }

           static testMethod void getData5(){
                Mapping_Setting__c setting=new Mapping_Setting__c(name='FCST Mapping Data',
                                                              Cost_Center__c='fcst_cost_center__c',
                                                              FCST_ProgramManager__c = 'lastmodifiedbyid',

                                                              Fcst_CPM__c='fcst_cpm_region__c',
                                                              Fcst_EndDate__c='fcst_end_date__c',
                                                              Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                              Fcst_StartDate__c='fcst_start_date__c',
                                                              Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                              Fcst_Revenue_Type__c='fcst_revenue_type__c',
                                                              Geo__c='fcst_geo_code_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;
                FCST_RevRecognizationRules frevrec = new FCST_RevRecognizationRules();
               frevrec.oppType= 'Prod - Commodity' ;
                frevrec.strPrd = '--None--';
                frevrec.getTermsMonths();
               frevrec.getActiveProducts();
                frevrec.initmethod();
            }
       
    
}