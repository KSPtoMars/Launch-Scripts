//Code to save data for later analysis
log t +","+ altitude to Universe.csv.
log pitchAngle +","+ yawAngle to Orientation.csv.
log surfacespeed +","+ verticalspeed +","+ airspeed +","+ arctan(verticalspeed/surfacespeed) +","+ ship:velocity:orbit:mag +","+ arcsin(verticalspeed/ship:velocity:orbit:mag) +","+  maxthrust/(mass*Gnot) to Velocity.csv.
log apoapsis +","+ ship:obt:eccentricity +","+ ship:obt:semimajoraxis +","+ eta:apoapsis +","+ ship:obt:inclination +","+ ship:obt:trueanomaly to Orbit.csv.
//log Rerror*RKp +","+ Rerrorintg*RKi +","+ Rerrorder*RKd +","+ ship:control:roll to ControlRoll.csv.
log 0 +","+ 0 +","+ 0 +","+ 0 to ControlRoll.csv.
log pitchEavg*pitchKp +","+ pitchIntg*pitchKi +","+ pitchDer*pitchKd +","+ ship:control:pitch to ControlPitch.csv.
log yawEavg*yawKp +","+ yawIntg*yawKi +","+ yawDer*yawKd +","+ ship:control:yaw to ControlYaw.csv.
