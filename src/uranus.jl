function uranus(day_number)
	N =  74.0005 + 1.3978E-5    * day_number # Long of asc. node
	i =   0.7733 + 1.9E-8       * day_number # Inclination
	w =  96.6612 + 3.0565E-5    * day_number # Argument of perihelion
	a = 19.18171 - 1.55E-8      * day_number # Semi-major axis
	e = 0.047318 + 7.45E-9      * day_number # eccentricity
	M = 142.5905 + 0.011725806  * day_number # Mean anomaly Uranus
	M = revolve(M)
	Mu = M
	Ms = 316.9670 + 0.0334442282 * day_number # Mean anomaly Saturn
	Ms = revolve(Ms)
	Mj =  19.8950 + 0.0830853001 * day_number # Mean anomaly Jupiter
	Mj = revolve(Mj)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic

	E = eccentric_anomaly(M, e, 0.0005)
        # uranus's rectrangular coordinates
        x = a * (cosd(E) - e)
        y = a * sind(E) * sqrt(1 - e*e)
        # convert to distance and true anomaly
        r = sqrt(x*x + y*y)
        v = atan(y, x) * (180/pi)
        # uranus's position in ecliptic coordinates
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
        RA = atan(yequat, xequat) * (180/pi)
        RA = revolve(RA)
	RA = RA / 15
        Decl = atan(zequat, sqrt(xequat^2 + yequat^2)) * (180/pi)
        R = sqrt(xequat^2+yequat^2+zequat^2)
        # convert to ecliptic longitude and latitude
        lon = atan(yeclip, xeclip) * (180/pi)
        lon = revolve(lon)
        lat = atan(zeclip, sqrt(xeclip^2 + yeclip^2)) * (180/pi)
	perturbations_in_longitude = +0.040 * sind(Ms - 2*Mu + 6) +0.035 * sind(Ms - 3*Mu + 33) -0.015 * sind(Mj - Mu + 20)
	lon = perturbations_in_longitude + lon
	lon = revolve(lon)
	return [lon, lat, r, RA, Decl, R]
end
