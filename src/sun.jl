function sun(day_number, latitude, longitude, UT)
	# rotate equitorial coordinates
	coords = sun_rectangular(day_number)
	xequat = coords[1]
	yequat = coords[2] * cosd(coords[4]) - coords[3] * sind(coords[4])
	zequat = coords[2] * sind(coords[4]) + coords[3] * cosd(coords[4])

	RA = atan2(yequat, xequat) * (180/π) 
	RA = revolve(RA) 
	# convert RA to hours
	RA = RA / 15 
	Decl = atan2(zequat, sqrt(xequat^2 + yequat^2)) * (180/π)
	
	# calculate GMST0 	
	GMST0 = revolve(coords[5] + 180) / 15 

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
	azimuth = atan2(yhor, xhor) * (180/π) + 180 
	altitude = atan2(zhor, sqrt(xhor^2 + yhor^2)) * (180/π)
	return [RA, Decl, SIDTIME, azimuth, altitude] 
end
