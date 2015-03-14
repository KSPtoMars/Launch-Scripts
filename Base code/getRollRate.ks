//NAME: getRollRate.ks
//Script that returns the roll rate of the ship

/// *** DEPENDENCIES ***
//None.

/// *** INPUTS ***
//None.

/// *** OUTPUTS *** (Variables you will need later on)
//getRollRate_rollRate - The current roll rate of the ship. Positive is clockwise, negative is anti-clockwise.

Set getRollRate_timeInterval TO 0.1.

SET getRollRate_tVec TO SHIP:FACING:TOPVECTOR.
WAIT getRollRate_timeInterval.
SET getRollRate_tVec2 TO SHIP:FACING:TOPVECTOR.

SET getRollRate_componentRoll TO vectorangle(VCRS(getRollRate_tVec,getRollRate_tVec2),SHIP:FACING:FOREVECTOR).
SET getRollRate_rollRate TO vectorangle(getRollRate_tVec,getRollRate_tVec2) * cos(getRollRate_componentRoll)/0.1.
	