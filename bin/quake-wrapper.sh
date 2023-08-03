#!/bin/sh
if [ -z "${MOTD}" ]; then
    echo "WARN: MOTD was not set, setting it to:"
    echo "      ioquake3-motd"
    MOTD="ioquake3-motd"
fi

if [ -z "${RCON_PASS}" ]; then
    echo "WARN: RCON_PASS was not set, setting it to:"
    echo "      ioquake3-rcon"
    RCON_PASS="ioquake3-rcon"
fi

_ARGS="+seta rconPassword ${RCON_PASS}"
_ARGS="${_ARGS} +g_motd ${MOTD}"
_ARGS="${_ARGS} +exec base_ffa.cfg"
_ARGS="${_ARGS} +vstr map1"
_ARGS="${_ARGS} ${EXTRA_ARGS}"

echo "INFO: ioq3ded.x86_64 cmdline:"
echo "      ${_ARGS}"

/opt/quake3/ioq3ded.x86_64 ${_ARGS}
