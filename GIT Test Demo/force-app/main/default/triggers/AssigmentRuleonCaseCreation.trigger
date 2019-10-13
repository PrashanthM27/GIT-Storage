trigger AssigmentRuleonCaseCreation on Case (after insert) {
  List<Case> caseList=new List<Case>();
    User intuser=new User();
    if(trigger.isAfter||trigger.isInsert){
     intuser=[Select Id,Name from User where Name='SubashChandra Bose'];
        for(Case c:Trigger.New){
            if(c.OwnerId==intuser.Id){
                Case cs=new Case();
                 cs.id=c.Id;
                caseList.add(cs);
            }
    }   
    }
    Database.DMLOptions options=new Database.DMLOptions();
    options.AssignmentRuleHeader.useDefaultRule=true;
    Database.update(caseList,options);
}