public class mergeAccount {
    
    public List<wrapAccount> wrapAccountList {get; set;}
    public List<wrapAccount> selectedAccounts{get;set;}
    public Boolean bolvar {get; set;}
    public Boolean bolvar1{get;set;}
    public Boolean bolvar2{get;set;} 
    public Boolean bolvar3{get;set;} 
    public String SelectAccount{get;set;}
    public Account objMasterAccount {get;set;}
    public List<SelectOption> lstSelectOption {get;set;}
    public String AccountId;
    public Account objAccount;
    public string AccountName ;
    public ID AccountID1;
    public List<Account> lstAccount = new List<Account>();
    public List<Account> lstAccount1 = new List<Account>();
    public mergeAccount(ApexPages.StandardController controller) {
        
        system.debug('lstAccount'+lstAccount);
        bolvar1 = true;
        bolvar2 = false;
        //objAccount= (Account)Controller.getRecord().id;
        system.debug('objAccount'+objAccount);
        
        if(wrapAccountList == null) {
            wrapAccountList = new List<wrapAccount>();
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
            String query='select id';
            for(String s : objectFields.keySet()) {
                if(s != 'Id'){
                    SObjectField test=objectFields.get(s); 
                    //system.debug('test' +test);
                    //if(test.getDescribe().isUpdateable()){ 
                    query += ', ' + s + ' ';
                }
                //}
            }
            
            query +=' FROM Account';
            System.debug(query);
            List<Account> lstAccount = new List<Account>();
            lstAccount = database.query(query);
            //System.debug(lstAccount);
            for(Account a: lstAccount) {
                wrapAccountList.add(new wrapAccount(a,bolvar));
                
                
            }
        }
    }
    
    public void getAccountNames() {
        system.debug('AccountId'+AccountId);
        /*AccountId=Apexpages.currentpage().getParameters().get('id');
        lstAccount1 =[Select id,name from Account where id =:AccountId];
        if(lstAccount1.size()>0)
        {
            AccountName =  lstAccount1[0].Name;
            AccountID1 = lstAccount1[0].id;
            system.debug('AccountName'+AccountName);
        }*/
        
        system.debug('AccountId'+AccountId);
        // selectedAccounts = new List<wrapAccount>();
        lstSelectOption= new List<SelectOption>();
        lstSelectOption.add( new SelectOption('','--Select--'));
        for( wrapAccount wrapacc :  selectedAccounts) {
            lstSelectOption.add( new SelectOption(wrapacc.acc.Id,wrapacc.acc.name));
            
            //lstSelectOption.add(new SelectOption(AccountID1,AccountName));
            system.debug('accOptions'+lstSelectOption);
        }
        
    }
    
    public void nextButton(){
        selectedAccounts = new List<wrapAccount>();
        
        for(wrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
                selectedAccounts.add(new wrapAccount(wrapAccountObj.acc,wrapAccountObj.selected));
                
            }
        }
        getAccountNames();
        bolvar1 = false;
        bolvar2 = true;
        
    }
    
    public PageReference  Selectedmaster(){
        objMasterAccount = new Account();
        objAccount = new Account();
        SobjectField[] fields =  Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().values();
        System.debug(fields);
        for(wrapAccount wrapacc :selectedAccounts){
            if(wrapacc.acc.id == SelectAccount)
                objMasterAccount = wrapacc.acc;
            //AccountID1 = wrapacc.accId;
            system.debug('objMasterAccount'+objMasterAccount);
        }
        for( wrapAccount wrapacc :selectedAccounts){
            if(wrapacc.acc.id != SelectAccount){
                for(SObjectField field:fields){  
                    if(field.getDescribe().isUpdateable()){   
                        system.debug('masterLead.get(field)'+objMasterAccount.get(field));
                        if(objMasterAccount.get(field)==null && wrapacc.acc.get(field)!=null ){     
                            objMasterAccount.put(field,wrapacc.acc.get(field));
                        }
                    }
                }
            }
        }
        update objMasterAccount;
        bolvar3 = false; 
        PageReference pageRef = new PageReference('/apex/PopUp');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference ok(){
        PageReference pageRef = new PageReference('/001/o');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public class wrapAccount {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        //public id accId {get;set;}
        public wrapAccount(Account a,Boolean bolvar) {
            acc = a;
            selected = bolvar;
            //accId = aId;
        }
    } 
}