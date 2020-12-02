using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;

class HRDelegate extends WatchUi.BehaviorDelegate {

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
    	System.println(data.get("name"));
    	Storage.setValue("lt_id", data.get("name"));
    }
    
    function makeRequest() {
    	var url= URL;
    	var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    	Storage.setValue("lt_timeval", Time.now().value());
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
    	Storage.setValue("lt_timestamp", dateString);
    	Storage.setValue("lt_hv", "false");
    	Storage.setValue("lt_vv", 0.355);
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