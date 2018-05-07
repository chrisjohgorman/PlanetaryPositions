#
# usage  jupiter(day_number)
#
# this function takes a day number from the 
# day_number function and uses it to calculate
# Jupiter's latitude, longitude and distance, right ascension
# declination and R. It returns an array of these values 
#

function jupiter(day_number)
	node = 100.4542 + 2.76854e-5 * day_number	# Long of asc. node
	inclination = 1.3030 - 1.557e-7  * day_number
	argument_of_perihelion = 273.8777 + 1.64505e-5 * day_number
	axis = 5.20256					# Semi-major axis
	eccentricity = 0.048498 + 4.469e-9 * day_number
	mean_anomaly=  19.8950 + 0.0830853001 * day_number
	# FIXME change script name from rev to revolve
	mean_anomaly = rev(mean_anomaly)
	mean_anomaly_jupiter = mean_anomaly
	mean_anomaly_saturn = 316.9670 + 0.0334442282 * day_number
	mean_anomaly_saturn = rev(mean_anomaly_saturn)
	mean_anomaly_uranus = 142.5905 + 0.011725806 * day_number
	mean_anomaly_uranus = rev(mean_anomaly_uranus)
	obliquity_of_ecliptic = 23.4393 - 3.563e-7 * day_number 
	
	EccentricAnomaly = eccentric_anomaly(mean_anomaly, eccentricity, 0.0005)
        # jupiter's rectrangular coordinates
        x = axis * (cosd(EccentricAnomaly) - eccentricity)
        y = axis * sind(EccentricAnomaly) * sqrt(1 - eccentricity^2)
        # convert to distance and true anomaly
        distance = sqrt(x*x + y*y)
        true_anomaly = atan2(y, x)
        # jupiter's position in ecliptic coordinates
        x_ecliptic = distance * ( cosd(node) 
		* cosd(true_anomaly + argument_of_perihelion) 
		- sind(node) * sind(true_anomaly + argument_of_perihelion) 
		* cosd(inclination))
        y_ecliptic = distance * ( sind(node) 
		* cosd(true_anomaly + argument_of_perihelion) 
		+ cosd(node) * sind(true_anomaly + argument_of_perihelion) 
		* cosd(inclination))
        z_ecliptic = distance * sind(true_anomaly + argument_of_perihelion) * sind(inclination)
        # add sun's rectangular coordinates
        SunRectangular = sun_rectangular(day_number)
        x_geocentric = SunRectangular[1] + x_ecliptic
        y_geocentric = SunRectangular[2] + y_ecliptic
        z_geocentric = SunRectangular[3] + z_ecliptic
        # rotate the equitorial coordinates
        x_equatorial = x_geocentric
        y_equatorial = y_geocentric * cosd(obliquity_of_ecliptic) 
		- z_geocentric * sind(obliquity_of_ecliptic)
        z_equatorial = y_geocentric * sind(obliquity_of_ecliptic) 
		+ z_geocentric * cosd(obliquity_of_ecliptic)
        # convert to right_ascension and declination
        right_ascension = atan2(y_equatorial, x_equatorial)
        right_ascension = rev(right_ascension)
	right_ascension = right_ascension/15
        declination = atan2(z_equatorial, sqrt(x_equatorial^2 + y_equatorial^2))
	#FIXME do we need this variable?
        R = sqrt(x_equatorial^2+y_equatorial^2+z_equatorial^2)
        # convert to ecliptic longitude and latitude
        longitude = atan2(y_ecliptic, x_ecliptic)
        longitude = rev(longitude)
        latitude = atan2(z_ecliptic, sqrt(x_ecliptic^2 + y_ecliptic^2))
	perturbations_of_longitude = -0.332 * sind(2*mean_anomaly_jupiter 
		- 5*mean_anomaly_saturn - 67.6) -0.056 * sind(2*mean_anomaly_jupiter 
		- 2*mean_anomaly_saturn + 21) +0.042 * sind(3*mean_anomaly_jupiter 
		- 5*mean_anomaly_saturn + 21) -0.036 * sind(mean_anomaly_jupiter 
		- 2*mean_anomaly_saturn) +0.022 * cosd(mean_anomaly_jupiter 
		- mean_anomaly_saturn) +0.023 * sind(2*mean_anomaly_jupiter 
		- 3*mean_anomaly_saturn + 52) -0.016 * sind(mean_anomaly_jupiter 
		- 5*mean_anomaly_saturn - 69)
	longitude = longitude + perturbations_of_longitude
	longitude = rev(longitude)
	jupiter = [longitude, latitude, distance, right_ascension, declination, R]
end
