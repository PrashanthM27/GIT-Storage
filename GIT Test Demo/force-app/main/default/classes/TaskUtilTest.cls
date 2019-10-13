@isTest
private class TaskUtilTest{
static testmethod void tasktest(){
String st=TaskUtil.getTaskPriority('Hello');
System.assertEquals(null,st);
}
static testmethod void task(){
String st2=TaskUtil.getTaskPriority('NY');
System.assertEquals('Normal',st2);
}
static testmethod void task3(){
String st3=TaskUtil.getTaskPriority('CA');
System.assertEquals('High',st3);
}
}