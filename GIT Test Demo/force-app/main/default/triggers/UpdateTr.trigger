trigger UpdateTr on Contact (after insert,after update, after delete) {
    if(Trigger.isAfter) {
        if(trigger.isInsert || Trigger.isUpdate) {
            ContactTriggerHandler.updateTotalSalary(Trigger.new, Trigger.oldMap);
        } 
        if(Trigger.isDelete) {
            Decimal TotalSalary = 0;
            list<My_Exam__c> lstMyExam = new list<My_Exam__c>();
            for(Contact cIterator : Trigger.Old) {
                My_Exam__c ObjExam = [Select id, Total_Salary__c From My_Exam__c Where id =:cIterator.My_Exam__c];
                list<Contact> lstCons = [Select id, Salary__c From Contact Where My_Exam__c =:objExam.Id];
                for(Contact conIterator : lstCons) {
                    TotalSalary += conIterator.salary__c;
                }
                ObjExam.Total_Salary__c = TotalSalary;
                lstMyExam.add(ObjExam);
            }
            update lstMyExam;
        }
    }     
}