({
     getContactData : function(component) {
       var action=component.get('c.getContacts');
         var r=this;
         action.setCallback(this,function(actionResult){
             component.set('v.AccountData',actionResult.getReturnValue());
         });
        $A.enqueueAction(action);
     }
})