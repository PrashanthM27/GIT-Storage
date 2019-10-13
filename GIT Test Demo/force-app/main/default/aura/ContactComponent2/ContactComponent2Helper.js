({
	getData : function(cmp) {
		var action=cmp.get('v.getContacts');
        action.setCallback(this,$A.getCallback(function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                cmp.set('v.myData',response.getReturnValue());
            }else if(state=='ERRORS'){
                var errors=response.getError();
                console.error(errors);
            }
        }))
	$A.enqueueAction(action);
    }
})