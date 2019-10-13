public class RemoteActionCls{
    @RemoteAction
    public static List<Account> getRecordsAll(String nm){
        return [Select Id,NAME FROM Account WHERE NAME LIKE:('%'+nm+'%')];
    }
}