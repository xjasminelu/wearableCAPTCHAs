using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Attention;
using Toybox.System;
using Toybox.Application.Storage;

var lastTransmitTime = null;
var lastTransmitID = "";
var checkCaptcha = false;

class WearableCAPTCHAApp extends Application.AppBase {


    function initialize() {
        AppBase.initialize();
    }


    function onReceive(responseCode,data) {
    	System.println(responseCode);
    	System.println(data);
    }

    function markLastTransmissionStale() {
    	var lt_id = Storage.getValue("lt_id");
    	var lt_timestamp = Storage.getValue("lt_timestamp");
    	var lt_hv = Storage.getValue("lt_hv");
    	var lt_vv = Storage.getValue("lt_vv");

    	var url="https://networks-fall2020.firebaseio.com/networks-fall2020/client/" + lt_id + ".json";
    	var params = {
    		"timestamp" => lt_timestamp,
    		"uID" => "user###temp###",
    		"human_verified" => lt_hv,
    		"verification_value" => lt_vv,
    		"stale" => "true"
    	};
    	var options= {
    		:method => Communications.HTTP_REQUEST_METHOD_PUT,
    		:headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    		:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    	};

    	var responseCallback = method(:onReceive);

    	Communications.makeWebRequest(url, params, options, responseCallback);
    }

    function timerCallback() {
    	checkCaptcha = true;
    	var vibeData = null;
    	if (Attention has :vibrate) {
		    vibeData =
		    [
		        new Attention.VibeProfile(50, 1000), // On for two seconds
		        //new Attention.VibeProfile(0, 2000),  // Off for two seconds
		        //new Attention.VibeProfile(50, 2000), // On for two seconds
		        //new Attention.VibeProfile(0, 2000),  // Off for two seconds
		        //new Attention.VibeProfile(50, 2000)  // on for two seconds
		    ];
		}
		Attention.vibrate(vibeData);
		WatchUi.pushView(new WearableCAPTCHAView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
		markLastTransmissionStale();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	//check if last Transmission has exceeded 5 min
    	var lt_timeval = Storage.getValue("lt_timeval");
    	if(lt_timeval != null) {
    	var lt_moment = new Time.Moment(lt_timeval);

	    	var timeElapsed = Time.now().subtract(lt_moment);
	    	if(timeElapsed.value() > 300){ // 5 minutes
	    		markLastTransmissionStale();
	    	}
	    }

    	var myTimer = new Timer.Timer();
    	//callback every 5min (change to every 5 min later)
    	//myTimer.start(method(:timerCallback), 300000, true);
      myTimer.start(method(:timerCallback), 30000, true);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new WearableCAPTCHAView(), new WearableCAPTCHADelegate() ];
    }

}
