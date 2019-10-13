global class FCST_To_CleanModel implements Database.Batchable<sObject>,Database.Stateful {
		
    public Set<Id> oppIdSetdelete{get;set;}
    
	global FCST_To_CleanModel(Set<Id> oppIdSet) {
		oppIdSetdelete = new Set<Id>();
		oppIdSetdelete.addAll(oppIdSet);
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		if(oppIdSetdelete!=null && oppIdSetdelete.size()>0){
	      return Database.getQueryLocator('Select Id from FCST_Product_Model__c where Opportunity__r.Id IN:oppIdSetdelete');
	    }
	    else{
	      return null;
	    }  
    }
    
     global void execute(Database.BatchableContext bc, List<FCST_Product_Model__c> productModelList){
     	  try{
	     		if(productModelList!=null && productModelList.size()>0){
	     			delete productModelList;
	     		}
     		
		    }
	       catch(Exception e) {
	            System.debug('Exception Message '+e);
	            System.debug('Exception Line Number: '+e.getLineNumber());
	        }
     }
     
     global void finish(Database.BatchableContext bc){
     	
        
     }    
}