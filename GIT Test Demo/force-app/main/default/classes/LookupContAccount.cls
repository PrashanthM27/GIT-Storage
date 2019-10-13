public class LookupContAccount {
    public ApexPages.StandardController cont{Set;get;}
    public LookupContAccount(ApexPages.StandardController controller){
        cont=controller;
    }
    public void Save(){
           Contact ct=(Contact)cont.getRecord();
        if(!String.isBlank(ct.AccountId)){
           ct.Account=[Select AccountNumber,NumberofContacts__c from Account where id=:ct.AccountId];
        }
    }
}