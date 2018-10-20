using Toybox.Application as App;

class CiqView extends DatarunpremiumView {  

    function initialize() {
        DatarunpremiumView.initialize();
    }

    //! Calculations we need to do every second even when the data field is not visible
    function compute(info) {
        //! If enabled, switch the backlight on in order to make it stay on
        if (uBacklight) {
             Attention.backlight(true);
        }
		//! We only do some calculations if the timer is running
		if (mTimerRunning) {  
			jTimertime = jTimertime + 1;
			//!Calculate lapheartrate
            mHeartrateTime		 = (info.currentHeartRate != null) ? mHeartrateTime+1 : mHeartrateTime;				
           	mElapsedHeartrate    = (info.currentHeartRate != null) ? mElapsedHeartrate + info.currentHeartRate : mElapsedHeartrate;
            //!Calculate lappower
            mPowerTime		 = (info.currentPower != null) ? mPowerTime+1 : mPowerTime;
			mElapsedPower    = (info.currentPower != null) ? mElapsedPower + info.currentPower : mElapsedPower;              
        }
	}


	function onUpdate(dc) {
		//! call the parent onUpdate to do the base logic
		DatarunpremiumView.onUpdate(dc);

    	//! Setup back- and foregroundcolours
		mColourFont = Graphics.COLOR_BLACK;
		mColourFont1 = Graphics.COLOR_BLACK;
		mColourLine = Graphics.COLOR_BLUE;
		mColourBackGround = Graphics.COLOR_WHITE;
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
	}
}
