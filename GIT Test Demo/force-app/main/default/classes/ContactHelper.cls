public with sharing class ContactHelper {

public static void setDefaultValues(List<Contact> contacts) {  
        Set<Id> accountIds = new Set<Id>();

        for (Contact contact : contacts) {
            if (contact.AccountId != null) accountIds.add(contact.AccountId);
        }

        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Id IN :accountIds]);

        for (Contact contact : contacts) {
            if (contact.AccountId != null && accounts.containsKey(contact.AccountId)) {
                Account account = accounts.get(contact.AccountId);

                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingPostalCode = account.BillingPostalCode;
                contact.MailingCountry = account.BillingCountry;
            }
        }   
    }
}