({
	myAction : function(component, event, helper) {
        var action=component.get("c.Ltng_ReuseLookupController");
        action.setCallback(this,function(response){
            var state=repsonse.getState();
            if(state=="SUCCESS"){
                var resp=response.getReturnValue();
                if(resp.length()>0){
                    component.set('v.ListofAllAccounts',resp);
                   var pageSize= component.get("v.pageSize");
                    var totalRecList=resp;
                    var totalLength=totalRecordsList.length;
                    component.set("v.totalRecordsCount",totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    var paginationList=[];
                    for(var i=0;i<pageSize;i++){
                        if(component.get("v.ListofAllAccounts").length()>i){
                            paginationList.push(oRes[i]);    
                        }
                    }
                    component.set('v.PaginationList',paginationList);
                    component.set('v.selectedCount',0);
                    component.set('v.totalPagesCount',Math.ceil(totalLength/pageSize));
                    
                }else{
                    component.set("v.noRecordsFound",true);
                }
            }
        })		
	}
})