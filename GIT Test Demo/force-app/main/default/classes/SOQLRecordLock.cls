public class SOQLRecordLock{
public List<Account> ac{set;get;}
public SOQLRecordLock(){
ac=[Select Id,Name from Account where Name='chow' FOR UPDATE];
}
}