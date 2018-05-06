#
# This function takes a date as input via day,
# month, and year values and returns a "day_number"
# used to calculate the position of the sun
# and planets.
#

function day_number(year,month,day)
	367*year - floor(7 * ( year + floor((month+9)/12))  / 4) + floor(275*month/9) + day - 730530
end
