function mars(day_number)
    	N =  49.5574 + 2.11081e-5   * day_number
    	i =   1.8497 - 1.78e-8      * day_number
    	w = 286.5016 + 2.92961e-5   * day_number
    	a = 1.523688				
    	e = 0.093405     + 2.516e-9 * day_number
    	M =  18.6021 + 0.5240207766 * day_number
	M = revolve(M)
        oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic

	E = eccentric_anomaly(M, e, 0.0005)
        # mars's rectrangular coordinates
        x = a * (cosd(E) - e)
        y = a * sind(E) * sqrt(1 - e*e)
        # convert to distance and true anomaly
        r = sqrt(x*x + y*y)
        v = atan(y, x) * (180/pi)
        # mars's position in ecliptic coordinates
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
        Decl = atan(zequat, sqrt(xequat*xequat + yequat*yequat)) * (180/pi)
        # convert to ecliptic longitude and latitude
        lon = atan(yeclip, xeclip) * (180/pi)
        lon = revolve(lon)
        lat = atan(zeclip, sqrt(xeclip*xeclip + yeclip*yeclip)) * (180/pi)
	return [lon, lat, r, RA, Decl]
end
