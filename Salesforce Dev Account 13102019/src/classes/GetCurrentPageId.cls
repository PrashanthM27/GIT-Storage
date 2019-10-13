public class GetCurrentPageId{
public String currentId{set;get;}
public String paramterValue{set;get;}
public Account ac{set;get;}
public GetCurrentPageId(ApexPages.StandardController controller){
currentId=ApexPages.CurrentPage().getParameters().get('id');
ac=[Select Id,Name,Industry from Account where id=:currentId];
paramterValue=ApexPages.CurrentPage().getParameters().get('nameParam');
}
}