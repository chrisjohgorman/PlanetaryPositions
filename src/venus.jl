function venus(day_number)
	N =  76.6799 + 2.46590e-5   * day_number
	i =   3.3946 + 2.75e-8      * day_number
	w =  54.8910 + 1.38374e-5   * day_number
	a = 0.723330				
	e = 0.006773     - 1.302e-9 * day_number
	M =  48.0052 + 1.6021302244 * day_number
	M = revolve(M)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic
	
	E = eccentric_anomaly(M, e, 0.0005)
        # venus's rectrangular coordinates
        x = a * (cosd(E) - e)
        y = a * sind(E) * sqrt(1 - e*e)
        # convert to distance and true anomaly
        r = sqrt(x*x + y*y)
        v = atan(y, x) * (180/pi)
        # venus's position in ecliptic coordinates
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
	RA = RA/15
        Decl = atan(zequat, sqrt(xequat^2 + yequat^2)) * (180/pi)
        R = sqrt(xequat^2+yequat^2+zequat^2)
        # convert to ecliptic longitude and latitude
        lon = atan(yeclip, xeclip) * (180/pi)
        lon = revolve(lon)
        lat = atan(zeclip, sqrt(xeclip^2 + yeclip^2)) * (180/pi)
	return [lon, lat, r, RA, Decl, R]
end
