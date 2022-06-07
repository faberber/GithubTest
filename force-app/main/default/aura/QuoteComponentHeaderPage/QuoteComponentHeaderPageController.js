({
    Displaycreate : function(component, event, helper) {
        console.log("gitti");
        // var compEvents = component.getEvent("CreateModal");
        var compEvents = $A.get("e.c:CreateModal");
        compEvents.setParams(
            { "recordId" : component.get("v.recordId") , "display" : true }
        );
        compEvents.fire();
    },
    DisplayALLeditmodal : function(component, event, helper) {
        console.log("gitti");
        var compEvents2 = $A.get("e.c:EditModal");
        compEvents2.setParams(
            { "recordId" : component.get("v.recordId") , "display" : true }
        );
        compEvents2.fire();
        
    },
    dataSize : function(component, event, helper) {
        console.log("geldi sizesız");      
        
        var params = event.getParam('arguments');
        if (params) {
            var p1 = params.Size;
            
            console.log("geldi size"+p1);      
            component.set("v.displaySize",p1);
            
        }
    },
})