({
       callContact : function(component,event,helper) {
       var action=component.get("c.getAccount");
           //action.setParams(accountids:accountId);
           action.setCallback(this,function(response){
               var state=response.getState();
               if(state==="SUCCESS"){
                   component.set('v.ContactList',response.getReturnValue());
               }else{
                   alert('Error');
               }
           });
           $A.enqueueAction(action);
      }
})