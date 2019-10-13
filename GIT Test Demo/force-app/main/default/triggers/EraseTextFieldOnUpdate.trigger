trigger EraseTextFieldOnUpdate on Contact (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        EraseTextFieldOnUpdate.checkForRequiredField(Trigger.New);
    }
    if(trigger.isBefore && trigger.isUpdate){
        EraseTextFieldOnUpdate.EmptyRequiredField(Trigger.New);
    }
}