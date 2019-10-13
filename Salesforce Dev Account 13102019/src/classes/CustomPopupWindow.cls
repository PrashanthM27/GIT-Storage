/*Class                  Date       Developer       Purpose

CustomPopupWindow      29-10-18     Prashanth       CustomPopUp on Button Click

*/
public class CustomPopupWindow {
    Id idOpp;
    public list<CustomPopUpWrapper> lstWrapper {get;set;}
    public String strSelectedValue {get;set;}
    public Account objAcc {get;set;}
    public list<OpportunityDataStore__c> lstOppData {get;set;}
    public list<ShowOppSavedData> lstShowData {get;set;}
    
    public CustomPopupWindow(Apexpages.StandardController stdController) {
        lstShowData  = new  list<ShowOppSavedData>();
        lstWrapper = new List<CustomPopUpWrapper>();
        idOpp = stdController.getId();
        getOppDataWithProducts();
    }
    
    public PageReference getOppDataWithProducts() { 
        map<String, Date> mapOfPdNameWithDate = new map<String, Date>();
        list<SelectOption> productOptions = new list<SelectOption>();
        productOptions.add(new SelectOption('--None--','-None-'));
        list<Opportunity> lstOpps = [SELECT ID,Name, LH__LH_Test_1__c, Amount, Account.Name, AccountId, (SELECT PricebookEntry.Product2.Name,ServiceDate FROM OpportunityLineItems) 
                                     FROM Opportunity where Id =:idOpp];  
        
        for(Opportunity oppIterator : lstOpps) {
            for(OpportunityLineItem olIterator : oppIterator.OpportunityLineItems) {
                productOptions.add(new SelectOption(olIterator.PricebookEntry.Product2.Name, olIterator.PricebookEntry.Product2.Name));
                mapOfPdNameWithDate.put(olIterator.PricebookEntry.Product2.Name, olIterator.ServiceDate);
            }
            CustomPopUpWrapper objWrapper = new CustomPopUpWrapper();
            objWrapper.opp = oppIterator;
            objWrapper.options = productOptions;
            objWrapper.mapOfOppWithDate = mapOfPdNameWithDate;
            lstWrapper.add(objWrapper);
            
        }
        return null;
    }        
    public void AccountSelected(){
        String strAccName = Apexpages.currentpage().getParameters().get('accName');
        if(!String.isBlank(strAccName)) {
            objAcc = [Select Name,Website,Phone from Account where Name=:strAccName];
        }
    }
    
    //Save method for storing data in another object
    public PageReference oppDataStore(){
        Boolean bSuccess = false;
        lstOppData = new list<OpportunityDataStore__c>();
        if(strSelectedValue == '-None-') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Product Name other than -None-'));
            return null;
        }
        for(ShowOppSavedData sdIterator : lstShowData) {
                    System.debug('=====>>>'+sdIterator);
            if(sdIterator.oppData.Product_Name__c == strSelectedValue) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Opportunity Data Already Created with Selected Product Name try with another Product Name.'));
                return null;
            }
        }
        
        if(lstWrapper != null && !lstWrapper.isEmpty()) {
            for(CustomPopUpWrapper wrIterator : lstWrapper) {
                if(wrIterator.opp.LH__LH_Test_1__c != null) {
                    OpportunityDataStore__c objODS = new OpportunityDataStore__c();
                    objODS.Name = wrIterator.opp.Name;
                    objODS.Amount__c = wrIterator.opp.Amount;
                    objODS.Product_Name__c = strSelectedValue;
                    objODS.Account__c = wrIterator.opp.LH__LH_Test_1__c;
                    objODS.Date__c = wrIterator.mapOfOppWithDate.get(strSelectedValue);
                    lstOppData.add(objODS);
                }
            }            
        }   
        if(lstOppData != null && !lstOppData.isEmpty()) {
            Database.insert(lstOppData, false);
            bSuccess = true;
            
            for(OpportunityDataStore__c opIterator : lstOppData) {
                ShowOppSavedData objWrapper = new ShowOppSavedData();
                objWrapper.oppData = opIterator;
                lstShowData.add(objWrapper);
            }
        }
        if(bSuccess) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Opportunity Data Created Successfully!!'));
        }
        return null;
    }
    
    public class CustomPopUpWrapper {
        public Opportunity opp {get;set;}
        public map<String, Date> mapOfOppWithDate {get;set;}
        public list<SelectOption> options {get;set;}
    }
    
    public class ShowOppSavedData {
        public OpportunityDataStore__c oppData {get;set;} 
    }
}