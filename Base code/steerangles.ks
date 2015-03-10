//NAME: steerangles.ks
//Script that gives angle values to the main script, orientvector
//This script determines what way the ship should rotate and by how much.

/// *** DEPENDENCIES ***
//None.

/// *** INPUT ***
//steerVector - is implicitly (globally) passed to this function
//

/// *** OUTPUT *** (values that will be used outside this function)
//pitchAngle - The pitch change required in degrees
//yawAngle - The yaw change required in degrees

//Direction and magnitude of rotation determined from the projection of steerVector onto a perpendicular of FOREVECTOR
SET steerangles_directionVector to VXCL(SHIP:FACING:FOREVECTOR, steerVector).

//If the angle between the starboard vector and the direction of rotation is greater than 90 degrees (if rotation is occuring in the -y plane/direction)
//Then the angle between the top vector and the steering direction are used. Otherwise, this angle is subtracted from 360 first.
IF VANG(SHIP:FACING:STARVECTOR, steerangles_directionVector) > 90 {
	SET steerangles_vectorAngle TO VANG(SHIP:FACING:TOPVECTOR, steerangles_directionVector).
}
ELSE { 
	SET steerangles_vectorAngle TO 360-VANG(SHIP:FACING:TOPVECTOR, steerangles_directionVector). 
}.

SET steerangles_facingAngle to VANG(SHIP:FACING:FOREVECTOR, steerVector).

SET pitchAngle TO cos(steerangles_vectorAngle) * steerangles_facingAngle.
SET yawAngle TO sin(steerangles_vectorAngle) * steerangles_facingAngle.
