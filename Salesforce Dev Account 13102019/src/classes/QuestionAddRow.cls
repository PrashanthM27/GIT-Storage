public class QuestionAddRow
{
    public List<Answer__c> memberList {get;set;}
    public List<Answer__c> memberAddList {get;set;}
    public String memberName {get;set;}  
    
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