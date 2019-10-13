public class TreeNodes {
    public List<Contact> parentCont{set;get;}
    public Account grandParentAcc{set;get;}
    public TreeNodes(Account gp,List<Contact> parentContr){
        parentCont = parentContr;
        grandParentAcc= gp;
        
    }
    public List<TreeNodes> hierarchy{Set;get;}
    public List<TreeNodes> getMainNodes(){
        hierarchy = new List<TreeNodes>();
        List<Account> acctList = [Select Id,Name FROM Account];
        for(Integer i=0;i<acctList.size();i++){
            List<Contact> contList = [Select Id,FirstName,LastName,(SELECT Id from Cases) FROM Contact WHERE AccountId=:acctList[0].Id];
            hierarchy.add(new TreeNodes(acctList[i],contList));
        }
        return hierarchy;
    }
}