({
  ContentDoc : function(component, event, helper) {
      var action = component.get("c.getContDocument");
      action.setCallBack(this,function(response){
          var state = response.getState();
          if(state=="SUCCESS"){
             component.set("v.LstContent",response.getReturnValue());
          }else if(state=="INCOMPLETE"){
               var err = response.getError();
          }else if(state=="ERROR"){
              var errors = response.getError();
              if(errors){
                  if(errors[0]&&errors[0].message){
                      console.log('Error Message:'+errors[0].message);
                  }
              }              
          }
      })
      $A.enqueueAction(action);
},
    getSelected : function(component,event,helper){
        component.set("v.hasModelOpen",true);
        component.set("v.selectedDocId",event.currentTarget.getAttribute("get-Id"));
    },
    
    closeModel : function(component,event,helper){
        component.set("v.hasModelOpen",false);
        component.set("v.selectedDocId",null);
    }
})