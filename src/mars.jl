
#
# this function takes a day number from the 
# day_number function and uses it to calculate
# mars's latitude, longitude, distance, 
# right ascension and Declination. It returns an 
# array of these values
#

function mars(day_number)
    	node =  49.5574 + 2.11081e-5 * day_number
    	inclination = 1.8497 - 1.78e-8 * day_number
    	argument_of_perihelion = 286.5016 + 2.92961e-5 * day_number
    	axis = 1.523688	
    	eccentricity = 0.093405 + 2.516e-9 * day_number
    	mean_anomaly =  18.6021 + 0.5240207766 * day_number
	mean_anomaly = revolve(mean_anomaly)
        obliquity_of_ecliptic = 23.4393 - 3.563e-7 * day_number 

	EccentricAnomaly = eccentric_anomaly(mean_anomaly, eccentricity, 0.0005)
        # mars's rectrangular coordinates
        x = axis * (cosd(EccentricAnomaly) - eccentricity)
        y = axis * sind(EccentricAnomaly) * sqrt(1 - eccentricity^2)
        # convert to distance and true anomaly
        distance = sqrt(x*x + y*y)
        true_anomaly = atan2(y, x) * (180/pi)
        # mars's position in ecliptic coordinates
        x_ecliptic = distance * ( cosd(node) 
		* cosd(true_anomaly + argument_of_perihelion) 
		- sind(node) * sind(true_anomaly + argument_of_perihelion) 
		* cosd(inclination))
        y_ecliptic = distance * ( sind(node) 
		* cosd(true_anomaly + argument_of_perihelion) 
		+ cosd(node) * sind(true_anomaly + argument_of_perihelion) 
		* cosd(inclination))
        z_ecliptic = distance * (sind(true_anomaly + argument_of_perihelion)
		* sind(inclination))
        # add sun's rectangular coordinates
        SunRectangular = sun_rectangular(day_number)
        x_geocentric = SunRectangular[1] + x_ecliptic
        y_geocentric = SunRectangular[2] + y_ecliptic
        z_geocentric = SunRectangular[3] + z_ecliptic
        # rotate the equitorial coordinates
        x_equatorial = x_geocentric
        y_equatorial = y_geocentric * cosd(obliquity_of_ecliptic) - z_geocentric * sind(obliquity_of_ecliptic)
        z_equatorial = y_geocentric * sind(obliquity_of_ecliptic) + z_geocentric * cosd(obliquity_of_ecliptic)
        # convert to right_ascesion and Decl
        right_ascesion = atan2(y_equatorial, x_equatorial) * (180/pi)
        right_ascesion = revolve(right_ascesion)
	right_ascesion = right_ascesion / 15
        declination = atan2(z_equatorial, sqrt(x_equatorial^2 + y_equatorial^2)) * (180/pi)
        # convert to ecliptic longitude and latitude
        longitude = atan2(y_ecliptic, x_ecliptic) * (180/π)
        longitude = revolve(longitude)
        latitude = atan2(z_ecliptic, sqrt(x_ecliptic^2 + y_ecliptic^2)) *(180/pi)
	return [longitude, latitude, distance, right_ascesion, declination]
end
