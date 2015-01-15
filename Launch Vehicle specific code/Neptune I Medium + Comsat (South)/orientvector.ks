//NAME: orientvector.ks
//Main script that does most of the magic
 
/// *** DEPENDENCIES ***
//steerangles.ks
       
DECLARE PARAMETER steerVector.
       
SET directionVector to VXCL(SHIP:FACING:FOREVECTOR, steerVector).
 
IF VANG(SHIP:FACING:STARVECTOR, directionVector) > 90 {
        SET vectorAngle TO VANG(SHIP:FACING:TOPVECTOR,directionVector).
}
ELSE { SET vectorAngle TO 360-VANG(SHIP:FACING:TOPVECTOR,directionVector). }.
 
set facingAngle to VANG(SHIP:FACING:FOREVECTOR, steerVector).
 
set pitchAngle TO cos(vectorAngle)*facingAngle.
set yawAngle TO sin(vectorAngle)*facingAngle.

SET pitchE0 TO pitchAngle.
SET yawE0 TO yawAngle.
 
SET t0 TO TIME:SECONDS.
WAIT 0.05.
RUN steerangles.
       
SET t1 TO TIME:SECONDS.
SET pitchE1 TO pitchAngle.
SET yawE1 TO yawAngle.
       
SET dPitch TO (pitchE1 - pitchE0)/(t1 - t0).
SET dYaw TO (yawE1 - yawE0)/(t1 - t0).
 
//Useful for debugging
SET SHIP:CONTROL:PITCH TO (pitchP*pitchE1 + pitchD*dPitch).
SET SHIP:CONTROL:YAW TO -1*(yawP*yawE1 + yawD*dYaw).
       
PRINT "vectorAngle:" + ROUND(vectorAngle,2) at (1,3).
PRINT "facingAngle:" + ROUND(facingAngle,2) at (1,4).
       
PRINT "Pitch: " + ROUND(pitchP*pitchE1 + pitchD*dPitch,2) at (1,6).