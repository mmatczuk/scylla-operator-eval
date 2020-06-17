#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import scyllasetup
import logging
import commandlineparser

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG, format="%(message)s")

try:
    arguments = commandlineparser.parse()
    setup = scyllasetup.ScyllaSetup(arguments)
    setup.developerMode()
    setup.cpuSet()
    setup.io()
    setup.cqlshrc()
    setup.arguments()
    setup.set_housekeeping()
    setup._run(['/opt/scylladb/scripts/scylla_prepare'])
    setup._run(['/scylla-service.sh'])
except Exception:
    logging.exception('failed!')