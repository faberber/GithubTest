({
	createColumns : function(component) {
        component.set("v.columns", [
            {label:"Product Name", fieldName:"name" ,type:"text"},
            {label:"Product Description", fieldName:"Description", type:"text"},
            {label:"Product Family", fieldName:"Family", type:"text"}
        ]);
	},
    ResetTable: function(component) {
        component.set("v.Selected",null);
        component.set("v.selectedRowsCount",0);
        component.set("v.selectedRows",null);
        component.find("enter-search").set("v.value",null);
        component.set("v.totalNumberOfRows",300);
        component.set("v.loadMoreOffset",20);
        component.set("v.currentCount",0);
    },
     LoadProduct: function(component) {
        var selected=component.get("v.selectedRows");
        component.set('v.selectedRows', selected); 
        console.log("knt3");
        console.log(component.get('v.selectedRows'));
        component.set("v.currentCount",0);
        component.set("v.totalNumberOfRows",300);
        var action2 = component.get("c.getProductlist");
        //console.log("burayada geldi");
        
        action2.setParams({
            recordId: component.get("v.recordId"),
            limits: component.get("v.initialRows"),
            offsets: component.get("v.currentCount")
        });        
        action2.setCallback(this, function(data2) {
            component.set("v.data", data2.getReturnValue());
            component.set("v.currentCount",component.get("v.currentCount") +component.get("v.initialRows"));
            console.log(JSON.stringify(data2.getReturnValue()));
            
        });
        $A.enqueueAction(action2);
        
        console.log("buerada 4");
    },
})