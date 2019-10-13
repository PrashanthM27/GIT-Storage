@isTest
public class Test_MappingFieldUtility {
    static testmethod void mfudata(){
        string orgid  = UserInfo.getOrganizationId();
        string datestring = string.valueOf(datetime.now()).replace(':','').replace('-','').replace(' ','');
        integer RandomInteger = integer.valueOf(math.random()*100000);
        string uniquename= orgid + datestring + RandomInteger;
        UserRole ur = new UserRole(Name = 'CEO');
        profile p=[select id from profile where name='Standard User'];
        User u=new user(Alias='StndUsr', Email=uniquename+'@testorg.com',EmailEncodingKey='UTF-8',LastName='test',LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',ProfileId=p.id,UserRoleId=ur.id, TimeZonesidKey='America/Los_Angeles',
                        UserName=uniquename+'@testorg.com');
        
        insert u;
        System.runAs(u){
            sobject obj ;
            sobject Opportunity;
            //   Opportunity opp = new Opportunity(); 
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
            
            Opportunity opt = new Opportunity();
            opt.Name = 'Test Opportunity';
            opt.Partial_Shipments__c = 'Yes';
            opt.Fcst_Type__c = 'Project';
            opt.CloseDate=System.today();
            opt.Fcst_Start_Date__c = system.today();
            opt.StageName='Closed Won';
            opt.Fcst_End_Date__c = system.today();
          
            insert opt;
            
            test.startTest();
            MappingFieldUtility mfu= new MappingFieldUtility();
          //  mfu.getBusinessUnit();
          //  mfu.getBusinessUnit(Obj);
            mfu.getCPMRegion();
            mfu.getCPMRegion(Obj);
            mfu.getOpportunityDynamicFields();
            mfu.getProjectEndDate();
            mfu.getProjectEndDate(opt);
            mfu.getProjectStartDate();
            mfu.getProjectStartDate(opt);
            mfu.getRevenueType();
           // mfu.getRevenueType(opt);
            mfu.getSalesRegion();
            mfu.getSalesRegion(Obj);
            mfu.getSubRegion();
            mfu.getSubRegion(Obj);
            mfu.getQNum();
            mfu.getGeoNum();
            mfu.getProgramManager();
           // mfu.getQNum(opt);
            
            test.stopTest();
        }
        
    }
    static testmethod void mfudata1(){
        string orgid  = UserInfo.getOrganizationId();
        string datestring = string.valueOf(datetime.now()).replace(':','').replace('-','').replace(' ','');
        integer RandomInteger = integer.valueOf(math.random()*100000);
        string uniquename= orgid + datestring + RandomInteger;
        UserRole ur = new UserRole(Name = 'CEO');
        profile p=[select id from profile where name='Standard User'];
        User u=new user(Alias='StndUsr1', Email=uniquename+'@testorg.com',EmailEncodingKey='UTF-8',LastName='test',LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',ProfileId=p.id,UserRoleId=ur.id, TimeZonesidKey='America/Los_Angeles',
                        UserName=uniquename+'@testorg.com');
        
        insert u;
        System.runAs(u){
            sobject obj;
            Opportunity opp = new Opportunity();
            Mapping_Setting__c setting1=new Mapping_Setting__c(name='FCST Mapping Data');
            insert setting1;
            
            test.startTest();
            MappingFieldUtility mfu= new MappingFieldUtility();
           // mfu.getBusinessUnit();
          //  mfu.getBusinessUnit(Obj);
            mfu.getCPMRegion();
            mfu.getCPMRegion(Obj);
            mfu.getOpportunityDynamicFields();
            mfu.getProjectEndDate();
            mfu.getProjectEndDate(Obj);
            mfu.getProjectStartDate();
            mfu.getProjectStartDate(Obj);
            mfu.getRevenueType();
            mfu.getRevenueType(opp);
            mfu.getSalesRegion();
            mfu.getSalesRegion(Obj);
            mfu.getSubRegion();
            mfu.getSubRegion(Obj);
            test.stopTest();
        }
    }
}