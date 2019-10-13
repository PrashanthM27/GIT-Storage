@isTest
public class Test_AddRowController {
    static testMethod void getRowData(){
     /* List<Account> aclist = new List<Account>();
        for(Integer i=0;i<5;i++){
            Account a = new Account(Name='Test'+i);
            acList.add(a);
        }
        insert acList;*/
        
       /* List<Contact> conList = new List<Contact>();
        for(Integer i=0;i<5;i++){
            Contact cc = new Contact(FirstName ='Test',LastName = 'ContName'+i);
            conList.add(cc);
        }
        insert conList;*/
        
        AddRowsDeleteRows adr = new AddRowsDeleteRows();
        adr.addRow();
        adr.deleteRow();
        adr.Save();
    }
}