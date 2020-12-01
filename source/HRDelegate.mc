using Toybox.WatchUi;

class HRDelegate extends WatchUi.BehaviorDelegate {

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
    	WatchUi.pushView(new VerifiedHumanView(), new WearableCAPTCHADelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}