{-# LANGUAGE FlexibleContexts #-}

import System.Posix

import System.Taffybar.Hooks.PagerHints (pagerHints)

import XMonad
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.ManageDocks (ToggleStruts(ToggleStruts))
import XMonad.Util.EZConfig (additionalKeys)



main :: IO ()
main = xmonad . pagerHints $ myConfig


myModMask = mod4Mask
myKeys =
  [ ((myModMask, xK_p), spawn "synapse")
  , ((myModMask .|. mod1Mask, xK_space), spawn "synapse")
  , ((myModMask, xK_b), sendMessage ToggleStruts)
  ]


-- Stolen from xmonad-contrib/src/XMonad-Hooks-DynamicLog.html, which doesn't
-- export it.
toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )


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
  ]


myConfig
  = desktopConfig
      { modMask = myModMask
      , focusedBorderColor = "#1010bb"
      , normalBorderColor = "#000000"
      , borderWidth = 2
      , startupHook = startupHook desktopConfig >> myStartupHook
      , manageHook = composeAll myManageHooks <+> manageHook desktopConfig
      }
    `additionalKeys` myKeys

