public class QuestionAnswerController{
    public Integer num{set;get;}
    public List<Question__c> question{set;get;}
    public List<Answer__c> answer{set;get;}
    public List<SelectOption> options{set;get;}
    
    public QuestionAnswerController(ApexPages.StandardController sc) {
        question=new List<Question__c>();
        answer=new List<Answer__c>();
    }
    
    public void getData(){
        answer = [Select id,Data__c From Answer__c];
        options = new List<SelectOption>();
        if(options == null) {
            options.add(new SelectOption('--None--', '--None--'));
        }
        options.add(new SelectOption('Numeric-','Numeric'));
        options.add(new SelectOption('Text','Text'));
        options.add(new SelectOption('','Text'));
        options.add(new SelectOption('Text','Text'));
    }
}