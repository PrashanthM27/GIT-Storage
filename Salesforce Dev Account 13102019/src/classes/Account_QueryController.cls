public class Account_QueryController {
    public List<Account> acList{set;get;}
   public List<Account> acc{set;get;}
   public List<String> accNames{set;get;}
    public void getAccountRecords(){
        acc = [Select Id,Name,Industry FROM Account WHERE Name LIKE 'P%'];
        accNames = new List<String>();
        for(Account act:acc){
            accNames.add(act.Name);
            accNames.sort();
            System.debug('Account Names==>>'+accNames);
        }
    }
    
    
}