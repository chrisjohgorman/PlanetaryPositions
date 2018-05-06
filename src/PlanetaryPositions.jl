module PlanetaryPositions

latitude = 45.365624
longitude = -75.790013

day = day_number(1999,4,19)
utc_time = 0

su = sun(day,latitude,longitude,utc_time)
me = mercury(day)
ve = venus(day)
moon_az_alt = moon(day,latitude,su(3))
ma = mars(day)
ju = jupiter(day)
sa = saturn(day)
ur = uranus(day)
ne = neptune(day)

mercury_az_alt = az_alt(su(3),me(4),me(5),latitude)
venus_az_alt = az_alt(su(3),ve(4),ve(5),latitude)
mars_az_alt = az_alt(su(3),ma(4),ma(5),latitude)
jupiter_az_alt = az_alt(su(3),ju(4),ju(5),latitude)
saturn_az_alt = az_alt(su(3),sa(4),sa(5),latitude)
uranus_az_alt = az_alt(su(3),ur(4),ur(5),latitude)
neptune_az_alt = az_alt(su(3),ne(4),ne(5),latitude)

end # module
