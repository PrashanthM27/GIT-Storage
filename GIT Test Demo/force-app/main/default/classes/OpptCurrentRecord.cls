public class OpptCurrentRecord {
   public Opportunity oppt{set;get;}
    public String paramValue{set;get;}
    public OpptCurrentRecord(ApexPages.StandardController stdController){
        oppt = [Select Id,Name FROM Opportunity where Id=:ApexPages.currentPage().getParameters().get('Id')];
        paramValue = ApexPages.currentPage().getParameters().get('NameParam');
    }
    public Opportunity getCurrentRecordId(){
        return oppt;
    }
}