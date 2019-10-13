public class CustomControllerPage{

    public String Account { get; set; }
public Account ac{set;get;}
public CustomControllerPage(){
ac=[Select Id,Name,Industry,AnnualRevenue,Description,BillingCountry from Account where id=:ApexPages.CurrentPage().getParameters().get('Id')];
}
public Account getAccount(){
return ac;
}
public PageReference Save(){
PageReference pf=new ApexPages.StandardController(ac).view();
return pf;
}
}