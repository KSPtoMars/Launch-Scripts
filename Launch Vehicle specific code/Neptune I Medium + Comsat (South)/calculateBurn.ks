declare parameter newPeri.

run bodyconstants("Kerbin").

set r to apoapsis + bodyRadius.
 
set sma to (apoapsis+bodyRadius + periapsis+bodyRadius)/2.
 
set vS to bodyStdGravParam*((2/r)-(1/sma)).
 
set currentV to vS^0.5.
 
set sma to (apoapsis+bodyRadius + newPeri+bodyRadius)/2.
 
set vS to bodyStdGravParam*((2/r)-(1/sma)).
 
set targetV to vS^0.5.
 
set vDiff to targetV - currentV.

run writeLine("Burn calculated: " + vDiff).
SET myNode to NODE( TIME:SECONDS+ETA:apoapsis, 0, 0, vDiff ).
ADD myNode.
SET pitchP TO 0.04.
SET pitchD TO 0.2.
 
set yawP TO 0.04.
set yawD TO 0.2.
clearscreen.
set i to 0.
run orientvector(myNode:BURNVECTOR).
until facingAngle < 0.3{
run orientvector(myNode:BURNVECTOR).
}
clearscreen.
sas on.
run writeLine("Coasting to apoapsis, burn will occur at T+" + round(missiontime) + round(myNode:eta)).
wait until eta:apoapsis < 120.
run writeLine("Preparing for burn in two minutes").
sas off.
until eta:apoapsis < 30{
run orientvector(myNode:BURNVECTOR).
}
SAS on.
print "Go for correction".
RCS on.
wait until eta:apoapsis < 10.
until myNode:DELTAV:mag < 0.2 or periapsis > 499999{
clearscreen.
print myNode:DELTAV:mag.
set ship:control:fore to 1.
}
set ship:control:fore to 0.
sas on.
print "Burn complete".
