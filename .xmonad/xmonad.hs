{-# LANGUAGE FlexibleContexts #-}

import Data.Monoid ((<>))

import System.IO (Handle, hGetContents)
import System.Posix.Env (getEnv, setEnv, putEnv)
import System.Process (StdStream(CreatePipe), proc, createProcess, std_out)

import System.Taffybar.Hooks.PagerHints (pagerHints)

import XMonad
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.ManageDocks (ToggleStruts(ToggleStruts))
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.Fullscreen (fullscreenEventHook, fullscreenManageHook)
import XMonad.Layout.NoBorders (Ambiguity(Screen), lessBorders)
import XMonad.Hooks.Place (fixed, inBounds, placeHook)
import XMonad.Util.EZConfig (additionalKeys)



main :: IO ()
main = xmonad . pagerHints $ myConfig


myModMask = mod4Mask
myKeys =
  [ ((myModMask               , xK_p)         , spawn "synapse")
  , ((myModMask .|. mod1Mask  , xK_space)     , spawn "synapse")
  , ((myModMask               , xK_b)         , sendMessage ToggleStruts)

  -- TODO: make this work
  , ((0                       , 0x1008FF11)   , spawn "amixer set Master 2-")
  , ((0                       , 0x1008FF13)   , spawn "amixer set Master 2+")
  , ((0                       , 0x1008FF12)   , spawn "amixer set Master toggle")
  ]


myStartupHook
  = do  home <- liftIO $ getEnv "HOME"
        mapM_ spawn commands
        setWMName "LG3D"  -- helps with Java GUIs
        liftIO $ do mapM_ (putEnv . gtk2RcFiles) =<< getEnv "HOME"
                    (_, Just hout, _, _) <- gnomeKeyringDaemon
                    mapM_ putEnv =<< lines <$> hGetContents hout

  where gtk2RcFiles home = "GTK2_RC_FILES=" <> home <> "/.gtkrc-2.0"
        gnomeKeyringDaemon
          = createProcess $ (proc "gnome-keyring-daemon" ["--replace"])
                            { std_out = CreatePipe }

commands
  =   [ "setxkbmap -option 'compose:menu'"  -- TODO: what do I want?
      , "synapse -s"
      , "compton"
      , "nm-applet --sm-disable"
      , "system-config-printer-applet"
      , "taffybar 0"
      ]


myManageHooks =
  [ placeHook . inBounds . fixed $ (0.5, 0.5)
  , appName =? "synapse" --> doIgnore
  , appName =? "speedcrunch" --> doFloat
  , fullscreenManageHook
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
      , handleEventHook = fullscreenEventHook
      }
    `additionalKeys` myKeys

