public class AccountHierarchy{
    public List<Account> acc{set;get;}
    public List<AccountWrappr> accWrap{set;get;}
    public List<ContactWrap> wrp{set;get;}
    public AccountHierarchy(){
         acc=[Select Id,Name,(Select Id,FirstName,LastName from Contacts)from Account LIMIT 20];
        for(Account a:acc){
          wrp=new List<ContactWrap>();
            for(Contact c:a.Contacts){
                
            }
        }
    }
    //Account Wrapper Class
public class AccountWrappr{
    public Account ac{Set;get;}
    public Boolean selected{set;get;}
    public List<ContactWrap> cont{set;get;}
    public AccountWrappr(Account a,boolean b,List<ContactWrap> c){
        ac=a;
        selected=b;
        cont=c;
    }
}
    //Contact Wrapper Class
    public class ContactWrap{
    public Contact contList{set;get;}
    public boolean selected{set;get;}
    public ContactWrap(Contact c,boolean s){
        contList=c;
        selected=false;
        
    }
}
}