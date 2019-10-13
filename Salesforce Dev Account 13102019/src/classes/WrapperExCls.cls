public class WrapperExCls {
    public List<Account> acList{set;get;}
    public List<Contact> contList{set;get;}
    public List<WrapController> wrList{set;get;}
    public WrapperExCls(){
        acList=new List<Account>();
        contList=new List<Contact>();
        wrList=new List<WrapController>();
    }
    public List<WrapController> wrapData(){
        acList=[Select Id,Name,Phone from Account LIMIT 10];
        contList=[Select Id,FirstName,LastName,Phone from Contact LIMIT 10];
        for(Integer i=0;i<acList.size();i++){
            wrList.add(new WrapController(acList[i].Name,acList[i].Phone,contList[i].MailingCity));
        }
        return wrList;
    }
    public class WrapController{
        public String TName{set;get;}
        public String TPhone{set;get;}
        public String TCity{set;get;}
        public WrapController(String Tname,String tphone,String tcity){
            TName=tname;
            TPhone=tphone;
            TCity=tcity;
        }
    }
}