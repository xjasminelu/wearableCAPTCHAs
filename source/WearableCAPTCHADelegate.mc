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

    function onNextPage() {
    	//If ready for next captcha var = true
    	// Push to one of 3 interfaces

    	// temp - choose one on random number 1-3
    	if (checkCaptcha) {
	    	var r;
	    	r = Mt.rand()%3;
        //r=0; //for testing each page - Remove for full version
        if (r == 0) {
	    		WatchUi.pushView(new CheckHRView(), new HRDelegate(), WatchUi.SLIDE_UP);
	    	}
	    	else if(r == 1) {
	    		WatchUi.pushView(new RotateHandsView(), new RotateHandsDelegate(), WatchUi.SLIDE_UP);
	    	}
	    	else {
	    		WatchUi.pushView(new ShakeHandsView(), new ShakeHandsDelegate(), WatchUi.SLIDE_UP);
    		}
    		checkCaptcha = false;

    	}


        return true;
    }

}
