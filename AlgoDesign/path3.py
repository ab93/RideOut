
import math

class Location:
    def __init__(self,lat,long):
        self.lat = lat
        self.long = long

class Person:
    def __init__(self,ID):
        self.ID = ID
        #self.name = name
        #self.email = email
        #self.type = ''

class Rider(Person):
    def __init__(self,ID,source,destination,startTime,tripTime):
        Person.__init__(self,ID)
        self.source = source
        self.destination = destination
        self.startTime = startTime
        self.tripTime = tripTime

class Driver(Person):
    def __init__(self,ID,source,destination,startTime,tripTime,wayPoints):
        Person.__init__(self,ID)
        self.source = source
        self.destination = destination
        self.startTime = startTime
        self.tripTime = tripTime
        self.wayPoints = wayPoints

def latlong_XYZ(lat,long):
    

def findRides(R):


