({
	 handleEvent : function(component, event, helper) {
        console.log("geldi");
        var Id =event.getParam("recordId");
        component.set("v.recordId",Id);
        var display =event.getParam("display");       
        component.set("v.display",display);
         if(display){
             var action3 = component.get("c.editQuotelineItemList");
             action3.setParams({
                 recordId: component.get("v.recordId"),
             });
             action3.setCallback(this, function(data3) {
                 component.set("v.SelectedEdit", data3.getReturnValue());
                 console.log(JSON.stringify(data3.getReturnValue()));
                 //var count=component.get("v.SelectedEdit").length;
                 if(component.get("v.SelectedEdit").length <= 0){
                     component.set("v.display",false);
                 }
             });
             $A.enqueueAction(action3);
         }
    },
    noDisplayALLeditmodal : function(component, event, helper) {
        component.set("v.display",false);
    },
     handleSubmit : function(component, event, helper) {
         //if(component.find('EditAllItem').length>1){
         var validateForm = component.find('EditAllItem');
         if(Array.isArray(validateForm))
         {
             validateForm = component.find('EditAllItem').reduce(function (validSoFar, inputCmp) {
                 inputCmp.submit(); 
                 return true;
             }, true);
         } 
         else{
             event.preventDefault();
             //var eventFields = event.getParam("fields");
             validateForm.submit();
         }
    },
     handleSuccess : function(component, event, helper) {
         component.set("v.display",false);
         var cmpEvent = component.getEvent("RefreshData");
         cmpEvent.fire();
    }
})