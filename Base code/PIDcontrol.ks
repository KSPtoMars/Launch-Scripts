//NAME: PIDcontrol.ks
//Script that returns values (outputs) based on setpoints and sensor values(inputs) 

/// *** DEPENDENCIES ***
//None.

/// *** INPUTS ***
//error - the error that this function is attempting to minimize
//pGain - the gain for the proportional term
//iGain - the gain for the integral term
//dGain - the gain for the derivative term
//integralSum - the integral summation for the integral term
//lastError - the error value (setpoint - output) at the last iteration of this function
//dt - the time difference between the last iteration of this function

/// *** OUTPUTS *** (Variables you will need later on)
//PIDcontrol_output - the output value based on the PID control settings
//PIDcontrol_integralSum - the updated integral summation. This should be passed to integralSum on the next iteration of this function.

DECLARE PARAMETER error, pGain, iGain, dGain, integralSum, lastError, dt.

SET PIDcontrol_integralSum TO (integralSum + error * dt).

//Combined PID calculation
SET PIDcontrol_output TO pGain * error + iGain * PIDcontrol_integralSum + dGain * (error - lastError)/dt.