({
    fetchProductCode : function(component,event,helper){
        var action = component.get("c.returnCodes");
        action.setCallBack(this,function(response){
            var state = response.getState();
            if(state=="SUCCESS"){
            var result = response.getReturnValue();
                console.log("result"+result);
                var PrdCodeMap=[];
                if(result==null && result.isEmpty()){
                    alert('Got no response from server side');
                }
                else{
                    if(result!=null && !result.isEmpty()){
                      component.set("v.objInfo",result);
                        // for(var key in result){
                           // PrdCodeMap.push()
                        }
                    }
                }
            })
       // });
    }  
})