({
    doInit : function(component,event,helper) {
          //component.set("v.showThing",false);
          window.setTimeout(
              $A.getCallback(function() {
                  //component.set("v.showThing",true);
                  var endEvent = component.getEvent("successEndEvent");
                  endEvent.fire();
              }), 800
          );
    }
})