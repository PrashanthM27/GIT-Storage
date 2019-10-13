public class DisplayDataonButtonClick {
    public List<Account> acc{set;get;}
    public DisplayDataonButtonClick(){
        acc=new List<Account>();
    }
    public void Save(){
        acc=[Select Id,Name,Industry from Account];
    }
}