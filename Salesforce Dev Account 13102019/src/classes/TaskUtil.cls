public class TaskUtil{
public static string getTaskPriority(String leadstatus){
if(String.isBlank(leadstatus)||leadstatus.length()>3){
return null;
}
String taskpriority;
if(leadstatus=='CA'){
    taskpriority='High';
}
else
{
taskpriority='Normal';
}
return taskpriority;
}
}