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


# Get command summaries
def extractSummary(filePath):
	summaryCmd = readFile(filePath)
	if summaryCmd is not None:
		cmdList = {}
		rawCmdList = json.loads(summaryCmd)
		for cmd, rawAttr in rawCmdList.iteritems():
			group = ""
			arguments = []
			complexity = ""
			summary = ""
			since = ""
			if "group" in rawAttr:
				group = rawAttr["group"]
			if "arguments" in rawAttr:
				for item in rawAttr["arguments"]:
					arguments.append(item)
			if "complexity" in rawAttr:
				complexity = rawAttr["complexity"]
			if "summary" in rawAttr:
				summary = rawAttr["summary"]
			if "since" in rawAttr:
				since = rawAttr["since"]
			if cmd not in blob:
				blob[cmd] = {}
			if "group" not in blob[cmd]:
				blob[cmd]["group"] = ""
			group = group + blob[cmd]["group"]
			blob[cmd]["group"] = group
			if "arguments" not in blob[cmd]:
				blob[cmd]["arguments"] = []
			arguments = arguments + blob[cmd]["arguments"]
			blob[cmd]["arguments"] = arguments
			if "complexity" not in blob[cmd]:
				blob[cmd]["complexity"] = ""
			complexity = complexity + blob[cmd]["complexity"]
			blob[cmd]["complexity"] = complexity
			if "summary" not in blob[cmd]:
				blob[cmd]["summary"] = ""
			summary = summary + blob[cmd]["summary"]
			blob[cmd]["summary"] = summary
			if "since" not in blob[cmd]:
				blob[cmd]["since"] = ""
			since = since + blob[cmd]["since"]
			blob[cmd]["since"] = since
	return


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
	return


# Process Pull data to conform to Model.md
def preprocess():
	extractSummary(Config.summary)
	extractDetail(Config.commands)
	# Use data from blob to define namespaces
        return

