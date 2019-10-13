trigger FeedTrigger on FeedItem (after update) {
List<FeedAttachment> attach=[Select Id,Title,FeedEntityId from FeedAttachment where FeedEntityId in:Trigger.New];
    for(FeedAttachment atm:attach){
        System.debug('Attachment Type:'+atm.type);
    }
}