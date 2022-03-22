needs "loaddifferencematrix.m2"

-- Define X = P^1xP^1 and S = Cox(X)
X = toricProjectiveSpace(1,CoefficientRing=>ZZ/32003)**toricProjectiveSpace(1,CoefficientRing=>ZZ/32003)
S = ring X
B = ideal X

load "randompoints.m2"

file = openOutAppend "results.txt" << ""

file << toString(netList nvirtualposet(rI4,rI6)) << endl

file << close

