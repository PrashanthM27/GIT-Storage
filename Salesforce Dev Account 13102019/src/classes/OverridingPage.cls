public class OverridingPage {
    public String recordId{set;get;}
    public OverridingPage(ApexPages.StandardController cont){
        recordId=cont.getId();
    }
    public PageReference redirectPage(){
        Profile userP=[Select name from Profile where id=:UserInfo.getUserId()];
        if('Marketing User'.equals(userP.Name)||'Solution Manager'.equals(userP.Name)){
        PageReference pg=Page.OverrideVFPage;
          pg.setRedirect(true);
          pg.getParameters().get('Id'); 
            return pg;  
        }else{
            return null;
        }
           
    }
   
}