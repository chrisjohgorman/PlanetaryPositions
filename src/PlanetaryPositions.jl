module PlanetaryPositions

export revolve, revolve_hour_angle, altitude_azimuth, eccentric_anomaly, sun_rectangular

include("sun.jl")
include("moon.jl")
include("mercury.jl")
include("venus.jl")
include("mars.jl")
include("jupiter.jl")
include("saturn.jl")
include("uranus.jl")
include("neptune.jl")

function day_number(year,month,day)
	367*year - floor(7 * ( year + floor((month+9)/12))  / 4) + floor(275*month/9) + day - 730530
end

function revolve(degree)
	return	degree - floor(degree/360)*360
end

function eccentric_anomaly(M,e,tol)
	e0 = M + (180/π) * e * sind(M) * (1 + e + cosd(M))
        e1 = e0 - (e0 - (180/π) * e * sind(e0) - M) / (1 - e * cosd(e0))
        while abs(e0-e1) > tol
		e0 = e1
		e1 = e0 - (e0 - (180/π) * e * sind(e0) -M) / (1 -e * cosd(e0))
	end
	return e1
end

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
	return [x1,y1,z1,oblecl,L]
end

function revolve_hour_angle(hour)
	answer = hour - floor(hour/24)*24
end

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
	altitude = asind(z_horizon)
	return [altitude, azimuth]
end

end # module
