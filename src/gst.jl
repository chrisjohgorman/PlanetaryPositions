#
# usage: gst(julian_day, UT)
#
# This function takes a julian date and 
# decimal time for grenwich and returns a 
# sidereal time for that day and time
#

function gst(julian_day, UT)
	T = (julian_day - 2451545.0)/36525.0
	T_0 = 6.697374558+ (2400.051336*T)+(0.000025862*T^2)+(UT*1.0027379093)
	T_0 = rev_ha(T_0)
	answer = T_0
end
