public class AccountRecordSearch {
    public String accName{set;get;}
    public List<Contact> conList{set;get;}
    public List<Opportunity> opList{set;get;}
    public List<Account> acList{set;get;}
    public List<SelectOption> options{set;get;}
    public String selectedAcc{set;get;}
    public AccountRecordSearch(){
        acList=new List<Account>();
        conList=new List<Contact>();
        opList=new List<Opportunity>();
    }
    public void Save(){
        acList=[Select Id,Name from Account where Name LIKE 'accName%'];
        if(acList.size()!=null){
            options=new List<SelectOption>();
            options.add(new SelectOption('None','-None-'));
            for(Account a:acList){
              options.add(new SelectOption(a.Id,a.Name));  
            }
        }
    } 
    public void getTheRecords(){
        if(selectedAcc!=null){
            conList=[Select Id,Name from Contact where AccountId=:selectedAcc];
            opList=[Select Id,Name from Opportunity where AccountId=:selectedAcc];          
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select Account'));
        }
    } 
}