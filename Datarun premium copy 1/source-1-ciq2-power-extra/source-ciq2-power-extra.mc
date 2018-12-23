using Toybox.Math;
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
	hidden var mETA							= 0;
	hidden var uETAfromLap 					= true;
	hidden var FilteredCurPower				= 0;
	//!var sumNormalizedPow 					= 0;
	var sum4thPowers						= 0;
	var fourthPowercounter 					= 0;
	var mIntensityFactor					= 0;
	var mTTS								= 0;
	var uWorkoutzones						= "00@150-170;05@150-170;05@150-170;05@150-170;05@150-170;05@150-170;05@150-170;05@150-170;05@150-170;05@150-170";
	var mWorkoutTime						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
	var mWorkoutLzone						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
	var mWorkoutHzone						= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
	
    function initialize() {
        ExtramemView.initialize();
		var mApp 		 = Application.getApp();
		rolavPowmaxsecs	 = mApp.getProperty("prolavPowmaxsecs");	
		uPowerZones		 = mApp.getProperty("pPowerZones");	
		PalPowerzones 	 = mApp.getProperty("p10Powerzones");
		uPower10Zones	 = mApp.getProperty("pPPPowerZones");
		uFTP		 	 = mApp.getProperty("pFTP");
		uCP		 	 	 = mApp.getProperty("pCP");
		uWorkoutzones	 = mApp.getProperty("pWorkoutzones");
		if (metric[1] == 57 or metric[2] == 57 or metric[3] == 57 or metric[4] == 57 or metric[5] == 57 or metric[6] == 57 or metric[7] == 57) {
			rolavPowmaxsecs = (rolavPowmaxsecs < 30) ? 30 : rolavPowmaxsecs;
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
			jTimertime = jTimertime + 1;
			//!Calculate lapheartrate
            mHeartrateTime		 = (info.currentHeartRate != null) ? mHeartrateTime+1 : mHeartrateTime;				
           	mElapsedHeartrate    = (info.currentHeartRate != null) ? mElapsedHeartrate + info.currentHeartRate : mElapsedHeartrate;
            //!Calculate lappower
            mPowerTime		 = (info.currentPower != null) ? mPowerTime+1 : mPowerTime;
			mElapsedPower    = (info.currentPower != null) ? mElapsedPower + info.currentPower : mElapsedPower;
			
			RSS 			 = (info.currentPower != null) ? RSS + 0.03 * Math.pow(((info.currentPower+0.001)/uCP),3.5) : RSS; 			             
        }
	}

	function onUpdate(dc) {
		//! call the parent onUpdate to do the base logic
		ExtramemView.onUpdate(dc);
        		
		//!Calculate HR-metrics
		var info = Activity.getActivityInfo();
		
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

		//! Calculation of rolling average of power 
		var zeroValueSecs = 0;
		if (counterPower < 1) {
			for (var i = 1; i < rolavPowmaxsecs+2; ++i) {
				rollingPwrValue [i] = 0; 
			}
		}
		counterPower = counterPower + 1;
		rollingPwrValue [rolavPowmaxsecs+1] = (info.currentPower != null) ? info.currentPower : 0;
//!temporary solution for power spikes > 2000 Wat 		
		rollingPwrValue [rolavPowmaxsecs+1] = (rollingPwrValue [rolavPowmaxsecs+1] > 2000) ? rollingPwrValue [rolavPowmaxsecs] : rollingPwrValue [rolavPowmaxsecs+1];
		FilteredCurPower = rollingPwrValue [rolavPowmaxsecs+1]; 
		for (var i = 1; i < rolavPowmaxsecs+1; ++i) {
			rollingPwrValue [i] = rollingPwrValue [i+1];
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

		//! Calculate IF and TTS
		mIntensityFactor = (uFTP != 0) ? mNormalizedPow / uFTP : 0;
		mTTS = (jTimertime * mNormalizedPow * mIntensityFactor)/(uFTP * 3600) * 100;

		//! Set up powerbased workout
		mWorkoutTime[1]		= uWorkoutzones.substring(0, 2);
		mWorkoutLzone[1]	= uWorkoutzones.substring(3, 6);
		mWorkoutHzone[1]	= uWorkoutzones.substring(7, 10);
		mWorkoutTime[2]		= uWorkoutzones.substring(11, 13);
		mWorkoutLzone[2] 	= uWorkoutzones.substring(14, 17);
		mWorkoutHzone[2] 	= uWorkoutzones.substring(18, 21);
		mWorkoutTime[3]		= uWorkoutzones.substring(22, 24);
		mWorkoutLzone[3] 	= uWorkoutzones.substring(25, 28);
		mWorkoutHzone[3]	= uWorkoutzones.substring(29, 32);
		mWorkoutTime[4]		= uWorkoutzones.substring(33, 35);
		mWorkoutLzone[4] 	= uWorkoutzones.substring(36, 39);
		mWorkoutHzone[4]	= uWorkoutzones.substring(40, 43);
		mWorkoutTime[5]		= uWorkoutzones.substring(44, 46);
		mWorkoutLzone[5] 	= uWorkoutzones.substring(47, 50);
		mWorkoutHzone[5]	= uWorkoutzones.substring(51, 54);
		mWorkoutTime[6]		= uWorkoutzones.substring(55, 57);
		mWorkoutLzone[6] 	= uWorkoutzones.substring(58, 61);
		mWorkoutHzone[6]	= uWorkoutzones.substring(62, 65);
		mWorkoutTime[7]		= uWorkoutzones.substring(66, 68);
		mWorkoutLzone[7] 	= uWorkoutzones.substring(69, 72);
		mWorkoutHzone[7]	= uWorkoutzones.substring(73, 76);
		mWorkoutTime[8]		= uWorkoutzones.substring(77, 79);
		mWorkoutLzone[8] 	= uWorkoutzones.substring(80, 83);
		mWorkoutHzone[8]	= uWorkoutzones.substring(84, 87);
		mWorkoutTime[9]		= uWorkoutzones.substring(88, 90);
		mWorkoutLzone[9] 	= uWorkoutzones.substring(91, 94);
		mWorkoutHzone[9]	= uWorkoutzones.substring(95, 98);
		mWorkoutTime[10]	= uWorkoutzones.substring(99, 101);
		mWorkoutLzone[10] 	= uWorkoutzones.substring(102, 105);
		mWorkoutHzone[10] 	= uWorkoutzones.substring(106, 109);		
		
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		if (mWorkoutTime[1].equals("00") == false ) {
			if (jTimertime == 0) { 
				dc.drawText(120, 135, Graphics.FONT_MEDIUM,  mWorkoutTime[1] + " min " + " @ " + mWorkoutLzone[1] + " - " + mWorkoutHzone[1], Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			}
		}
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		
		var i = 0; 
	    for (i = 1; i < 8; ++i) {
	        if (metric[i] == 38) {
    	        fieldValue[i] =  (info.currentPower != null) ? info.currentPower : 0;     	        
        	    fieldLabel[i] = "P zone";
            	fieldFormat[i] = "0decimal";
			} else if (metric[i] == 56) {
	            fieldValue[i] = FilteredCurPower;
    	        fieldLabel[i] = "Filt Pwr";
        	    fieldFormat[i] = "0decimal";            	
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
			} else if (metric[i] == 37) {
	            fieldValue[i] = Averagepowerpersec;
    	        fieldLabel[i] = "Pw ..sec";
        	    fieldFormat[i] = "power";
			} else if (metric[i] == 57) {
	            fieldValue[i] = mNormalizedPow;
    	        fieldLabel[i] = "N Power";
        	    fieldFormat[i] = "0decimal";
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

		fieldvalue = (metric[counter]==38) ? Powerzone : fieldvalue; 
		fieldvalue = (metric[counter]==46) ? HRzone : fieldvalue;
		
        if ( fieldformat.equals("0decimal" ) == true ) {
        	fieldvalue = fieldvalue.format("%.0f");        	
        } else if ( fieldformat.equals("2decimal" ) == true ) {
            Temp = Math.round(fieldvalue*100)/100;
            var fString = "%.2f";
         	if (Temp > 9.99999) {
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

		var hideText = true;
    	if (mWorkoutTime[1].equals("00") == false ) {
			if (jTimertime == 0) {
				if (counter < 3 or counter > 5) { 
					hideText = false;
				}
			} else {
				hideText = false;
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
        			dc.drawText(xx, y, Graphics.FONT_NUMBER_MEDIUM, fTimer, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        		}	
        	}
        } else {
        	if (hideText == false) {
        		dc.drawText(x, y, Graphics.FONT_NUMBER_MEDIUM, fieldvalue, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
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

}

