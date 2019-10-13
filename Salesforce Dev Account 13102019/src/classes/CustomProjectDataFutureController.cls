public class CustomProjectDataFutureController {
   @future
   public static void deleteFeedData(Set<Id> ids){
        List<FeedItem> feedList = [Select Id,ParentId from FeedItem where ParentId IN:ids ORDER BY CreatedDate DESC LIMIT 1];
        if(feedList!=null && !feedList.isEmpty()){
            delete feedList;
        }
    }
}