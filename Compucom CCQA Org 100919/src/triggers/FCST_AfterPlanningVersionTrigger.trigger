trigger FCST_AfterPlanningVersionTrigger on Planning_Version__c (after update) {
    set<Id> setPreviousVersions = new set<Id>();
    for(Planning_Version__c p: trigger.new){
        System.debug('P>>>>'+p);
        if(p.Version_Status__c == 'Open (Admin)' && p.Previous_Version__c <> null && p.Version_Status__c <> trigger.oldmap.get(p.id).Version_Status__c){
            setPreviousVersions.add(p.Previous_Version__c);
        }
    }
    if(setPreviousVersions.size()>0){
        List<Opportunity> lstOpps = [select Id,Is_Submitted__c,Submitted_for_Planning_Version__c  from Opportunity 
            where Submitted_for_Planning_Version__c IN: setPreviousVersions and stageName <> 'closed won'];
        for(opportunity opp: lstOpps ){
            opp.Is_Submitted__c = false;
            opp.Submitted_for_Planning_Version__c = null;
        }
        if(lstOpps.size()>0){
            Database.update(lstOpps,false);
        }
    }
}