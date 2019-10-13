public class SelectRecordCheckBox {
    public List<WrapperCheckBox> check{set;get;}
    public List<Account> ac{set;get;}
    public SelectRecordCheckBox(){
        ac=[Select Id,Name,Phone from Account];
    }
    public void Save(){
        
    }
    public class WrapperCheckBox{
        public Account ac{set;get;}
        public boolean selected{set;get;}
        public WrapperCheckBox(Account a){
            ac=a;
            selected=false;
        }
    }
}