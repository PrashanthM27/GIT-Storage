public class chatterpost {
public string body { get; set;}
public string userID { get; set;}
 
public void postFeed(){
FeedItem post = new FeedItem();
post.ParentId = userID;
post.Body = body;
insert post;
}
}