public class Mapping_Setting_UTIL {
    public void mapSettingUTIL(){
        Mapping_Setting__c setting = new Mapping_Setting__c();
            setting.Name = 'FCST Mapping Data';
            setting.FCST_BSLA__c = 'fcst_bsla__c';
            setting.Cost_Center__c = 'fcst_cost_center__c';
            setting.Fcst_BusinessUnit__c = 'Test_Picklist__c';
            setting.Fcst_CPM__c = 'fcst_cpm_region__c';
            setting.Fcst_EndDate__c = 'fcst_end_date__c';
            setting.FCST_Program_Executive__c  = 'fcst_program_executive__c';
            setting.FCST_ProgramManager__c  = 'fcst_program_manager__c';
            setting.Fcst_SalesRegion__c  = 'fcst_account_region_vertical__c';
            setting.Fcst_StartDate__c  = 'fcst_start_date__c';
            setting.Fcst_SubRegion__c  = 'fcst_account_sub_region__c';
            setting.FCST_GeoCodes__c  = 'fcst_geocodes__c';
            setting.Fcst_Q__c  = 'fcst_q__c';
            setting.Fcst_Revenue_Type__c  = 'fcst_revenue_type__c';
            setting.Geo__c  = 'fcst_geo_codes__c';
            setting.Geo_Name__c  = 'geo_name__c';
            setting.Term_In_Months__c  = 'Deal_Duration__c';
            setting.Transition_Date__c  = 'CloseDate';
            setting.Opportunity_SVC_YR1__c='amount';
            setting.Opportunity_TCV__c='deal_tcv__c';
            setting.Opportunity_RecordType_Api__c = 'Division__c';
            insert setting;
    }
}