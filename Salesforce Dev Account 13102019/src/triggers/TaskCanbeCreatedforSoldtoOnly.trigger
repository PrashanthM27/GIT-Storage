trigger TaskCanbeCreatedforSoldtoOnly  on Task (before insert, before update) {

set<id>accids=new set<id>();

for(task t:trigger.new){
    accids.add(t.whatid);
}
if(!accids.isempty()){
    List<Account>lstacc=[select id,Type from account where id in:accids AND Type=:'Bill To Customer'];
    Map<id,String>mapofaccts=new Map<id,string>();
    for(account acc:lstacc){
        mapofaccts.put(acc.id,acc.Type);
    }
    for(task t:trigger.new){
        if(mapofaccts.containsKey(t.whatid)){
            t.addError ('Please select the Sold to Customer');
        }
    }
}

}