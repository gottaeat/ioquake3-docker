#!/bin/ash
. /static/shell/common

trap shutdown SIGTERM SIGINT

# -- sanity check vars -- #
if [ -z "${MOTD}" ]; then
    perr "MOTD variable was not set or is empty."
fi

if [ -z "${RCON_PASS}" ]; then
    perr "RCON_PASS variable was not set or is empty."
fi

# -- check mounts -- #
for i in /quake/baseq3 /config; do
    if ! mountpoint "${i}" >/dev/null 2>&1; then
        perr "${i} is not bind mounted, exiting."
    fi
done

# -- check pak's -- #
for i in 0 1 2 3 4 5 6 7 8; do
    if [ ! -f "/quake/baseq3/pak${i}.pk3" ]; then
        perr "pak${i}.pk3 is missing in /quake/baseq3/."
    fi
done

# -- /config/dockerquake.cfg existence -- #
if [ ! -f "/config/dockerquake.cfg" ]; then
    pwarn "/config/dockerquake.cfg is missing."
    pinfo "static files default ffa config will be used."
    cp "/static/files/base_ffa.cfg" "/config/dockerquake.cfg"
fi

# -- check vstr existence -- #
if ! grep '^set map1' "/config/dockerquake.cfg" >/dev/null 2>&1; then
    pwarn "the provided /config/dockerquake.cfg is missing the map1 vstr."
    pwarn "check the README for more details."
    perr "missing vstr, exiting."
fi

# -- action -- #
_ARGS="+seta rconPassword ${RCON_PASS}"
_ARGS="${_ARGS} +g_motd ${MOTD}"
_ARGS="${_ARGS} +exec dockerquake.cfg"
_ARGS="${_ARGS} +vstr map1"
_ARGS="${_ARGS} ${EXTRA_ARGS}"

pinfo "setting permissions."
chown -Rh quake:quake /config /home/quake
evalret

pinfo "ioq3ded.x86_64 cmdline args:"
pinfo "${_ARGS}"

su quake -c "/quake/ioq3ded.x86_64 ${_ARGS}" &

wait $!
