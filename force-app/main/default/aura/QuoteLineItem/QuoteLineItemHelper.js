({
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
    CollumsProductTable: function(component) {
        component.set("v.columns2", [
            {label:"Product Name", fieldName:"name" ,type:"text"},
            {label:"Product Description", fieldName:"Description", type:"text"},
            {label:"Product Family", fieldName:"Family", type:"text"}
        ]);
    },
    CollumsQuoteLineItemTable: function(component) {
        var actions = [{
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit'
        },{
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete'
        }];
        component.set("v.Columns", [
            {label:"Product", fieldName:"name" ,type:"text"},
            {label:"Sales Price", fieldName:"UnitPrice", type:"currency"},
           /* {label:"Quantity", fieldName:"Quantity", type:"number"},
            {label:"Subtotal", fieldName:"Subtotal", type:"currency"},*/
            {label:"Discount", fieldName:"Discount", type: 'percent', typeAttributes: {minimumFractionDigits: 2}},
            {label:"Total Price", fieldName:"TotalPrice", type:"currency"},
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
    },
    firstload: function(component) {
        var action = component.get("c.getQuotelist");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            component.set("v.QuoteLineItem", data.getReturnValue());
             component.set("v.ProductCount", data.getReturnValue().length);
            
           // console.log(JSON.stringify( component.get("v.QuoteLineItem")));
        });
        $A.enqueueAction(action);
    },
    ResetTable: function(component) {
        component.set("v.data",null);
        component.set("v.Selected",null);
        component.find("enter-search").set("v.value",null);
        component.set("v.selectedRowsCount",null);
        component.set("v.columns2",null);
        component.set("v.loadMoreStatus",null);
        component.set("v.totalNumberOfRows",300);
        component.set("v.loadMoreOffset",20);
        component.set("v.currentCount",0);
    },
    removeQuoteLineItem: function (component, row) {
        
        var action = component.get("c.deleteQuotelineItem");
        action.setParams({
            recordId: component.get("v.recordId"),
            row: row
        });
        action.setCallback(this, function(data) {
            component.set("v.QuoteLineItem", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
})