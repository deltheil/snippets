#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import sys
import subprocess
import urllib, urllib2
from Config import Config

# Execute git command in python
def git(*args):
	return subprocess.check_call(['git'] + list(args))

# Pull data from redis-doc repository and store it in server file system
def pull():
	git("clone", Config.sourceURI, Config.source)
        return

