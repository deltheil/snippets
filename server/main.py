#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import sys
import urllib, urllib2
from Pull import pull
from Retrieve import retrieve
from Diff import diff
from Update import update

# Keep Redis-doc up to date with Winch
def run():
	# pull data from redis-doc repository and store it in server file system
	pull()
	# get previous version available in winch
	retrieve()
	# check for changes to prevous version obtained from winch
	diff()
	# push updates to winch
	update()
	print "Test"
	return

# Script to be run as cron job
if __name__ == "__main__":
	run()
