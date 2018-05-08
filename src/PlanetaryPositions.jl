module PlanetaryPositions

export day_number, revolve, revolve_hour_angle, altitude_azimuth, eccentric_anomaly, sun_rectangular, latitude, longitude, utc_time 


#latitude = 45.365624
#longitude = -75.790013

#day = day_number(1999,4,19)
#utc_time = 0

#su = sun(day,latitude,longitude,utc_time)
#me = mercury(day)
#ve = venus(day)
#moon_altitude_azimuth = moon(day,latitude,su(3))
#ma = mars(day)
#ju = jupiter(day)
#sa = saturn(day)
#ur = uranus(day)
#ne = neptune(day)

#mercury_altitude_azimuth = altitude_azimuth(su(3),me(4),me(5),latitude)
#venus_altitude_azimuth = altitude_azimuth(su(3),ve(4),ve(5),latitude)
#mars_altitude_azimuth = altitude_azimuth(su(3),ma(4),ma(5),latitude)
#jupiter_altitude_azimuth = altitude_azimuth(su(3),ju(4),ju(5),latitude)
#saturn_altitude_azimuth = altitude_azimuth(su(3),sa(4),sa(5),latitude)
#uranus_altitude_azimuth = altitude_azimuth(su(3),ur(4),ur(5),latitude)
#neptune_altitude_azimuth = altitude_azimuth(su(3),ne(4),ne(5),latitude)

#
# This function takes a date as input via day,
# month, and year values and returns a "day_number"
# used to calculate the position of the sun
# and planets.
#

function day_number(year,month,day)
	367*year - floor(7 * ( year + floor((month+9)/12))  / 4) + floor(275*month/9) + day - 730530
end
#
# This function takes a degree value, either 
# negative or positive and returns that value
# as a number between 0 and 360.
#

function revolve(degree)
	return	degree - floor(degree/360)*360
end
# 
# This function takes M in degrees, e the eccentricity and tol a tolerance as 
# input and returns an eccentric anomaly in degrees.
#

function eccentric_anomaly(M,e,tol)
	e0 = M + (180/π) * e * sind(M) * (1 + e + cosd(M))
        e1 = e0 - (e0 - (180/π) * e * sind(e0) - M) / (1 - e * cosd(e0))
        while abs(e0-e1) > tol
		e0 = e1
		e1 = e0 - (e0 - (180/π) * e * sind(e0) -M) / (1 -e * cosd(e0))
	end
	return e1
end
#
# usage sun_rectangular (day_number, latitude, longitude)
#
# this function takes a day number from the 
# day_number function and uses it to calculate
# the sun's Right Ascension and Declination, the
# local sidereal time SIDTIME and then calculates 
# the sun's azimuth and altitude
# it returns sun_rectangular_data = [RA, Decl, SIDTIME, azimuth, altitude]
#

function sun_rectangular(day_number)
	w = 282.9404 + 4.70935e-5 * day_number   # longitude of perihelion
	a = 1                                    # mean distance, a.u.
	e = 0.016709 - 1.151e-9 * day_number     # eccentricity
	M = 356.0470 + 0.9856002585 * day_number # mean anomaly
	M = revolve(M)
	oblecl = 23.4393 - 3.563e-7 * day_number # obliquity of the eliptic
	L = w + M				  # sun's mean longitude
	L = revolve(L)
	# sun's eccentric anomaly
	E = M + (180/π) * e * sind(M) * (1 + e * cosd(M))
	# sun's rectrangular coordinates
	x = cosd(E) - e
	y = sind(E) * sqrt(1 - e*e)
	# convert to distance and true anomaly
	r = sqrt(x*x + y*y)
	v = atan2(y, x) * (180/pi)
	# sun's longitude
	lon = v + w
	lon = revolve(lon)
	# sun's ecliptic rectangular coordinates
	x1 = r * cosd(lon)
	y1 = r * sind(lon)
	z1 = 0
	return [x1,y1,z1]
end

#
# usage: revolve_hour_angle(hour)
#
# This function takes a hour value, either 
# negative or positive and returns that value
# as a number between 0 and 24.
#

function revolve_hour_angle(hour)
	answer = hour - floor(hour/24)*24
end
#
# convert from right_ascension and decliantion to altitude and azimuth
# 

function altitude_azimuth(sidereal_time,right_ascension,declination,latitude)
	hour_angle = sidereal_time - right_ascension
	hour_angle = revolve_hour_angle(hour_angle)
	hour_angle = hour_angle * 15
	x = cosd(hour_angle)*cosd(declination)
	y = sind(hour_angle)*cosd(declination)
	z = sind(declination)
	x_horizon = x * sind(latitude) - z * cosd(latitude)
	y_horizon = y
	z_horizon = x * cosd(latitude) + z * sind(latitude)
	azimuth = atan2(y_horizon,x_horizon) * (180/pi) + 180 
	#altitude = atan2(z_horizon, sqrt(x_horizon^2+y_horizon^2)) * (180*pi)
	altitude = asind(z_horizon)
	return [altitude, azimuth]
end

end # module
