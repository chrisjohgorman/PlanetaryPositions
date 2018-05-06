#
# This function takes a degree value, either 
# negative or positive and returns that value
# as a number between 0 and 360.
#

function rev(degree)
	degree - floor(degree/360)*360
end
