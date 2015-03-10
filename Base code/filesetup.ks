//Code to set up files for data logging
log 1 to Parameters.csv.
log 1 to Universe.csv.
log 1 to Orientation.csv.
log 1 to Velocity.csv.
log 1 to Orbit.csv.
log 1 to ControlRoll.csv.
log 1 to ControlPitch.csv.
log 1 to ControlYaw.csv.

delete Parameters.csv.
delete Universe.csv.
delete Orientation.csv.
delete Velocity.csv.
delete Orbit.csv.
delete ControlRoll.csv.
delete ControlPitch.csv.
delete ControlYaw.csv.

//log "RKp= " + RKp + ",RKi= " + RKi + ",RKd= " + RKd to Parameters.csv.
log "pitchKp= " + pitchKp + ",pitchKi= " + pitchKi + ",pitchKd= " + pitchKd to Parameters.csv.
log "yawKp= " + yawKp + ",yawKi= " + yawKi + ",yawKd= " + yawKd to Parameters.csv.
log "Pitch Angle= " + pitch_angle + ",Pitch Velocity= " + pitch_velocity to Parameters.csv.
log "Time,Altitude" to Universe.csv.
log "PitchAngle,YawAngle" to Orientation.csv.
log "Horizontal Speed,Vertical Speed,Surface Speed,Flight Path Angle_Earth,Orbital Speed,Flight Path Angle_Space,TWR," to Velocity.csv.
log "Apoapsis,Eccentricity,Semimajor Axis,ETA to Apoapsis,Inclination,True Anomaly" to Orbit.csv.
log "RollProportional,RollIntegral,RollDerivative,RollControl" to ControlRoll.csv.
log "PitchProportional,PitchIntegral,PitchDerivative,PitchControl" to ControlPitch.csv.
log "YawProportional,YawIntegral,YawDerivative,YawControl" to ControlYaw.csv.
