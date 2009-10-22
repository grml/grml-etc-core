#!/usr/bin/python
# -*- coding: utf-8 -*-
# Copyright (C) 2005-2009 Alexander Bernauer <alex@copton.net>
# Copyright (C) 2005-2009 Rico Schiekel <fire@downgra.de>
# Copyright (C) 2005-2009 Ulrich Dangel <uli@spamt.net>
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


"""
example of ~/.notifid.conf:
---------------------------

import os

host = "127.0.0.1"
port = 8901
logfile = os.path.expanduser("~/.event.log")
osdparams = "-p bottom  --color=red --delay=4 --age=4 " \
 "--font=\-\*\-helvetica\-medium\-r\-\*\-\*\-34\-\*\-\*\-\*\-\*\-\*\-\*\-15 " \
     "--offset=100 --shadow=0 --lines=5 --align=right --indent=100"
actions = (
    (".*", [log], True),
    ("IRC:&bitlbee:bitlbee", [], False),
    (".*shutdown.*", [command('sudo shutdown -h now %(msg)s')], False),
    (".*", [libnotify], False),
)

"""

import os
import sys
import re
import string
import socket
import logging
import getopt

default_hostname = 'localhost'
default_port = 1234
default_osd_params = osdparams = "-p bottom  --color=red --delay=4 --age=4 " \
           "--font=\-\*\-helvetica\-medium\-r\-\*\-\*\-34\-\*\-\*\-\*\-\*\-\*\-\*\-15 " \
            "--offset=100 --shadow=0 --lines=5 --align=right --indent=100"
default_logfile = None


def play(sound_file):
    def play_wrapper(msg):
        os.system('/usr/bin/aplay "%s" 2> /dev/null &' % sound_file)
    return play_wrapper

def execute(command):
    def command_wrapper(msg):
        os.system(command % dict(msg = msg))
    return command_wrapper

def osd(msg):
    osdcmd = "/usr/bin/osd_cat"
    osdpipe = os.popen("%s %s" % (osdcmd, osdparams), 'w')
    osdpipe.write(msg)
    osdpipe.close()

def libnotify(msg):
    try:
        import dbus
    except ImportError:
        sys.stderr.write('Please install python-dbus\n')
        raise SystemExit(1)

    bus = dbus.SessionBus()
    notifyService = bus.get_object("org.freedesktop.Notifications", '/org/freedesktop/Notifications')
    interface = dbus.Interface(notifyService, 'org.freedesktop.Notifications')

    message, title = (':' + msg).split(':')[::-1][0:2]
    if not title:
        title, message = message, title
    interface.Notify('notify-server', 0, 'notification-message-im', title, message, [], {'x-canonical-append':'allowed'}, -1)

def log(msg):
    if logger:
        logger.info(msg)

def syntax():
    print "osd_server.py [options]"
    print "   options:"
    print "     -h --help       print this message"
    print "     -H --host       host of the osd server (def: " + default_hostname + ")"
    print "     -P --port       port of the osd server (def: " + str(default_port) + ")"
    print "     -l --log        log file ('-' logs to stdout)"


env = { 'play' : play,
        'execute' : execute,
        'osd' : osd,
        'libnotify' : libnotify,
        'log' : log,
        'host' : default_hostname,
        'port' : default_port,
        'logfile' : default_logfile,
        }

default_actions = (
    (".*", [log], True),
    (".*", [libnotify], False),
)


default_bind = (default_hostname, default_port)

try:
    execfile(os.path.expanduser('~/.notifyd.conf'), {}, env)
except IOError:
    pass

try:
    opts, args = getopt.getopt(sys.argv[1:], "hH:P:l:", ["help", "host=", "port=", "log="])
except getopt.GetoptError:
    syntax()
    sys.exit(2)

for opt, arg in opts:
    if opt in ("-h", "--help"):
        syntax()
        sys.exit(3)
    elif opt in ("-H", "--host"):
        env['host'] = arg
    elif opt in ("-P", "--port"):
        env['port'] = int(arg)
    elif opt in ("-l", "--log"):
        env['logfile'] = arg


actions = env.get('actions', default_actions)
logfile_name = env.get('logfile')
logfile_format = env.get('logformat', '%(asctime)s %(message)s')
bind_address = (env['host'], env['port'])
osd_params = env.get('osdparams', default_osd_params)

if logfile_name:
    logger = logging.getLogger('notify_server')
    lformatter = logging.Formatter(logfile_format)
    if logfile_name not in ('', '-'):
        lfh = logging.FileHandler(logfile_name)
        lfh.setFormatter(lformatter)
        logger.addHandler(lfh)
    else:
        lout = logging.StreamHandler(sys.stdout)
        lout.setFormatter(lformatter)
        logger.addHandler(lout)
    logger.setLevel(logging.INFO)
else:
    logger = None

l = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
l.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
l.bind(bind_address)
l.listen(5)

def filter_char(c):
    return c in string.printable + "äöüßÄÖÜ" and c or '_'

while 1:
    try:
        (con, addr) = l.accept()
    except:
        continue
    data = con.recv(50).strip()
    con.close()

    log = ''.join(filter_char(c) for c in data)

    for pattern, handlers, cont in actions:
        if re.match(pattern, log):
            for handler in handlers:
                handler(log)
            if not cont:
                break
