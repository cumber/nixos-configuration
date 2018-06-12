module Main
  ( main )
where

import Control.Monad.IO.Class (liftIO)

import Data.Monoid ((<>))

import System.Posix.Env (getEnv, putEnv)

import System.Taffybar.Support.PagerHints (pagerHints)

import XMonad
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.ManageDocks (ToggleStruts(ToggleStruts))
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.Fullscreen (fullscreenSupport)
import XMonad.Layout.NoBorders (Ambiguity(Screen), lessBorders)
import XMonad.Hooks.Place (fixed, inBounds, placeHook)
import XMonad.Util.EZConfig (additionalKeys)


main :: IO ()
main = launch . pagerHints . fullscreenSupport $ myConfig


myModMask = mod4Mask
myKeys =
  [ ((myModMask               , xK_p)         , spawn "{{synapse}}/bin/synapse")
  , ((myModMask               , xK_x)         , spawn "{{synapse}}/bin/synapse")
  , ((myModMask .|. mod1Mask  , xK_space)     , spawn "{{synapse}}/bin/synapse")

  , ((myModMask               , xK_b)         , sendMessage ToggleStruts)

  , ( (0, 0x1008FF11)
    , spawn "{{pulseaudioLight}}/bin/pactl set-sink-volume '@DEFAULT_SINK@' '-5%'"
    )
  , ( (0, 0x1008FF13)
    , spawn "{{pulseaudioLight}}/bin/pactl set-sink-volume '@DEFAULT_SINK@' '+5%'"
    )
  , ( (0, 0x1008FF12)
    , spawn "{{pulseaudioLight}}/bin/pactl set-sink-mute '@DEFAULT_SINK@' toggle"
    )

    -- Win-z locks screen
  , ( (myModMask, xK_z) , spawn "{{lightlocker}}/bin/light-locker-command -l")
  ]


myStartupHook
  = do  startupCommands
        setWMName "LG3D"  -- helps with Java GUIs
        liftIO $ mapM_ (putEnv . gtk2RcFiles) =<< getEnv "HOME"

  where gtk2RcFiles home = "GTK2_RC_FILES=" <> home <> "/.gtkrc-2.0"


startupCommands
  = mapM_ spawn simpleCommands

simpleCommands
  =   [ "{{status-notifier-item}}/bin/status-notifier-watcher"
      , "{{setxkbmap}}/bin/setxkbmap -option 'compose:ralt'"
      , "{{notify-osd}}/bin/notify-osd"
      , "{{synapse}}/bin/synapse -s"
      , "{{compton}}/bin/compton"
      , "{{networkmanagerapplet}}/bin/nm-applet --sm-disable"
      , "{{system-config-printer}}/bin/system-config-printer-applet"
      , "{{powerline}}/bin/powerline-daemon --replace"
      , "{{udiskie}}/bin/udiskie --tray --appindicator"
      , "{{syncthing-gtk}}/bin/syncthing-gtk --minimized"
      , "env XDG_CURRENT_DESKTOP=Unity {{slack}}/bin/slack"
      , "env XDG_CURRENT_DESKTOP=Unity {{signal-desktop}}/bin/signal-desktop --start-in-tray"
      , "{{lightlocker}}/bin/light-locker --lock-on-suspend"
      , "taffybar"
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
    `additionalKeys` myKeys
