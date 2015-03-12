//NAME: orientvectorCustom.ks
//Main script that does most of the magic.
//It steers the craft in the right direction.

/// *** DEPENDENCIES ***
//steerangles.ks

/// *** INPUT ***
//steerVector - the vector in 3d rotational space (x,y,z) at which the ship should point
//pitchKp - the gain value for the proportional term of pitch PID loop
//pitchKi - the gain value for the integral term of pitch PID loop
//pitchKd - the gain value for the derivative term of pitch PID loop
//yawKp - the gain value for the proportional term of yaw PID loop
//yawKi - the gain value for the integral term of pitch PID loop
//yawKd - the gain value for the derivative term of yaw PID loop 
 
/// *** OUTPUT ***
//None. There is only physical outputs (the ship moves).
//
	
DECLARE PARAMETER steerVector, pitchKp, pitchKi, pitchKd, yawKp, yawKi, yawKd.

//TODO: If we are running low on computational time, we can remove one of the two steerangles and simply store a value from the last iteration.

RUN steerangles.
SET pitchE0 TO pitchAngle.
SET yawE0 TO yawAngle.
SET rollE0 TO VXCL(SHIP:FACING:STARVECTOR, steerVector).

SET t0 TO TIME:SECONDS.
WAIT 0.0001.
RUN steerangles.
	
SET t1 TO TIME:SECONDS.
SET pitchE1 TO pitchAngle.
SET yawE1 TO yawAngle.
SET rollE1 TO VXCL(SHIP:FACING:STARVECTOR, steerVector).
SET rollAngle TO rollE1.

SET dt TO t1 - t0.

//Corrects the Pitch Angle
set pitchEavg to (pitchE0+pitchE1)/2.
set pitchIntg to pitchIntg + (dt*(pitchEavg)).
set pitchDer to (pitchE1-pitchE0)/dt.

SET orientvector_pitchRate TO pitchKp*pitchEavg + pitchKi*pitchIntg + pitchKd*pitchDer.
SET SHIP:CONTROL:PITCH TO orientvector_pitchRate.

//Corrects the Yaw angle
set yawEavg to (yawE0+yawE1)/2.
set yawIntg to yawIntg + (dt*(yawEavg)).
set yawDer to (yawE1-yawE0)/dt.

SET orientvector_yawRate TO yawKp*yawEavg + yawKi*yawIntg + yawKd*yawDer.
SET SHIP:CONTROL:YAW TO orientvector_yawRate.

//Useful for debugging	
PRINT "vectorAngle:" + ROUND(steerangles_vectorAngle, 2) at (1,3).
PRINT "facingAngle:" + ROUND(steerangles_facingAngle, 2) at (1,4).
	
PRINT "Pitch Rate: " + orientvector_pitchRate at (1,6).
PRINT "Pitch Angle: " + ROUND(pitchAngle, 2) at (1,7).
	
PRINT "Yaw Rate: " + orientvector_yawRate at (1,10).
PRINT "Yaw Angle: " + ROUND(yawAngle, 2) at (1,11).
