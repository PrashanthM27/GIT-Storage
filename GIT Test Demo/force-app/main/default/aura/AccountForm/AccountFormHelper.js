({
    getIndustry : function(component,event,helper){
        var v = component.get("c.saveRecord");
        console.log("====>>"+v);
    },
    
    recordSave : function() {
          var action = component.get("c.returnRecords"); 
        console.log("action"+action);
    }
    
})