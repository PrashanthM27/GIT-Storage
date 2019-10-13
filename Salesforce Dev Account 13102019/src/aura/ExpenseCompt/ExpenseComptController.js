({
    handleData : function(component, event, helper) {
        var btnClick=event.getSource();
        var btLabel=btnClick.get("v.label");
        component.set("v.message",btnLabel);
        var vexp=component.find('expenseform').reduce(function(validsofar,inputCmp){
            inputCmp.ShowHelpMessageIfInvalid();    
            
            var myDate=component.get("v.expense",Date__c);
            if(myDate){
                component.set('v.formatdate',new Date(myDate));
            }
        })
        }
})