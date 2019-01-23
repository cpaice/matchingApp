({
    getUserContactInfo : function(component) {
        var action = component.get("c.getUserContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userContact", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },

    getContactsToMatchList : function(component) {
        var action = component.get("c.getContactsToMatch");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
               // set current user information on userInfo attribute
                component.set("v.matchContacts", storeResponse);
                component.set("v.currentMatchContact", storeResponse[0]);
            }
        });
        $A.enqueueAction(action);
    }
})