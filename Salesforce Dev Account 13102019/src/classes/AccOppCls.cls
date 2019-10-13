@isTest
private class AccOppCls{
static testMethod void AccSave(){
Opportunity op=new Opportunity(Name='Pens',CloseDate=System.today()+9,StageName='Closed-Won');
insert op;

 op.StageName='Closed-Lost';
 update op;
 
 op.StageName='Open';
 update op;
}
}