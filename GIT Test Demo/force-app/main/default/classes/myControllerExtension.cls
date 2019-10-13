public class myControllerExtension {
    public Opportunity op{get;set;}

    public myControllerExtension(ApexPages.StandardController stdController) {
         op = (Opportunity)stdcontroller.getRecord();
    }
    public pageReference Save(){
         update op;
         PageReference pg = new PageReference('/'+op.Id);
         return pg;
    }
}