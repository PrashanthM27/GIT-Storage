public class FieldSearch {
    public List<Account> ac{set;get;}
    public String name{set;get;}
    public String phone{set;get;}
    public FieldSearch(){
        ac=new List<Account>();
        String q='Select Id,Name,Phone from Account';
        ac=Database.query(q);
    }
    public PageReference Search(){
        String q='Select Id,Name,Phone,Fax from Account where Name=:name or Phone=:phone';
        ac=Database.query(q);
        return null;
    }
}