public class CheckBoxSelection {
    public List<Wrapper> wrp{set;get;}
    public CheckBoxSelection(){
        if(wrp==null){
            wrp=new List<Wrapper>();
            for(Account a:[Select Id,Name from Account]){
                wrp.add(new Wrapper(a));
            }
        }
        
    }
    
    
    public class Wrapper{
    public Account ac{set;get;}
        public Boolean selection{set;get;}
    public Wrapper(Account a){
        ac=a;
        selection=false;
    }
}
}