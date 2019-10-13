@isTest
public class TEST_FCST_MultiCurrencyConversion{

    static testMethod void CurrencyConversion(){
        
        User loginUser = FCST_Util.createUser(); 
        system.runAs(loginUser)
        {
             FCST_UTIL.InsertTriggerMappingFields();
            
            Account Acc = FCST_Util.createAccount();
            insert Acc;
            Set<Id> oppId = new Set<Id>();
            List<Opportunity> lstRegularOpp = new List<Opportunity>();
            for(Integer i =1;i<=20;i++){
                lstRegularOpp.add(FCST_Util.createOpportunity('Test Opp-'+i,Acc.Id,'Regular'));
            }
            insert lstRegularOpp;
            
            set<Id> setOppIds = new set<Id>();
            for(Opportunity opp : lstRegularOpp){
                setOppIds.add(opp.id);
            }
            
            FCST_CurrencyConversion.Initialization();
            map<Id,string> mapcurrency = FCST_CurrencyConversion.opportunityCurrencyCode(setOppIds);   
            decimal t = FCST_CurrencyConversion.Convert('USD','USD',100);
          
        }
    }
}