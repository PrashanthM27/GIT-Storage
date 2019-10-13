public with sharing class PopupScreen{
public string textreason{set;get;}
public string textcomment{set;get;}
public PopupScreen(){
textreason='';
textcomment='';
}
public void SubmitPopup(){
string statusval=ApexPages.currentPage().getParameters().get('status');
string reasonval=ApexPages.currentPage().getParameters().get('reason');
string commentval=ApexPages.currentPage().getParameters().get('comment');
if((reasonval!=null&&reasonval.trim().length()>0)&&(commentval!=null&commentval.trim().length()>0))
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Record Saved'));
}
}
}