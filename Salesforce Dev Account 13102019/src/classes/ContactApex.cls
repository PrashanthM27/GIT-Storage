public class ContactApex {
    public List<Contact> con{set;get;}
    public ContactApex(){
        con=[Select Id,FirstName,LastName,Department,Phone,Email from Contact];
    }
    public void Offset(){
        con=[Select Id,FirstName,LastName,Phone from Contact OffSet 5];
    }
    public void getData2(){
        con=[Select Id,FirstName,LastName,Phone from Contact LIMIT 5];
    }
    public void getData3(){
        con=[Select Id,Email,Phone,LastName,FirstName from Contact order by Phone ASC];
    }
}