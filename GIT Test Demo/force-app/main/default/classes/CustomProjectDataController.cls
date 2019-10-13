/*Class                  Date       Developer       Purpose

CustomPopupWindow      29-10-18     Prashanth       CustomProjectDataController on Button Click

*/
public class CustomProjectDataController {
    Id idOpp;
    public Opportunity objOpp;
    public Boolean bSuccess {get;set;}
    public CLIN__c objClin {get;set;}
    public String strSelectedValue {get;set;}
    public Project__c objPrjt {get;set;}
    public Date dPrdtDate {get;set;}
    public list<SelectOption> productOptions {get;set;}
    public map<String, Date> mapOfPdNameWithDate;
    public list<ShowCLINSavedData> lstShowData {get;set;}
    
    public CustomProjectDataController(Apexpages.StandardController stdController) {
        lstShowData = new  list<ShowCLINSavedData>();
        idOpp = stdController.getId();
        getOppDataWithCIN();
    }
    public PageReference getOppDataWithCIN() {
        mapOfPdNameWithDate = new map<String, Date>();
        productOptions = new list<SelectOption>();
        productOptions.add(new SelectOption('--None--','-None-'));
        list<Opportunity> lstOpps = [SELECT ID,Name, LH__LH_Test_1__c, Amount, Account.Name, AccountId, (SELECT PricebookEntry.Product2.Name,ServiceDate FROM OpportunityLineItems) 
                                     FROM Opportunity where Id =:idOpp];  
        for(Opportunity oppIterator : lstOpps) {
            objOpp = oppIterator;
            for(OpportunityLineItem olIterator : oppIterator.OpportunityLineItems) {
                productOptions.add(new SelectOption(olIterator.PricebookEntry.Product2.Name, olIterator.PricebookEntry.Product2.Name));
                mapOfPdNameWithDate.put(olIterator.PricebookEntry.Product2.Name, olIterator.ServiceDate);
            }
        }
        return null;
    }
    
    public PageReference updateDate() {
        if(strSelectedValue != '--None--' && mapOfPdNameWithDate.get(strSelectedValue) != null) {
            dPrdtDate = mapOfPdNameWithDate.get(strSelectedValue);
        }
        return null;
    }
    
    public void getProjectDetails() {
        String strProjectName = ApexPages.currentPage().getParameters().get('projectName');
        if(!String.isBlank(strProjectName)) {
            objPrjt = [Select id, Name, Account_Id__c, Amount__c,Project_Description__c,Project_End_Date__c,Project_Level__c,Project_Name__c,
                       Project_Start_Date__c From Project__c where Name =:strProjectName];
        }
    }
    public PageReference saveCLIN() {
        Set<Id> ids = new Set<Id>();
        bSuccess = false;
        list<CLIN__c> lstCIN = new list<CLIN__c>();
        if(objPrjt == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Product Id to save CLIN!'));
        }
   List<CLIN__c> clnList=[Select Id,Opportunity__c,Account__c,Product__c,Project__c,Date__c from CLIN__c where Opportunity__c =:idOpp AND Product__c=:strSelectedValue and Date__c=:dPrdtDate ];
        if(clnList.size()>0){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'CLIN already Created with selected product Name and Date, Please Select another Product Name'));
        }
        else {
            CLIN__c objCIN = new CLIN__c();
            objCIN.Opportunity__c = idOpp;
            objCIN.Product__c = strSelectedValue;
            objCIN.Account__c = objOpp.AccountId;
            objCIN.Project__c = objPrjt.Id;
            objCIN.Date__c = mapOfPdNameWithDate.get(strSelectedValue);
           lstCIN.add(objCIN);
        }        
        //List<CLIN__c> clnList=[Select Id,Account__c,Product__c,Project__c,Date__c from CLIN__c where Id=:strSelectedValue];
        /*if(lstShowData != null && !lstShowData.isEmpty()) {
            for(ShowCLINSavedData sdIterator : lstShowData) {
                if(sdIterator.objWrapperCLIN.Product__c == strSelectedValue || sdIterator.objWrapperCLIN.Project__c == objPrjt.Id) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'CLIN already Created with selected product Name and Date, Please Select another Product Name'));
                    return null;
                }
            }
        }*/
        
        /*if(lstShowData != null && !lstShowData.isEmpty()) {
        List<Opportunity> opList=[Select Id,Name,(SELECT PricebookEntry.Product2.Name,ServiceDate FROM OpportunityLineItems) from Opportunity];
        for(Opportunity opt:opList){
            for(OpportunityLineItem optLine:opt.OpportunityLineItems){
                if(optLine.PricebookEntry.Product2.Name!=null && optLine.ServiceDate!=null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Should not select same product'));
      
                }
            }
        }
        }*/
     
        if(lstCIN != null && !lstCIN.isEmpty()) {            
            Database.SaveResult[] srList = Database.insert(lstCIN, false);
            System.debug('srList:'+srList);
            bSuccess = true;
            for(Database.SaveResult sr:srList){
                if(sr.isSuccess()){
                    ids.add(sr.getId());
                }
            }
            System.debug('CLIN Ids:'+ids);
             if(ids != null && !ids.isEmpty()) {
                CustomProjectDataFutureController.deleteFeedData(ids);
             }
            for(CLIN__c clIterator : lstCIN){
                ShowCLINSavedData objCLINWrapper = new ShowCLINSavedData();
                objCLINWrapper.objWrapperCLIN = clIterator;
                lstShowData.add(objCLINWrapper);
            }
            if(bSuccess) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'CLIN Created Successfully, Click on Back to Opportunity return to Opportunity!!'));
            }
        }
        return null;
    }
    public class ShowCLINSavedData {
        public CLIN__c objWrapperCLIN {get;set;}  
    }
}