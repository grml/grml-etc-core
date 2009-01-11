#!/usr/bin/python
# -*- coding: utf-8 -*-
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
from select import select
try: 
    import dbus
except ImportError:
    print >>sys.stderr, 'Please install python-dbus'
    raise SystemExit(1)


host='localhost'
port=1234
timeout=5

def syntax():
    print "osd_server.py [options]"
    print "   options:"
    print "     -h --help       print this message"
    print "     -H --host       host of the osd server (def: " + host + ")"
    print "     -P --port       port of the osd server (def: " + str(port) + ")"
    print "     -t --timeout    timeout in seconds (def: " + str(timeout) + ")"
    print "     -l --log        log file ('-' logs to stdout)"

logfile_name = ''

try:
    opts, args = getopt.getopt(sys.argv[1:], "hH:P:l:t:", ["help", "host=", "port=", "log=", 'timeout='])
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
    elif opt in ("-l", "--log"):
        logfile_name = arg
    elif opt in ("-p", "--timeout"):
        timeout=int(arg)

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

bus = dbus.SessionBus()
devobj = bus.get_object('org.freedesktop.Notifications', '/org/freedesktop/Notifications')
notify = dbus.Interface(devobj, 'org.freedesktop.Notifications')

while 1:
    (con, addr) = l.accept()
    message = con.recv(60).strip()
    con.close()

    message = message.splitlines()
    if message:
        body = ' '.join([m for m in message[1:]])
        notify.Notify('', 0, '', message[0], body, '', [], timeout*1000)
        logger.info(message)

