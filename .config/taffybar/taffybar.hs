import Control.Applicative

import Data.Maybe

import System.Environment

import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.MPRIS2
import System.Taffybar.Pager
import System.Taffybar.Systray
import System.Taffybar.SimpleClock
import System.Taffybar.TaffyPager
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.WorkspaceHUD
import System.Information.CPU

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]

main = do
  let defaultMonitor = monitorNumber defaultTaffybarConfig
  monitor <- maybe defaultMonitor read . listToMaybe <$> getArgs
  let cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                  , graphLabel = Just "cpu"
                                  }
      clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      pagerConfig = defaultPagerConfig { activeWindow = escape . shorten 100
                                       , widgetSep = colorize "grey" "" "  |  "
                                       , emptyWorkspace = colorize "grey" "" . escape
                                       }
      pager = taffyPagerHUDNew pagerConfig defaultWorkspaceHUDConfig
      tray = systrayNew
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      battery = batteryBarNewWithFormat defaultBatteryConfig "($time$)" 20
      mpris = mpris2New

      widgets
        = if monitor == 0
            then  [ tray, clock, cpu, battery ]
            else  [ mpris, clock, cpu ]


  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager ]
                                        , endWidgets = widgets
                                        , monitorNumber = monitor
                                        , widgetSpacing = 20
                                        , barHeight = 40
                                        }
