trigger FCST_PlanningYearTrigger on Fiscal_Year_Planning__c(after insert) {
    if(trigger.isInsert){    
        FCST_FiscalSynchronization.createFSPeriods(trigger.new);//Periods->Versions
        FCST_FiscalSynchronization.putAdditionalPlanningVersion();//Additional Version->Versions
        FCST_FiscalSynchronization.putFinancialMeasure();//Measures
    }   
}