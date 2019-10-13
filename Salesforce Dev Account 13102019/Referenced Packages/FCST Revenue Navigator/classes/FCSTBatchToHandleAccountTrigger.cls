/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FCSTBatchToHandleAccountTrigger implements Database.Batchable<SObject>, Database.Stateful {
    global List<Account> accListVal;
    global String query;
    global FCSTBatchToHandleAccountTrigger(List<Account> accList) {

    }
    global void execute(Database.BatchableContext bc, List<FcstCCRev__FCST_Product_Model__c> productModelListVal) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
