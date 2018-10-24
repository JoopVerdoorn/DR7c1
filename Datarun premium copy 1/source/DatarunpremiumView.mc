using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
class Datarunpremiumcopy1App extends Toybox.Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new DeviceView() ];  
    }
}

class DatarunpremiumView extends Ui.DataField {
	hidden var stats = Sys.getSystemStats();
	hidden var pwr = stats.battery;
	hidden var appversion = "1.00";

	//!Get device info
	var mySettings = System.getDeviceSettings();
	hidden var ID0 = 999;
	hidden var ID1 = 123;
	hidden var ID2 = 456;
	hidden var WatchID = mySettings.uniqueIdentifier;
	hidden var watchType = mySettings.partNumber;
	hidden var licenseOK = false;
	hidden var CCode = 12345678;
	
	hidden var uMilClockAltern = 0;
	hidden var uShowDemo = false;
	hidden var umyNumber = 26429769;
	var uBlackBackground 					= false;
	
	hidden var mtest = 63869733;
	hidden var jTimertime = 0;
	
	hidden var fieldValue = [1, 2, 3, 4, 5, 6, 7, 8];
	hidden var fieldLabel = [1, 2, 3, 4, 5, 6, 7, 8];
	hidden var fieldFormat = [1, 2, 3, 4, 5, 6, 7, 8];	

    hidden var Averagespeedinmper3sec 			= 0;
    hidden var Averagespeedinmper5sec 			= 0;
    hidden var mColour;
    hidden var mColourFont;
	hidden var mColourFont1;
    hidden var mColourLine;
    hidden var mColourBackGround;
   
    hidden var mLapTimerTime   = 0;
	hidden var mElapsedDistance				= 0;
    hidden var mTimerRunning                = false;	
    hidden var unitP                        = 1000.0;
    hidden var unitD                        = 1000.0;
    hidden var Pace1 								= 0;
    hidden var Pace2 								= 0;
    hidden var Pace3 								= 0;
	hidden var Pace4 								= 0;
    hidden var Pace5 								= 0;

    hidden var CurrentSpeedinmpersec			= 0;
    hidden var uRoundedPace                 = true;

    hidden var uBacklight                   = false;

    hidden var uUpperLeftMetric            = 0;    //! Timer is default
    hidden var uUpperRightMetric           = 4;    //! Distance is default
    hidden var uMiddleLeftMetric           = 45;    //! HR is default
    hidden var uMiddleMiddleMetric           = 8;    //! Pace is default    
    hidden var uMiddleRightMetric           = 50;    //! Cadence is default
    hidden var uBottomLeftMetric            = 10;    //! Power is default
    hidden var uBottomRightMetric           = 20;    //! Lap power is default
    hidden var uRequiredPower		 		= "000:999";
    hidden var uWarningFreq		 			= 5;
    hidden var uAlertbeep			 		= false;
	hidden var uNoAlerts 					= false;
	hidden var PowerWarning 				= 0;
	hidden var Powerzone					= 0;
	hidden var HRzone						= 0;
    
    hidden var mStartStopPushed             = 0;    //! Timer value when the start/stop button was last pushed

    hidden var mPrevElapsedDistance         = 0;
    hidden var uRacedistance                = 42195;
    hidden var uRacetime					= "03:59:48";
	hidden var mRacetime  					= 0;

    hidden var mLastLapDistMarker           = 0;
    hidden var mLastLapTimeMarker           = 0;
    hidden var mLastLapStoppedTimeMarker    = 0;
    hidden var mLastLapStoppedDistMarker    = 0;
	hidden var mLastLapElapsedDistance      = 0;
    hidden var mLastLapTimerTime            = 0;
    hidden var mLapSpeed 					= 0;
    hidden var mLastLapSpeed 				= 0;
	hidden var mLaps                        = 1;           
	hidden var metric 						= [1, 2, 3, 4, 5, 6, 7,8];
	hidden var pMilClockAltern				= false;
	
    hidden var mElapsedHeartrate   			= 0;
	hidden var mLastLapHeartrateMarker      = 0;    
    hidden var mCurrentHeartrate    		= 0; 
    hidden var mLastLapElapsedHeartrate		= 0;
    hidden var mHeartrateTime				= 0;
    hidden var mLapTimerTimeHR				= 0;    
	hidden var mLastLapTimeHRMarker			= 0;
	hidden var mLastLapTimerTimeHR			= 0;
	hidden var LapHeartrate					= 0;
	hidden var LastLapHeartrate				= 0;
	hidden var AverageHeartrate 			= 0; 
	hidden var mLapElapsedDistance 			= 0;

    function initialize() {
         DataField.initialize();

         var mApp = Application.getApp();
         metric[1]    	= mApp.getProperty("pUpperLeftMetric");
         metric[2]   	= mApp.getProperty("pUpperRightMetric");
    	 metric[3]   	= mApp.getProperty("pMiddleLeftMetric");
    	 metric[4] 		= mApp.getProperty("pMiddleMiddleMetric");    
    	 metric[5]		= mApp.getProperty("pMiddleRightMetric");
         metric[6]   	= mApp.getProperty("pBottomLeftMetric");
         metric[7]  	= mApp.getProperty("pBottomRightMetric");
         uRoundedPace        = mApp.getProperty("pRoundedPace");
         uBacklight          = mApp.getProperty("pBacklight");
         umyNumber			 = mApp.getProperty("myNumber");
         var uCCnumber	     = mApp.getProperty("pCCnumber");
         uShowDemo			 = mApp.getProperty("pShowDemo");
         uMilClockAltern	 = mApp.getProperty("pMilClockAltern");
         uRacedistance		 = mApp.getProperty("pRacedistance");
         uRacetime			 = mApp.getProperty("pRacetime");
         appversion 		 = mApp.getProperty("pAppversion");
		 var uHrZones = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
	 
        if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
            unitP = 1609.344;
        }

        if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
            unitD = 1609.344;
        }

		//! Setting ID's for licensing and testing license
		ID0 = watchType.substring(5, 9);
		ID0 = 511+ID0.toNumber();
		var mHash = hashfunction(WatchID);	
		mHash = (mHash > 0) ? mHash : -mHash;
		ID2 = Math.round(mHash / 315127)+329;
		ID1 = mHash % 315127+1864;
		mtest = ((ID2-329)*315127 + ID1-1864) % 74539;
		mtest = (mtest < 1000) ? mtest + 80000 : mtest;
        
		CCode = hashfunction(umyNumber.toString())+548831;                
		CCode = CCode*hashfunction((uHrZones[2]*uHrZones[4]+uHrZones[1]+uHrZones[3]).toString())-4785;
        CCode = (CCode > 0) ? CCode : -CCode; 
        CCode = CCode % 346898 + 54215;   
        licenseOK = (umyNumber == mtest or CCode == uCCnumber) ? true : false;
    }

    //! Timer transitions from stopped to running state
    function onTimerStart() {
        startStopPushed();
        mTimerRunning = true;
    }


    //! Timer transitions from running to stopped state
    function onTimerStop() {
        startStopPushed();
        mTimerRunning = false;
    }


    //! Timer transitions from paused to running state (i.e. resume from Auto Pause is triggered)
    function onTimerResume() {
        mTimerRunning = true;
    }


    //! Timer transitions from running to paused state (i.e. Auto Pause is triggered)
    function onTimerPause() {
        mTimerRunning = false;
    }

    
    //! Start/stop button was pushed - emulated via timer start/stop
    function startStopPushed() {     
    	var info = Activity.getActivityInfo();   
        var doublePressTimeMs = null;
        if ( mStartStopPushed > 0  &&  info.elapsedTime > 0 ) {
            doublePressTimeMs = info.elapsedTime - mStartStopPushed;
        }
        if ( doublePressTimeMs != null  &&  doublePressTimeMs < 5000 ) {
            uNoAlerts = !uNoAlerts;
        }
        mStartStopPushed = (info.elapsedTime != null) ? info.elapsedTime : 0;
    }
    
    //!! this is called whenever the screen needs to be updated
    function onUpdate(dc) {
        //! Calculate lap (HR) time
		var info = Activity.getActivityInfo();

        mLapTimerTimeHR = mHeartrateTime - mLastLapTimeHRMarker;
        var mLapElapsedHeartrate = mElapsedHeartrate - mLastLapHeartrateMarker;

		AverageHeartrate = Math.round((mHeartrateTime != 0) ? mElapsedHeartrate/mHeartrateTime : 0);  		
		LapHeartrate = (mLapTimerTimeHR != 0) ? Math.round(mLapElapsedHeartrate/mLapTimerTimeHR) : 0; 					
		LapHeartrate = (mLaps == 1) ? AverageHeartrate : LapHeartrate;
		LastLapHeartrate			= (mLastLapTimerTime != 0) ? Math.round(mLastLapElapsedHeartrate/mLastLapTimerTime) : 0;

        //! Calculate lap time
        mLapTimerTime = jTimertime - mLastLapTimeMarker;				

        //! Calculate lap distance
        mLapElapsedDistance = 0.0;
        if (info.elapsedDistance != null) {
            mLapElapsedDistance = info.elapsedDistance - mLastLapDistMarker;
        }
        
		//! Calculate lap speeds
        if (mLapTimerTime > 0 && mLapElapsedDistance > 0) {
            mLapSpeed = mLapElapsedDistance / mLapTimerTime;
        }
        if (mLastLapTimerTime > 0 && mLastLapElapsedDistance > 0) {
            mLastLapSpeed = mLastLapElapsedDistance / mLastLapTimerTime;
        }

		//! Calculate average speed
        var currentSpeedtest				= 0;
        if (info.currentSpeed != null) {
        	currentSpeedtest = info.currentSpeed; 
        }
        if (currentSpeedtest > 0) {
            	//! Calculate average pace
				if (info.currentSpeed != null) {
        		Pace5 								= Pace4;
        		Pace4 								= Pace3;
        		Pace3 								= Pace2;
        		Pace2 								= Pace1;
        		Pace1								= info.currentSpeed; 
        		} else {
					Pace5 								= Pace4;
    	    		Pace4 								= Pace3;
        			Pace3 								= Pace2;
        			Pace2 								= Pace1;
        			Pace1								= 0;
				}
				Averagespeedinmper5sec= (uRoundedPace) ? unitP/(Math.round( (unitP/(Pace1+Pace2+Pace3+Pace4+Pace5)*5) / 5 ) * 5) : (Pace1+Pace2+Pace3+Pace4+Pace5)/5;
				Averagespeedinmper3sec= (uRoundedPace) ? unitP/(Math.round( (unitP/(Pace1+Pace2+Pace3)*3) / 5 ) * 5) : (Pace1+Pace2+Pace3)/3;
				CurrentSpeedinmpersec= (uRoundedPace) ? unitP/(Math.round( unitP/currentSpeedtest / 5 ) * 5) : currentSpeedtest;
		}

		//! Determine required finish time and calculate required pace 	

        var mRacehour = uRacetime.substring(0, 2);
        var mRacemin = uRacetime.substring(3, 5);
        var mRacesec = uRacetime.substring(6, 8);
        mRacehour = mRacehour.toNumber();
        mRacemin = mRacemin.toNumber();
        mRacesec = mRacesec.toNumber();
        mRacetime = mRacehour*3600 + mRacemin*60 + mRacesec;

		//!Fill field metrics
		var i = 0; 
	    for (i = 1; i < 8; ++i) {	    
        	if (metric[i] == 0) {
            	fieldValue[i] = (info.timerTime != null) ? info.timerTime / 1000 : 0;
            	fieldLabel[i] = "Timer";
            	fieldFormat[i] = "time";   
	        } else if (metric[i] == 1) {
    	        fieldValue[i] = mLapTimerTime;
        	    fieldLabel[i] = "Lap T";
            	fieldFormat[i] = "time";
			} else if (metric[i] == 2) {
    	        fieldValue[i] = mLastLapTimerTime;
        	    fieldLabel[i] = "L-1LapT";
            	fieldFormat[i] = "time";
			} else if (metric[i] == 3) {
        	    fieldValue[i] = (info.timerTime != null) ? info.timerTime / (mLaps * 1000) : 0;
            	fieldLabel[i] = "AvgLapT";
            	fieldFormat[i] = "time";
	        } else if (metric[i] == 4) {
    	        fieldValue[i] = (info.elapsedDistance != null) ? info.elapsedDistance / unitD : 0;
        	    fieldLabel[i] = "Distance";
            	fieldFormat[i] = "2decimal";   
	        } else if (metric[i] == 5) {
    	        fieldValue[i] = mLapElapsedDistance/unitD;
        	    fieldLabel[i] = "Lap D";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 6) {
    	        fieldValue[i] = mLastLapElapsedDistance/unitD;
        	    fieldLabel[i] = "L-1LapD";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 7) {
	            fieldValue[i] = (info.elapsedDistance != null) ? info.elapsedDistance / (mLaps * unitD) : 0;
    	        fieldLabel[i] = "AvgLapD";
        	    fieldFormat[i] = "2decimal";
	        } else if (metric[i] == 8) {
   	        	fieldValue[i] = CurrentSpeedinmpersec;
        	    fieldLabel[i] = "Pace";
            	fieldFormat[i] = "pace";   
	        } else if (metric[i] == 9) {
    	        fieldValue[i] = Averagespeedinmper5sec; 
        	    fieldLabel[i] = "Pace 5s";
            	fieldFormat[i] = "pace";
	        } else if (metric[i] == 16) {
    	        fieldValue[i] = Averagespeedinmper3sec; 
        	    fieldLabel[i] = "Pace 3s";
            	fieldFormat[i] = "pace";
	        } else if (metric[i] == 10) {
    	        fieldValue[i] = mLapSpeed;
        	    fieldLabel[i] = "L Pace";
            	fieldFormat[i] = "pace";
			} else if (metric[i] == 11) {
    	        fieldValue[i] = mLastLapSpeed;
        	    fieldLabel[i] = "LL Pace";
            	fieldFormat[i] = "pace";
			} else if (metric[i] == 12) {
	            fieldValue[i] = (info.averageSpeed != null) ? info.averageSpeed : 0;
    	        fieldLabel[i] = "AvgPace";
        	    fieldFormat[i] = "pace";
            } else if (metric[i] == 13) {
        		fieldLabel[i]  = "Req pace ";
        		fieldFormat[i] = "pace";
        		if (info.elapsedDistance != null and info.timerTime != null and mRacetime != info.timerTime/1000 and mRacetime > info.timerTime/1000) {
        			fieldValue[i] = (uRacedistance - info.elapsedDistance) / (mRacetime - info.timerTime/1000);
        		} 
	        } else if (metric[i] == 40) {
    	        fieldValue[i] = (info.currentSpeed != null) ? 3.6*info.currentSpeed*1000/unitP : 0;
        	    fieldLabel[i] = "Speed";
            	fieldFormat[i] = "2decimal";   
	        } else if (metric[i] == 41) {
    	        fieldValue[i] = (info.currentSpeed != null) ? 3.6*((Pace1+Pace2+Pace3+Pace4+Pace5)/5)*1000/unitP : 0;
        	    fieldLabel[i] = "Spd 5s";
            	fieldFormat[i] = "2decimal";
	        } else if (metric[i] == 42) {
    	        fieldValue[i] = (mLapSpeed != null) ? 3.6*mLapSpeed*1000/unitP  : 0;
        	    fieldLabel[i] = "L Spd";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 43) {
    	        fieldValue[i] = (mLastLapSpeed != null) ? 3.6*mLastLapSpeed*1000/unitP : 0;
        	    fieldLabel[i] = "LL Spd";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 44) {
	            fieldValue[i] = (info.averageSpeed != null) ? 3.6*info.averageSpeed*1000/unitP : 0;
    	        fieldLabel[i] = "Avg Spd";
        	    fieldFormat[i] = "2decimal";
			} else if (metric[i] == 47) {
    	        fieldValue[i] = LapHeartrate;
        	    fieldLabel[i] = "Lap HR";
            	fieldFormat[i] = "0decimal";
			} else if (metric[i] == 48) {
    	        fieldValue[i] = LastLapHeartrate;
        	    fieldLabel[i] = "LL HR";
            	fieldFormat[i] = "0decimal";
			} else if (metric[i] == 49) {
	            fieldValue[i] = AverageHeartrate;
    	        fieldLabel[i] = "Avg HR";
        	    fieldFormat[i] = "0decimal";
			} else if (metric[i] == 50) {
				fieldValue[i] = (info.currentCadence != null) ? info.currentCadence : 0; 
    	        fieldLabel[i] = "Cadence";
        	    fieldFormat[i] = "0decimal";
			} else if (metric[i] == 51) {
		  		fieldValue[i] = (info.altitude != null) ? Math.round(info.altitude).toNumber() : 0;
		       	fieldLabel[i] = "Altitude";
		       	fieldFormat[i] = "0decimal";        		
        	} else if (metric[i] == 45) {
    	        fieldValue[i] = (info.currentHeartRate != null) ? info.currentHeartRate : 0;
        	    fieldLabel[i] = "HR";
            	fieldFormat[i] = "0decimal";

			}
		//!einde invullen field metrics
		
	  }
    }
	function hashfunction(string) {
    	var val = 0;
    	var bytes = string.toUtf8Array();
    	for (var i = 0; i < bytes.size(); ++i) {
        	val = (val * 997) + bytes[i];
    	}
    	return val + (val >> 5);
	}    

    function Formatting(dc,counter,fieldvalue,fieldformat,fieldlabel,CorString) {    
        var originalFontcolor = mColourFont;
        var Temp; 
        var x = CorString.substring(0, 3);
        var y = CorString.substring(4, 7);
        var xms = CorString.substring(8, 11);
        var xh = CorString.substring(12, 15);
        var yh = CorString.substring(16, 19);
        var xl = CorString.substring(20, 23);
		var yl = CorString.substring(24, 27);                  
        x = x.toNumber();
        y = y.toNumber();
        xms = xms.toNumber();
        xh = xh.toNumber();        
        yh = yh.toNumber();
        xl = xl.toNumber();
        yl = yl.toNumber();

		fieldvalue = (metric[counter]==38) ? Powerzone : fieldvalue; 
		fieldvalue = (metric[counter]==46) ? HRzone : fieldvalue;
        if ( fieldformat.equals("0decimal" ) == true ) {
        	fieldvalue = Math.round(fieldvalue);
        } else if ( fieldformat.equals("1decimal" ) == true ) {
            Temp = Math.round(fieldvalue*10)/10;
        	fieldvalue = Temp.format("%.1f");
        } else if ( fieldformat.equals("2decimal" ) == true ) {
            Temp = Math.round(fieldvalue*100)/100;
            var fString = "%.2f";
         	if (Temp > 10) {
             	fString = "%.1f";
            }           
        	fieldvalue = Temp.format(fString);        	
        } else if ( fieldformat.equals("pace" ) == true ) {
        	Temp = (fieldvalue != 0 ) ? (unitP/fieldvalue).toLong() : 0;
        	fieldvalue = (Temp / 60).format("%0d") + ":" + Math.round(Temp % 60).format("%02d");
        } else if ( fieldformat.equals("power" ) == true ) {     
        	fieldvalue = Math.round(fieldvalue);       	
        	if (PowerWarning == 1) { 
        		mColourFont = Graphics.COLOR_PURPLE;
        	} else if (PowerWarning == 2) { 
        		mColourFont = Graphics.COLOR_RED;
        	} else if (PowerWarning == 0) { 
        		mColourFont = originalFontcolor;
        	}
        } else if ( fieldformat.equals("timeshort" ) == true  ) {
        	Temp = (fieldvalue != 0 ) ? (fieldvalue).toLong() : 0;
        	fieldvalue = (Temp /60000 % 60).format("%02d") + ":" + (Temp /1000 % 60).format("%02d");
        }

    	dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
    	
        if ( fieldformat.equals("time" ) == true ) {    
	    	if ( counter == 1 or counter == 2 or counter == 6 or counter == 7 ) {  
	    		var fTimerSecs = (fieldvalue % 60).format("%02d");
        		var fTimer = (fieldvalue / 60).format("%d") + ":" + fTimerSecs;  //! Format time as m:ss
	    		var xx = x;
	    		//! (Re-)format time as h:mm(ss) if more than an hour
	    		if (fieldvalue > 3599) {
            		var fTimerHours = (fieldvalue / 3600).format("%d");
            		xx = xms;
            		dc.drawText(xh, yh, Graphics.FONT_NUMBER_MILD, fTimerHours, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            		fTimer = (fieldvalue / 60 % 60).format("%02d") + ":" + fTimerSecs;  
        		}
        		dc.drawText(xx, y, Graphics.FONT_NUMBER_MEDIUM, fTimer, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);	
        	}
        } else {
        	dc.drawText(x, y, Graphics.FONT_NUMBER_MEDIUM, fieldvalue, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }        
        dc.drawText(xl, yl, Graphics.FONT_XTINY,  fieldlabel, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);               
        mColourFont = originalFontcolor;
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
    }

}
