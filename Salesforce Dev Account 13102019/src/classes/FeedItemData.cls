public class FeedItemData {
    public List<FeedItem> fdList{set;get;}
    public List<CLIN__c> cln{Set;get;}
    public FeedItemData(){
        fdList=new List<FeedItem>();
        cln=new List<CLIN__c>();
    }
    public void Save(List<FeedItem> cln){
       for(FeedItem fi : cln) {
	  CLIN__c dm = new CLIN__c();
	     dm = [Select Id from CLIN__c where Id =:fi.ParentId];
	  } 
    }
}