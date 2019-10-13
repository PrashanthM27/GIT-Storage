({
     callContactList : function(component, event, helper) {
       helper.callContact(component);
     },
    createContact:function(component,event,helper){
        var createContact=$A.get("e.force:createRecord");
        createContact.setParams({
            "entityApiName" : "Contact",
            "defaultFieldValues" :{"AccountId" :component.get("v.recordId")}
        });
        createContact.fire();
    }
})