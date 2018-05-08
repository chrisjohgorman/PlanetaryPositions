#
# usage sun(day_number, latitude, longitude, UT)
# Takes the day, latitude, longitude and grenwich mean time and returns
# right ascention, declination, sidreal time, altitude and azimuth
#

function sun(day_number, latitude, longitude, UT)
	w = 282.9404 + 4.70935e-5 * day_number    # longitude of perihelion
	a = 1                                    # mean distance, a.u.
	e = 0.016709 - 1.151e-9 * day_number      # eccentricity
	M = 356.0470 + 0.9856002585 * day_number  # mean anomaly
	M = revolve(M) 
	oblecl = 23.4393 - 3.563e-7 * day_number  # obliquity of the eliptic
	L = w + M 				 # sun's mean longitude
	L = revolve(L) 
	# sun's eccentric anomaly
	E = M + (180/pi) * e * sind(M) * (1 + e * cosd(M)) 
	# sun's rectrangular coordinates
	x = cosd(E) - e 
	y = sind(E) * sqrt(1 - e*e) 
	# convert to distance and true anomaly
	r = sqrt(x*x + y*y) 
	v = atan2(y, x)*(180/pi) 
	# sun's longitude
	lon = v + w 
	lon = revolve(lon) 
	# sun's ecliptic rectangular coordinates
	x1 = r * cosd(lon) 
	y1 = r * sind(lon) 
	z1 = 0 
	# rotate equitorial coordinates
	xequat = x1 
	yequat = y1 * cosd(oblecl) - z1 * sind(oblecl) 
	zequat = y1 * sind(oblecl) + z1 * cosd(oblecl) 

	RA = atan2(yequat, xequat) * (180/pi) 
	RA = revolve(RA) 
	# convert RA to hours
	RA = RA / 15 
	Decl = atan2(zequat, sqrt(xequat*xequat + yequat*yequat)) * (180/pi)
	
	# calculate GMST0 	
	GMST0 = revolve(L + 180) / 15 
	#UT = UT 

	# calculate SIDTIME and Hour Angle
	SIDTIME = GMST0 + UT + longitude/15 
	#SIDTIME = revolve_ha(SIDTIME)
	HA = (SIDTIME - RA) * 15 

	# convert HA and Decl to rectangular system
	x2 = cosd(HA) * cosd(Decl) 
	y2 = sind(HA) * cosd(Decl) 
	z2 = sind(Decl) 

	# rotate this along the y2 axis
	xhor = x2 * sind(latitude) - z2 * cosd(latitude) 
	yhor = y2 
	zhor = x2 * cosd(latitude) + z2 * sind(latitude) 

	# finally calculate azimuth and altitude 
	azimuth = atan2(yhor, xhor) * (180/pi) + 180 
	altitude = atan2(zhor, sqrt(xhor*xhor + yhor*yhor)) * (180/pi)
	return [RA, Decl, SIDTIME, azimuth, altitude] 
end
