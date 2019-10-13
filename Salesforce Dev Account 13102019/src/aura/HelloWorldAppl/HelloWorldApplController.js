({
	doInit : function(component, event, helper) {
		var action=component.get("c.getCurrentUser");
        action.setCallback(this,function(response){
            var value=response.getReturnValue();
            component.set("v.data",value.FirstName);
        })
        $A.enqueueAction(action);
	}
})