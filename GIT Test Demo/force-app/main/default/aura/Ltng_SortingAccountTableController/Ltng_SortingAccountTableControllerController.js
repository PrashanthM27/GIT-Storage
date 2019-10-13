({
        AccountRecordsList : function(component, event, helper) {
            var action = component.set("v.accColumns",[
                {label:'Name',FieldName:'AccountName',Type:'url',typeAttributes:{label:{fieldName:'Name'},target:'blank'}},
                {label:'Rating',FieldName:'AccountRating',Type:'Text',},
                {label:'Account Source',FieldName:'Account Source',Type:'Text',}
            ]);
            
        },
    })