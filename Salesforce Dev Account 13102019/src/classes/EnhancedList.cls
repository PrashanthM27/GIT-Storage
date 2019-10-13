public with sharing class EnhancedList {
    public String listId{set;get;}
    public string listName{
        get;
        set{
            listName=value;
            String query='Select Id,FirstName,LastName from Contact Limit 1';
            ApexPages.StandardSetController cont=new ApexPages.StandardSetController(Database.getQueryLocator(query));
            List<SelectOption> options=cont.getListViewOptions();
            for(SelectOption opt:options){
                if(opt.getLabel()==listName){
                   listId=opt.getValue().SubString(0,15); 
                    break;
                }
            }
        }
}
}