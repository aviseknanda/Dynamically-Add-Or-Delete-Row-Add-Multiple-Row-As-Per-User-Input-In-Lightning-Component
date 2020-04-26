({
    // Adding Single row at a time using + button on the component
    addRow: function (component, event, helper) {
        var orderLineItemList = component.get("v.orderLineItemList");
        orderLineItemList.push(helper.addOrderLineItemRecord(component));
        component.set("v.orderLineItemList", orderLineItemList);
    },
    // Remove the row based on the action by the user.
    removeRow: function (component, event, helper) { // Get the OrderLine Item List list
        var orderLineItemList = component.get("v.orderLineItemList");
        // Get the target object
        var selectedItem = event.currentTarget;
        // Get the selected item index
        var index = selectedItem.dataset.record;
        orderLineItemList.splice(index, 1);
        component.set("v.orderLineItemList", orderLineItemList);
    },
    save: function (component, event, helper) {
        if (helper.validateOrderLineItemList(component, event)) {
            helper.saveOrderLineItemList(component, event);
            window.setTimeout($A.getCallback(function () {
                helper.navigateToAdCampaignWhenSaved(component, event, helper);
            }), 3000);
        }
    },
    // OnChage Event to add Multiple Rows based on the dropdown value selected on the component
    onChangeAddMultipleRow: function (component, event, helper) {
        var orderLineItemList = component.get("v.orderLineItemList");
        helper.showSpinnerButtonClick(component, event);
        var rowAddCounter = component.find('howManyOli').get('v.value');
        if (!$A.util.isEmpty(rowAddCounter) && rowAddCounter <= 50) {
            for (var i = 0; i < rowAddCounter; i++) {
                orderLineItemList.push(helper.addOrderLineItemRecord(component));
            }
        } else {
            swal("Error", "Oops! You can add a maximum of 50 rows at a time.", "error");
        } helper.hideSpinnerButtonClick(component, event, orderLineItemList);
    },


    onClickCancelHideInsertPanel: function (component, event, helper) {
        component.set("v.showInsertPanelRows", false);
    },
    onCancelInsert: function (component, event, helper) {
        location.reload(true);
    },
    doInit: function (component, event, helper) {
        helper.getPackageNameList(component, event);
    }
})