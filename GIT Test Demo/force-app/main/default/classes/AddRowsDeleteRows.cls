public class AddRowsDeleteRows{
    public List<Account> ac{set;get;}
    public List<Contact> con{set;get;}
    public AddRowsDeleteRows(){
        ac=new List<Account>();
        con=new List<Contact>();
    }
    public void addRow(){
        ac.add(new Account());
    }
    public void deleteRow(){
        ac.remove(Integer.valueOf(ac.size()-1));
    }
    public void Save(){
        insert ac;
        ac.clear();
        addRow();
    }
}