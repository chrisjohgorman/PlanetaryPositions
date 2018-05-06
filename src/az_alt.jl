#
# convert from RA and Decliantion to altitude and azimuth
# 

function az_alt(SIDTIME,RA,Decl,latitude)
	HA = SIDTIME - RA
	HA = rev_ha(HA)
	HA = HA * 15
	x = cosd(HA)*cosd(Decl)
	y = sind(HA)*cosd(Decl)
	z = sind(Decl)
	xhor = x * sind(latitude) - z * cosd(latitude)
	yhor = y
	zhor = x * cosd(latitude) + z * sind(latitude)
	azimuth = atan2(yhor,xhor) + 180
	altitude = atan2(zhor, sqrt(xhor*xhor+yhor*yhor))
	az_alt_data = [azimuth, altitude]
endfunction
