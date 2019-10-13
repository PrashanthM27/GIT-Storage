public class TreeStructureParentChild {
    public List<Account> acList{set;get;}
    public List<AccountWrapper> actWrap{set;get;}
    public TreeStructureParentChild(){
           List<ContactWrapper> contWrap;
        acList = [Select Id,Name,Industry,(Select Id,FirstName,LastName from Contacts) FROM Account];
        for(Account act:acList){
        contWrap = new List<ContactWrapper>();
            for(Contact ccont: act.Contacts){
            contWrap.add(new ContactWrapper(ccont));
            }
        }
    }
    public class AccountWrapper{
        public Account ac{set;get;}
        public Boolean isSelected{set;get;}
        public List<ContactWrapper> contWrap{set;get;}
        public AccountWrapper(Account a,boolean b,List<ContactWrapper> wrp){
            ac = a;
            isSelected = b;
            contWrap = wrp;
        }
    }
    
    public class ContactWrapper{
        public Contact contc{set;get;}
        public Boolean isSelected{set;get;}
        public ContactWrapper(Contact cc){
            contc = cc;
            
        }
    }
}