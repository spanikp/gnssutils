#!/usr/bin/env python3

import sys
import datetime as dt

def gpstime2str(GPSweek, GPSseconds, outFormat):
    gps0 = dt.datetime(1980,1,6,0,0,0)
    d = gps0 + dt.timedelta(weeks=GPSweek) + dt.timedelta(seconds=GPSseconds)
    return d.strftime(outFormat)

def loadStdin():
    data = []
    for line in sys.stdin:
        w, s = line.rstrip().split()
        w = int(w)
        s = float(s)
        data.append((w,s))
    return data

def getFormat():
    if len(sys.argv) == 2:
        return sys.argv[1]
    else:
        return "%Y/%m/%d %H:%M:%S"

if __name__ == "__main__":
    for w, s in loadStdin():
        print(gpstime2str(w,s,getFormat()))

