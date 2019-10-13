({
    copyHardcoreText : function(component, event, helper) {
        // get HTML hardcore value using aura:id
        var textForCopy = component.find('pId').getElement().innerHTML;
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    
    copyInputFieldValue : function(component, event, helper) {
        // get lightning:textarea field value using aura:id
        var textForCopy = component.find('inputF').get("v.value");
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    
})