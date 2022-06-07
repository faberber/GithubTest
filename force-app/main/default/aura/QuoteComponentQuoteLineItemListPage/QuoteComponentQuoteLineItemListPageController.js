({
    FirstQuoteLoad : function(component, event, helper) {
        console.log("id"+component.get("v.recordId"));
        helper.firstload(component);
        helper.CollumsQuoteLineItemTable(component);
        
    },
    refreshData : function(component, event, helper) {
        helper.firstload(component);
        helper.CollumsQuoteLineItemTable(component);
    },
     noDisplaydeletemodal : function(component, event, helper) {
        component.set("v.display",false)
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit':
                var action3 = component.get("c.QuotelineItemName");
                action3.setParams({
                    recordId: row.Id,
                });
                action3.setCallback(this, function(data3) {
                    component.set("v.EditQuoteLineItemName", data3.getReturnValue());
                });
                $A.enqueueAction(action3);
                component.set("v.saved",true);
                component.set("v.EditQuoteLineItemId",row.Id);
                component.set("v.displayEdit",true)
                break;
            case 'Delete':
                component.set("v.DeleteQuoteLineItem",null);
                component.set("v.DeleteQuoteLineItem",row);
                component.set("v.display",true)
                console.log("display"+ component.get("v.display"));
                break;
        }
    },
    Displaydeletemodal: function(component, event, helper) {
        var row =  component.get("v.DeleteQuoteLineItem");
        helper.removeQuoteLineItem(component, row);
        component.set("v.display",false)

    },
    
     handleSuccess : function(component, event, helper) {
        helper.firstload(component);
        helper.CollumsQuoteLineItemTable(component);
        component.set("v.displayEdit",false)
        component.set("v.saved",false);
    },
    handleOnSubmit : function(component, event, helper) {
        var fields = event.getParam("fields");
        component.find("EditForm").submit(fields);
        
    },
    
    
})