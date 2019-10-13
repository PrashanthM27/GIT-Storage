({
	searchController : function(component, event, helper) {
        var searchField = component.find('v.searchField');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        if(isValueMissing){
            searchField.showHelpMessageIfInvalid();
            searchField.focus();
        }else{
            helper.searchHelper(component,event,helper);
        }
	}
})