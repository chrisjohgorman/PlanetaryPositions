#
# usage: lst(gst, longitude)
#
# This function takes a grenwich sidereal time and longitude
# and returns a local sidereal time 
#

function lst(gst, longitude)
	lst = gst + longitude/15
	lst = rev_ha(lst)
	answer = lst
end
