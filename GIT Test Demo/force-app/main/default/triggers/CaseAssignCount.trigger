trigger CaseAssignCount on Case (before insert) {
Integer recCount = 100;
    Set<Id> csOwnerId = new Set<Id>();
    for(Case cs:Trigger.New){
        csOwnerId.add(cs.OwnerId);
    }
    Map<Id,Integer> agrResMap = new Map<Id,Integer>();
    List<Integer> resSize = new List<Integer>();
    for(AggregateResult result:[Select Count(Id)OwnerId from Case WHERE CreatedDate=THIS_MONTH AND Id=:csOwnerId GROUP BY OwnerId]){
        agrResMap.put((Id) result.get('OwnerId'), (Integer) result.get('expr0'));

    }
    
    for(Case cs:Trigger.New){
        if(agrResMap.get(cs.OwnerId)> recCount){
            cs.addError('User already contains 100 case records');                                                                                         
        }
    }
}