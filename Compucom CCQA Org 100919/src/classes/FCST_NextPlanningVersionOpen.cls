public class FCST_NextPlanningVersionOpen{
    //@future
    public static void updateStatus(set<Id> setPlanningVerisonIds){
        
        map<string,Planning_Version__c> mapRExistingVersion = new map<string,Planning_Version__c>();       
        for(Planning_Version__c p : [select Id,OpenByInProgressVersion__c,Name,SequenceNo__c,Planning_Version_Fiscal_Year__c from Planning_Version__c where Is_this_a_Gap_Planning_Version__c = false and Is_this_a_Budget_Planning_Version__c = false and SequenceNo__c >= 1 and  SequenceNo__c <= 12 limit 50000]){
            mapRExistingVersion.put(p.Planning_Version_Fiscal_Year__c+'-'+p.SequenceNo__c,p);            
        }
        map<Id,Planning_Version__c> mapNextPlanningVersion = new map<Id,Planning_Version__c>();
        for(Planning_Version__c  p : [select Id,OpenByInProgressVersion__c,Is_this_a_Gap_Planning_Version__c,Is_this_a_Budget_Planning_Version__c,SequenceNo__c,Version_Status__c,Planning_Version_Fiscal_Year__c from Planning_Version__c  where Is_this_a_Gap_Planning_Version__c = false and Is_this_a_Budget_Planning_Version__c = false and id IN: setPlanningVerisonIds]){
            
                Integer sno = Integer.valueOf(p.SequenceNo__c);sno++;
                Integer pyear = Integer.valueOf(p.Planning_Version_Fiscal_Year__c);
                if(sno == 13){sno=1;pyear++;}
                string key = pyear+'-'+sno;
                Planning_Version__c pp;
                if(mapRExistingVersion.containsKey(key))pp = mapRExistingVersion.get(key);
                if(pp<>null)mapNextPlanningVersion.put(p.id,pp);
        }
        if(mapNextPlanningVersion.size()>0){
            List<Planning_Version__c> lstP = new List<Planning_Version__c>();
            for(Id pId : mapNextPlanningVersion.keyset()){
                Planning_Version__c p = mapNextPlanningVersion.get(pId);
                p.Previous_Version__c = pId;
                p.Version_Status__c = 'Open (Admin)';
                p.OpenByInProgressVersion__c = false;
                p.IsAutoConvert__c = true;
              //  if(setInprogressVerisonIds.contains(pId))
                   // p.OpenByInProgressVersion__c = true;
                lstP.add(p);
            }
            if(Schema.sObjectType.Planning_Version__c.fields.Previous_Version__c.isUpdateable() &&
               Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isUpdateable() &&
               Schema.sObjectType.Planning_Version__c.fields.OpenByInProgressVersion__c.isUpdateable()){
                update lstP;
            }
        }
    }
}