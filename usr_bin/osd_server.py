#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
# Copyright (C) 2005 2006 Alexander Bernauer <alex@copton.net>
# Copyright (C) 2005 2006 Rico Schiekel <fire@donwgra.de>
# Copyright (C) 2005 2006 Ulrich Dangel <uli@spamt.net>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation version 2
# of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA # 02111-1307, USA.
#

import sys, getopt, logging
from socket import *
from os import popen
from select import select

host='localhost'
port=1234
osdcmd = "/usr/bin/osd_cat"

def syntax():
    print "osd_server.py [options]"
    print "   options:"
    print "     -h --help       print this message"
    print "     -H --host       host of the osd server (def: " + host + ")"
    print "     -P --port       port of the osd server (def: " + str(port) + ")"
    print "     -o --osd        set new osd parameter string"
    print "     -l --log        log file ('-' logs to stdout)"

def get_osd_paramstr(def_params, user_params):
    ret = user_params
    if user_params == '':
        for n, v in def_params.iteritems():
            if v != '':
                ret += n + "=" + v + " "
    return ret



osd_params={ '--pos': 'middle',
             '--offset': '100',
             '--align': 'center',
             '--indent': '100',
             '--font':
             '\-\*\-helvetica\-\*\-r\-\*\-\*\-34\-\*\-\*\-\*\-\*\-\*\-iso8859\-15',
             '--colour': 'green',
             '--shadow': '0',
             '--shadowcolour': '',
             '--outline': '1',
             '--outlinecolour': 'black',
             '--age': '4',
             '--lines': '5',
             '--delay': '4' }

logfile_name = ''
user_osd_params = ''

try:
    opts, args = getopt.getopt(sys.argv[1:], "hH:P:o:l:", ["help", "host=", "port=", "osd=", "log="])
except getopt.GetoptError:
    syntax()
    sys.exit(2)

for opt, arg in opts:
    if opt in ("-h", "--help"):
        syntax()
        sys.exit(3)
    elif opt in ("-H", "--host"):
        host = arg
    elif opt in ("-P", "--port"):
        port = int(arg)
    elif opt in ("-o", "--osd"):
        user_osd_params = arg
    elif opt in ("-l", "--log"):
        logfile_name = arg

l = socket(AF_INET, SOCK_STREAM)
l.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
l.bind((host, port))
l.listen(5)

logger = logging.getLogger('osd_server')
lformatter = logging.Formatter('%(asctime)s %(message)s')
if logfile_name not in ('', '-'):
    lfh = logging.FileHandler(logfile_name)
    lfh.setFormatter(lformatter)
    logger.addHandler(lfh)
else:
    lout = logging.StreamHandler(sys.stdout)
    lout.setFormatter(lformatter)
    logger.addHandler(lout)
logger.setLevel(logging.INFO)

logger.info("osd_server running on [%s] port [%d]" % (host, port))
osdpipe = popen("%s %s" % (osdcmd, get_osd_paramstr(osd_params, user_osd_params)), 'w')

r = range(32,127)
r.extend([ord(umlaut) for umlaut in "äöüßÄÖÜ€" ])

while 1:
    (con, addr) = l.accept()
    message = con.recv(60).strip()
    con.close()

    message = message.replace("\n", "")
    message = ''.join(map(lambda a: not a in r \
                        and '[%.2d]' % a \
                        or chr(a), \
                        [ord(c) for c in message]))[:60]

    logger.info(message)
    osdpipe.write(message)
    osdpipe.write("\n")
    osdpipe.flush()

osdpipe.close()
