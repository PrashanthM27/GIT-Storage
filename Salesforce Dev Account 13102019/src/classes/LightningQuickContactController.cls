public class LightningQuickContactController {
@AuraEnabled
    public static Account getAccount(Id accountId){
        return [Select Id,BillingCity,BillingCountry from Account where id=:accountId];
    }
    @AuraEnabled
    public static Contact getContactAccount(Contact contact,Id accountId){
        contact.AccountId=accountId;
        upsert contact;
        return contact;
    }
}