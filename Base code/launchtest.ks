// Script used to launch from Earth at Cape Canaveral into a circular parking orbit. Can be used for launching from other locations.

// DEPENDENCIES:
//	filesetup.ks
//	logdata.ks (This along with 'filesetup' can be commented out if not being used. These can be used with Excel or other programs for
//	troubleshooting or analysis)
//	steerangles.ks
// 	orientvectorCustom.ks
//	staging.ks

// USER DEFINED PARAMETERS:
//	PID gains for Pitch and Yaw: I have some starting values but each ship will have different ones that you will
// 		need to tune. These are written as 
//	pitch_velocity: Effectively determining at what altitude to begin the turn.
//	desired_inc: The desired Inclination of your final orbit.
//	Azimuth: The launch azimuth you want to use. This is determined from analytics from KSPTOT Launch Window Analysis
//	Rcir: Altitude of your circular parking orbit

// SUGGESTIONS FOR RUNNING:
//	Run the orientvectorCustom.ks file to try and tune the PID gains and then after you finish tuning it, then run
//	the launchtest.ks file to tune the pitch_velocity to get the proper ascent profile.

SAS on.
lock throttle to 1.
//Make sure that the ship is set to 0 throttle at start.
set ship:control:pilotmainthrottle to 0.
stage.

set MAX to maxthrust.
set Gnot to ship:body:mu/(ship:body:radius)^2.

// The pitch_velocity is the only factor that can be changed as far as the gravity turn goes
// I have decided to stick with a pitch_angle of 2.5 degrees and then adjust the speed according to this criteria:
// If the rocket's apoapsis surpasses the target apoapsis (229Km) and the rocket's altitude is less than the target apoapsis:
//		reduce the velocity
// If the rocket's apoapsis never surpasses the target apoapsis after it has reached the apogee:
// 		increase the velocity
// Note that the ship's trajectory will never be perfectly the same, so adjust the pitch_velocity until you have it
// within the ballpark  range or your final circular orbit height.

set pitch_angle to 2.5.
lock pitch_stop to vectorangle(UP:vector, velocity:surface).
set pitch_velocity to 45.
set desired_inc to 33. 

set Azimuth to 110. // Azimuth angle desired

set Rcir to 229000. // Radius of Circular Orbit

//I use a gravity turn and so I set the angle (pitch_angle) that I want the ship to be and what vertical speed (pitch_velocity) it will start the pitch.
// After it reaches that velocity, it should be at the desired angle and from then on it will follow the surface prograde 
// until the inclination angle is close to the desired inclination angle. Then switch to the orbital prograde so the inclination doesnt change as much.

// Set the desired gains for the PID control for Pitch/Yaw. These will be different for each craft but I have left some starting values int he comments

// declare and set the PID calculation values to 0.

set pitchEavg to 0.
set pitchIntg to 0.
set pitchDer to 0.

set yawEavg to 0.
set yawIntg to 0.
set yawDer to 0.

// Roll is currently not being controlled, still working on how to solve this if its an issue.
//set RKp to 0.//0.005.
//set RKi to 0.//0.0005. 
//set RKd to 0.//0.01.

set pitchKp to 0.0075.
set pitchKi to 0.001.
set pitchKd to 0.015.

set yawKp to -0.0075.
set yawKi to -0.001.
set yawKd to -0.015.

run filesetup.

set start to time:seconds.
lock t to time:seconds - start.
set pitchAngle to 0.
set yawAngle to 0.

clearscreen.

until verticalspeed > pitch_velocity {

	run staging.

	print "Accelerating to Vertical Speed of " + round(pitch_velocity,2) + "m/s" at (0,0).
	
	run logdata.
	
	}

SAS off.

lock direction_desired to Heading(Azimuth,90 - pitch_angle).

clearscreen.

until pitch_stop > .9*pitch_angle {
	
	run staging.
	
	print "Performing Pitch Over Maneuver" at (0,0).
		
	run orientvectorCustom(direction_desired:vector,  pitchKp, pitchKi, pitchKd, yawKp, yawKi, yawKd).
	
	run logdata.
	
	}
	
lock direction_desired to Heading(Azimuth,90-vectorangle(-1*body:position,velocity:surface)).
lock IncDifference to abs(desired_inc - ship:obt:inclination).	
	
until IncDifference < .01 {
	
	run staging.
	
	print "Following Surface Velocity Vector    " at (0,0).
	print "                             " at (0,1).
	
	run orientvectorCustom(direction_desired:vector,  pitchKp, pitchKi, pitchKd, yawKp, yawKi, yawKd).
	
	run logdata.
	
	}
	
	
lock direction_desired to velocity:orbit:direction.

until apoapsis > Rcir OR verticalspeed < 2.5 {
	
	run staging.
	
	print "Following Orbital Velocity Vector    " at (0,0).
	
	run orientvectorCustom(direction_desired:vector,  pitchKp, pitchKi, pitchKd, yawKp, yawKi, yawKd).
	
	run logdata.
	
	}

if apoapsis > Rcir AND verticalspeed > 0 {

	lock throttle to .1.
	
	lock down_angle to 90-vectorangle(UP:vector,velocity:orbit).
	lock PitchDown to angleaxis(down_angle,vcrs(up:vector,prograde:vector)).
	lock direction_desired to velocity:orbit:direction.
	
	until verticalspeed < 1 {
		run staging.
	
		print "Waiting for Apogee T-" + round(eta:apoapsis,2) + " seconds" at (0,0).
	
		run orientvectorCustom(direction_desired:vector,  pitchKp, pitchKi, pitchKd, yawKp, yawKi, yawKd).
		
		run logdata.
	
		}
	
		lock throttle to 1.
	}
	
lock ShipRadius to ship:body:radius + altitude.
lock gravity to ship:body:mu/(ShipRadius^2).
lock orbitalspeed to velocity:orbit:mag.
lock horizontalspeed to sqrt(orbitalspeed^2 - verticalspeed^2).
lock centripedal to (horizontalspeed^2)/ShipRadius.
lock DownwardAcc to gravity - centripedal.
set errorP to -.01.
lock pitch_correction to errorP*verticalspeed.
lock pitch_cnstalt to arcsin(mass*DownwardAcc/maxthrust) - pitch_correction.

lock PitchUp to angleaxis(pitch_cnstalt,vcrs(prograde:vector,up:vector)).
lock direction_desired to PitchUp*prograde.

lock Rcurrent to altitude + ship:body:radius.
lock CirVelocity to sqrt(ship:body:MU/Rcurrent).
lock deltaV to CirVelocity - velocity:orbit:mag.


// CAUTION!: This part is untested but its a starting point for the constant altitude burn. Use with caution.
until deltaV < 1  {

	if verticalspeed > 0 {
		lock direction_desired to prograde.
		}
	
	if verticalspeed < 0 {
		lock direction_desired to PitchUp*prograde.
		}
	
	run staging.
	
	print "Performing Circular Injection Phase" at (0,0).
	print "Delta-V for Circular Orbit at Current Orbit: " + round(deltaV,2) at (0,1).
	run orientvectorCustom(direction_desired:vector,  pitchKp, pitchKi, pitchKd, yawKp, yawKi, yawKd).
	
	run logdata.
	
	}
