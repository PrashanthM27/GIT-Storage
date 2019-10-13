@isTest
public class TestDataFactory {
    public static List<Account> createAccountOpp(integer acc,integer accwithopp){
       List<Account> ac2=new List<Account>();
        for(integer i=0;i<acc;i++){
         Account a=new Account(Name='Test'+i);
            ac2.add(a);
        }
        insert ac2;
    List<Opportunity> op2=new List<Opportunity>();
    for(Integer j=0;j<accwithopp;j++){
        Account aa=ac2[j];
        Opportunity op=new Opportunity(Name=aa.Name+'Opportunity'+j,closedate=System.today(),AccountId=aa.Id);
          op2.add(op);
    }
    insert op2;
        return ac2;
}
    
}