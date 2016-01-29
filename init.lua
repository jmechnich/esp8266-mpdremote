require('util')
require('network')
require('mpd')
require('remote')

--network.networks = {
--   ["SSID"] = "PASSWORD",
--}

--mpd.host = "mpdhost"

-- comment the following line to turn on automatic shutdown
remote.sleepdelay = nil

-- trigger initialization
require('init_remote')
