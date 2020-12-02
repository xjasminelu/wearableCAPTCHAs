using Toybox.WatchUi;
using Toybox.System;

class WearableCAPTCHAMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
        //start session start timer
            System.println("item 1");
        } else if (item == :item_2) {
        // stop session stop timer
            System.println("item 2");
        }
    }

}