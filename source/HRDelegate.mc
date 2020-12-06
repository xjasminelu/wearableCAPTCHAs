using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;
using Toybox.Attention;
using Toybox.Timer;
using Toybox.Sensor;

var s_hr;
var captcha_mode = false;

class HRDelegate extends WatchUi.BehaviorDelegate {

	var verified=false;
	var myTimer;
	var totalHRchecks=0;
	var totalWrongHR = 0;
	
	var ver_value = 0;
	
	function onSensor(sensorInfo) {
    	s_hr = sensorInfo.heartRate;
    	if(s_hr == null) {
	    	totalWrongHR +=1;
    	}
    	totalHRchecks +=1;
    	WatchUi.requestUpdate();
	}
	
	function onReceive(responseCode,data) {
    	System.println(responseCode);
    	System.println(data);
    	Storage.setValue("lt_id", data.get("name"));
    }

    function makeRequest() {
    	var url= URL;
    	var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    	Storage.setValue("lt_timeval", Time.now().value());
    	
    	var ver_string = "";
    	if(verified) {
    		ver_string = "true";
    	}
    	else {
    		ver_string = "false";
    	}
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
    		"human_verified" => ver_string, 
    		"captcha_type" => "hr",
    		"verification_value" => ver_value,
    		"stale" => "false"
    	};
    	var options= {
    		:method => Communications.HTTP_REQUEST_METHOD_POST,
    		:headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    		:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    	};
    	var responseCallback = method(:onReceive);
    	Storage.setValue("lt_timestamp", dateString);
    	Storage.setValue("lt_type", "hr");
    	Storage.setValue("lt_hv", ver_string);
    	Storage.setValue("lt_vv", ver_value);
    	Storage.setValue("markedstale", "false");
    	Communications.makeWebRequest(url, params, options, responseCallback);
    }

    function verify() {
    	//Run CAPTCHA Verification
    	//when the process is complete, push data to the database
    	if(totalHRchecks!=0){
    		ver_value = 1.0 - ((totalWrongHR*1.0)/(totalHRchecks*1.0));
    	}
    	verified = ver_value >= 0.5;
    	
    	if (verified!=false){
    		var vibeData = null;
    		if (Attention has :vibrate) {
			   		vibeData =
			    	[
			        	new Attention.VibeProfile(50, 2000), // On for two seconds
			   	 	];
				}
			Attention.vibrate(vibeData);
			makeRequest();
    		WatchUi.pushView(new VerifiedHumanView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
    	}
    	else {
    		System.println("NOT VERIFIED");
    		var vibeData = null;
    		if (Attention has :vibrate) {
			   		vibeData =
			    	[
			        	new Attention.VibeProfile(50, 2000), // On for two seconds
			   	 	];
				}
			Attention.vibrate(vibeData);
			makeRequest();
    		WatchUi.pushView(new NotVerifiedView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
    	}
    	
    	captcha_mode = false;
    	
        return true;
    }
    
    function onNextPage() {
    
    }
	
	function timerCallback() {
		Sensor.setEnabledSensors([]);
		verify();
	}

    function initialize() {
        BehaviorDelegate.initialize();
     	captcha_mode = true;
     	
     	Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
    	Sensor.enableSensorEvents(method(:onSensor));
		
		myTimer = new Timer.Timer();
    	//callback every 5sec
      	myTimer.start(method(:timerCallback), 5000, false);
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new WearableCAPTCHAMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    



}
