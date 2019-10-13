@isTest
public class Test_Fcst_FunnelSW {
    static testMethod void getPlData(){
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
                                                              Geo__c='geo_test__c',
                                                              Geo_Name__c='geo_name__c',
                                                              Fcst_Q__c='division__c');
            insert setting;           
            
              
      /* Mapping_Setting__c setting =new Mapping_Setting__c(name='FCST Mapping Data',Cost_Center__c='quantityunitofmeasure',
                                                                
                                                                Fcst_CPM__c='fcst_cpm_region__c',Fcst_EndDate__c='fcst_end_date__c',
                                                                Fcst_SalesRegion__c='fcst_account_region_vertical__c',
                                                                Fcst_StartDate__c='fcst_start_date__c',
                                                                Fcst_SubRegion__c='fcst_account_sub_region__c',
                                                                Fcst_Revenue_Type__c='fcst_type__c',
                                                                Geo__c='rating',Geo_Name__c='industry',Q__c='division__c');
            insert setting;*/
        
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
            
           // FCST_UTIL.InsertMappingFields();
            
            List<Planning_Version__c> plvList = new List<Planning_Version__c>();
            for(Integer i=0;i<20;i++){
                Planning_Version__c plv = new Planning_Version__c(Name  = '2019'+i);
                plvList.add(plv);    
            }
            insert plvList;
            
            List<Fiscal_Year_Planning__c> ftpList = new List<Fiscal_Year_Planning__c>();
            for(Integer i=0;i<20;i++){
                Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(name='2019',EndDate__c=System.today()+2,StartDate__c=System.today());
                ftpList.add(fyp);
            }        
            insert ftpList;
            List<Opportunity> oppList = new List<Opportunity>();
            List<Account> accList = new List<Account>();
            for(Integer i=0;i<4;i++){
                Account acc = new Account(Name='Test Account');
                accList.add(acc);
            }
            if(accList!=null && accList.size()>0)
                insert accList;
            
          
                Planning_Version__c plvr = new Planning_Version__c();
                plvr.Name = '2019-March';
                plvr.Version_Status__c = 'Open (Admin)'; 
                insert plvr;
            
            Account ac = new Account();
            ac.Name = 'Test Account';
            insert ac;

            Fiscal_Year_Model__c fypl= new Fiscal_Year_Model__c(name='FY2019P01');
            insert fypl;
            
            Planning_Version__c pv= new Planning_Version__c(name='2019'); insert pv;
           /* Fiscal_Year_Model__c fypl= new Fiscal_Year_Model__c(name='FY2019P01');
            insert fypl;*/
 
            Opportunity opt = new Opportunity();
            opt.AccountId = ac.Id;
            opt.Amount = 20000;
            opt.Name = 'Test Oppt';
            opt.StageName = 'Lead (Above the Funnel)';
            opt.CloseDate = System.today();
            opt.AccountId = ac.Id;
            insert opt;
            
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
                OpportunityId = opt.Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id
                
            );
            oli.TotalPrice = oli.quantity * pbEntry.UnitPrice;
            oli.Risk_Factor__c = 0;
            insert oli;
         FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
           prdModel.Account__c = ac.Id;
            prdModel.Opportunity__c = opt.Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
           // prdModel.Planning_Version__c = plvList[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            //prdModel.Risk_Factor_Revenue__c = 10;
            prdModel.Amount__c = 100;
          //  prdmodel.Fiscal_Period__c = plv.id;
            prdmodel.Fiscal_Period__c = fypl.id;
            prdmodel.Planning_Version__c = pv.id;
            insert prdModel;
            
            /*FCST_Product_Model__c prdModel = new FCST_Product_Model__c();
            prdModel.Account__c = accList[0].Id;
            prdModel.Opportunity__c = opt.Id;
            prdModel.FCST_Product_Line_ID__c=oli.id;
            prdModel.Planning_Version__c = plvList[0].Id;
            prdModel.Weighted_Revenue__c = 10;
            prdModel.Amount__c = 100;
          //  prdmodel.Fiscal_Period__c = plv.id;
            prdmodel.Fiscal_Period__c = fypl.id;
            prdmodel.Planning_Version__c = plvList[0].id;
            insert prdModel;   */
            
            Fiscal_Year_Model__c fypl1= new Fiscal_Year_Model__c(name='FY2019P03');
            insert fypl1;
            FCST_Product_Model__c prdModel1 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl1.id,
            Planning_Version__c = pv.id);
            insert prdModel1; 
            Fiscal_Year_Model__c fypl2= new Fiscal_Year_Model__c(name='FY2019P04');
            insert fypl2;
            FCST_Product_Model__c prdModel2 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl2.id,
            Planning_Version__c = pv.id);
            insert prdModel2;
             Fiscal_Year_Model__c fypl3= new Fiscal_Year_Model__c(name='FY2019P05');
            insert fypl3;
            FCST_Product_Model__c prdModel3 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl3.id,
            Planning_Version__c = pv.id);
            insert prdModel3;
            Fiscal_Year_Model__c fypl4= new Fiscal_Year_Model__c(name='FY2019P06');
            insert fypl4;
            FCST_Product_Model__c prdModel4 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl4.id,
            Planning_Version__c = pv.id);
            insert prdModel4;
            Fiscal_Year_Model__c fypl5= new Fiscal_Year_Model__c(name='FY2019P07');
            insert fypl5;
            FCST_Product_Model__c prdModel5 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl5.id,
            Planning_Version__c = pv.id);
            insert prdModel5;
            Fiscal_Year_Model__c fypl6= new Fiscal_Year_Model__c(name='FY2019P08');
            insert fypl6;
            FCST_Product_Model__c prdModel6 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl6.id,
            Planning_Version__c = pv.id);
            insert prdModel6;
            Fiscal_Year_Model__c fypl7= new Fiscal_Year_Model__c(name='FY2019P09');
            insert fypl7;
            FCST_Product_Model__c prdModel7 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl7.id,
            Planning_Version__c = pv.id);
            insert prdModel7;
            Fiscal_Year_Model__c fypl8= new Fiscal_Year_Model__c(name='FY2019P10');
            insert fypl8;
            FCST_Product_Model__c prdModel8 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl8.id,
            Planning_Version__c = pv.id);
            insert prdModel8;
            Fiscal_Year_Model__c fypl9= new Fiscal_Year_Model__c(name='FY2019P11');
            insert fypl9;
            FCST_Product_Model__c prdModel9 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl9.id,
            Planning_Version__c = pv.id);
            insert prdModel9;
            Fiscal_Year_Model__c fypl10= new Fiscal_Year_Model__c(name='FY2019P12');
            insert fypl10;
            FCST_Product_Model__c prdModel10 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl10.id,
            Planning_Version__c = pv.id);
            insert prdModel10;
             Fiscal_Year_Model__c fypl11= new Fiscal_Year_Model__c(name='FY2019P02');
            insert fypl11;
            FCST_Product_Model__c prdModel11 = new FCST_Product_Model__c(Account__c = ac.Id,Opportunity__c = opt.Id,FCST_Product_Line_ID__c=oli.id,
            Weighted_Revenue__c = 10,Amount__c = 100,Fiscal_Period__c = fypl11.id,
            Planning_Version__c = pv.id);
            insert prdModel11;
            
       //FCST_InsertProductModel.AddModels(oli);
        PageReference pgf = Page.Fcst_OpenSW;
        Test.setCurrentPage(pgf);
        
        pgf.getparameters().put('pv',String.valueOf(pv.Id));
        pgf.getparameters().put('AccId',String.valueOf(ac.Id));
        pgf.getparameters().put('su',String.valueOf(u.Id));
        pgf.getparameters().put('id',String.valueOf(prdModel.Id));
        pgf.getparameters().put('getincreaseValue',String.valueOf(0));

            for(Account acc :accList){
                System.debug('acc>>>>>>>>'+acc.Name+'>>>>>>>>>..acc.Id'+acc.Id);
                for(Integer i=1;i<5;i++){
                    Opportunity opp = new Opportunity();
                    opp.Name='Test Optimistic'+i; 
                    opp.AccountID=acc.Id; 
                    opp.stageName = 'Lead (Above the Funnel)';
                    oppList.add(opp);
                }
            }
           test.startTest();
     Fcst_FunnelSW fcp = new Fcst_FunnelSW();
        fcp.pVVersionStringId = 'Test';
        fcp.strPlanningVersion = plvList[0].Name;
        fcp.strPlanYear = '2017';
        fcp.Beginning();
        fcp.Previous();
        fcp.Next();
        fcp.End();
        fcp.counter=2;
        fcp.getDisablePrevious();
        fcp.counter=-2;
        fcp.getDisablePrevious();
        fcp.getDisableNext();
        fcp.getTotal_size();
        fcp.getPageNumber();
        fcp.getTotalPages();
        fcp.mainfetchOppRecord();
        fcp.updatePlanningModel();
        fcp.gotohomepage();
        fcp.BackPage();
        //fcp.getPlanningYearOptionList();
        fcp.strOpportunity = 'Test Oppt';
        fcp.StageNameSet.add('Lead (Above the Funnel)');
        fcp.opportunitySet.add('Test Oppt');
        fcp.strPlanningVersion = '2019';
        fcp.likeStr = 'FY2019P01';
        fcp.fetchOppRecord();
            test.stopTest();
    }
    }
    
    static testMethod void getPlData1(){
        List<Planning_Version__c> plvList = new List<Planning_Version__c>();
        for(Integer i=0;i<20;i++){
        Planning_Version__c plv = new Planning_Version__c(Name  = '2019');
        plvList.add(plv);    
        }
        insert plvList;
        
        
        List<Fiscal_Year_Planning__c> ftpList = new List<Fiscal_Year_Planning__c>();
        for(Integer i=0;i<20;i++){
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(name='2019',EndDate__c=System.today()+2,StartDate__c=System.today());
            ftpList.add(fyp);
        }        
        insert ftpList;
        
         Fiscal_Year_Planning__c fypg = new Fiscal_Year_Planning__c();
        fypg.Name = null;
        fypg.EndDate__c = System.today()+2;
        fypg.StartDate__c = System.today();
        insert fypg;
        
        Fcst_FunnelSW fcp = new Fcst_FunnelSW();
        fcp.strPlanningYear = null;
        fcp.strPlanningVersion = null;
               
    }
    static testMethod void getPlData2(){
        Fcst_FunnelSW fcp = new Fcst_FunnelSW();
        fcp.strOpportunity = null;

}
    static testMethod void getPlData3(){
        Fcst_FunnelSW fcp = new Fcst_FunnelSW();
        fcp.strOpportunity = 'All';

}
    static testMethod void getPlData4(){
        Fcst_FunnelSW fcp = new Fcst_FunnelSW();
        fcp.strOpportunity = '';

}
}