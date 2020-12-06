using Toybox.WatchUi;
using Toybox.Application;
using Toybox.System;

class WearableCAPTCHAMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
        //start session start timer
            WatchUi.pushView(new WearableCAPTCHAView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
        } else if (item == :item_2) {
        // stop session stop timer
        	System.exit();
        }
    }

}