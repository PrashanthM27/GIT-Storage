({
  doInIt : function() {
        var r = component.get("c.contactData");
      action.setCallBack(this,function(response){
          var state = response.getState();
          if(state == "SUCCESS"){
            var retValue = response.getReturnValue();
              
          }
      })
    }
})