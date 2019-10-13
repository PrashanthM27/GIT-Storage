public class LookupDataSelect{
    public ApexPages.StandardController std{set;get;}
    public LookupDataSelect(ApexPages.StandardController controller){
        std=controller;
    }
    public void Save(){
        Contact c=(Contact)std.getRecord();
        if(!String.isBlank(c.AccountId)){
        c.Account=[Select id,AccountNumber from Account where id=:c.AccountId];
        }else{
            c.AccountId=null;
        }
    }
}