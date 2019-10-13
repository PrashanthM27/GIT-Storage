public with sharing class PassingParamsToCommandLink {
    public String var{set;get;}
    public PageReference act(){
        PageReference pg=new PageReference('/apex/'+var);
        Id id=System.currentPageReference().getParameters().get('id');
        pg.setRedirect(true);        
        return pg;
    }
}