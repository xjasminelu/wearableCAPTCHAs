using Toybox.WatchUi;
using Toybox.Time;

class CheckHRView extends WatchUi.View {

	hidden var mLabel;
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.CheckHeartRateLayout(dc));
        mLabel = View.findDrawableById("hr_text");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	var hr = "--";
    	if (s_hr == null){
    		hr = "--";
    	}
    	else {
    		hr = s_hr + "";
    	}
    	mLabel.setText(hr);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
