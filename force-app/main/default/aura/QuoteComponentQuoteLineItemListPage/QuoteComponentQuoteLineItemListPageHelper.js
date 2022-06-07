({
    firstload: function(component) {
        var action = component.get("c.getQuotelist");
        var cmpEvent = component.getEvent("DataSize");
        
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            component.set("v.QuoteLineItem", data.getReturnValue());
            cmpEvent.setParams({
                "Size" : component.get("v.QuoteLineItem").length });
            cmpEvent.fire();      
        });
        $A.enqueueAction(action);
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
            {label:"Discount", fieldName:"Discount", type: 'percent', typeAttributes: {minimumFractionDigits: 2}},
            {label:"Total Price", fieldName:"TotalPrice", type:"currency"},
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
    },
    removeQuoteLineItem: function (component, row) {
        
        var action = component.get("c.deleteQuotelineItem");
        var cmpEvent = component.getEvent("DataSize");
        
        action.setParams({
            recordId: component.get("v.recordId"),
            row: row
        });
        action.setCallback(this, function(data) {
            component.set("v.QuoteLineItem", data.getReturnValue());
            cmpEvent.setParams({
                "Size" : component.get("v.QuoteLineItem").length });
            cmpEvent.fire(); 
        });
        $A.enqueueAction(action);
    }
})