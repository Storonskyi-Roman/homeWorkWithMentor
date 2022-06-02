({
    doInit : function(component, event, helper) {
        var action = component.get("c.getMemberId");
        action.setParams({
            "intakeId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var responseValue = response.getReturnValue(); 
                component.set("v.Member",responseValue);
            } else if(state == "ERROR"){
                //helper.getError();
                var error = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "type": "error",
                    "message": error
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },



    save : function(component, event, helper) {
        component.find("edit").get("e.recordSave").fire();
    }


    
})
