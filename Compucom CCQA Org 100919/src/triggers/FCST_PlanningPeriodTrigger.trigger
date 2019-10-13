trigger FCST_PlanningPeriodTrigger on Fiscal_Year_Model__c (after insert) {
    if(trigger.isInsert){
        FCST_FiscalSynchronization.createFSVersion(trigger.new);
    }
}