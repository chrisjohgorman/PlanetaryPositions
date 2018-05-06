#
# usage mercury(day_number)
#
# this function takes a day number from the 
# day_number function and uses it to calculate
# the mercury's Right Ascension and Declination.
# It returns RA, Decl
#

function mercury(day_number)
	N =  48.3313 + 3.24587e-5   * day_number   # (Long of asc. node)
	i =   7.0047 + 5.00e-8      * day_number   # (Inclination)
	w =  29.1241 + 1.01444e-5   * day_number   # (Argument of perihelion)
	a = 0.387098                               # (Semi-major axis)
	e = 0.205635 + 5.59e-10     * day_number   # (Eccentricity)
	M = 168.6562 + 4.0923344368 * day_number   # (Mean anonaly)
	M = rev(M)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic

	E = eccentric_anomaly(M, e, 0.0005)
        # mercury's rectrangular coordinates
        x = a * (cosd(E) - e)
        y = a * sind(E) * sqrt(1 - e*e)
        # convert to distance and true anomaly
        r = sqrt(x*x + y*y)
        v = atan2(y, x)
        # mercury's position in ecliptic coordinates
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
	RA = atan2(yequat, xequat)
	RA = rev(RA)
	RA = RA/15
	Decl = atan2(zequat, sqrt(xequat*xequat + yequat*yequat))
	R = sqrt(xequat^2+yequat^2+zequat^2)
        # convert to ecliptic longitude and latitude
        lon = atan2(yeclip, xeclip)
        lon = rev(lon)
        lat = atan2(zeclip, sqrt(xeclip*xeclip + yeclip*yeclip))

	mercury_data = [lon, lat, r, RA, Decl, R]
end
