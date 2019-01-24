({
	doInit : function(component, event, helper) {
        helper.getUserContactInfo(component);
        helper.getContactToMatch(component);
        helper.getButtonOptions(component);
    },

    handleSave : function(component,event,helper) {
        var relVal = event.getParam("relationshipVal");
        console.log('relVal: ' + relVal);
        helper.saveContactMatch(component,relVal);
    },

    endSuccessAnimation : function(component,event,helper) {
        component.set("v.showSuccess",false);
    }
})