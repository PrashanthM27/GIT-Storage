({
	doInit : function(component, event, helper) {
        var action = component.get("c.getBaseLineYear");        
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var today = new Date();  
            var yyyy = today.getFullYear();
            
            var state = response.getState();
          // component.set("v.showSpinner", response.getReturnValue());
           // component.set("v.isError", true);
            if (component.isValid() && state == "SUCCESS") {
                if(response.getReturnValue() < yyyy){                    
                   // component.set("v.showSpinner", true);
                    component.set("v.showSpinner", response.getReturnValue());
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/apex/FCST_BaseLineYear_Contract?id="+component.get("v.recordId")
                    });
                    urlEvent.fire();                    
                }
                else{
                  //  component.set("v.Message", "Year should be less than Current Year");
                   component.set("v.isError", true);
                    setTimeout(function(){
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/lightning/r/FCST_Contract__c/"+component.get("v.recordId")+"/view?0.source=alohaHeader"
                        });
                        urlEvent.fire();
                    }, 2000);
                }
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
})