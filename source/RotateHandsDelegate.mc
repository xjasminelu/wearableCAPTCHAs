using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class RotateHandsDelegate extends WatchUi.BehaviorDelegate {

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
    	var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format(
		    "$1$:$2$:$3$ $4$ $5$ $6$ $7$",
		    [
		        today.hour,
		        today.min,
		        today.sec,
		        today.day_of_week,
		        today.day,
		        today.month,
		        today.year
		    ]
		);
		var params= {
    		"timestamp" => dateString,
    		"uID" => "user###temp###",
    		"human_verified" => "false",
    		"verification_value" => 0.355,
    		"stale" => "false"
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