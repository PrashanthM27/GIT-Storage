public with sharing class DisplayContactonAccountClick{
    public String sid{set;get;}
    public List<Account> accList{set;get;}
    public List<Contact> contList{set;get;}
    public Account acc{set;get;}
    public DisplayContactonAccountClick(){
        accList=[Select Id,Name from Account];
        contList=null;
    }
    public void getContacts(){
        contList=[Select Id,FirstName,LastName from Contact where Accountid=:sid];
    }
    public void getAccounts(){
        accList=[Select Id,Name from Account where id=:sid];
    
    }
    public PageReference deleteRec(){
        Account ac=[Select Id,Name from Account where id=:sid];
        delete ac;      
        PageReference pg=new PageReference('/apex/DisplayContactonAccountClick');
        pg.setRedirect(true);
        return pg;
    }               
}