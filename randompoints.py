from random import randrange
import os

here = os.path.dirname(os.path.abspath(__file__))

randpointsfilename = os.path.join(here, 'randompoints.m2')

class P1Point:

    def __init__(self, xInit, yInit):
        assert xInit !=0 or yInit != 0, "Projective space does not contain (0,0)"
        self.x = xInit
        self.y = yInit

    def __eq__(self, other):
        if self.x != 0 and other.x != 0:
            return self.y/self.x == other.y/other.x
        if self.y != 0 and other.y != 0:
            return self.x/self.y == other.x/other.y
        else: 
            return False
    
    def __str__(self):
        return str([self.x, self.y])
    
    def __repr__(self):
        return str(self)
        

def pointPairM2Code(point1, point2):
    return "ideal({}*x_0-{}*x_1,{}*x_2-{}*x_3)".format(point1.y,point1.x, point2.y, point2.x)

def makeRandomPoints(numPoints, gridSize):
    pointList = []
    i = 0
    while len(pointList) < numPoints:
        newCoords = [randrange(gridSize), randrange(gridSize)]
        if newCoords != [0,0]:
            newPoint = P1Point(newCoords[0], newCoords[1])
            if newPoint not in pointList:
                pointList.append(newPoint)
    return pointList

def writeRandPointsM2(numpoints, gridSize):
    pointList = [[p1, p2] for [p1, p2] in zip(makeRandomPoints(numpoints, gridSize), makeRandomPoints(numpoints, gridSize))]
    with open(randpointsfilename, 'w') as file:
        for i in range(numpoints):
            file.write('rP{} = {}'.format(i+1, pointPairM2Code(pointList[i][0], pointList[i][1])) + '\n')
        file.write('\n')
        file.write('rI2 = intersect(rP1, rP2)' + '\n')
        for i in range(3,numpoints+1):
            file.write('rI{} = intersect(rI{}, rP{})'.format(i, i-1, i) + '\n')

#Make 10 random points in P1 x P1
writeRandPointsM2(10, 10)

#Run tests on them, write the results to results.txt
os.system("M2 --script runtests.m2")

