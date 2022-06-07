({
    FirstQuoteLoad : function(component, event, helper) {
    }, 
    handleEvent2 : function(component, event, helper) {
        console.log("parent");
    },
    refreshData : function(component,event,helper){
        console.log("yenilendi");
        var childCmp = component.find("childComponent");
        childCmp.refreshData();
    },
       DataSize : function(component,event,helper){
           var Size = event.getParam("Size");
           console.log("log"+Size);
           component.set("v.Size",Size);
           var childCmpHdr = component.find("childComponentHeader");
           childCmpHdr.dataSize(Size);
    }
})