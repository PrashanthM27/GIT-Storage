public class validationController {
    public Account ac{set;get;}
    public PageReference Test(){
        try{
        update ac;
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }    
    public Account Save(){
        ac=[Select Id,Name,Industry from Account];
        return ac;
    }
}