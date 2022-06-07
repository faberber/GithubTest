({
    
    noDisplaycreate1 : function(component, event, helper) {
        component.set("v.display",false); 
        helper.ResetTable(component);
    },
    noDisplaycreate : function(component, event, helper) {
        component.set("v.display2",false); 
    },
    Displaycreate1 : function(component, event, helper) {
        component.set("v.display",false); 
        component.set("v.display2",true); 
        console.log(component.get("v.display2"));
    },
    handleEvent : function(component, event, helper) {
        console.log("geldi");
        
        var Id =event.getParam("recordId");
        component.set("v.recordId",Id);
        var display =event.getParam("display");       
        component.set("v.display",display);
        if(display){
            helper.ResetTable(component);
            helper.createColumns(component);
            helper.LoadProduct(component);
        }
    },
    loadMoreData: function (component, event, helper) {
        var selected=component.get("v.selectedRows");
        component.set('v.selectedRows', selected); 
        console.log("knt4");
        console.log(component.get('v.selectedRows'));
        console.log(component.get('v.selectedRows1'));
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading');
        new Promise($A.getCallback(function(resolve, reject) {
            var currentDatatemp = component.get('c.getProductlist');
            currentDatatemp.setParams({
                recordId: component.get("v.recordId"),
                limits: component.get("v.initialRows"),
                offsets: component.get("v.currentCount")
            });                   
            currentDatatemp.setCallback(this, function(a) {
                resolve(a.getReturnValue());
                var countstemps = component.get("v.currentCount");
                countstemps = countstemps+component.get("v.initialRows");
                component.set("v.currentCount",countstemps);
            });
            $A.enqueueAction(currentDatatemp);
        })).then($A.getCallback(function (data) {
            if (component.get('v.data').length >= component.get('v.totalNumberOfRows')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {
                event.getSource().set("v.isLoading", false);
                component.set('v.loadMoreStatus', 'Loading');
                var currentData = component.get('v.data');
                var newData = currentData.concat(data);
                component.set('v.data',component.get('v.data').concat(data));
                component.set('v.loadMoreStatus', 'Please wait ');
            }
            event.getSource().set("v.isLoading", false);
        }));
        console.log("knt7");
        var selected=component.get("v.selectedRows");
        
        component.set('v.selectedRows', selected); 
        console.log(component.get('v.selectedRows'));    
        console.log(component.get('v.selectedRows1'));
        
    },
    SearchKeyChange: function (component, event, helper) {
        var queryTerm= component.find('enter-search').get('v.value');
        if(queryTerm=="" ){
            var selected=component.get("v.selectedRows");
            helper.LoadProduct(component);
            component.set('v.selectedRows', selected); 
        }
        else if(component.get("v.totalNumberOfRows")==300 && queryTerm.length >=3 )
        {        
            var queryTerm = component.find('enter-search').get('v.value');
            var action3 = component.get("c.getsearchProductlist");
            action3.setParams({
                SearchKey:queryTerm,
                recordId: component.get("v.recordId"),
                limits: component.get("v.initialRows"),
                offsets: component.get("v.currentCount")                
            });
            action3.setCallback(this, function(data3) {
                var selected=component.get("v.selectedRows");
                component.set("v.data", data3.getReturnValue());
                component.set("v.totalNumberOfRows",data3.getReturnValue().length );
            });
            $A.enqueueAction(action3);
        }
        helper.createColumns(component);
        component.set('v.selectedRows', selected); 
        
        
    }, 
    handleSubmit : function(component, event, helper) {
        if(component.find('createform').length>1){
            event.preventDefault();
            var validateForm = component.find('createform').reduce(function (validSoFar, inputCmp) {
                inputCmp.submit(); 
                return true;
            }, true);
        }
        else{
            event.preventDefault();
            var eventFields = event.getParam("fields");
            component.find('createform').submit(eventFields);
        }
    },
    handleSuccess : function(component, event, helper) {
        component.set("v.display2",false); 
        var cmpEvent = component.getEvent("RefreshData");
        cmpEvent.fire();
    },
    getError: function(component, event, helper) {
        debugger;
        var errorObj = event.getParams();
        var errorString = JSON.stringify(errorObj);
        console.log("@@@@:   " + errorString);
        var error = event.getParam("error");
        console.log(error.message);
    },
    updateSelectedText: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var select=[];
        component.set('v.selectedRowsCount', selectedRows.length);
        component.set('v.Selected', selectedRows);
        selectedRows.forEach(key => {
            select.push(key.Idprice);
        });       
            component.set('v.selectedRows', select);
            
            
        }
            
        })