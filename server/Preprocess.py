#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import os
import sys
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


# Process Pull data to conform to Model.md
def preprocess():
	summaryCmd = readFile(Config.summary)
	detailCmd = fetch(Config.commands, ".md")
	
        return

