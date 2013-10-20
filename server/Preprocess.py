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


# Store data in specified path
def store(obj, path):
	entry = Config.targetFile
	entryPath = os.path.join(path, entry)
	if not os.path.exists(path):
		os.makedirs(path)
	with open(entryPath, 'w') as outfile:
		json.dump(obj, outfile)
	return


# Write data for rds:types namespace
def writeTypes(path):
	path = path + "/" + Config.ns_types.split(":")[1]
	rdsTypes = {}
	rdsGroups = {}
	for cmd, attr in blob.iteritems():
		group = ""
		command = cmd.lower()
		val = [command]
		if "group" in attr:
			group = attr["group"]
			if group in rdsGroups:
				val = val + rdsGroups[group]
			rdsGroups[group] = val
	sortedTypes = sorted(rdsGroups.keys())
	numTypes = len(sortedTypes)
	numDigits = len(str(abs(numTypes))) + 2
	ind = 1
	for type in sortedTypes:
		index = str(ind).zfill(numDigits)
		name = type
		cmds = rdsGroups[type]
		val = {"name" : name, "cmds" : cmds}
		if index not in rdsTypes:
			rdsTypes[index] = val
		ind = ind + 1
	store(rdsTypes, path)
	return


# Write data for rds:cmds namespace
def writeCmds(path):
	path = path + "/" + Config.ns_cmds.split(":")[1]
	rdsCmds = {}
	for cmd, attr in blob.iteritems():
		summary = ""
		name = cmd
		command = name.lower()
		cli = []
		val = {"name" : name}
		if "summary" in attr:
			summary = attr["summary"]
			val["summary"] = summary
		if "cli" in attr:
			cli = cli + attr["cli"]
			val["cli"] = cli
		if command not in rdsCmds:
			rdsCmds[command] = val
	store(rdsCmds, path)
	return


# Write data for rds:cmds_html
def writeCmdsHtml(path):
	path = path + "/" + Config.ns_cmds_html.split(":")[1]
	rdsCmdsHtml = {}
	for cmd, attr in blob.iteritems():
		html = ""
		command = cmd.lower()
		if "html" in attr:
			html = attr["html"]
		if command not in rdsCmdsHtml:
			rdsCmdsHtml[command] = html
	store(rdsCmdsHtml, path)
	return


# Process Pull data to conform to Model.md
def preprocess():
	extractSummary(Config.summary)
	extractDetail(Config.commands)
	# Use data from blob to define namespaces as in server/Model.md
	# rds:types
	writeTypes(Config.target)
	# rds:cmds
	writeCmds(Config.target)
	# rds:cmds_html
	writeCmdsHtml(Config.target)
        return

