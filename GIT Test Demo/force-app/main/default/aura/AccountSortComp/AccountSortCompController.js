({
    accountTable : function(component, event, helper) {
        var action = component.get("v.accountSort");
        action.setCallBack(this,function(response){
            component.set("v.AccountList",reponse.getReturnValue());
        })
        $A.enqueueAction(action);
        console.log("Lightning Component");
    }
})