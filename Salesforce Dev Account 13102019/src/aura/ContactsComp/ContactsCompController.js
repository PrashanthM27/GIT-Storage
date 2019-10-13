({
	checkBrowser : function(component) {
     var check=$A.get("$Browser.formFactor");
	 alert("Dude you are using a" +  check);
    },
    
    checkLocale:function(cmp){
        var language=$A.get("$Label.language");
        alert("Our Country is:"+locale);
        
        var currency=$A.get("$Label.currency");
        alert("Man our currency is:"+currency);
    },
    labels:function(cmp){
        var vlabe=$A.get("$Label.c.Hello_Prathyusha");
        component.get("v.some text",vlabe);
    }
})