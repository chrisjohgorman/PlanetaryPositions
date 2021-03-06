function moon(day_number, latitude, SIDTIME)
	N = 125.1228 - 0.0529538083 * day_number # long asc. node
	i = 5.1454				  # inclination
	w = 318.0634 + 0.1643573223 * day_number # Arg. of perigree
	a = 60.2666				  # mean distance
	e = 0.054900				  # eccentricity
	M = 115.3654 + 13.0649929509 * day_number# mean anomaly
	M = revolve(M)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic

	E = eccentric_anomaly(M, e, 0.0005)
	# moon's rectrangular coordinates
	x = a * (cosd(E) - e)
	y = a * sind(E) * sqrt(1 - e*e)
	# convert to distance and true anomaly
	r = sqrt(x*x + y*y)
	v = atan(y, x) * (180/pi)
	# moon's position in ecliptic coordinates
	xeclip = r * ( cosd(N) * cosd(v+w) - sind(N) * sind(v+w) * cosd(i))
	yeclip = r * ( sind(N) * cosd(v+w) + cosd(N) * sind(v+w) * cosd(i))
	zeclip = r * sind(v+w) * sind(i)
	# convert to ecliptic longitude, latitude and distance
	lon = atan(yeclip, xeclip) * (180/pi)
	lon = revolve(lon)
	lat = atan(zeclip, sqrt(xeclip*xeclip + yeclip*yeclip)) * (180/pi)

	Sw = 282.9404 + 4.70935e-5   * day_number # sun's (longitude of 
						   # perihelion)
	Ms = 356.0470 + 0.9856002585 * day_number # sun's mean anomaly
	Ls = Sw + Ms
	Ls = revolve(Ls)
	Lm = N + w + M
	Mm = M
	D = Lm - Ls
	F = Lm - N

	perturbations_in_longitude = -1.274 * sind(Mm - 2*D) +0.658 * sind(2*D) -0.186 * sind(Ms) -0.059 * sind(2*Mm - 2*D) -0.057 * sind(Mm - 2*D + Ms) +0.053 * sind(Mm + 2*D) +0.046 * sind(2*D - Ms) +0.041 * sind(Mm - Ms) -0.035 * sind(D) -0.031 * sind(Mm + Ms) -0.015 * sind(2*F - 2*D) +0.011 * sind(Mm - 4*D)
	perturbations_in_latitude = -0.173 * sind(F - 2*D) -0.055 * sind(Mm - F - 2*D) -0.046 * sind(Mm + F - 2*D) +0.033 * sind(F + 2*D) +0.017 * sind(2*Mm + F)
	perturbations_in_distance = -0.58 * cosd(Mm - 2*D) -0.46 * cosd(2*D)
	lon = lon + perturbations_in_longitude
	lat = lat + perturbations_in_latitude
	r = r + perturbations_in_distance
	x1 = cosd(lon)*cosd(lat)
	y1 = cosd(lat)*sind(lon)
	z1 = sind(lat)
	x2 = x1
	y2 = y1 * cosd(oblecl) - z1 * sind(oblecl)
	z2 = y1 * sind(oblecl) + z1 * cosd(oblecl)
	RA = atan(y2,x2) * (180/pi)
	RA1 = RA
	RA = RA / 15
	RA = revolve_hour_angle(RA)
	Decl = atan(z2, sqrt(x2*x2 + y2*y2)) * (180/pi)
	HA = (SIDTIME - RA) * 15
	x = cosd(HA) * cosd(Decl)
	y = sind(HA) * cosd(Decl)
	z = sind(Decl)
	xhor = x * sind(latitude) - z * cosd(latitude)
	yhor = y
	zhor = x * cosd(latitude) + z * sind(latitude)
	az  = atan( yhor, xhor ) * (180/pi) + 180
	alt = asind( zhor )
	mpar = asind(1/r)
	gclat = latitude - 0.1924 * sind(2*latitude)
	rho   = 0.99833 + 0.00167 * cosd(2*latitude)
	g = atand( tand(gclat) / cosd(HA) ) 
	topRA   = RA1  - mpar * rho * cosd(gclat) * sind(HA) / cosd(Decl)
	topRA = revolve(topRA)
	topDecl = Decl - mpar * rho * sind(gclat) * sind(g - Decl) / sind(g)
       	moon_data = [topRA, topDecl, az, alt]
       	#moon_data = [RA, Decl, az, alt]
end
