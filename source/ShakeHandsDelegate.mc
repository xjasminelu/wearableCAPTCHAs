using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.System;

class ShakeHandsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new WearableCAPTCHAMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function makeRequest() {
    	var url= URL;
    	var params= {
    		"timestamp" => System.timestamp,
    		"uID" => "user###temp###",
    		"human_verified" => "No(temp)",
    		"verification_value" => 0.355,
    		"stale" => false
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
    	//Run CAPTCHA Verification
    	//when the process is complete, push data to the database
    	makeRequest();
    	WatchUi.pushView(new VerifiedHumanView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}