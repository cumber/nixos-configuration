{-# LANGUAGE FlexibleContexts #-}

import System.Posix

import System.Taffybar.Hooks.PagerHints (pagerHints)

import XMonad
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.ManageDocks (ToggleStruts(ToggleStruts))
import XMonad.Layout.Fullscreen (fullscreenEventHook, fullscreenManageHook)
import XMonad.Layout.NoBorders (Ambiguity(Screen), lessBorders)
import XMonad.Util.EZConfig (additionalKeys)



main :: IO ()
main = xmonad . pagerHints $ myConfig


myModMask = mod4Mask
myKeys =
  [ ((myModMask               , xK_p)         , spawn "synapse")
  , ((myModMask .|. mod1Mask  , xK_space)     , spawn "synapse")
  , ((myModMask               , xK_b)         , sendMessage ToggleStruts)
  , ((0                       , 0x1008FF11)   , spawn "amixer set Master 2-")
  , ((0                       , 0x1008FF13)   , spawn "amixer set Master 2+")
  , ((0                       , 0x1008FF12)   , spawn "amixer set Master toggle")
  ]


myStartupHook
  = do  spawn "~/.xmonad/startup-hook"
        liftIO $ do gkc <- liftIO $ getEnv "GNOME_KEYRING_CONTROL"
                    maybe
                        (return ())
                        (\path
                         -> liftIO $ setEnv "SSH_AUTH_SOCK" (path ++ "/ssh") True
                        )
                        gkc
                    setEnv "GTK2_RC_FILES" "$HOME/.gtkrc-2.0" True


myManageHooks =
  [ appName =? "synapse" --> doIgnore
  , fullscreenManageHook
  ]


myConfig
  = desktopConfig
      { modMask = myModMask
      , terminal = "gnome-terminal"
      , focusedBorderColor = "#1010bb"
      , normalBorderColor = "#000000"
      , borderWidth = 2
      , startupHook = startupHook desktopConfig >> myStartupHook
      , layoutHook = lessBorders Screen $ layoutHook desktopConfig
      , manageHook = composeAll myManageHooks <+> manageHook desktopConfig
      , handleEventHook = fullscreenEventHook
      }
    `additionalKeys` myKeys

