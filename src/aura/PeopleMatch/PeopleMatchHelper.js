({
    getUserContactInfo : function(component) {
        var action = component.get("c.getUserContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userContact", res);
            }
        });
        $A.enqueueAction(action);
    },

    getContactToMatch : function(component) {
        var action = component.get("c.getContactToMatch");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                this.getPercentageOfMatches(component,false,res);
            }
        });
        $A.enqueueAction(action);
    },

    getButtonOptions : function(component) {
        var action = component.get("c.getButtonLabelsAndValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = [];
                var optionsMap = response.getReturnValue();
                for(var key in optionsMap){
                    options.push({value:optionsMap[key], key:key});
                }
                component.set("v.buttonOptions", options);
            }
        });
        $A.enqueueAction(action);
    },

    saveContactMatch : function(component, relLvl) {
        var action = component.get("c.saveNewContactMatch");
        action.setParams({
            matchedContactId : component.get("v.currentMatchContact.Id"),
            relationshipLevel : relLvl
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                this.getPercentageOfMatches(component,true,res);
            } else {
                let errors = res.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.log(message);
                //todo error handling for user
            }
        });
        $A.enqueueAction(action);
    },

    getPercentageOfMatches : function(component,showSuccess,currentContact) {
        var action = component.get("c.getMatchPercentage");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.matchPercentage",res);
                omponent.set("v.currentMatchContact",currentContact);
                component.set("v.showSuccess",showSuccess);
            } else {
                //handle error
            }
        });
        $A.enqueueAction(action);
    }
})