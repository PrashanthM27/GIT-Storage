public class AccountIndustryList {
    public String selectedValue{set;get;}
    public List<SelectOption> options{set;get;}
    public void getAccIndustry(){
        Schema.DescribeFieldResult fldRes = Account.Industry.getDescribe();
        options = new List<SelectOption>();
        for(Schema.PicklistEntry a:fldRes.getPicklistValues()){
            options.add(new SelectOption(a.getValue(),a.getLabel()));
        }
    }   
    public void checkValue(){
        System.debug('===>>'+selectedValue);
    }
}