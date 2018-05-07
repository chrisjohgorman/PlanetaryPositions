#
# usage: gst(julian_day, universal_time)
#
# This function takes a julian date and 
# decimal time for grenwich and returns a 
# sidereal time for that day and time
#

function gst(julian_day, universal_time)
	time = (julian_day - 2451545.0)/36525.0
	time_0 = 6.697374558+ (2400.051336*time)+(0.000025862*time^2)
		+(universal_time*1.0027379093)
	time_0 = rev_ha(time_0)
	answer = time_0
end
