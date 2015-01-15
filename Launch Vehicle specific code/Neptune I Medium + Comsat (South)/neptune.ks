


 
lock rightrotation to ship:facing*r(0,90,0).
 
lock right to rightrotation:vector. //right and left are directly along wings
 
lock left to (-1)*right.
 
lock up to ship:up:vector. //up and down are skyward and groundward
 
lock down to (-1)*up.
 
lock fore to ship:facing:vector. //fore and aft point to the nose and tail
 
lock aft to (-1)*fore.
 
lock righthor to vcrs(up,fore). //right and left horizons
 
lock lefthor to (-1)*righthor.
 
lock forehor to vcrs(righthor,up). //forward and backward horizons
 
lock afthor to (-1)*forehor.
 
lock top to vcrs(fore,right). //above the cockpit, through the floor
 
lock bottom to (-1)*top.
 
//the following are all angles, useful for control programs
 
lock absaoa to vang(fore,srfprograde:vector). //absolute angle of attack
 
lock aoa to vang(top,srfprograde:vector)-90. //pitch component of angle of attack
 
lock sideslip to vang(right,srfprograde:vector)-90. //yaw component of aoa
 
lock rollangle to vang(right,righthor)*((90-vang(top,righthor))/abs(90-vang(top,righthor))). //roll angle, 0 at level flight
 
lock pitchangle to vang(fore,forehor)*((90-vang(fore,up))/abs(90-vang(fore,up))). //pitch angle, 0 at level flight
 
lock glideslope to vang(srfprograde:vector,forehor)*((90-vang(srfprograde:vector,up))/abs(90-vang(srfprograde:vector,up))).
 
 
print "Go for launch".
print pitchangle.
set i to 3.
until i = 0{
set i to i - 1.
print "T-" + i.
wait 1.
}
SET eList to SHIP:PARTSDUBBED("mainEngine").
SET mainEngine to eList[0].
lock throttle to 0.1.
stage.
SAS on.
print "Lift off!".
wait 2.

set i to 0.
wait until altitude > 35000.
SAS off.
SET SHIP:CONTROL:PITCH to 0.05.
print "T+" + round(missiontime) + "s: " + "Deactivating SAS. Initiating gravity turn.".
wait until pitchangle < 70.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
print "T+" + round(missiontime) + "s: " + "First Gravity turn complete. Activating SAS to stabilize.".
sas on.
wait until stage:solidfuel < 693.
stage.
lock throttle to 0.5.
wait until altitude >  60000.
lock throttle to 1.
wait 5.
SAS off.
SET SHIP:CONTROL:PITCH to 0.1.
print "T+" + round(missiontime) + "s: " + "Deactivating SAS. Initiating gravity turn.".
wait until pitchangle < 50.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
print "T+" + round(missiontime) + "s: " + "First Gravity turn complete. Activating SAS to stabilize.".
sas on.
wait 5.
print "Waiting for meco".
wait until mainEngine:thrust = 0.
stage.
wait 1.
stage.
lock throttle to 1.
wait 20.
SAS off.
SET SHIP:CONTROL:PITCH to 0.1.
print "T+" + round(missiontime) + "s: " + "Deactivating SAS. Initiating gravity turn.".
wait until pitchangle < 10.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
print "T+" + round(missiontime) + "s: " + "First Gravity turn complete. Activating SAS to stabilize.".
sas on.
print "Waiting for SECO".
wait until stage:lqdhydrogen = 0.
stage.
wait 2.
stage.
SAS off.
SET SHIP:CONTROL:PITCH to 0.1.
print "T+" + round(missiontime) + "s: " + "Deactivating SAS. Initiating gravity turn.".
wait until pitchangle < 0.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
print "T+" + round(missiontime) + "s: " + "First Gravity turn complete. Activating SAS to stabilize.".
sas on.
wait until apoapsis > 40000000.
lock throttle to 0.
wait 5.
stage.
toggle ag1.
wait 5.
sas off.
run calculateBurn(500000).