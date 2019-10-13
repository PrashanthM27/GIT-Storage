public class DateFilter{
    public Account objAcc {get;set;}
    public list<SelectOption> lstOptions {get;set;}
    public DateFilter(ApexPages.StandardController sc) {
        objAcc = new Account();
    }
    public PageReference searchAccountData(){
        lstOptions = new list<SelectOption>();
        Id recordId = ApexPages.currentPage().getParameters().get('recordId');     
        objAcc = [Select Id, Name, Start_Date__c,End_Date__c from Account where Id =:recordId];
        Date dStartDate = objAcc.Start_Date__c;
        Date dEndDate = objAcc.End_Date__c;
        Integer startDayValue = dStartDate.day();
        Integer EndDayValue = dEndDate.day();
        
        if(dStartDate != null && dEndDate != null) {
            lstOptions.add(new SelectOption('--None--', '--None--'));
            While(startDayValue <= EndDayValue) {  
                lstOptions.add(new SelectOption(String.valueOf(startDayValue), String.valueOf(startDayValue)));
                startDayValue++;
            }
            System.debug('===Options==='+lstOptions);
        }        
        return null;
    }
}