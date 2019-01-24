({
    sendMatchedContact : function(component,event,helper) {
        var btnValue = event.getSource().get("v.value");
        console.log('val: ' + btnValue);

        var saveEvent = component.getEvent("saveMatchEvent");
        saveEvent.setParams({"matchedContact": component.get("v.contactToMatch"),
        "relationshipVal": btnValue});
        saveEvent.fire();
    }
})