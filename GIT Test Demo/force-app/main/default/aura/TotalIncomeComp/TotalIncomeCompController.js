({
	doInIt : function(component, event, helper) {
        component.set('v.myIncome',[            
            {label:'S.No',FieldName:'sno',type:'number'},
            {label:'Name of Source',FieldName:'Source',type:'text'},
            {label:'Amount',FieldName:'amount',type:'number'}
        ]);
        component.set('v.income',[
            {sno:'122',Source:'Regular Job',amount:'2300'},
            {sno:'123',Source:'Parttime Job',amount:'4000'}
        ]);
        
	}
})