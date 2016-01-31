local P = {}
remote = P
P.__index = P

local pin_rstsw = 4
local pin_led = 8
P.buttons = {}
P.sleepdelay = 5

function P.blink(count,dt)
   if count == nil then count = 1 end
   if dt == nil then dt = 100 end

   for i=1,count do
      gpio.write(pin_led, gpio.HIGH)
      tmr.delay(dt*1000)
      gpio.write(pin_led, gpio.LOW)
      tmr.delay(dt*1000)
   end
end

function P.init_timer()
   if P.sleepdelay == nil then return end
   tmr.register(2,P.sleepdelay*1000,tmr.ALARM_SINGLE,function ()
                   print("Sleeping")
                   P.blink(2)
                   node.dsleep(0)
   end)
end

function P.start_timer()
   if P.sleepdelay == nil then return end
   tmr.start(2)
end

function P.stop_timer()
   if P.sleepdelay == nil then return end
   tmr.stop(2)
end

function P.init_resetsw(pin)
   if pin ~= nil then pin_rstsw = pin end
   gpio.mode(pin_rstsw,gpio.OUTPUT)
   gpio.write(pin_rstsw,gpio.LOW)
end

function P.init_led(pin)
   if pin ~= nil then pin_led = pin end
   gpio.mode(pin_led,gpio.OUTPUT)
   gpio.write(pin_led,gpio.LOW)
end

function P.init_buttons(buttons)
   if buttons ~= nil then P.buttons = buttons end
   for pin,func in pairs(P.buttons) do
      gpio.mode(pin,gpio.INPUT,gpio.PULLUP)
      local state = 0
      local function action (lvl)
         if lvl == 0 then
            P.stop_timer()
            state = 1
            tmr.alarm(1,2000,tmr.ALARM_SINGLE, function()
                         if state == 1 then
                            state = 0
                            if gpio.read(pin)==gpio.LOW and func[2]~=nil then
                               func[2]()
                            end
                         end
                         state = 0
            end)
            P.blink()
         else
            if state == 1 then
               tmr.unregister(1)
               if func[1] ~= nil then
                  func[1]()
               end
            end
            state = 0
            P.start_timer()
         end
      end
      gpio.trig(pin, "both", action)
   end
end

return remote
