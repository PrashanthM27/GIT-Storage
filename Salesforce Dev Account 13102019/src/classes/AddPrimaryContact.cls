public class AddPrimaryContact implements Queueable{
    public Contact con;
    public String state;
    public AddPrimaryContact(Contact con,String state){
        this.con=con;
        this.state=state;
    }
    public void Execute(QueueableContext qc){
        List<Account> ac=[Select Id,Name,(Select Id,LastName from Contacts)from Account where BillingState=:state];
        List<Contact> cont=new List<Contact>();
        for(Account acc:ac){
            Contact cc=con.clone(false,false,false,false);
            cc.AccountId=acc.Id;
            cont.add(cc);
        }
        if(cont.size()>0){
            insert cont;
        }
    }
}