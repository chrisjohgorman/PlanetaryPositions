#
# usage: julian(year, month, day)
#
# This function takes a date value and returns
# the julian date for that particular day.
#

function julian(year, month, day)
	if ((month == 1) || (month == 2))
		year = year - 1
		month = month + 12
	endif 
	A = floor(year/100)
	B = 2 - A + floor(A/4)
	C = floor(365.25*year)
	E = floor(30.6001*(month + 1))
	JD = B + C + day + E + 1720994.5
	answer = JD
end
