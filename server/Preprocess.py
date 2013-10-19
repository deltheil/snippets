#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import os
import sys
import json
import urllib, urllib2
from Config import Config

# Get file contents from specified directory
def fetch(path, ext):
        data = {}
        for entry in os.listdir(path):
                entryPath = os.path.join(path, entry)
		if entryPath.endswith(ext):
			fileContent = readFile(entryPath)
			if fileContent is not None:
				data[entry] = fileContent
	return data

# Read specified file
def readFile(path):
	if os.path.isfile(path):
		with open(path, 'r') as sourceFile:
			return sourceFile.read()
	return None

# Sanitize JSON data
def printKeyVals(data, indent=0):
    if isinstance(data, list):
        print
        for item in data:
            printKeyVals(item, indent+1)
    elif isinstance(data, dict):
        print
        for k, v in data.iteritems():
            print "    " * indent, k + ":",
            printKeyVals(v, indent + 1)
    else:
        print data

# Get command summaries
def extractSummary(filePath):
	summaryCmd = readFile(filePath)
	if summaryCmd is not None:
		cmdList = json.loads(summaryCmd)
		for cmd, attr in cmdList.iteritems():
			print cmd, attr
		# TODO	
	return None

# Get command details from .md files
def extractDetail(path):
	detailCmd = fetch(path, ".md")
	# TODO
	return

# Process Pull data to conform to Model.md
def preprocess():
	summary = extractSummary(Config.summary)
	detail = extractDetail(Config.commands)
	# TODO
        return

