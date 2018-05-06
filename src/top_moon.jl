#
# usage top_moon(RA, Decl, r, SIDTIME, latitude)
#
# this function takes the moon's RA, Decl and r,
# the sun's SIDTIME and the observer's latitude
# to provide the moon's topocentric RA and Decl
#

function top_moon(RA, Decl, r, SIDTIME, latitude)
	mpar = asind(1/r)
	gclat = latitude - 0.1924 * sind(2*latitude)
	rho = 0.99833 + 0.00167 * cosd(2*latitude)
	HA = (SIDTIME * 15) - RA
	HA = rev(HA)
	g = atand(tand(gclat) / cosd(HA))
	topRA = RA - mpar * rho * cosd(gclat)*sind(HA)/cosd(Decl)
	topDecl = Decl - mpar * rho * sind(gclat) * sind(g - Decl) / sind(g)
	top_moon_data = [topRA, topDecl]
end
