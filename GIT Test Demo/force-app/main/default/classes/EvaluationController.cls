public class EvaluationController{
public List<Evaluation__c> keyList{set;get;}
public EvaluationController(){
keyList=[Select Id,Opportunity__c from Evaluation__c];
}
}