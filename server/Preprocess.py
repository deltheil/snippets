#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import os
import sys
import json
import subprocess
import urllib, urllib2
from Config import Config

# Structure to hold data per command
blob = {}


# Read specified file
def readFile(path):
	if os.path.isfile(path):
		with open(path, 'r') as sourceFile:
			return sourceFile.read()
	return None


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


# Sanitize JSON data
def sanitize(data, indent=0):
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
		cmdList = {}
		rawCmdList = json.loads(summaryCmd)
		for cmd, rawAttr in rawCmdList.iteritems():
			print cmd, rawAttr
		#cmdList = sanitize(rawCmdList)
		# TODO
		return cmdList	
	return None

# Execute pandoc command in python
def pandoc(arg):
	p = subprocess.Popen(['pandoc', '--to=html', '--from=markdown'], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
	return p.communicate(arg)[0]

# Get command details from .md files and extract CLI data and MarkDown
def extractDetail(path):
	detailCmd = fetch(path, ".md")
	for cmd, rawDetail in detailCmd.iteritems():
		cli = []
		markDown = ""
		# parse to ge MarkDown and CLI data
		detail = rawDetail.split("```")
		for x in xrange(0, len(detail), 2):
			markDown += detail[x]
		markDown = markDown.replace("@","## ")
		html = pandoc(markDown)
		for x in xrange(1, len(detail), 2):
			cliExmpl = detail[x]
			if cliExmpl[:3] == "cli":
				cli.append(cliExmpl[3:])
			else:
				cli.append(cliExmpl)
		#generate html from markDown
		if cmd not in blob:
			blob[cmd] = {}
		if "html" not in blob[cmd]:
			blob[cmd]["html"] = ""
		html = html + blob[cmd]["html"]
		blob[cmd]["html"] = html
		if "cli" not in blob[cmd]:
			blob[cmd]["cli"] = []
		cli = cli + blob[cmd]["cli"]
		blob[cmd]["cli"] = cli
		print blob[cmd]["html"]
	return

# Process Pull data to conform to Model.md
def preprocess():
	#summary = extractSummary(Config.summary)
	extractDetail(Config.commands)
	# TODO
        return

