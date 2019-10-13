public class LightningComponentController {
@AuraEnabled
    public static List<Map<String, Object>> findAccountAges(List<String> emails) {
    List<Map<String, Object>> ret = new List<Map<String, Object>>();
    List<Contact> contacts = [SELECT Name, Account.Name, Account.CreatedDate 
                              FROM Contact 
                              WHERE Contact.Email IN :emails];
    for (Contact c: contacts) {
            Map<String, Object> item = new Map<String, Object>();
            item.put('name', c.Account.Name);
            item.put('age', 
                     Date.valueOf(c.Account.CreatedDate).daysBetween(
                         System.Date.today()));
            ret.add(item);
    }
     return ret;
}
    public static List<Map<String,Object>> findOpportunityCloseDateTime(List<String> mails){
        List<Map<String,Object>> listmap=new List<Map<String,Object>>();
        List<OpportunityContactRole> oppcontrole=[Select Opportunity.Name,Opportunity.CloseDate from OpportunityContactRole
         where isPrimary=true and Contact.Email in:mails];
        for(OpportunityContactRole cr:oppcontrole){
            Map<String,Object> obj=new Map<String,Object>();
            obj.put('name',cr.Opportunity.Name);
            obj.put('closesIn',System.Date.today().daysBetween(Date.valueOf(cr.Opportunity.closeDate)));
            listmap.add(obj);            
        }
        return listmap;
    }
}