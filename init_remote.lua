require('mpd')
require('remote')

local function mkclickfun (name, cmd)
   return function () print(name); cmd(); remote.blink() end
end
local function mklongfun (name, cmd)
   return function () print(name); cmd(); remote.blink(2) end
end

remote.buttons = {
   [2]={
      mkclickfun("stop", function() mpd:send("stop") end),
      mklongfun("shutdown", function() mpd:sendArbitrary(6789,"shutdown") end),
   },
   [1]={
      mkclickfun("previous",   function() mpd:send("previous") end),
      mklongfun("btn2_long", function() end),
   },
   [7]={
      mkclickfun("play/pause", function() mpd:toggle() end),
      mklongfun("mpd_dynamic", function() mpd:sendArbitrary(6789,"mpd_dynamic") end),
   },
   [6]={
      mkclickfun("next",       function() mpd:send("next") end),
      mklongfun("btn4_long", function() end),
   },
}
remote.init_resetsw()
remote.init_led()
remote.init_buttons()
remote.init_timer()

require('network')
require('telnet')
require('mpd')

network.init()
network.waitconnect(
   function () remote.blink(1) end,
   function ()
      remote.blink(2)
      if hostmapping ~= nil and network.ssid ~= nil then
         print("Selecting mpd host for "..network.ssid)
         for k,v in pairs(hostmapping) do
            if k == network.ssid then
               mpd.host = v
               print("Setting mpd host to "..mpd.host)
               break
            end
         end
      end
      network.info()
      telnet.setupTelnetServer()
      print("Started telnet server")
      mpd:sendArbitrary(6789,"beep")
      remote.start_timer()
   end,
   function () node.dsleep(0) end
)
