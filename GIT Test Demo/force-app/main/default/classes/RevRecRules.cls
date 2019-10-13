public class RevRecRules {
    public String strProductFamily{set;get;}
    public String OppType{set;get;}
    public List<SelectOption> options{set;get;}
    public RevRecRules(){
        options = new List<SelectOption>();
    }
    public void getRevData(){
        if(strSelProductId <> null && strSelProductId <> '-None-'){
            List<FCST_Revenue_Recognition_Product__c> revList = new List<FCST_Revenue_Recognition_Product__c>();
        }
    }
    public Product2 prd{set;get;}
    public String strSelProductId{set;get;}
    public Boolean blnCheck{set;get;}
    public void getProductFamily(){
        options.add(new SelectOption('-None-','-None-'));
        Schema.SObjectType objType = Product2.getSobjectType();
        Schema.DescribeSObjectResult objRes = objType.getDescribe();
        Map<String,Schema.SObjectField> objFlds = objRes.fields.getMap();
        for(Schema.PicklistEntry vls : objFlds.get('Family').getDescribe().getPickListValues()){
            options.add(new SelectOption(vls.getLabel(),vls.getValue()));
            System.debug('===>>Product Family pickList:'+vls);
        }
    }
    public List<SelectOption> opt{set;get;}
    public void getActiveProducts(){
        opt = new List<SelectOption>();
        if(!String.isEmpty(strProductFamily) && strProductFamily!=null){
            opt.add(new SelectOption('-None-','-None-'));
            for(Product2 prd:[Select Id,Name from Product2 where isActive=true AND Family=:strProductFamily]){
                opt.add(new SelectOption(prd.Id,prd.Name));
            }
        }
    }
    public void getTermsMonths(){
        blnCheck = false;
        // FCST_Rev_Rec_Revenue_Type__c revRec = new FCST_Rev_Rec_Revenue_Type__c();
        
    }
}