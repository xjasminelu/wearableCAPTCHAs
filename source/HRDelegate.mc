using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;
using Toybox.ActivityMonitor;
using Toybox.Activity;
using Toybox.Attention;

class HRDelegate extends WatchUi.BehaviorDelegate {

	var verified=false;

    function initialize() {
        BehaviorDelegate.initialize();
        //where to put this?? trigger it somewhere other than initialize? or on delay?
        var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
		var sample = hrIterator.next();                                   // get the previous HR
    	if (null != sample) {                                           // null check
        	if (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE){ // check for invalid sample
        		verified=true;
                System.println("Verified. Sample: " + sample.heartRate);
                var vibeData = null;
    			if (Attention has :vibrate) {
		   		vibeData =
		    	[
		        	new Attention.VibeProfile(50, 2000), // On for two seconds
		        	//new Attention.VibeProfile(0, 2000),  // Off for two seconds
		        	//new Attention.VibeProfile(50, 2000), // On for two seconds
		        	//new Attention.VibeProfile(0, 2000),  // Off for two seconds
		        	//new Attention.VibeProfile(50, 2000)  // on for two seconds
		   	 	];
				}
				Attention.vibrate(vibeData);
        	}
  	  	}

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
    		"human_verified" => "false", //this is what to set
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
    	if (verified!=false){
    	var vibeData = null;
    			if (Attention has :vibrate) {
		   		vibeData =
		    	[
		        	new Attention.VibeProfile(50, 2000), // On for two seconds
		        	//new Attention.VibeProfile(0, 2000),  // Off for two seconds
		        	//new Attention.VibeProfile(50, 2000), // On for two seconds
		        	//new Attention.VibeProfile(0, 2000),  // Off for two seconds
		        	//new Attention.VibeProfile(50, 2000)  // on for two seconds
		   	 	];
				}
				Attention.vibrate(vibeData);
    	}
    	makeRequest();
    	WatchUi.pushView(new VerifiedHumanView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
        return true;
    }



}
