({
	doInit : function(component, event, helper) {
        var action = component.get("c.getOpportunityStage");        
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Message", response.getReturnValue());
            component.set("v.isError", true);
            if (component.isValid() && state == "SUCCESS") {
                if(response.getReturnValue() == 'Closed Won'){                    
                    component.set("v.Message", "Waiting loading....");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/apex/FCST_Update_Contract?id="+component.get("v.recordId")
                    });
                    urlEvent.fire();                    
                }else{
                    component.set("v.Message", "Opportunity must be closed won to Add/Update Contract");
                    setTimeout(function(){
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/lightning/r/Opportunity/"+component.get("v.recordId")+"/view?0.source=alohaHeader"
                        });
                        urlEvent.fire();
                    }, 2000);
                }
            }
        });
        $A.enqueueAction(action);
    }
})