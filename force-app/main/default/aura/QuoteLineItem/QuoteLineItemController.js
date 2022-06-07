({   ////////////display controller /////////////////////
    noDisplaycreate: function(component, event, helper) {
        document.getElementById("createmodal1").style.display = "none";
    },
    Displaycreate1: function(component, event, helper) {
        var selected=component.get("v.selectedRows");
        if(selected.length>0){
            document.getElementById("createmodal1").style.display = "block";
            document.getElementById("createmodal").style.display = "none";
        }
    },
    noDisplaycreate1: function(component, event, helper) {
        document.getElementById("createmodal").style.display = "none";
    },
    noDisplayeditmodal: function(component, event, helper) {
        document.getElementById("editQuoteLineItem2").style.display = "none";
    },
    noDisplaydeletemodal: function(component, event, helper) {
        document.getElementById("delete").style.display = "none";
    },
    DisplayALLeditmodal: function(component, event, helper) {
        console.log("dsiplayyyy");
        
        var action3 = component.get("c.editQuotelineItemList");
        action3.setParams({
            recordId: component.get("v.recordId"),
        });
        action3.setCallback(this, function(data3) {
            component.set("v.SelectedEdit", data3.getReturnValue());
            console.log(JSON.stringify(data3.getReturnValue()));
            //var count=component.get("v.SelectedEdit").length;
            if(component.get("v.SelectedEdit").length > 0){
                document.getElementById("editAllItem").style.display = "block";
            }
        });
        $A.enqueueAction(action3);
        
        
    },    
    noDisplayALLeditmodal: function(component, event, helper) {
        document.getElementById("editAllItem").style.display = "none";
    },
    //////////search change function////////////
    SearchKeyChange: function (component, event, helper) {
        console.log("knt1");
        var selected=component.get("v.selectedRows");
        component.set('v.selectedRows', selected); 
        console.log(component.get('v.selectedRows'));
        console.log(component.get('v.selectedRows1'));
        
        
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
        helper.CollumsProductTable(component);
        component.set('v.selectedRows', selected); 
        console.log("knt2");
        console.log(component.get('v.selectedRows'));
        console.log(component.get('v.selectedRows1'));
        
    }, 
    ////////////Quote line Item Table load//////////////////
    FirstQuoteLoad : function(component, event, helper) {
        var selected=component.get("v.selectedRows");
        component.set('v.selectedRows', selected); 
        console.log("knt6");
        console.log(component.get('v.selectedRows'));
        console.log(component.get('v.selectedRows1'));
        
        helper.firstload(component);
        helper.CollumsQuoteLineItemTable(component);
    },
    /////////table pricebook entry load and first modal display
    Displaycreate: function(component, event, helper){
        console.log("tıklandı");
       	helper.ResetTable(component);
        helper.LoadProduct(component);
        helper.CollumsProductTable(component);
        document.getElementById("createmodal").style.display = "block";
        console.log("göster");

    },
    //////// first modal pricebook entry load product //////////
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
    //////////////////////////////////////////////
    ///
    /// Tablo Actionları
    //
    //////////////////////////////////////////////
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
                document.getElementById("editQuoteLineItem2").style.display = "block";
                break;
            case 'Delete':
                component.set("v.DeleteQuoteLineItem",null);
                component.set("v.DeleteQuoteLineItem",row);
                document.getElementById("delete").style.display = "block";
                break;
        }
    },
    Displaydeletemodal: function(component, event, helper) {
        var row =  component.get("v.DeleteQuoteLineItem");
        helper.removeQuoteLineItem(component, row);
        document.getElementById("delete").style.display = "none";
    },
    //////////////////////////////////////////////////////////
    ///
    /// kayıt yapmak için script
    //
    //////////////////////////////////////////////
    handleLoad : function(component, event, helper) {
    },
    handleSubmit : function(component, event, helper) {
         if(component.find('fatih').length > 1){
            event.preventDefault();
            var validateForm = component.find('fatih').reduce(function (validSoFar, inputCmp) {
                inputCmp.submit(); 
                return true;
            }, true);
        }
        else{
            event.preventDefault();
            var eventFields = event.getParam("fields");
            component.find('fatih').submit(eventFields);
        }
    },
    handleSuccess : function(component, event, helper) {
        document.getElementById("createmodal1").style.display = "none";
        helper.firstload(component);
    },
    getError: function(component, event, helper) {
        debugger;
        var errorObj = event.getParams();
        var errorString = JSON.stringify(errorObj);
        console.log("@@@@:   " + errorString);
        var error = event.getParam("error");
        console.log(error.message);
       /* error.data.output.errors.forEach(
            function(msg) { console.log(msg.errorCode); 
                           console.log(msg.message); }
        );*/
       /* Object.keys(error.data.output.fieldErrors).forEach(
            function(field) { 
                error.data.output.fieldErrors[field].forEach(
                    function(msg) { console.log(msg.fieldName); 
                                   console.log(msg.errorCode); 
                                   console.log(msg.message); }
                )
            });*/
    },
    //////////////////////////////////////////////////////////
    ///
    /// kayıt güncellemek için script
    //
    //////////////////////////////////////////////
    handleSuccess2 : function(component, event, helper) {
        helper.firstload(component);
        helper.CollumsQuoteLineItemTable(component);
        document.getElementById("editQuoteLineItem2").style.display = "none";
        component.set("v.saved",false);
    },
    handleOnSubmit22 : function(component, event, helper) {
        var fields = event.getParam("fields");
        component.find("form").submit(fields);
        
    },
    //////////////////////////////////////////////////////////
    ///
    /// Tüm kayıt güncellemek için script
    //
    //////////////////////////////////////////////
    handleSubmit5 : function(component, event, helper) {
        if(component.find('EditAllItem').length>1){
        var validateForm = component.find('EditAllItem').reduce(function (validSoFar, inputCmp) {
            inputCmp.submit(); 
            return true;
        }, true);
        }
        else{
            event.preventDefault();
            var eventFields = event.getParam("fields");
            component.find('EditAllItem').submit(eventFields);
        }
    },
    handleSuccess5 : function(component, event, helper) {
        document.getElementById("editAllItem").style.display = "none";
        helper.firstload(component);
    },
    //////////// pricebook product selected item /////////
    updateSelectedText: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var select=[];
        component.set('v.selectedRowsCount', selectedRows.length);
        component.set('v.Selected', selectedRows);
        selectedRows.forEach(key => {
            select.push(key.Idprice);
        });       
            component.set('v.selectedRows', select);
            component.set('v.selectedRows1', select);
            
            
        },
          
            
            
            
            
        })