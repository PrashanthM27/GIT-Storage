global class FCSTBatchToHandleAccountTrigger implements Database.Batchable<sObject>,Database.Stateful {
    
    string cpmRegionLabelName;
   global List<Account> accListVal;
   global String query='';
    global FCSTBatchToHandleAccountTrigger(List<Account> accList) {
        Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        if(mapCustomObj <> null)
            cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
        
        accListVal = new List<Account>();   
        accListVal.addAll(accList);
       query='Select Account_CPM_Region__c,Account__r.'+cpmRegionLabelName+'  from FCST_Product_Model__c where Account__c IN: accListVal';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
           
        return Database.getQueryLocator(query); 
    } 
    
    global void execute(Database.BatchableContext bc, List<FCST_Product_Model__c> productModelListVal){
        try{
            List<FCST_Product_Model__c> modelListCPMUpdate = new List<FCST_Product_Model__c>();
            
            if(productModelListVal!=null && productModelListVal.size()>0){
                for(FCST_Product_Model__c proObj:productModelListVal){
                    String CPMRegion='';
                    if((Account)proObj.getSObject('Account__r')!=null)
                       CPMRegion=(String)proObj.getSObject('Account__r').get(cpmRegionLabelName);
                    
                    proObj.Account_CPM_Region__c=CPMRegion;
                    modelListCPMUpdate.add(proObj);
                }
            }
        
          if(modelListCPMUpdate!=null && modelListCPMUpdate.size()>0)
           update modelListCPMUpdate;
            
        }
        catch(Exception e) {
            System.debug('Exception Message '+e);
            System.debug('Exception Line Number: '+e.getLineNumber());
        
        }   
    
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}