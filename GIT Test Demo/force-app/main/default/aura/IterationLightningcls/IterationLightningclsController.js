({
   myAction : function(component, event, helper) {
         var action=component.get("c.getResult");
           action.setCallback(this,function(){
            alert('called state');
            var state=response.getCallback();
            if(state=="SUCCESS"){
                component.set("v.AccountData",response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
    }
})