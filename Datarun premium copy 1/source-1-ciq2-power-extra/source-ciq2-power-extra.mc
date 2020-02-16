using Toybox.Math;
using Toybox.WatchUi as Ui;
class CiqView extends ExtramemView {  
	var mfillColour 						= Graphics.COLOR_LT_GRAY;
	var counterPower 						= 0;
	var rollingPwrValue 					= new [303];
	var totalRPw 							= 0;
	var rolavPowmaxsecs 					= 30;
	var Averagepowerpersec 					= 0;
	var uBlackBackground 					= false;
	var uFTP								= 250;    
	var uCP									= 250;
	var RSS									= 0;
	hidden var FilteredCurPower				= 0;
	var sum4thPowers						= 0;
	var fourthPowercounter 					= 0;
	var mIntensityFactor					= 0;
	var mTTS								= 0;
	var uWorkoutType						= 0;
	var uWorkoutzones						= "0300t100-190;0800d240-260;0100d100-190;0800d260-280;0100d100-190;0800d280-300;0100d100-190;0800d300-320;0100d100-190;0800d320-340;0100d100-190;0800d300-320;0100d100-190;0800d280-300;0100d100-190;0800d260-280;0100d100-190;0300t100-190";
	var mWorkoutAmount						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
	var mWorkoutType						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
	var mWorkoutLzone						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
	var mWorkoutHzone						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
	var mWorkoutstepNumber					= 1;
	var oldmWorkoutstepNumber					= 1;
	var nextAlertD							= 0;
	var nextAlertT							= 0;
	var oldnextAlertD						= 0;
	var oldnextAlertT						= 0;
	var oldnextAlertType					= "t";
	var nextAlertType						= "t";
	var workoutUnit							= "sec";
	var i 									= 0;
	var hideText 							= false;
	var jDistance 							= 0;
	var runPower							= 0;
	var lastsrunPower						= 0;
	var sethideText 						= false;
	var setPowerWarning 					= 0;
	var k									= 0;
	var TimeToNextStep						= 0;
	var DistanceToNextStep					= 0;
	var PowerTargetThisStep					= 0;
	var TheEnd 								= false;
	hidden var hideDiv 						= false;
	var Temp; 
	var fieldvalue;
	var WU;
	hidden var uLapPwr4alerts 				= false;
	var Garminfont = Ui.loadResource(Rez.Fonts.Garmin1);
	var Power1 									= 0;
    var Power2 									= 0;
    var Power3 									= 0;	
	var Power4 									= 0;
    var Power5 									= 0;
    var Power6 									= 0;
	var Power7 									= 0;
    var Power8 									= 0;
    var Power9 									= 0;
    var Power10									= 0;
    var uWeight									= 70;
    var redTextwidthDisplay						=120;
	var redTextheightDisplay					=135;
		
    function initialize() {
        ExtramemView.initialize();
		var mApp 		 = Application.getApp();
		rolavPowmaxsecs	 = mApp.getProperty("prolavPowmaxsecs");	
		uPowerZones		 = mApp.getProperty("pPowerZones");	
		PalPowerzones 	 = mApp.getProperty("p10Powerzones");
		uPower10Zones	 = mApp.getProperty("pPPPowerZones");
		uFTP		 	 = mApp.getProperty("pFTP");
		uCP		 	 	 = mApp.getProperty("pCP");
		uWorkoutType	 = mApp.getProperty("pWorkoutType");
		uWorkoutzones	 = mApp.getProperty("pWorkoutzones");
		uLapPwr4alerts    = mApp.getProperty("pLapPwr4alerts");
		i = 0; 
	    for (i = 1; i < 8; ++i) {		
			if (metric[i] == 57 or metric[i] == 58 or metric[i] == 59) {
				rolavPowmaxsecs = (rolavPowmaxsecs < 30) ? 30 : rolavPowmaxsecs;
			}
		}		
		
		if (ID0 == 3588 or ID0 == 3832 or ID0 == 3624 or ID0 == 3952 or ID0 == 3762 or ID0 == 3962 or ID0 == 3761 or ID0 == 3961 or ID0 == 3757 or ID0 == 3931 or ID0 == 3758 or ID0 == 3932 or ID0 == 3759 or ID0 == 3959 or ID0 == 3798 or ID0 == 4023 or ID0 == 3799 or ID0 == 4024) {
			Garminfont = Ui.loadResource(Rez.Fonts.Garmin1);		
		} else if (ID0 == 3801 or ID0 == 4026 ) {
			Garminfont = Ui.loadResource(Rez.Fonts.Garmin2);
		} else if (ID0 == 3802 or ID0 == 4027 ) {
			Garminfont = Ui.loadResource(Rez.Fonts.Garmin3);
		}

		if (ID0 == 3801 or ID0 == 4026 ) {  //! Fenix 6 pro red notification text geometrie
			redTextwidthDisplay=130;
			redTextheightDisplay=146;
		} else if (ID0 == 3802 or ID0 == 4027 ) {     //! Fenix 6x pro red notification text geometrie
			redTextwidthDisplay=140;
			redTextheightDisplay=158;
		}
				
		//!Workout variables setup
		if (uWorkoutType == 2) { 			//! Set up powerbased workout with timers
			i = 0; 
	    	for (i = 1; i < 19; ++i) {			
		    	mWorkoutAmount[i]	= uWorkoutzones.substring(0+(i-1)*13, 4+(i-1)*13);		    	
		    	mWorkoutType[i]		= uWorkoutzones.substring(4+(i-1)*13, 5+(i-1)*13);		    	
				mWorkoutLzone[i]	= uWorkoutzones.substring(5+(i-1)*13, 8+(i-1)*13);				
				mWorkoutHzone[i]	= uWorkoutzones.substring(9+(i-1)*13, 12+(i-1)*13);
			}		
		}			
    }

    //! Calculations we need to do every second even when the data field is not visible
    function compute(info) {
        //! If enabled, switch the backlight on in order to make it stay on
        if (uBacklight) {
             Attention.backlight(true);
        }
		//! We only do some calculations if the timer is running
		if (mTimerRunning) {  
			jTimertime 		 = jTimertime + 1;
			//!Calculate lapheartrate
            mHeartrateTime	 = (info.currentHeartRate != null) ? mHeartrateTime+1 : mHeartrateTime;				
           	mElapsedHeartrate= (info.currentHeartRate != null) ? mElapsedHeartrate + info.currentHeartRate : mElapsedHeartrate;
            //!Calculate lappower
            mPowerTime		 = (info.currentPower != null) ? mPowerTime+1 : mPowerTime;
            runPower 		 = (info.currentPower != null) ? info.currentPower : 0;
		 	if ( uLapPwr4alerts == true ) {
		    	runalertPower 	 = LapPower;
		    } else {
		    	runalertPower 	 = runPower;
		    }
			mElapsedPower    = mElapsedPower + runPower;
			lastsrunPower 	 = runPower;
			RSS 			 = (info.currentPower != null) ? RSS + 0.03 * Math.pow(((runPower+0.001)/uCP),3.5) : RSS; 			             
        }

		//!Setup workout notifcations
		sethideText = false;
		var vibrateData = [
			new Attention.VibeProfile( 100, 100 )
		    ];
		oldnextAlertD = nextAlertD;
		oldnextAlertT = nextAlertT;
		oldnextAlertType = nextAlertType;
		oldmWorkoutstepNumber = mWorkoutstepNumber;
		if (uWorkoutType == 2) {
			if (jTimertime == 0) {  //! Activity not yet started
				mWorkoutstepNumber = 1;
				if (mWorkoutType[1].equals("t")) {	
					nextAlertT = jTimertime + mWorkoutAmount[mWorkoutstepNumber].toNumber();
					nextAlertType = "t";
					TimeToNextStep = 1000*mWorkoutAmount[mWorkoutstepNumber].toNumber();
				} else if (mWorkoutType[1].equals("d")) {	
					nextAlertD = jDistance + mWorkoutAmount[mWorkoutstepNumber].toNumber();
					nextAlertType = "d";
					DistanceToNextStep = mWorkoutAmount[mWorkoutstepNumber].toNumber();
				}
				PowerTargetThisStep = Math.round((mWorkoutLzone[mWorkoutstepNumber].toNumber() + mWorkoutHzone[mWorkoutstepNumber].toNumber())/2).toNumber();
				
			} else if (jTimertime > 0){  //! timer is running
				setPowerWarning = 0;
				//! Executing alerts
				if (mWorkoutstepNumber < 18) {
				  if (runalertPower > mWorkoutHzone[mWorkoutstepNumber].toNumber() or runalertPower < mWorkoutLzone[mWorkoutstepNumber].toNumber()) {		 
					 if (Toybox.Attention has :vibrate && uNoAlerts == false) {
					 	vibrateseconds = vibrateseconds + 1;	 		  			
    					if (runalertPower>mWorkoutHzone[mWorkoutstepNumber].toNumber()) {
    						setPowerWarning = 1;
    						if (vibrateseconds == uWarningFreq) {
    							Toybox.Attention.vibrate(vibrateData);
    							if (uAlertbeep == true) {
    								Attention.playTone(Attention.TONE_ALERT_HI);
		    					}
    							vibrateseconds = 0;
    						}
    					} else if (runalertPower<mWorkoutLzone[mWorkoutstepNumber].toNumber()){
    						setPowerWarning = 2;
    						if (vibrateseconds == uWarningFreq) {
    							if (uAlertbeep == true) {
    								Attention.playTone(Attention.TONE_ALERT_LO);
	    						}
    						Toybox.Attention.vibrate(vibrateData);
    						vibrateseconds = 0;
	    					}
    					} 
					 }
				  } 
				}		

				if (CurrentSpeedinmpersec != 0) {
					TimeToNextStep = (mWorkoutType[mWorkoutstepNumber].equals("t")) ? (nextAlertT-jTimertime)*1000 : Math.round((nextAlertD-jDistance)/CurrentSpeedinmpersec).toNumber()*1000;
				} else {
					TimeToNextStep = 0;
				}
				DistanceToNextStep = (mWorkoutType[mWorkoutstepNumber].equals("t")) ? (nextAlertT-jTimertime)*CurrentSpeedinmpersec : (nextAlertD-jDistance);
				PowerTargetThisStep = Math.round((mWorkoutLzone[mWorkoutstepNumber].toNumber() + mWorkoutHzone[mWorkoutstepNumber].toNumber())/2).toNumber();
				TimeToNextStep = (TheEnd == true ) ? 0 : TimeToNextStep; 
				DistanceToNextStep = (TheEnd == true ) ? 0 : DistanceToNextStep; 
				PowerTargetThisStep = (TheEnd == true ) ? 0 : PowerTargetThisStep; 
				
				workoutUnit = (mWorkoutType[mWorkoutstepNumber+1].equals("t")) ? "sec" : "met";
				if (mWorkoutAmount[mWorkoutstepNumber+1].equals("0000") == false) {
					mWorkoutstepNumber = mWorkoutstepNumber;
				} else {
					if (TimeToNextStep < 2) {
						mWorkoutstepNumber = 18;
					}
				}
				if (nextAlertType.equals("t")) {
					if (nextAlertT > jTimertime+5 and nextAlertT < jTimertime+10) {      //! Notification nearing the end of a time-based step 	
					  if (mWorkoutstepNumber < 18) {				
						Toybox.Attention.vibrate(vibrateData);
						Attention.playTone(Attention.TONE_ALERT_LO);
						Attention.playTone(Attention.TONE_ALERT_HI);
					  } else if (mWorkoutstepNumber == 18) {				
						Toybox.Attention.vibrate(vibrateData);
						Attention.playTone(Attention.TONE_ALERT_LO);
						Attention.playTone(Attention.TONE_ALERT_HI);
					  }
					}
				}			
				if (nextAlertType.equals("d")) {
					if (nextAlertD > jDistance+5*CurrentSpeedinmpersec and nextAlertD < jDistance+10*CurrentSpeedinmpersec) {       //! Notification nearing the end of a distance-based step
					  if (mWorkoutstepNumber < 18) {				
						Toybox.Attention.vibrate(vibrateData);
						Attention.playTone(Attention.TONE_ALERT_LO);
						Attention.playTone(Attention.TONE_ALERT_HI);
					  } else if (mWorkoutstepNumber == 18){				
						Toybox.Attention.vibrate(vibrateData);
						Attention.playTone(Attention.TONE_ALERT_LO);
						Attention.playTone(Attention.TONE_ALERT_HI);
					  }
					}
				 
				}		
				if (jTimertime == nextAlertT and nextAlertType.equals("t")) {			//! Setting up next alert at the end of a time-based step
						onTimerLap();
						if (mWorkoutstepNumber < 18) {
							mWorkoutstepNumber = mWorkoutstepNumber + 1;
						  if (mWorkoutType[mWorkoutstepNumber].equals("t")) { 	//! setting up next time-based alert       
							nextAlertT = jTimertime + mWorkoutAmount[mWorkoutstepNumber].toNumber();
							nextAlertType = "t";				
						  } else if (mWorkoutType[mWorkoutstepNumber].equals("d")) {		//! setting up next distance-based alert							
							nextAlertD = jDistance + mWorkoutAmount[mWorkoutstepNumber].toNumber();
							nextAlertType = "d";
						  }
						}
				}
				if ( jDistance > nextAlertD and nextAlertType.equals("d")) {			//! Setting up next alert at the end of a distance-based step			 
					if (nextAlertD < jDistance + CurrentSpeedinmpersec) {
						onTimerLap();
						if (mWorkoutstepNumber < 18) {
							mWorkoutstepNumber = mWorkoutstepNumber + 1;
						  if (mWorkoutType[mWorkoutstepNumber].equals("t")) { 	//! setting up time-based next alert       							
							nextAlertT = jTimertime + mWorkoutAmount[mWorkoutstepNumber].toNumber();
							nextAlertType = "t";	
						  } else if (mWorkoutType[mWorkoutstepNumber].equals("d")) {	//! setting up next distance-based alert
							nextAlertD = jDistance + mWorkoutAmount[mWorkoutstepNumber].toNumber();
							nextAlertType = "d";
						  }
						}
					}  
				}
			}			
		}



	}

    //! Store last lap quantities and set lap markers after a lap
    function onTimerLap() {
        if (NoLapEffect == false) {
	        var info = Activity.getActivityInfo();
    	    mLastLapTimerTime       	= jTimertime - mLastLapTimeMarker;
        	mLastLapElapsedDistance 	= (info.elapsedDistance != null) ? info.elapsedDistance - mLastLapDistMarker : 0;
	        mLastLapDistMarker      	= (info.elapsedDistance != null) ? info.elapsedDistance : 0;
    	    mLastLapTimeMarker      	= jTimertime;
	
	        mLastLapTimerTimeHR			= mHeartrateTime - mLastLapTimeHRMarker;
    	    mLastLapElapsedHeartrate 	= (info.currentHeartRate != null) ? mElapsedHeartrate - mLastLapHeartrateMarker : 0;
        	mLastLapHeartrateMarker     = mElapsedHeartrate;
	        mLastLapTimeHRMarker        = mHeartrateTime;

    	    mLastLapTimerTimePwr		= mPowerTime - mLastLapTimePwrMarker;
        	mLastLapElapsedPower  		= (info.currentPower != null) ? mElapsedPower - mLastLapPowerMarker : 0;
	        mLastLapPowerMarker         = mElapsedPower;
    	    mLastLapTimePwrMarker       = mPowerTime;        

	        mLaps++;
	    }
	}


	 //!Store last lap quantities and set lap markers after a step within a structured workout
	 function onWorkoutStepComplete() {
        var info = Activity.getActivityInfo();
        mLastLapTimerTime       	= jTimertime - mLastLapTimeMarker;
        mLastLapElapsedDistance 	= (info.elapsedDistance != null) ? info.elapsedDistance - mLastLapDistMarker : 0;
        mLastLapDistMarker      	= (info.elapsedDistance != null) ? info.elapsedDistance : 0;
        mLastLapTimeMarker      	= jTimertime;

        mLastLapTimerTimeHR			= mHeartrateTime - mLastLapTimeHRMarker;
        mLastLapElapsedHeartrate 	= (info.currentHeartRate != null) ? mElapsedHeartrate - mLastLapHeartrateMarker : 0;
        mLastLapHeartrateMarker     = mElapsedHeartrate;
        mLastLapTimeHRMarker        = mHeartrateTime;

        mLastLapTimerTimePwr		= mPowerTime - mLastLapTimePwrMarker;
        mLastLapElapsedPower  		= (info.currentPower != null) ? mElapsedPower - mLastLapPowerMarker : 0;
        mLastLapPowerMarker         = mElapsedPower;
        mLastLapTimePwrMarker       = mPowerTime;        

        mLaps++;
	 }

	function onUpdate(dc) {
		//! call the parent onUpdate to do the base logic
		ExtramemView.onUpdate(dc);
        		
		//!Calculate HR-metrics
		var info = Activity.getActivityInfo();

		jDistance = (info.elapsedDistance != null) ? info.elapsedDistance : 0;
		
		var CurrentEfficiencyIndex   	= (info.currentPower != null && info.currentPower != 0) ? Averagespeedinmper3sec*60/info.currentPower : 0;
		var AverageEfficiencyIndex   	= (info.averageSpeed != null && AveragePower != 0) ? info.averageSpeed*60/AveragePower : 0;
		var LapEfficiencyIndex   		= (LapPower != 0) ? mLapSpeed*60/LapPower : 0;  
		var LastLapEfficiencyIndex   	= (LastLapPower != 0) ? mLastLapSpeed*60/LastLapPower : 0;  

		var CurrentPower2HRRatio 		= 0.00; 				
		if (info.currentPower != null && info.currentHeartRate != null && info.currentHeartRate != 0) {
			CurrentPower2HRRatio 		= (0.00001 + info.currentPower)/info.currentHeartRate;
		}
		var AveragePower2HRRatio 		= 0.00;
		if (AverageHeartrate != 0) {
			AveragePower2HRRatio 		= (AveragePower+0.00001)/AverageHeartrate;
		}
		var LapPower2HRRatio 			= 0.00;
		if (LapHeartrate != 0) {
			LapPower2HRRatio 			= (0.00001 + LapPower) / LapHeartrate;
		}
		var LastLapPower2HRRatio 		= 0.00;
		if (LastLapHeartrate != 0) {
			LastLapPower2HRRatio 		= (0.00001 + LastLapPower) / LastLapHeartrate;
		}			
		
		//!Calculate 5 and 10sec averaged power
        var AveragePower5sec  	 			= 0;
        var AveragePower10sec  	 			= 0;
        var currentPowertest				= 0;
		if (info.currentSpeed != null && info.currentPower != null) {
        	currentPowertest = info.currentPower; 
        }
        if (currentPowertest > 0) {
            if (currentPowertest > 0) {
				if (info.currentPower != null) {
        			Power1								= info.currentPower; 
        		} else {
        			Power1								= 0;
				}
        		Power10 							= Power9;
        		Power9 								= Power8;
        		Power8 								= Power7;
        		Power7 								= Power6;
        		Power6 								= Power5;
        		Power5 								= Power4;
        		Power4 								= Power3;
        		Power3 								= Power2;
        		Power2 								= Power1;
				AveragePower10sec= (Power1+Power2+Power3+Power4+Power5+Power6+Power7+Power8+Power9+Power10)/10;
				AveragePower5sec= (Power1+Power2+Power3+Power4+Power5)/5;
				AveragePower3sec	= (Power1+Power2+Power3)/3;
			}
 		}
 		
		//! Calculation of rolling average of power 
		var zeroValueSecs = 0;
		if (counterPower < 1) {
			for (var i = 1; i < rolavPowmaxsecs+2; ++i) {
				rollingPwrValue [i] = 0; 
			}
		}
		counterPower = counterPower + 1;
		rollingPwrValue [rolavPowmaxsecs+1] = (info.currentPower != null) ? info.currentPower : 0;
		FilteredCurPower = rollingPwrValue [rolavPowmaxsecs+1]; 
		for (var i = 1; i < rolavPowmaxsecs+1; ++i) {
			rollingPwrValue[i] = rollingPwrValue[i+1];
		}
		for (var i = 1; i < rolavPowmaxsecs+1; ++i) {
			totalRPw = rollingPwrValue[i] + totalRPw;
		
			if (mPowerTime < rolavPowmaxsecs) {
				zeroValueSecs = (rollingPwrValue[i] != 0) ? zeroValueSecs : zeroValueSecs + 1;
			}
		}
		if (rolavPowmaxsecs-zeroValueSecs == 0) {
			Averagepowerpersec = 0;
		} else {
			Averagepowerpersec = (mPowerTime < rolavPowmaxsecs) ? totalRPw/(rolavPowmaxsecs-zeroValueSecs) : totalRPw/rolavPowmaxsecs;
		}
		totalRPw = 0;       

		//!Calculate normalized power
		var mNormalizedPow = 0;
		var rollingPwr30s = 0;
		var j = 0; 		
	    for (j = 1; j < 8; ++j) {
			if (metric[j] == 57 or metric[j] == 58 or metric[j] == 59) {

				if (jTimertime > 30) {
					for (var i = 1; i < 31; ++i) {
						rollingPwr30s = rollingPwr30s + rollingPwrValue [rolavPowmaxsecs+2-i];
					}
					rollingPwr30s = rollingPwr30s/30;
					if (mTimerRunning == true) {
						sum4thPowers = sum4thPowers + Math.pow(rollingPwr30s,4);
						fourthPowercounter = fourthPowercounter + 1; 
					}
				mNormalizedPow = Math.round(Math.pow(sum4thPowers/fourthPowercounter,0.25));				
				}
			}
		}		


		//! Calculate IF and TTS
		mIntensityFactor = (uFTP != 0) ? mNormalizedPow / uFTP : 0;
		mTTS = (uFTP != 0) ? (jTimertime * mNormalizedPow * mIntensityFactor)/(uFTP * 3600) * 100 : 999;
		
		hideDiv = false;	
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		if (uWorkoutType == 2) {
			if (jTimertime == 0) {  //! Activity not yet started
				hideDiv = true;	
    	    	Temp = (mWorkoutAmount[mWorkoutstepNumber].toNumber() != 0 ) ? (mWorkoutAmount[mWorkoutstepNumber].toNumber()).toLong() : 0;
        		fieldvalue =(Temp /3600 % 60).format("%02d") + ":" +  (Temp /60 % 60).format("%02d") + ":" + (Temp % 60).format("%02d");			
				if (mWorkoutType[1].equals("t")) {
					dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  fieldvalue + " @ " + mWorkoutLzone[mWorkoutstepNumber].toNumber() + "-" + mWorkoutHzone[mWorkoutstepNumber].toNumber() , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);	
				} else if (mWorkoutType[1].equals("d")) {
					dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  mWorkoutAmount[mWorkoutstepNumber].toNumber() + " met @ " + mWorkoutLzone[mWorkoutstepNumber].toNumber() + "-" + mWorkoutHzone[mWorkoutstepNumber].toNumber() , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);	
				}
			} else if (jTimertime > 0){ 		
				if (oldnextAlertType.equals("t")) {
					if (oldnextAlertT > jTimertime+5 and oldnextAlertT < jTimertime+10) {      //! Notification nearing the end of a time-based step 		 	
					  if (oldmWorkoutstepNumber < 18) {
					    hideDiv = true;	
					    if ( workoutUnit.equals("sec")) {
		    	    		Temp = (mWorkoutAmount[mWorkoutstepNumber+1].toNumber() != 0 ) ? (mWorkoutAmount[mWorkoutstepNumber+1].toNumber()).toLong() : 0;
        					fieldvalue =(Temp /3600 % 60).format("%02d") + ":" +  (Temp /60 % 60).format("%02d") + ":" + (Temp % 60).format("%02d");
        					WU = "";
        				} else {
        					fieldvalue = mWorkoutAmount[oldmWorkoutstepNumber+1].toNumber();
        					WU = " " + workoutUnit;
        				}
						dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  fieldvalue + WU + " @ " + mWorkoutLzone[oldmWorkoutstepNumber+1].toNumber() + "-" + mWorkoutHzone[oldmWorkoutstepNumber+1].toNumber() , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);				
					  } else if (oldmWorkoutstepNumber == 18) {
					    hideDiv = true;	
					    dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  "Ending" , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);				
					  }
					}
				}			
				if (nextAlertType.equals("d")) {
					if (oldnextAlertD > jDistance+5*CurrentSpeedinmpersec and oldnextAlertD < jDistance+10*CurrentSpeedinmpersec) {       //! Notification nearing the end of a distance-based step 
					  if (oldmWorkoutstepNumber < 18) {
						hideDiv = true;	
					    if ( workoutUnit.equals("sec")) {
		    	    		Temp = (mWorkoutAmount[mWorkoutstepNumber+1].toNumber() != 0 ) ? (mWorkoutAmount[mWorkoutstepNumber+1].toNumber()).toLong() : 0;
        					fieldvalue =(Temp /3600 % 60).format("%02d") + ":" +  (Temp /60 % 60).format("%02d") + ":" + (Temp % 60).format("%02d");
        					WU = "";
        				} else {
        					fieldvalue = mWorkoutAmount[oldmWorkoutstepNumber+1].toNumber();
        					WU = " " + workoutUnit;
        				}
						dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  fieldvalue + WU + " @ " + mWorkoutLzone[oldmWorkoutstepNumber+1].toNumber() + "-" + mWorkoutHzone[oldmWorkoutstepNumber+1].toNumber() , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
					  } else if (oldmWorkoutstepNumber == 18){
					    hideDiv = true;	
					    dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  "Ending" , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);				
					  }
					}
				}	
				if (jTimertime == oldnextAlertT and nextAlertType.equals("t")) {			//! Setting up next alert at the end of a time-based step
						Workoutstepalert(dc);
						onWorkoutStepComplete();
				}
				if ( jDistance > oldnextAlertD and nextAlertType.equals("d")) {			//! Setting up next alert at the end of a distance-based step			 
					if (oldnextAlertD < jDistance + CurrentSpeedinmpersec) {
						Workoutstepalert(dc);
						onWorkoutStepComplete();
					}  
				}		
			}			
		}
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
		
		var Actualpower = (info.currentPower != null) ? info.currentPower : 0;

		i = 0; 
	    for (i = 1; i < 8; ++i) {
	        if (metric[i] == 38) {
    	        fieldValue[i] =  (info.currentPower != null) ? info.currentPower : 0;     	        
            	fieldLabel[i] = "Cur Pzone";
            	fieldFormat[i] = "1decimal";
            } else if (metric[i] == 99) {
    	        fieldValue[i] =  AveragePower3sec;     	        
        	    fieldLabel[i] = "3s P zone";
            	fieldFormat[i] = "1decimal";
            } else if (metric[i] == 100) {
    	        fieldValue[i] =  AveragePower5sec;     	        
        	    fieldLabel[i] = "5s P zone";
            	fieldFormat[i] = "1decimal"; 
            } else if (metric[i] == 101) {
    	        fieldValue[i] =  AveragePower10sec;     	        
        	    fieldLabel[i] = "10s P zone";
            	fieldFormat[i] = "1decimal";  
            } else if (metric[i] == 102) {
    	        fieldValue[i] =  LapPower;     	        
        	    fieldLabel[i] = "Lap Pzone";
            	fieldFormat[i] = "1decimal";  
            } else if (metric[i] == 103) {
    	        fieldValue[i] =  LastLapPower;     	        
        	    fieldLabel[i] = "LL Pzone";
            	fieldFormat[i] = "1decimal";
            } else if (metric[i] == 104) {
    	        fieldValue[i] =  AveragePower;     	        
        	    fieldLabel[i] = "Av Pzone";            	
			} else if (metric[i] == 17) {
	            fieldValue[i] = Averagespeedinmpersec;
    	        fieldLabel[i] = "Pc ..sec";
        	    fieldFormat[i] = "pace";            	
			} else if (metric[i] == 55) {   
            	fieldValue[i] = (info.currentSpeed != null or info.currentSpeed!=0) ? 100/info.currentSpeed : 0;
            	fieldLabel[i] = "s/100m";
        	    fieldFormat[i] = "2decimal";
        	} else if (metric[i] == 25) {
    	        fieldValue[i] = LapEfficiencyIndex;
        	    fieldLabel[i] = "Lap EI";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 26) {
    	        fieldValue[i] = LastLapEfficiencyIndex;
        	    fieldLabel[i] = "LL EI";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 27) {
	            fieldValue[i] = AverageEfficiencyIndex;
    	        fieldLabel[i] = "Avg EI";
        	    fieldFormat[i] = "2decimal";
			} else if (metric[i] == 31) {
	            fieldValue[i] = CurrentEfficiencyIndex;
    	        fieldLabel[i] = "Cur EI";
        	    fieldFormat[i] = "2decimal";
	        } else if (metric[i] == 33) {
    	        fieldValue[i] = LapPower2HRRatio;
        	    fieldLabel[i] = "L P2HR";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 34) {
    	        fieldValue[i] = LastLapPower2HRRatio;   	        
        	    fieldLabel[i] = "LL P2HR";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 35) {
	            fieldValue[i] = AveragePower2HRRatio;
    	        fieldLabel[i] = "A  P2HR";
        	    fieldFormat[i] = "2decimal";
			} else if (metric[i] == 36) {
	            fieldValue[i] = CurrentPower2HRRatio;
    	        fieldLabel[i] = "C P2HR";
        	    fieldFormat[i] = "2decimal";
        	} else if (metric[i] == 70) {
    	        fieldValue[i] = AveragePower5sec;
        	    fieldLabel[i] = "Pwr 5s";
            	fieldFormat[i] = "power";
			} else if (metric[i] == 39) {
    	        fieldValue[i] = AveragePower10sec;
        	    fieldLabel[i] = "Pwr 10s";
            	fieldFormat[i] = "power";
			} else if (metric[i] == 37) {
	            fieldValue[i] = Averagepowerpersec;
    	        fieldLabel[i] = "Pw ..sec";
        	    fieldFormat[i] = "power";
			} else if (metric[i] == 57) {
	            fieldValue[i] = mNormalizedPow;
    	        fieldLabel[i] = "N Power";
        	    fieldFormat[i] = "0decimal";
        	} else if (metric[i] == 80) {
    	        fieldValue[i] = (info.maxPower != null) ? info.maxPower : 0;
        	    fieldLabel[i] = "Max Pwr";
            	fieldFormat[i] = "power";
        	} else if (metric[i] == 71) {
            	fieldValue[i] = (uFTP != 0) ? Actualpower*100/uFTP : 0;
            	fieldLabel[i] = "%FTP";
            	fieldFormat[i] = "power";   
	        } else if (metric[i] == 72) {
    	        fieldValue[i] = (uFTP != 0) ? AveragePower3sec*100/uFTP : 0;
        	    fieldLabel[i] = "%FTP 3s";
            	fieldFormat[i] = "power";
			} else if (metric[i] == 73) {
    	        fieldValue[i] = (uFTP != 0) ? LapPower*100/uFTP : 0;
        	    fieldLabel[i] = "L %FTP";
            	fieldFormat[i] = "power";
			} else if (metric[i] == 74) {
        	    fieldValue[i] = (uFTP != 0) ? LastLapPower*100/uFTP : 0;
            	fieldLabel[i] = "LL %FTP";
            	fieldFormat[i] = "power";
	        } else if (metric[i] == 75) {
    	        fieldValue[i] = (uFTP != 0) ? AveragePower*100/uFTP : 0;
        	    fieldLabel[i] = "A %FTP";
            	fieldFormat[i] = "power";  
	        } else if (metric[i] == 76) {
    	        fieldValue[i] = (uFTP != 0) ? AveragePower5sec*100/uFTP : 0;
        	    fieldLabel[i] = "%FTP 5s";
            	fieldFormat[i] = "power";
			} else if (metric[i] == 77) {
    	        fieldValue[i] = (uFTP != 0) ? AveragePower10sec*100/uFTP : 0;
        	    fieldLabel[i] = "%FTP 10s";
            	fieldFormat[i] = "power";
			} else if (metric[i] == 78) {
	            fieldValue[i] = (uFTP != 0) ? Averagepowerpersec*100/uFTP : 0;
    	        fieldLabel[i] = "%FTP ..sec";
        	    fieldFormat[i] = "power";
			} else if (metric[i] == 58) {
	            fieldValue[i] = mIntensityFactor;
    	        fieldLabel[i] = "IF";
        	    fieldFormat[i] = "2decimal";
			} else if (metric[i] == 59) {
	            fieldValue[i] = mTTS;
    	        fieldLabel[i] = "TTS";
        	    fieldFormat[i] = "0decimal";
			} else if (metric[i] == 60) {
	            fieldValue[i] = RSS;
    	        fieldLabel[i] = "RSS";
        	    fieldFormat[i] = "0decimal";
        	} else if (metric[i] == 93) {
				if (info.currentPower != null and info.currentPower != 0) {
            		fieldValue[i] = CurrentSpeedinmpersec*uWeight/info.currentPower;
            	} else {
            		fieldValue[i] = 0;
            	}
            	fieldLabel[i] = "RE cur";
            	fieldFormat[i] = "2decimal";   
			} else if (metric[i] == 94) {
				if (AveragePower3sec != 0) {
            		fieldValue[i] = Averagespeedinmper3sec*uWeight/AveragePower3sec;
            	} else {
            		fieldValue[i] = 0;
            	}
            	fieldLabel[i] = "RE 3sec";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 95) {
				if (AveragePower5sec != 0) {
            		fieldValue[i] = Averagespeedinmper5sec*uWeight/AveragePower5sec;
            	} else {
            		fieldValue[i] = 0;
            	}
            	fieldLabel[i] = "RE 5sec";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 96) {
				if (LapPower != 0) {
            		fieldValue[i] = mLapSpeed*uWeight/LapPower;
            	} else {
            		fieldValue[i] = 0;
            	}
            	fieldLabel[i] = "RE lap";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 98) {
				if (AveragePower != 0) {
            		fieldValue[i] = info.averageSpeed*uWeight/AveragePower;
            	} else {
            		fieldValue[i] = 0;
            	}
            	fieldLabel[i] = "RE Aver";
            	fieldFormat[i] = "2decimal";
			} else if (metric[i] == 64) {
	            fieldValue[i] = TimeToNextStep;
    	        fieldLabel[i] = "T Next S";
        	    fieldFormat[i] = "timeshort";
			} else if (metric[i] == 65) {
	            fieldValue[i] = DistanceToNextStep/unitD;
    	        fieldLabel[i] = "D Next S";
        	    fieldFormat[i] = "2decimal";
			} else if (metric[i] == 66) {
	            fieldValue[i] = PowerTargetThisStep;
    	        fieldLabel[i] = "Power T";
        	    fieldFormat[i] = "0decimal";
        	} 
        	//!einde invullen field metrics
		}
		//! Conditions for showing the demoscreen       
        if (uShowDemo == false) {
        	if (licenseOK == false && jTimertime > 900)  {
        		uShowDemo = true;        		
        	}
        }

	   //! Check whether demoscreen is showed or the metrics 
	   if (uShowDemo == false ) {

	   } 
	   
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

		fieldvalue = (metric[counter]==38) ? mZone[counter] : fieldvalue;
		fieldvalue = (metric[counter]==99) ? mZone[counter] : fieldvalue;
		fieldvalue = (metric[counter]==100) ? mZone[counter] : fieldvalue;
		fieldvalue = (metric[counter]==101) ? mZone[counter] : fieldvalue;
		fieldvalue = (metric[counter]==102) ? mZone[counter] : fieldvalue;
		fieldvalue = (metric[counter]==103) ? mZone[counter] : fieldvalue;
		fieldvalue = (metric[counter]==104) ? mZone[counter] : fieldvalue;  
		fieldvalue = (metric[counter]==46) ? mZone[counter] : fieldvalue;
		
        if ( fieldformat.equals("0decimal" ) == true ) {
        	fieldvalue = fieldvalue.format("%.0f");        	
        } else if ( fieldformat.equals("1decimal" ) == true ) {
            Temp = Math.round(fieldvalue*10)/10;
			fieldvalue = Temp.format("%.1f");
        } else if ( fieldformat.equals("2decimal" ) == true ) {
            Temp = Math.round(fieldvalue*100)/100;
            var fString = "%.2f";
            if (counter == 3 or counter == 4 or counter ==5) {
   	      		if (Temp > 9.99999) {
    	         	fString = "%.1f";
        	    }
        	} else {
        		if (Temp > 99.99999) {
    	         	fString = "%.1f";
        	    }  
        	}        
        	fieldvalue = Temp.format(fString);     	
        } else if ( fieldformat.equals("pace" ) == true ) {
        	Temp = (fieldvalue != 0 ) ? (unitP/fieldvalue).toLong() : 0;
        	fieldvalue = (Temp / 60).format("%0d") + ":" + Math.round(Temp % 60).format("%02d");
        } else if ( fieldformat.equals("power" ) == true ) {     
        	fieldvalue = Math.round(fieldvalue);
        	PowerWarning = (setPowerWarning == 1) ? 1 : PowerWarning;    	
        	PowerWarning = (setPowerWarning == 2) ? 2 : PowerWarning;
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
        
		//! Don't display middle row metrics, if there is a workout notification

		hideText = false;
		if (hideDiv == true) {
			if (counter == 3 or counter == 4 or counter == 5) {
				hideText = true;
			}
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
            		if (hideText == false) {
            			dc.drawText(xh, yh, Graphics.FONT_NUMBER_MILD, fTimerHours, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            		}
            		fTimer = (fieldvalue / 60 % 60).format("%02d") + ":" + fTimerSecs;  
        		}
        		if (hideText == false) {
        			dc.drawText(xx, y, Garminfont, fTimer, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        		}	
        	}
        } else {
        	if (hideText == false) {
        		dc.drawText(x, y, Garminfont, fieldvalue, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        	}
        }        
        if (hideText == false) {
        	dc.drawText(xl, yl, Graphics.FONT_XTINY,  fieldlabel, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }               
        mColourFont = originalFontcolor;
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
    }

	function hashfunction(string) {
    	var val = 0;
    	var bytes = string.toUtf8Array();
    	for (var i = 0; i < bytes.size(); ++i) {
        	val = (val * 997) + bytes[i];
    	}
    	return val + (val >> 5);
	}


	function Workoutstepalert(dc) {
		hideText = true;
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		var vibrateData = [
			new Attention.VibeProfile( 100, 100 )
		];

		hideDiv = true;
		if (oldmWorkoutstepNumber < 18 ) {
			if (mWorkoutAmount[oldmWorkoutstepNumber].equals("0000") == false) { 
				dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,  "Next step" , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			} else { 
				dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,"The end", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			}
			Toybox.Attention.vibrate(vibrateData);
			Attention.playTone(Attention.TONE_ALERT_LO);
			Attention.playTone(Attention.TONE_ALERT_HI);
		} else if (oldmWorkoutstepNumber > 17 ) {
			dc.drawText(redTextwidthDisplay, redTextheightDisplay, Graphics.FONT_MEDIUM,"The end", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			TheEnd = true;
		}
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
	}
}
