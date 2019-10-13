@isTest
public class BatchclsTest{
static testmethod void Test(){
List<Account> a3=new List<Account>();
Account a=new Account();
a.Name='Prathyusha';
insert a;
a3.add(a);
List<Account> acc=[Select Id,Name from Account where id=:a3];
}
}