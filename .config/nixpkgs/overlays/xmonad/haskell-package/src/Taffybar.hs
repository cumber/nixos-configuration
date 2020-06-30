{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import System.Taffybar
import System.Taffybar.SimpleConfig
import System.Taffybar.Information.CPU
import System.Taffybar.Widget.Battery
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Layout
import System.Taffybar.Widget.SNITray
import System.Taffybar.Widget.SimpleClock
import System.Taffybar.Widget.Windows
import System.Taffybar.Widget.Workspaces

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]

main :: IO ()
main = do
  let cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                  , graphLabel = Just "cpu"
                                  }
      clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      tray = sniTrayNew
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      batteryPercent = textBatteryNew "$percentage$%"
      batteryTime = textBatteryNew "$time$"
      batteryIcon = batteryIconNew
      workspaces = workspacesNew defaultWorkspacesConfig
      layout = layoutNew defaultLayoutConfig
      windowCfg = defaultWindowsConfig { getMenuLabel = truncatedGetMenuLabel 80
                                       , getActiveLabel = truncatedGetActiveLabel 15
                                       }
      window = windowsNew windowCfg

  startTaffybar . toTaffyConfig
    $ defaultSimpleTaffyConfig { startWidgets = [ workspaces, layout ]
                               , centerWidgets = [ window ]
                               , endWidgets = [ tray
                                              , clock
                                              , cpu
                                              , batteryTime
                                              , batteryIcon
                                              , batteryPercent
                                              ]
                               , monitorsAction = useAllMonitors
                               , widgetSpacing = 20
                               , barHeight = 40
                               }
