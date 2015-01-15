DECLARE PARAMETER body.

//Universal constants
SET gravConstant TO 6.673*10^-11.

//Body-specific constants
IF BODY = "Kerbin" {
	PRINT "Setting physical constants for Earth.".
	SET bodyRadius TO 6371000.
	SET bodyMass TO 5.97219*10^24.
	SET bodySurfaceGrav TO 9.81.
}
ELSE IF BODY = "Duna" {
	PRINT "Setting physical constants for Mars.".
	SET bodyRadius TO 3396200.
	SET bodyMass TO 6.4185*10^23.
	SET bodySurfaceGrav TO 3.69.
}
ELSE IF BODY = "Sun" {
	PRINT "Setting physical constants for Sol.".
	SET bodyRadius		TO 696342000.
	SET bodyMass		TO 1.9886*10^30.
	SET bodySurfaceGrav TO 274.
}
ELSE {
	PRINT "Error: invalid body!".
}.

SET bodyStdGravParam to gravConstant*bodyMass.

