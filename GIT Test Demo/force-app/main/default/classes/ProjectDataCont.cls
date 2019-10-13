public class ProjectDataCont{
public Opportunity opt{set;get;}
public String strSelectedvalue{set;get;}
public CLIN__c cln{set;get;}
public Project__c prjt{set;get;}
public Id OppId{Set;get;}
public Map<String,Date> dtrDt{set;get;}
public List<SelectOption> options{set;get;}

public ProjectDataCont(ApexPages.StandardController controller){
OppId = controller.getId();
opt=new Opportunity();
}

public void getDataFromOppt(){
options = new List<SelectOption>();
dtrDt = new Map<String,Date>();
List<Opportunity> optList = [Select Id,Name,AccountId,(Select PricebookEntry.Product2.Name,ServiceDate from OpportunityLineItems) from Opportunity where Id=:OppId];
for(Opportunity oppt:optList){
 //objOpp = oppIterator;
 
}

}
}