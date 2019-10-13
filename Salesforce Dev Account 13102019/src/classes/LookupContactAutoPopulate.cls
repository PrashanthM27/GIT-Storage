public class LookupContactAutoPopulate {
    public ApexPages.StandardController stdrl{set;get;}
     
    public LookupContactAutoPopulate(ApexPages.StandardController controller){
        stdrl=controller;
    }
    public void AccountSelected(){
        Case cs=(Case)stdrl.getRecord();
        if(!String.isBlank(cs.AccountId)){
            cs.Account=[Select Website,Phone from Account where id=:cs.AccountId];
            
        }else{
            cs.AccountId=null;
        }
    }
}