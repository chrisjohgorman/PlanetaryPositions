# 
# This function takes M in degrees, e the eccentricity and tol a tolerance as 
# input and returns an eccentric anomaly in degrees.
#

function eccentric_anomaly(M,e,tol)
	e0 = M + (180/π) * e * sind(M) * (1 + e + cosd(M))
        e1 = e0 - (e0 - (180/π) * e * sind(e0) - M) / (1 - e * cosd(e0))
        while abs(e0-e1) > tol
		e0 = e1
		e1 = e0 - (e0 - (180/π) * e * sind(e0) -M) / (1 -e * cosd(e0))
	end
	return e1
end
