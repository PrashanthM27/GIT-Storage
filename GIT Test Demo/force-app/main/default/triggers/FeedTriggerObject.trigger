/*
 * We have the trigger below that if an attachment is deleted from Chatter Feed, certain profiles will recieve the error message.
 *  I need assistance in updating the trigger to only fire on a certain object (Documents_Manager__c). 
 * Currently the trigger is firing on all objects. The trigger is also currently blocking the System Administrator profile 
 * for testing testing purposes but we would like to add serveral profiles to the block list as well. Thank you in advance!
  */
trigger FeedTriggerObject on FeedItem (after delete) {
User u=[Select Id,Name,Profile.Id,Profile.Name from User where Id=:UserInfo.getUserId()];
    for(FeedItem fi : trigger.old) {
      
	  CLIN__c dm = new CLIN__c();
	  
	  try {
	     dm = [Select Id from CLIN__c where Id =:fi.ParentId];
	  }
	  catch(Exception e) {
	     dm = null;
	  }
	 
	  if (dm != null) {
        if(fi.type == 'ContentPost' && (u.Profile.Name == 'System Administrator' || u.Profile.Name == 'Profile name 2 here'
		   || u.Profile.Name == 'Profile name 3 here')) {
            fi.addError('You do not have the permissions to delete files from chatter feed');
		}
	  }
 }
}