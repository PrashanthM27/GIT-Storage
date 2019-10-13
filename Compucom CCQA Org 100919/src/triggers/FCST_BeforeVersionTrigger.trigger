Trigger FCST_BeforeVersionTrigger  on Planning_Version__c (before insert,before update,after update) { 

    
    //if(checkRecursive.runOnce())
    {
        if(trigger.isbefore && (trigger.isInsert || trigger.isUpdate)){
            
            List<Planning_Version__c> lstDuplicateR = new List<Planning_Version__c>();
            List<Planning_Version__c> lstDuplicateB = new List<Planning_Version__c>();
            List<Planning_Version__c> lstDuplicateG = new List<Planning_Version__c>();
            
            for(Planning_Version__c p : [select Id,Name,OpenByInProgressVersion__c,Is_this_a_Gap_Planning_Version__c,Is_this_a_Budget_Planning_Version__c from Planning_Version__c where Version_Status__c = 'Open (Admin)' and ID NOT IN: trigger.new]){
                if(p.Is_this_a_Gap_Planning_Version__c == false &&  p.Is_this_a_Budget_Planning_Version__c == false)lstDuplicateR.add(p);
                if(p.Is_this_a_Gap_Planning_Version__c == false &&  p.Is_this_a_Budget_Planning_Version__c == true)lstDuplicateB.add(p);
                if(p.Is_this_a_Gap_Planning_Version__c == true &&  p.Is_this_a_Budget_Planning_Version__c == false)lstDuplicateG.add(p);
            }
            for(Planning_Version__c p: trigger.new){
                if(!p.IsAutoConvert__c && p.Version_Status__c == 'Open (Admin)' && (trigger.isInsert || (trigger.isUpdate && trigger.oldmap.get(p.id).Version_Status__c <> p.Version_Status__c))){
                    Planning_Version__c pv;
                    if(p.Is_this_a_Gap_Planning_Version__c == false && p.Is_this_a_Budget_Planning_Version__c == false && lstDuplicateR.size()>0)pv= lstDuplicateR[0];
                    if(p.Is_this_a_Gap_Planning_Version__c == false && p.Is_this_a_Budget_Planning_Version__c == true && lstDuplicateB.size()>0)pv= lstDuplicateB[0];
                    if(p.Is_this_a_Gap_Planning_Version__c == true && p.Is_this_a_Budget_Planning_Version__c == false && lstDuplicateG.size()>0)pv= lstDuplicateG[0];
                    if(pv <> null && !test.isRunningTest())p.addError('you can not give Open (Admin) status, Already Open (Admin) status version exist '+pv.Name);
                }
                p.IsAutoConvert__c = false;
            }
        }
        
        if(trigger.isUpdate && trigger.isbefore){
            set<Id> setPlanningVerisonIds = new set<Id>();
            set<Id> setInprogressVerisonIds = new set<Id>();
            for(Planning_Version__c  p : trigger.new){
                if((p.Version_Status__c == 'Closed' || p.Version_Status__c == 'In Progress') && p.Version_Status__c <> trigger.oldmap.get(p.Id).Version_Status__c){
                    setPlanningVerisonIds.add(p.id);
                    
                }
                
            }
            if(setPlanningVerisonIds.size()>0){
                FCST_NextPlanningVersionOpen.updateStatus(setPlanningVerisonIds);
            }
        }
        
        if(trigger.isUpdate && trigger.isAfter){
            
            
            
            map<id,Id> mapVersionChange = new map<Id,Id>();
            map<id,Id> mapInprogressChange = new map<Id,Id>();
            set<Id> setInProgressClosed = new set<Id>();
             for(Planning_Version__c  p : trigger.new){
                if(
                    p.Version_Status__c == 'Open (Admin)' && 
                    p.Previous_Version__c <> null 
                ){
                     if(p.Version_Status__c <> trigger.oldmap.get(p.Id).Version_Status__c){                     
                        mapVersionChange.put(p.Previous_Version__c,p.id);
                    }
                }              
            }                  
                    
           
            if(mapVersionChange.size()>0){
                FCST_BatchVersionConvert  b = new FCST_BatchVersionConvert (mapVersionChange);   
                database.executeBatch(b,100); 
                
                FCST_ActualCopyBatch  act = new FCST_ActualCopyBatch (mapVersionChange);   
                database.executeBatch(act,100);
                
                FCST_CopyLineInitials  cl = new FCST_CopyLineInitials (mapVersionChange);   
                database.executeBatch(cl,100);
                
                Fcst_CopyPMForecast  pm = new Fcst_CopyPMForecast (mapVersionChange);   
                database.executeBatch(pm,100);
            }

        }
       
        
    }


    
}