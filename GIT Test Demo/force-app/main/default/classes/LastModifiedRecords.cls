public class LastModifiedRecords{
public List<Contact> contList{set;get;}
public String mail{set;get;}
public Contact cont{set;get;}
public LastModifiedRecords(){

}
public void Search(){
  String sr='select firstName,LastName,id,Account.Name,email from Contact WHERE Email LIKE \'%'+mail+'%\' ORDER BY LastModifiedDate DESC LIMIT 1';  
  cont=Database.Query(sr);
  }
}