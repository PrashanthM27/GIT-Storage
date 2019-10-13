@isTest
Private class Test_FCST_To_CleanModel {

    static testmethod void getData(){
        
    user u=[select id from user where id=:userinfo.getUserId()];
    system.runAs(u){
        
        list<opportunity> oplist= new list<opportunity>();
        for(integer i=0;i<10;i++){
            opportunity op= new opportunity(name='Test opty '+i, stagename='Qualification',closedate=system.today()+15); 
            oplist.add(op);
        }
        insert oplist;
        set<id> OpIds = new set<id>();
        for(opportunity opty:oplist){
            OpIds.add(opty.id);
        }
        list<FCST_Product_Model__c> pmlist= new list<FCST_Product_Model__c>();
        for(integer i=0;i<10;i++){
            FCST_Product_Model__c pm = new FCST_Product_Model__c(Opportunity__c=oplist[i].id);
            pmlist.add(pm);
        }
        insert pmlist;
        
        test.startTest();
        FCST_To_CleanModel cmodel= new FCST_To_CleanModel(OpIds);
        database.executebatch(cmodel);
        test.stopTest();
        
    }
        
    }
    
}