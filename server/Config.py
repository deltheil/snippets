#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import sys
import urllib, urllib2

# All configuraton related stuff goes here
class Config():
	
	# Define variables for configuration
	ds = "snippets_db"
	sourceURI = "git://github.com/antirez/redis-doc"
	targetFile = "dump.sp"
	source = "source"
	target = "target"
	commands = source + "/commands"
	summary = commands + ".json"
	ns_types = "rds:types"
	ns_cmds = "rds:cmds"
	ns_cmds_html = "rds:cmds_html"
	
