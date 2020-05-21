-- The goal is to get into another space, even when working from home.

-- Custom Desktop Background with prompts for focus, writing, code?
-- Warnings set up for launching apps not tagged properly.
-- Toggl timer and in built-in Pomodoro to help box time.
-- Preset screens for working.
-- Musical cues?

local hyper = require('hyper')
local hs_app = require('hs.application')

local spaces = {
  review = {
    setup = function()
      hs_app.launchOrFocusByBundleID('com.culturedcode.ThingsMac')
      local things = hs_app.find('com.culturedcode.ThingsMac')

      hs.fnutils.imap(things:allWindows(), function(v) v:close() end)
      things:selectMenuItem("New Things Window")

      local today = things:allWindows()[1]
      today:focus()
      today:moveToUnit(hs.layout.right30)
      today:application():selectMenuItem("Hide Sidebar")
      today:application():selectMenuItem("Today")
      today:application():selectMenuItem("New Things Window")

      local workspace = hs.fnutils.ifilter(things:allWindows(), function(w)
        if today == w then
          return false
        else
          return true
        end
      end)[1]

      workspace:focus()
      workspace:moveToUnit(hs.layout.left70)
      workspace:application():selectMenuItem("Show Sidebar")
      workspace:application():selectMenuItem("Anytime")
    end
  },
  focus_budget = {
    setup = function()
      hs_app.launchOrFocusByBundleID('com.culturedcode.ThingsMac')
      hs_app.launchOrFocusByBundleID('com.flexibits.fantastical2.mac')

      local things = hs_app.find('com.culturedcode.ThingsMac')
      local fantastical = hs_app.find('com.flexibits.fantastical2.mac')

      local today = things:focusedWindow()
      today:moveToUnit(hs.layout.right30)
      today:application():selectMenuItem("Hide Sidebar")
      today:application():selectMenuItem("Today")

      local cal = fantastical:focusedWindow()
      cal:moveToUnit(hs.layout.left70)
      cal:application():selectMenuItem("Hide Sidebar")
      cal:application():selectMenuItem("By Week")
    end
  }
}

hyper:bind({}, 'q', nil, function()
  local choices = {
    {
      text = "Review",
      subText = "Setup a Things 3 Review Session",
      space = "review",
    },
    {
      text = "Plan a Focus Budget",
      subText = "Setup Things 3 and Fantastical",
      space = "focus_budget",
    },
  }
  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      spaces[choice["space"]]["setup"]()
    end
  end)

  chooser:choices(choices)
  chooser:show()
end)
