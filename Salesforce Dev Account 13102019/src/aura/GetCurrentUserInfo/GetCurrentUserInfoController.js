({
	userInfo : function(component, event, helper) {
       var action=component.get("c.getUser");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=="SUCCESS"){
                var responseData=response.getReturnValue();
                component.set("v.userInfo",responseData);
            }
        })
        $A.enqueueAction(action);
	}
})