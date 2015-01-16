


 
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
set i to 10.
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
wait until altitude > 15000.
SAS off.
SET SHIP:CONTROL:PITCH to 0.05.
run writeLine("First pitchover").
wait until pitchangle < 70.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
run writeLine("First pitchover completed, awaiting SRB shutdown").
sas on.
wait until stage:solidfuel < 693.
wait 3.
stage.
wait 1.
run writeLine("SRB Seperation Confirmed.").
lock throttle to 0.05.
wait until altitude >  80000.
lock throttle to 1.
wait 5.
SAS off.
SET SHIP:CONTROL:PITCH to 0.05.
run writeLine("Second pitchover").
wait until pitchangle < 45.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
run writeLine("Second pitchover completed").
sas on.
wait 5.
run writeLine("Waiting for first stage cutoff").
wait until mainEngine:thrust = 0.
run writeLine("MECO").
stage.
wait 1.
stage.
run writeLine("Stage two ignition confirmed").
lock throttle to 1.
wait 20.
SAS off.
SET SHIP:CONTROL:PITCH to 0.05.
run writeLine("Final pitchover").
wait until pitchangle < 25.
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
run writeLine("Final pitchover completed").
sas on.
run writeLine("Waiting for second stage shutdown").
wait until stage:lqdhydrogen = 0.
run writeLine("SECO").
stage.
wait 2.
stage.
run writeLine("Final stage ignition confirmed").
run writeLine("Waiting for apoapsis to reach target").
wait until apoapsis > 40000000.
lock throttle to 0.
run writeLine("Engine shutdown").
wait 5.
stage.
run writeLine("Payload separation").
toggle ag1.
run writeLine("Dishes deployed").
wait 5.
sas off.
wait 10.
clearscreen.
run calculateBurn(500000).