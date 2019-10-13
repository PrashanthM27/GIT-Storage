public class ContactTriggerHandler {
    
    public static void updateTotalSalary(list<Contact> lstCons, map<Id, Contact> mapOldCons){
        Decimal dTotalSalary = 0;
        Contact oldCon;
        Id myExamId;
        if(lstCons != null && !lstCons.isEmpty()) {
            for(Contact cIterator : lstCons) {
                if(mapOldCons != null && !mapOldCons.isEmpty()) {
                    oldCon = mapOldCons.get(cIterator.Id);
                }
                if(cIterator.Salary__c != null || (cIterator.Salary__c != oldCon.Salary__c)) {
                    myExamId = cIterator.My_Exam__c;   
                }
            }
        }
        if(myExamId != null) {
            list<Contact> lstRelCons = [Select id,Salary__c,My_Exam__r.Total_Salary__c From Contact where My_Exam__c =:myExamId];
            for(Contact conIterator : lstRelCons) {
                dTotalSalary += conIterator.Salary__c; 
            }
            My_Exam__c objMyExam = [Select id, Total_Salary__c From My_Exam__c where id=:myExamId];
            objMyExam.Total_Salary__c = dTotalSalary;
            update objMyExam;
        }           
    }
}