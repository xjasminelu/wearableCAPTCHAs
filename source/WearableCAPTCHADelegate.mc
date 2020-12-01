using Toybox.WatchUi;
using Toybox.Math as Mt;
using Toybox.Communications;
using Toybox.System;

const URL = "https://networks-fall2020.firebaseio.com/networks-fall2020/client.json";

class WearableCAPTCHADelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new WearableCAPTCHAMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function onReceive(responseCode,data) {
    	System.println(responseCode);
    	System.println(data);
    }
    
    function makeRequest() {
    	var url= URL;
    	var params= {
    		"test" => "button press"
    	};
    	var options= {
    		:method => Communications.HTTP_REQUEST_METHOD_POST,
    		:headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    		:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    	};
    	var responseCallback = method(:onReceive);
    	
    	Communications.makeWebRequest(url, params, options, responseCallback);
    }
    
    function onNextPage() {
    	//If ready for next captcha var = true
    	// Push to one of 3 interfaces
    	
    	// temp - choose one on random number 1-3
    	
    	makeRequest();
    	
    	var r;
    	r = Mt.rand()%3;
    	if (r == 0) {
    	WatchUi.pushView(new CheckHRView(), new HRDelegate(), WatchUi.SLIDE_UP);
    	}
    	else if(r == 1) {
    	WatchUi.pushView(new RotateHandsView(), new HRDelegate(), WatchUi.SLIDE_UP);
    	}
    	else {
    	WatchUi.pushView(new ShakeHandsView(), new HRDelegate(), WatchUi.SLIDE_UP);
    	}
    	
        return true;
    }

}