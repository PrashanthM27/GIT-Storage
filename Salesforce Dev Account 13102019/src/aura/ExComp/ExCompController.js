({
	sendMessage : function(component, event, helper) {
        var msg = {name:"General",
                   value:component.get("v.messageToSend")};
        component.find("ReactApp").message(msg);
		
	},
    handleMessage : function(component,message,helper){
        var payload = message.getParams().payLoad;
        var pp = payLoad.Name;
        if(name == "General"){
            var value = payload.value;
            component.set("v.messageReceived",value);
        }else if(name == "foo"){
                var response= action.getState();
        }
        },
            handleError : function(component,error,helper){
                var e = error;
            }
})