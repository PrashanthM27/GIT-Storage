({
    myAction : function(component,event,helper){
        var action=component.get("c.getData");
        action.setCallback(this,function(response){
            alert('Callback called');
         component.set("v.Test",response.getReturnValue());
      });
        $A.enqueueAction(action);
    }
    
})