({
	parentUpdate : function(cmp) {
		cmp.set("v.parentAttribute","I am Parent");
        
	},
    onParentChange:function(cmp,evt){
        console.log("Parent Attribute has changed");
        console.log("old value:"+evt.getParam("Old value"));
        console.log("value:"+evt.getParam("value"));
    },
    lebelrefer:function(cmp){
        var label="test here today";
        var labelreference=$A.getReference("$Label.c."+label);
        cmp.set("v.parentAttribute",labelreference);
        cmp.get("parentAttribute");
    },
    doinit:function(component,event,helper){
        var r=component.get("c.getLabel");
    }
})