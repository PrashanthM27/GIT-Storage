@isTest
public class Test_FCST_Insert_Contract_Util {
    static testMethod void getContractData(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser) {
             FCST_UTIL.InsertTriggerMappingFields();
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
                                                              Fcst_Q__c='division__c');
            insert setting;
            
            
            
            Account ac = new Account();
            ac.Name = 'Test Account';
            insert ac;
            Fcst_Geo_Codes__c fgc  = new Fcst_Geo_Codes__c(name='test test1');
            insert fgc;
            List<Opportunity> optList = new List<Opportunity>();
            Opportunity opt = new Opportunity();
            opt.Name = 'test Oppt';
            opt.OwnerId = thisUser.Id;
            opt.AccountId = ac.Id;
            opt.StageName = 'Closed Won';
            opt.Fcst_Text_QNum__c = 'Q-44297';
            opt.CloseDate = System.today();
            opt.Fcst_Geo_Codes__c = fgc.id;
            optList.add(opt);
            
            if(optList!=NULL && !optList.isEmpty()){
                //insert optList;
            }
            
            FCST_Contract__c cont = new FCST_Contract__c();
            cont.Opportunity__c = optList[0].Id;
            cont.Fcst_Geo_Name__c = setting.geo_name__c;
            cont.Fcst_Geo_Number__c = 689;
            cont.FCST_Q__c = 'test' ;
            cont.FCST_Contract_Created_Year__c = String.valueOf(opt.CloseDate);
            cont.Contract_Owner__c = thisUser.Id;
            /* cont.Fcst_Geo_Name__c = 'geo name';
cont.Fcst_Geo_Number__c = 99999;
cont.FCST_Q__c = 'QData'; */     
           // insert cont;
            
            
            FCST_Insert_Contract_Util contrUtil = new FCST_Insert_Contract_Util();
            FCST_Insert_Contract_Util.createContracts(optList);
        }
    }
    static testMethod void getContractData2(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser) {
             FCST_UTIL.InsertTriggerMappingFields();
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
                                                              Fcst_Q__c='division__c');
            insert setting;
            
            
            Account ac = new Account();
            ac.Name = 'Test Account';
            insert ac;
            
            List<Opportunity> optList = new List<Opportunity>();
            Opportunity opt = new Opportunity();
            opt.Name = 'test Oppt';
            opt.AccountId = ac.Id;
            opt.StageName = 'Closed Won';
            opt.Fcst_Text_QNum__c = setting.Fcst_Q__c;
            opt.CloseDate = System.today();
            optList.add(opt);
            
            if(optList!=NULL && !optList.isEmpty()){
                insert optList;
            }
            
            FCST_Contract__c cont = new FCST_Contract__c();
            cont.Opportunity__c = optList[0].Id;
            cont.Fcst_Geo_Name__c = 'geo_name__c';
            cont.Fcst_Geo_Number__c = 2000;
            cont.FCST_Q__c = setting.Fcst_Q__c;
            cont.FCST_Contract_Created_Year__c = String.valueOf(opt.CloseDate);
            // cont.Contract_Owner__c = thisUser.Id;
            /* cont.Fcst_Geo_Name__c = 'geo name';
cont.Fcst_Geo_Number__c = 99999;
cont.FCST_Q__c = 'QData'; */     
            insert cont;
            
            
            FCST_Insert_Contract_Util contrUtil = new FCST_Insert_Contract_Util();
            FCST_Insert_Contract_Util.createContracts(optList);
            FCST_Insert_Contract_Util.updateCPMRegionOfContract(optList);
        }
    }
}