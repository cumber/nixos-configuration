module Main
  ( main )
where

import Control.Monad ((<=<))
import Control.Monad.IO.Class (liftIO)

import Data.List (intersperse)
import Data.Monoid ((<>))

import Graphics.X11.Xinerama (getScreenInfo)

import System.Posix.Env (getEnv, putEnv)

import System.Taffybar.Hooks.PagerHints (pagerHints)

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
  [ ((myModMask               , xK_p)         , spawn "@synapse@/bin/synapse")
  , ((myModMask .|. mod1Mask  , xK_space)     , spawn "@synapse@/bin/synapse")
  , ((myModMask               , xK_b)         , sendMessage ToggleStruts)

  -- TODO: make this work on vanwa
  , ((0                       , 0x1008FF11)   , spawn "amixer set Master 2-")
  , ((0                       , 0x1008FF13)   , spawn "amixer set Master 2+")
  , ((0                       , 0x1008FF12)   , spawn "amixer set Master toggle")
  ]


withScreenCount f = withDisplay $ f . length <=< liftIO . getScreenInfo


myStartupHook
  = do  withScreenCount startupCommands
        setWMName "LG3D"  -- helps with Java GUIs
        liftIO $ mapM_ (putEnv . gtk2RcFiles) =<< getEnv "HOME"

  where gtk2RcFiles home = "GTK2_RC_FILES=" <> home <> "/.gtkrc-2.0"


startupCommands screens
  = do  mapM_ spawn simpleCommands
        let spawnBars = [ "taffybar " ++ show n | n <- [0 .. screens - 1] ]
        mapM_ spawn $ intersperse "sleep 0.1" spawnBars

simpleCommands
  =   [ "@setxkbmap@/bin/setxkbmap -option 'compose:ralt'"
      , "@notify-osd@/bin/notify-osd"
      , "@synapse@/bin/synapse -s"
      , "@compton@/bin/compton"
      , "@networkmanagerapplet@/bin/nm-applet --sm-disable"
      , "@system-config-printer@/bin/system-config-printer-applet"
      , "@powerline@/bin/powerline-daemon --replace"
      , "@udiskie@/bin/udiskie --tray"
      , "@syncthing-gtk@/bin/syncthing-gtk --minimized"
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
