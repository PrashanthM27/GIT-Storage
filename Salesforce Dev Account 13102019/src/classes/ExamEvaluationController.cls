public class ExamEvaluationController{
public List<Exam_Key__c> keyList{set;get;}
public ExamEvaluationController(ApexPages.StandardController controller){

}
public void Save(){
keyList=[Select Id,SNo__c,Answer__c from Exam_Key__c];
}
}