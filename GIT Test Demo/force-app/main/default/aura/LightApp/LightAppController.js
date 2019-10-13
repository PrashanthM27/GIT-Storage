({
	clickHere : function(component,event,helper) {
		var device=event.getSource().get("v.label");
        alert("You are using:"+device);
	}
})