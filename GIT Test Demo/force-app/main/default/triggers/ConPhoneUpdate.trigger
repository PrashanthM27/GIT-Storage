trigger ConPhoneUpdate on Account(after insert, after update) {
    set<Id> accIds = new set<Id>();
    list<Contact> lstToUpdate = new list<Contact>();
    map<Id, Account> mapOfAccs = new map<Id, Account>();
    for(Account aIterator : Trigger.new) {   
        mapOfAccs.put(aIterator.Id, aIterator);
    }
    list<Contact> lstCons = [Select id, AccountId, Phone From Contact Where AccountId In:mapOfAccs.keySet()];
    for(Contact cIterator : lstCons){
        Account objCurAcc = mapOfAccs.get(cIterator.AccountId);
        Account oldAcc = Trigger.oldMap.get(cIterator.AccountId);
        if(objCurAcc.Phone != oldAcc.Phone) {
            cIterator.Phone = objCurAcc.Phone;
            lstToUpdate.add(cIterator);
        }
    }
    IF(!lstToUpdate.isEmpty()) {
        update lstToUpdate;
    }
    
}