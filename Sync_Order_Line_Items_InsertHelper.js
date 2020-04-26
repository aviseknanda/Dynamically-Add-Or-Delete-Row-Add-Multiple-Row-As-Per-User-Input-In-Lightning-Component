({
    // get the OLI List from component
    addOrderLineItemRecord: function (component) {
        var orderLineItem = {
            'sobjectType': 'Order_Line_Item__c',
            'Name': '',
            'Start_Date__c': '',
            'End_Date__c': '',
            'Property__c': '',
            'Line_Item_ID__c': ''
        };

        return orderLineItem;
    },
    // Validate all OLI records
    validateOrderLineItemList: function (component, event) {
        var isValid = true;
        var orderLineItemList = component.get("v.orderLineItemList");
        for (var i = 0; i < orderLineItemList.length; i++) {
            if (orderLineItemList[i].Name == '' || orderLineItemList[i].Line_Item_ID__c == '') {
                isValid = false;
                swal("Error", "Order Line Item name or Line item Id Cannot be blank at row :" + (
                    i + 1
                ), "error")
            }
        }
        return isValid;
    },
    // Call Apex class and pass OLI list parameters
    saveOrderLineItemList: function (component, event, helper) {
        var action = component.get("c.saveOrderLineItem");
        var finalList = component.get("v.orderLineItemList");
        for (var i = 0; i < finalList.length; i++) {
            finalList[i].Ad_Campaign__c = component.get("v.recordId");
            if (finalList[i].Name.includes('Sponsorship') || finalList[i].Name.includes('Hero Gateway')) {
                finalList[i].Property__c = 'Amazon Cross-Screen';
            } else if (finalList[i].Name.includes('Amazon DSP')) {
                finalList[i].Property__c = 'AAP';
            } else {
                finalList[i].Property__c = 'AAP';
            }
        }
        action.setParams({"oliList": component.get("v.orderLineItemList")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.orderLineItemList", []);
                swal("Successful", "Order line items have imported Successfully", "success");
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error Message: " + errors[0].message);
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    navigateToAdCampaignWhenSaved: function (component, event, helper) {
        var id = component.get("v.recordId");
        console.log('Ad Campaign Id on Save' + id);
        if (id.indexOf("a0s") > -1) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/' + id,
                "isredirect": false
            });
            urlEvent.fire();
        }
    },
    getPackageNameList: function (component, event) {
        var action = component.get("c.getLineItemName");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var packageNameMap = [];
                for (var key in result) {
                    packageNameMap.push({key: key, value: result[key]});
                }
                component.set("v.packageNameMap", packageNameMap);
            }
        });
        $A.enqueueAction(action);
    },
    // function automatic called by aura:waiting event
    showSpinnerButtonClick: function (component, event) {
        component.set("v.spinner", true);
    },
    hideSpinnerButtonClick: function (component, event, orderLineItemList) {
        window.setTimeout($A.getCallback(function () {
            if (orderLineItemList.length > 0) {
                component.set("v.showInsertPanelRows", true);
                component.set("v.orderLineItemList", orderLineItemList);
            }
            component.set("v.spinner", false);
        }), 1000);
    }
})