global class FCST_VersionSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        List<Planning_Version__c> plvList = [Select Id,Version_Status__c FROM Planning_Version__c WHERE Version_Status__c= 'Open (Admin)' LIMIT 1];
        
            if(plvList[0].Version_Status__c =='Open (Admin)'){
                plvList[0].Version_Status__c = 'Closed';
            }
               update plvList;   
         
    }
}