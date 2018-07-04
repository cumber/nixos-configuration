--  -*- dante-target: "exe:launch-xmonad";  -*-

module Main
  ( main )
where

import Control.Monad.IO.Class ( liftIO )

import Data.Foldable ( traverse_ )

import Data.Maybe ( fromMaybe )

import Data.Monoid ( (<>) )

import System.FilePath ( takeBaseName )

import System.Directory ( createDirectoryIfMissing )

import System.IO ( IOMode (WriteMode)
                 , openFile
                 )

import System.Posix.Env ( getEnv
                        , getEnvironment
                        , putEnv
                        )

import System.Process

import System.Taffybar.Support.PagerHints ( pagerHints )

import XMonad
import XMonad.Config.Desktop ( desktopConfig )
import XMonad.Hooks.ManageDocks ( ToggleStruts (ToggleStruts) )
import XMonad.Hooks.SetWMName ( setWMName )
import XMonad.Layout.Fullscreen ( fullscreenSupport )
import XMonad.Layout.NoBorders ( Ambiguity (Screen)
                               , lessBorders
                               )
import XMonad.Hooks.Place ( fixed
                          , inBounds
                          , placeHook
                          )
import XMonad.Util.EZConfig ( additionalKeysP )
import XMonad.Util.Run ( safeSpawn )


main :: IO ()
main = launch . pagerHints . fullscreenSupport $ myConfig


myModMask = mod4Mask
myKeys =
  [ ( "M-p"
    , safeSpawn "{{synapse}}/bin/synapse" []
    )
  , ( "M-x"
    , safeSpawn "{{synapse}}/bin/synapse" []
    )
  , ( "C-<Space>"
    , safeSpawn "{{synapse}}/bin/synapse" []
    )

  , ( "M-b"
    , sendMessage ToggleStruts
    )

  , ( "<XF86AudioLowerVolume>"
    , safeSpawn "{{pulseaudioLight}}/bin/pactl"
                 [ "set-sink-volume", "@DEFAULT_SINK@", "-5%" ]
    )
  , ( "<XF86AudioRaiseVolume>"
    , safeSpawn "{{pulseaudioLight}}/bin/pactl"
                [ "set-sink-volume", "@DEFAULT_SINK@", "+5%" ]
    )
  , ( "<XF86AudioMute>"
    , safeSpawn "{{pulseaudioLight}}/bin/pactl"
                [ "set-sink-mute", "@DEFAULT_SINK@", "toggle" ]
    )

    -- Win-z locks screen
  , ( "M-z"
    , safeSpawn "{{lightlocker}}/bin/light-locker-command" ["-l"]
    )
  ]


myStartupHook
  = do  startupCommands
        setWMName "LG3D"  -- helps with Java GUIs
        liftIO $ mapM_ (putEnv . gtk2RcFiles) =<< getEnv "HOME"

  where gtk2RcFiles home = "GTK2_RC_FILES=" <> home <> "/.gtkrc-2.0"


startupCommands
  = do traverse_ (uncurry spawnWithLogs) simpleCommands
       es <- liftIO getEnvironment
       let desktopHackEnv = Just $ es ++ [("XDG_CURRENT_DESKTOP", "Unity")]
       spawnWithLogsEnv "{{slack}}/bin/slack" [] desktopHackEnv
       spawnWithLogsEnv "{{signal-desktop}}/bin/signal-desktop" ["--start-in-tray"] desktopHackEnv

simpleCommands
  =   [ ("{{status-notifier-item}}/bin/status-notifier-watcher", [])
      , ("{{setxkbmap}}/bin/setxkbmap", ["-option", "compose:ralt"])
      , ("{{notify-osd}}/bin/notify-osd", [])
      , ("{{synapse}}/bin/synapse", ["-s"])
      , ("{{compton}}/bin/compton", [])
      , ("{{networkmanagerapplet}}/bin/nm-applet", ["--indicator"])
      , ("{{system-config-printer}}/bin/system-config-printer-applet", [])
      , ("{{powerline}}/bin/powerline-daemon", ["--replace"])
      , ("{{udiskie}}/bin/udiskie", ["--tray", "--appindicator"])
      , ("{{syncthing-gtk}}/bin/syncthing-gtk", ["--minimized"])
      , ("{{lightlocker}}/bin/light-locker", ["--lock-on-suspend"])
      , ("{{out}}/bin/launch-taffybar", [])
      , ("{{keepassxc}}/bin/keepassxc", [])
      , ("{{emacs-custom}}/bin/emacs", ["--bg-daemon"])
      ]


myManageHooks =
  [ placeHook . inBounds . fixed $ (0.5, 0.5)
  , appName =? "synapse" --> doIgnore
  , appName =? "speedcrunch" --> doFloat
  ]


myConfig
  = desktopConfig
      { modMask = myModMask
      , terminal = "termite"
      , focusedBorderColor = "#1010bb"
      , normalBorderColor = "#000000"
      , borderWidth = 2
      , startupHook = startupHook desktopConfig >> myStartupHook
      , layoutHook = lessBorders Screen $ layoutHook desktopConfig
      , manageHook = composeAll myManageHooks <+> manageHook desktopConfig
      }
    `additionalKeysP` myKeys


spawnWithLogs :: MonadIO m => FilePath -> [String] -> m ()
spawnWithLogs cmd args = spawnWithLogsEnv cmd args Nothing

spawnWithLogsEnv :: MonadIO m => FilePath -> [String] -> Maybe [(String, String)] -> m ()
spawnWithLogsEnv cmd args es
  = liftIO $
     do home <- fromMaybe "/tmp/xmonad/log" <$> getEnv "HOME"
        let logDir = home <> "/.local/var/log/" <> takeBaseName cmd
        createDirectoryIfMissing True logDir
        stdout <- UseHandle <$> openFile (logDir <> "/stdout") WriteMode
        stderr <- UseHandle <$> openFile (logDir <> "/stderr") WriteMode
        let pcfg = (proc cmd args) { std_out = stdout, std_err = stderr, env = es }
        _ <- createProcess pcfg
        pure ()
