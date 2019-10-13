public with sharing class AttachDocument{
public Document document{
get{
if(document==null)
document=new document();
return document;
}
set;
}
public PageReference upload(){
document.AuthorId=UserInfo.getUserId();
document.FolderId=UserInfo.getUserId();
try{
insert document;
}catch(Exception e){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error uploading file'));
return null;
}finally{
document.body=null;
document=new document();
}
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'File uploaded succesfully'));
return null;
}
}