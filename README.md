# ioquake3-docker
ioquake3-docker provides a dockerized ioquake3 server environment.

### installation
```sh
cp env.example .env # modify as needed
docker compose up -d
```

### warning
the entrypoint for the image assumes that you have a `vstr` named `map1` for the
map rotation to kick in.

this is necessary because by default, when a quake 3 server starts, it will not
start a game by loading a map automatically. if one tries to connect to a server
in this state, they will be stuck at the `Awaiting Challenge` screen. even if
they have the corresponding `rconPassword` set, they will not be able to start
a game on this screen.

this is not an issue when the server process is running in a pty as one can
simply type e.g. `map q3dm16` and get a game going but as this is dockerized,
you have two options:

1. force an arg such as `+map q3dm16` to the cmdline args of the server.
2. make the users name the `vstr`'s for their map rotation start with `map1`.

as the first option is invasive and will require the server operator to manually
trigger their own map rotation, going with the second option makes much more
sense.

### rotation example
```sh
set map1 "map q3tourney1 ; set fraglimit 20; set nextmap vstr map2"
set map2 "map q3tourney4 ; set fraglimit 20; set nextmap vstr map3"
set map3 "map q3tourney3 ; set fraglimit 20; set nextmap vstr map4"
set map4 "map q3dm16     ; set fraglimit 20; set nextmap vstr map5"
set map5 "map q3dm17     ; set fraglimit 20; set nextmap vstr map1"
```
