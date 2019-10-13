public with sharing class FCST_AccountTriggerHandler {
	
	
	public static boolean RecursionHandler = True;
 
	public static boolean HandlerMethod(){
	 
		if(RecursionHandler){
		 
		RecursionHandler = False;
		 
		return true;
		 
		}
		 
		else{
		 
		return RecursionHandler;
		 
		}
	 
	}
    public static void updateMOdelCPM(List<Opportunity> oppList){
    	
    	List<OpportunityLineItem> updateLineItemList = new List<OpportunityLineItem>();
    	if(oppList!=null && oppList.size()>0){
    		for(Opportunity OppObj:oppList){
    			System.debug('OppObj'+OppObj);
    			for(OpportunityLineItem lineObj:OppObj.OpportunityLineItems){
                    System.debug('Line'+lineObj);
    				if(lineObj!=null){
    				lineObj.Fcst_Auto_Script__c=true;
    				updateLineItemList.add(lineObj);
    				}
    			}
    		}
    	}
    	
    	if(updateLineItemList!=null && updateLineItemList.size()>0)
    		update updateLineItemList;
    	
    }
}