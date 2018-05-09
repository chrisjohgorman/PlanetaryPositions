function jupiter(day_number)
	N = 100.4542 + 2.76854e-5   * day_number # Long of asc. node
	i =   1.3030 - 1.557e-7     * day_number # Inclination
	w = 273.8777 + 1.64505e-5   * day_number # Argument of perihelion
	a = 5.20256				 # Semi-major axis
	e = 0.048498 + 4.469e-9     * day_number # eccentricity
	M =  19.8950 + 0.0830853001 * day_number # Mean anomaly Jupiter
	M = revolve(M)
	Mj = M
	Ms = 316.9670 + 0.0334442282 * day_number # Mean anomaly Saturn
	Ms = revolve(Ms)
	Mu = 142.5905 + 0.011725806 * day_number  # Mean anomaly Uranus
	Mu = revolve(Mu)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic
	
	E = eccentric_anomaly(M, e, 0.0005)
        # jupiter's rectrangular coordinates
        x = a * (cosd(E) - e)
        y = a * sind(E) * sqrt(1 - e*e)
        # convert to distance and true anomaly
        r = sqrt(x*x + y*y)
        v = atan2(y, x)*(180/pi)
        # jupiter's position in ecliptic coordinates
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
        RA = atan2(yequat, xequat)*(180/pi)
        RA = revolve(RA)
	RA = RA/15
        Decl = atan2(zequat, sqrt(xequat*xequat + yequat*yequat))*(180/pi)
        R = sqrt(xequat^2+yequat^2+zequat^2)
        # convert to ecliptic longitude and latitude
        lon = atan2(yeclip, xeclip)*(180/pi)
        lon = revolve(lon)
        lat = atan2(zeclip, sqrt(xeclip*xeclip + yeclip*yeclip))*(180/pi)
	perturbations_of_longitude = -0.332 * sind(2*Mj - 5*Ms - 67.6) 
				     -0.056 * sind(2*Mj - 2*Ms + 21) 
				     +0.042 * sind(3*Mj - 5*Ms + 21) 
				     -0.036 * sind(Mj - 2*Ms) 
				     +0.022 * cosd(Mj - Ms) 
				     +0.023 * sind(2*Mj - 3*Ms + 52) 
				     -0.016 * sind(Mj - 5*Ms - 69)
	lon = lon + perturbations_of_longitude
	lon = revolve(lon)
	return [lon, lat, r, RA, Decl]
end
