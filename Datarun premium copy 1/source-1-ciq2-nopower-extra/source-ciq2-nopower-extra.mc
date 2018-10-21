class CiqView extends ExtramemView {	
    var mlastaltitude 						= 0;
    var aaltitude 							= 0;
	var mElevationGain 						= 0;
    var mElevationLoss 						= 0;
    var mElevationDiff 						= 0;
    var mrealElevationGain 					= 0;
    var mrealElevationLoss 					= 0;
    var mrealElevationDiff 					= 0;

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
        //! Calculate elevation differences and rounding altitude
        if (info.altitude != null) {        
          aaltitude = Math.round(info.altitude).toNumber();
          mrealElevationDiff = aaltitude - mlastaltitude;
          if (mrealElevationDiff > 0 ) {
          	mrealElevationGain = mrealElevationDiff + mrealElevationGain;
          } else {
          	mrealElevationLoss =  mrealElevationLoss - mrealElevationDiff;
          }  
          mlastaltitude = aaltitude;
          mElevationLoss = Math.round(mrealElevationLoss).toNumber();
          mElevationGain = Math.round(mrealElevationGain).toNumber();
        }  
	}

	function onUpdate(dc) {
		//! call the parent onUpdate to do the base logic
		ExtramemView.onUpdate(dc);		
	}
	
}
