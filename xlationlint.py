#!/usr/bin/env python

import sys
import json
import os
import subprocess
import re

try:
  # For python3
  import urllib.request
except ImportError:
  # For python2
  import imp
  import urllib2
  urllib = imp.new_module('urllib')
  urllib.request = urllib2

for change in sys.argv[1:]:
    print(change)
    f = urllib.request.urlopen('http://code.rodnet.es/query?q=change:%s' % change)
    d = f.read().decode("utf-8")
    # gerrit doesnt actually return json. returns two json blobs, separate lines. bizarre.
    d = d.split('\n')[0]
    data = json.loads(d)
    project = data['project']
	project = project.replace('CyanogenMod/', '').replace('rodero95/', '').replace('android_', '')
	while not os.path.isdir(project):
        new_project = project.replace('_', '/', 1)
        if new_project == project:
		break
	project = new_project

    if not os.path.isdir(project):
        sys.stderr.write('no project directory: %s' % project)
        sys.exit(1)

    retval = os.system('cd %s ; xmllint --noout `git show FETCH_HEAD | grep "^+++ b"  | sed -e \'s/^+++ b\///g\' | egrep "res/.*xml$"`' % (project))
    sys.exit(retval!=0)
