class CiqView extends ExtramemView {	
	hidden var mETA							= 0;
	hidden var uETAfromLap 					= true;
	
    function initialize() {
        ExtramemView.initialize();		
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
        } 
	}

	function onUpdate(dc) {
		//! call the parent onUpdate to do the base logic
		ExtramemView.onUpdate(dc);		
	}
	
}
