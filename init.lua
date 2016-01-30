require('util')
require('network')
require('mpd')
require('remote')

-- comment the following line to turn on automatic shutdown
remote.sleepdelay = nil

--network.networks = {
--   ["SSID"] = "PASSWORD",
--}

--mpd.host = "mpdhost"
--and/or
--hostmapping = {
--   ["SSID"] = "mpdhost",
--}

-- start up
require('init_remote')
