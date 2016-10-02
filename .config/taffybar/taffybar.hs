import Control.Applicative

import Data.Maybe

import System.Environment

import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.Pager
import System.Taffybar.Systray
import System.Taffybar.SimpleClock
import System.Taffybar.TaffyPager
import System.Taffybar.Widgets.PollingGraph
import System.Information.CPU

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]

main = do
  let defaultMonitor = monitorNumber defaultTaffybarConfig
  monitor <- fromMaybe defaultMonitor . fmap read . listToMaybe <$> getArgs
  let cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                  , graphLabel = Just "cpu"
                                  }
      clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      pager = taffyPagerNew defaultPagerConfig { activeWindow = escape . shorten 100
                                               , widgetSep = colorize "grey" "" "  |  "
                                               , emptyWorkspace = colorize "grey" "" . escape
                                               }
      tray = systrayNew
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      battery = batteryBarNew defaultBatteryConfig 20
      batteryTime = textBatteryNew "($time$)" 20

      widgets = if monitor == 0 then [ tray, clock, cpu, batteryTime, battery ] else [ clock, cpu ]

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager ]
                                        , endWidgets = widgets
                                        , monitorNumber = monitor
                                        , widgetSpacing = 20
                                        }
