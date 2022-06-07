({
   handleLoad : function(component, event, helper) {
		console.log('handle handleLoad');
        component.set("v.showSpinner", false);
	},
    handleSubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        console.log(JSON.stringify(fields));
        component.find('createAccountForm').submit(fields(2));
        console.log(JSON.stringify(fields));
        // Submit form
		console.log('handle handleSubmit');
	},
	handleSuccess : function(component, event, helper) {
		console.log('record updated successfully');
        
        
        component.set("v.showSpinner", false);
	},
    getError: function(component, event, helper) {
        debugger;
        var errorObj = event.getParams();
        var errorString = JSON.stringify(errorObj);
        console.log("@@@@:   " + errorString);
        var error = event.getParam("error");
        console.log(error.message); // main error message

        // top level error messages
        error.data.output.errors.forEach(
            function(msg) { console.log(msg.errorCode); 
                           console.log(msg.message); }
        );

        // field specific error messages
        Object.keys(error.data.output.fieldErrors).forEach(
            function(field) { 
                error.data.output.fieldErrors[field].forEach(
                    function(msg) { console.log(msg.fieldName); 
                                   console.log(msg.errorCode); 
                                   console.log(msg.message); }
                )
            });
    }
})