import System.Taffybar
import System.Taffybar.SimpleConfig
import System.Taffybar.Information.CPU
import System.Taffybar.Widget.Battery
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Layout
import System.Taffybar.Widget.MPRIS2
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
      batteryText = textBatteryNew "$percentage$ ($time$)"
      batteryIcon = batteryIconNew
      mpris = mpris2New
      wsConfig = defaultWorkspacesConfig { getWindowIconPixbuf = scaledWindowIconPixbufGetter getWindowIconPixbufFromEWMH }
      workspaces = workspacesNew wsConfig
      layout = layoutNew defaultLayoutConfig
      window = windowsNew defaultWindowsConfig

  startTaffybar . toTaffyConfig
    $ defaultSimpleTaffyConfig { startWidgets = [ workspaces, layout, window ]
                               , endWidgets = [ mpris
                                              , tray
                                              , clock
                                              , cpu
                                              , batteryText
                                              , batteryIcon
                                              ]
                               , monitorsAction = useAllMonitors
                               , widgetSpacing = 20
                               , barHeight = 40
                               }
