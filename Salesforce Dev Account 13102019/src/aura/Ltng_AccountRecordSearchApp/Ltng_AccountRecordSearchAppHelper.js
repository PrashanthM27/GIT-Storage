({
	searchHelper : function(component,event,helper) {
     component.find("Id_spinner").set("v.class",'slds-show');
      var action = component.get("c.accRecordSearch");
        action.setParams({'keyword':component.get("v.searchKeyword")});
        action.setCallback(this,function(){
          component.find("Id_spinner").set("v.class",'slds-hide');
            var state =response.getState();
            if(state=="SUCCESS"){
                var resp=response.getState();
                if(resp.length()==0){
                    component.set("v.Message",true);
                }else{
                    component.set("v.Message",false);
                }
                component.set("v.numberofRecords",resp.length());
                component.set("v.searchResult",resp);
            }else if(state=="INCOMPLETE"){
                alert('state is INCOMPLETED');
            }else if(state=="ERROR"){
                var errors=response.getError();
                if(errors){
                    if(errors[0]&&errors[0].message){
                        alert("Error Message:"+errors[0].message);
                    }
                }else{
                    alert("unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})