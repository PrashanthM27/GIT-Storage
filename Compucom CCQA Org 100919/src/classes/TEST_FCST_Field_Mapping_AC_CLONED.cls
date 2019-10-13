@isTest
public class TEST_FCST_Field_Mapping_AC_CLONED   {
    
    static testMethod void test_mappingV1(){
        Mapping_Setting__c m1 = new Mapping_Setting__c();
        m1.Name = 'FCST Mapping Data';
        m1.FCST_ProgramManager__c = 'fcst_program_manager__c';
        m1.Cost_Center__c = 'fcst_cost_center__c';
        m1.Geo__c = 'fcst_geo_codes__c';
        m1.Geo_Name__c = 'geo_name__c';
        m1.Fcst_Q__c= 'fcst_q__c';
        m1.Fcst_SalesRegion__c='fcst_account_region_vertical__c	';
        m1.Fcst_SubRegion__c='fcst_account_sub_region__c';
        m1.Fcst_CPM__c='fcst_cpm_region__c	';
        m1.Fcst_Revenue_Type__c='fcst_revenue_type__c';
        m1.Fcst_StartDate__c='fcst_start_date__c';
        m1.Fcst_EndDate__c='fcst_end_date__c';
        m1.FCST_Program_Executive__c = 'fcst_program_executive__c';
        m1.FCST_GeoCodes__c = 'fcst_geocodes__c';
        m1.Opportunity_TCV__c = 'deal_tcv__c';
        m1.Opportunity_SVC_YR1__c = 'amount';
        m1.Fcst_BusinessUnit__c = 'test_picklist__c';
        m1.Term_In_Months__c = 'deal_duration__c';
        m1.Transition_Date__c = 'closedate';
        insert m1;  
        
        
        FCST_Field_Mapping_AC_CLONED fm = new FCST_Field_Mapping_AC_CLONED();
        fm.oppAmountStr = 'OppStr';
        fm.getOppPicklist();
        fm.getOppDatePicklist();
        fm.getOppDecimalPicklist();
        fm.getAccPicklist();
        fm.save();
        fm.gotohomepage();
        fm.getOppNum();
        fm.getOpptName();
        fm.getOpptStrFlds();
        fm.getOpptPrds();
        fm.getProductStrFlds();
        fm.getAccLookupFlds();
        fm.getProgramEngineers();
        fm.getAccountGeoCodes();
        fm.getbusinessUnitPicklist();
        fm.getOppTCVPicklist();
        fm.getSVCDecimalPicklist();
        fm.getTermsMonth();
        fm.getTransDatePicklist();
        
    }
    
    static testMethod void test_mappingV2(){
        FCST_Field_Mapping_AC_CLONED fm = new FCST_Field_Mapping_AC_CLONED();
        fm.getOppDatePicklist();
        fm.save();
    }
    
    static testMethod void test_mappingV3(){
        Mapping_Setting__c m2 = new Mapping_Setting__c();
        m2.Name = 'FCST Mapping Data';
        m2.Cost_Center__c = '--None--';
        m2.Geo__c = '--None--';
        m2.Geo_Name__c = '--None--';
        m2.Fcst_SalesRegion__c='--None--';
        m2.Fcst_SubRegion__c='--None--';
        m2.Fcst_CPM__c='--None--';
        m2.Fcst_Revenue_Type__c='--None--';
        m2.Fcst_StartDate__c='--None--';
        m2.Fcst_EndDate__c='--None--';
        m2.Fcst_Q__c = '--None--';
        m2.FCST_GeoCodes__c = '--None--';
        m2.FCST_ProgramManager__c = '--None--';
        m2.FCST_Program_Executive__c = '--None--';
        m2.Opportunity_TCV__c = '--None--';
        m2.Opportunity_SVC_YR1__c = '--None--';
        m2.Fcst_BusinessUnit__c = '--None--';
        m2.Term_In_Months__c = '--None--';
        m2.Transition_Date__c = '--None--';
        insert m2;
        
        
        FCST_Field_Mapping_AC_CLONED fm = new FCST_Field_Mapping_AC_CLONED();
        fm.save();
    }
    
}