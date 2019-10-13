/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FCST_CopyLineInitials implements Database.Batchable<SObject>, Database.Stateful {
    global String Query;
    global Set<Id> setFailedAccounts;
    global FCST_CopyLineInitials(Map<Id,Id> mv) {

    }
    global void execute(Database.BatchableContext BC, List<FcstCCRev__FCST_Initial_Forecast__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global void sendMailToAdmin() {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
