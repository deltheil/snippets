#!/usr/bin/python

# AngelHack Paris Oct '13
# @uthors Tushar Ghosh (2shar007)

import sys
import winch
import getpass
import urllib, urllib2
from Config import Config

# The Winch Data Store
DS = Config.ds

# Verify if data-store exists for user
def searchDataStore(wc, name):
  return next(ds for ds in wc.list_datastores() if ds.name==name)


# Load updates from system
def load(path, entry):
	obj = None
	entryPath = os.path.join(path, entry)
	if not os.path.exists(entryPath):
		os.makedirs(entryPath)
	with open(path, 'r') as inFile:
		obj = json.load(inFile)
	return obj


# Push updates to Winch
def push(npace, ds):
	entry = Config.targetFile
	path = Config.target + "/" + nspace.split(":")[1]
	obj = load(path, entry)
	ns = ds.search_namespace(nspace)
	if ns is None:
		ns = ds.create_namespace(nspace)
	print "Processing %s" % ns.name
	for k, v in obj.iteritems():
		try:
			ns.create_record(k, v, "application/json")
			#puts(".")
		except winch.ErrExists:
			#puts("s")
	return


# Initialize pushing updates
def init(user, passwd):
	wc = winch.Client(user, passwd)
	ds = searchDataStore(wc, ds)
	push("rds:types", ds)
	return

# Login retrieve
def login():
    user = input("Username [%s]: " % getpass.getuser())
    if not user:
        user = getpass.getuser()

    pprompt = lambda: (getpass.getpass(), getpass.getpass('Retype password: '))

    p1, p2 = pprompt()
    while p1 != p2:
        print('Passwords do not match. Try again')
        p1, p2 = pprompt()

    return user, p1


# Push updates to winch
def update():
	email, passw = login()
	init(email, passw)
        return

