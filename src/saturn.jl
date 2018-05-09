function saturn(day_number)
	N = 113.6634 + 2.38980E-5   * day_number # Long of asc. node
	i =   2.4886 - 1.081E-7     * day_number # Inclination
	w = 339.3939 + 2.97661E-5   * day_number # Argument of perihelion
	a = 9.55475				 # Semi-major axis
	e = 0.055546 - 9.499E-9     * day_number # eccentricity
	M = 316.9670 + 0.0334442282 * day_number # Mean anomaly
	M = revolve(M)
	Ms = M
	Mj = 19.8950 + 0.0830853001 * day_number # Mean anomaly Jupiter
	Mj = revolve(Mj)
	Mu = 142.5905 + 0.011725806 * day_number # Mean anomaly Uranus
	Mu = revolve(Mu)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic

	E = eccentric_anomaly(M, e, 0.0005)
	# saturn's rectrangular coordinates
	x = a * (cosd(E) - e)
	y = a * sind(E) * sqrt(1 - e*e)
	# convert to distance and true anomaly
	r = sqrt(x*x + y*y)
	v = atan2(y, x) * (180/π)
	# saturn's position in ecliptic coordinates
	xeclip = r * ( cosd(N) * cosd(v+w) - sind(N) * sind(v+w) * cosd(i))
	yeclip = r * ( sind(N) * cosd(v+w) + cosd(N) * sind(v+w) * cosd(i))
	zeclip = r * sind(v+w) * sind(i)
	# add sun's rectangular coordinates
	sunr = sun_rectangular(day_number)
	xgeoc = sunr[1] + xeclip
	ygeoc = sunr[2] + yeclip
	zgeoc = sunr[3] + zeclip
	# rotate the equitorial coordinates
	xequat = xgeoc
	yequat = ygeoc * cosd(oblecl) - zgeoc * sind(oblecl)
	zequat = ygeoc * sind(oblecl) + zgeoc * cosd(oblecl)
	# convert to RA and Decl
	RA = atan2(yequat, xequat) * (180/π)
	RA = revolve(RA)
	RA = RA / 15
	Decl = atan2(zequat, sqrt(xequat*xequat + yequat*yequat)) * (180/π)
	R = sqrt(xequat^2+yequat^2+zequat^2)
	# convert to ecliptic longitude and latitude
	lon = atan2(yeclip, xeclip) * (180/π)
	lon = revolve(lon)
	lat = atan2(zeclip, sqrt(xeclip*xeclip + yeclip*yeclip)) * (180/π)
	perturbations_in_longitude = 0.812 * sind(2*Mj - 5*Ms - 67.6) 
				    -0.229 * cosd(2*Mj - 4*Ms - 2) 
				    +0.119 * sind(Mj - 2*Ms - 3) 
				    +0.046 * sind(2*Mj - 6*Ms - 69) 
				    +0.014 * sind(Mj - 3*Ms + 32)
	perturbations_in_latitude = -0.020 * cosd(2*Mj - 4*Ms - 2) 
				    +0.018 * sind(2*Mj - 6*Ms - 49)
	lon = lon + perturbations_in_longitude
	lon = revolve(lon)
	lat = lat + perturbations_in_latitude
	lat = revolve(lat)
	return [lon, lat, r, RA, Decl, R]
end
