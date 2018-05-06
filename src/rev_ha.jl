#
# usage: rev_ha(hour)
#
# This function takes a hour value, either 
# negative or positive and returns that value
# as a number between 0 and 24.
#

function rev_ha(hour)
	answer = hour - floor(hour/24)*24
end
