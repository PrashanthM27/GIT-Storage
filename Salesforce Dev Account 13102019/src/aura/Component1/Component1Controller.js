({
	handleClick : function(component,event,helper) {
		var buttonclick= event.getSource();
        var buttonclickmessage=buttonclick.get("v.label");
        component.set("v.message",buttonclickmessage);
	}
})