public class ProcessBuilderAssignmentRuleUsingApex{
@InvocableMethod
public static void setAssign(List<Id> leadId){
List<Lead> leadList=new List<Lead>();
Database.DMLOptions dml=new Database.DMLOptions();
dml.assignmentRuleHeader.useDefaultRule=true;
//Lead leads=[Select Id from Lead where Id in:leadId];
for(Lead ld:[Select Id from Lead where Id in:leadId]){
ld.setOptions(dml);
leadList.add(ld);
}
if(leadList!=null&leadList.size()>0){
Database.Update(leadList);
}
}
}