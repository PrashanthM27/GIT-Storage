public class AssignLeadsusingAssignmentRules{
@InvocableMethod
public static void AssignRule(List<id> lead){
Database.DMLOptions dmo=new Database.DMLOptions();
dmo.EmailHeader.triggerAutoResponseEmail=true;
dmo.AssignmentRuleHeader.UseDefaultRule=true;
dmo.optAllorNone=false;
Lead leads=[Select Id,Name from Lead where id in :lead];
leads.setOptions(dmo);
update leads;
}
}