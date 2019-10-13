({
	childUpdate : function(cmp) {
		cmp.set("v.childAttribute","I am Child");
	},
    onChildChange:function(cmp,evt){
        console.log("Child Attribute has changed");
        console.log("old value:"+evt.getParam("oldvalue"));
        console.log("current value:"+evt.getParam("value"));
    }
})