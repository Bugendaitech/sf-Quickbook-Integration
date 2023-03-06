({
	navigateToLWC : function(component, event, helper) {
	var recid = component.get("v.recordId");
        console.log('recid::'+recid);
        /*var navLink = component.find("navToLWC");	
        var pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Bind_New',
                recordId: recid
            }
            
        };
         navLink.navigate(pageReference, true);*/
        var currentURL =window.location.href;
				 console.log('currentURL'+currentURL);
				 var baseURL = currentURL.substring(0, currentURL.indexOf("lightning/r"));
				 console.log('baseURL after removing'+baseURL);
				 baseURL = baseURL + '/apex/Bind?quoteId='+recid;
				 window.open(baseURL, '_blank');
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
})