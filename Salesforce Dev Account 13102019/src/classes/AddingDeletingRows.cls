public class AddingDeletingRows{
public List<Contact> con{set;get;}
public List<Opportunity> opp{set;get;}
public Contact cc{set;get;}
public AddingDeletingRows(){
con=new List<Contact>();
opp=new List<Opportunity>();
}
public void addRow(){
con.add(new Contact());
}
public void deleteRow(){
con.remove(Integer.valueOf(con.size()-1));
}
public void Save(){
insert con;
con.clear();
addRow();
}
}