({
	doInit : function(component, event, helper) {
	var action = component.get("c.getUserContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.UserContact", storeResponse);
            }
        });
        $A.enqueueAction(action);
    }
})