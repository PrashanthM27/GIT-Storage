({
	doInit : function(component, event, helper) {
		helper.getProduct(component,'I LOVE U PRATHYUSHA PLEASE COME TO ME');
        helper.getProducts(component);
	},
    change:function(component,event,helper){
        selectedName=event.target.value;
        helper.getProduct(component,selectedName);
    },
    addToCart:function(component,event,helper){
        var product=component.get("v.Product");
        var evt=$A.get("e.AddToCart");
        evt.setParams({"Product":Product});
        evt.fire();
    }
    
})