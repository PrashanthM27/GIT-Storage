public class PicklistOptons {
    
    public list<SelectOption> options{get;set;}
    public string Selected{get;set;}   
    
    
    public PicklistOptons(){
        
        options = new list<SelectOption>();
        options.add(new SelectOption('None','None'));
        options.add(new SelectOption('Text','Text'));  
        options.add(new SelectOption('Radio','Radio')); 
        system.debug('==Selected==Selected'+Selected);
    }
    public void AddRow(){
    
    }
    
    
    public class QuestionAddRow
{
    public List<Answer__c> memberList {get;set;}
    public List<Answer__c> memberAddList {get;set;}
    public String Selected{get;set;}  
    
    public QuestionAddRow(ApexPages.StandardController sc)
    {
        String sql = 'SELECT Id, Name FROM Answer__c';
        memberList = Database.Query(sql);
        memberAddList = new List<Answer__c>();
        memberAddList.add(new Answer__c());
    }
   
    public void AddRow()
    {
        memberAddList.add(new Answer__c());
    } 
}
       
}