#
# convert from right_ascension and decliantion to altitude and azimuth
# 

function altitude_azimuth(sidreal_time,right_ascension,declination,latitude)
	hour_angle = sidreal_time - right_ascension
	# FIXME change script rev_ha to revolve_hour_angle
	hour_angle = rev_ha(hour_angle)
	hour_angle = hour_angle * 15
	x = cosd(hour_angle)*cosd(declination)
	y = sind(hour_angle)*cosd(declination)
	z = sind(declination)
	x_horizon = x * sind(latitude) - z * cosd(latitude)
	y_horizon = y
	z_horizon = x * cosd(latitude) + z * sind(latitude)
	azimuth = atan2(y_horizon,x_horizon) + 180
	altitude = atan2(z_horizon, sqrt(x_horizon*x_horizon+y_horizon*y_horizon))
	altitude_azimuth = [altitude, azimuth]
end
