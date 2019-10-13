({
	myAction : function(comp, event, helper) {
		var action=comp.get("c.getTheMethod");
        //action.setParams({Hello:comp.get("v.Hello")});
        action.setCallback(this,function(response){           
             comp.set("v.accountList",response.getReturnValue());
            });
        $A.enqueueAction(action);
	},
    getRecordId: function(comp,event,helper){
        alert(comp.get("v.getRecordId"));
        var action=comp.get("c.getTheAccount");
        //var recId=comp.get("v.recordId");
        action.setParams({Id:comp.get("v.recordId")});
        action.setCallback(this,function(){
            comp.set("v.accRecord",response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})