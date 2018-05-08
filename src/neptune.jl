#
# usage neptune(day_number)
#
# this function takes a day number from the 
# day_number function and uses it to calculate
# the neptune's Right Ascension and Declination.
# It returns RA, Decl and r 
#

function neptune(day_number)
	N = 131.7806 + 3.0173E-5    * day_number
	i =   1.7700 - 2.55E-7      * day_number
	w = 272.8461 - 6.027E-6     * day_number
	a = 30.05826 + 3.313E-8     * day_number
	e = 0.008606 + 2.15E-9      * day_number
	M = 260.2471 + 0.005995147  * day_number
	M = revolve(M)
        oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic
	
	E = eccentric_anomaly(M, e, 0.0005)
        # neptune's rectrangular coordinates
        x = a * (cosd(E) - e)
        y = a * sind(E) * sqrt(1 - e*e)
        # convert to distance and true anomaly
        r = sqrt(x*x + y*y)
        v = atan2(y, x) * (180/pi)
        # neptune's position in ecliptic coordinates
        xeclip = r * ( cosd(N) * cosd(v+w) - sind(N) * sind(v+w) * cosd(i))
        yeclip = r * ( sind(N) * cosd(v+w) + cosd(N) * sind(v+w) * cosd(i))
        zeclip = r * sind(v+w) * sind(i)
        # add sun's rectangular coordinates
        sunr = sun_rectangular(day_number)
        xgeoc = sunr(1) + xeclip
        ygeoc = sunr(2) + yeclip
        zgeoc = sunr(3) + zeclip
        # rotate the equitorial coordinates
        xequat = xgeoc
        yequat = ygeoc * cosd(oblecl) - zgeoc * sind(oblecl)
        zequat = ygeoc * sind(oblecl) + zgeoc * cosd(oblecl)
        # convert to RA and Decl
        RA = atan2(yequat, xequat) * (180/pi)
        RA = revolve(RA)
	RA = RA / 15
        Decl = atan2(zequat, sqrt(xequat*xequat + yequat*yequat)) *(180/pi)
        R = sqrt(xequat^2+yequat^2+zequat^2)
        # convert to ecliptic longitude and latitude
        lon = atan2(yeclip, xeclip) * (180/pi)
        lon = revolve(lon)
        lat = atan2(zeclip, sqrt(xeclip*xeclip + yeclip*yeclip)) * (180/pi)
	return [lon, lat, r, RA, Decl, R]
endfunction
