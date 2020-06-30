module Main
  ( main )
where

import System.Posix.Env ( getEnv
                        , putEnv
                        )

import System.Taffybar.Support.PagerHints ( pagerHints )

import XMonad
import XMonad.Actions.UpdatePointer ( updatePointer )
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
main = launch . fullscreenSupport . pagerHints $ myConfig


myModMask = mod4Mask
myKeys =
  [ ( "M-p"
    , safeSpawn "{{synapse}}/bin/synapse" []
    )
  , ( "M-x"
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
  = do  setWMName "LG3D"  -- helps with Java GUIs
        liftIO $ mapM_ (putEnv . gtk2RcFiles) =<< getEnv "HOME"
        safeSpawn "/usr/bin/env" ["xmonad-session-init"]
  where gtk2RcFiles home = "GTK2_RC_FILES=" <> home <> "/.gtkrc-2.0"


myManageHooks =
  [ placeHook . inBounds . fixed $ (0.5, 0.5)
  , appName =? "synapse" --> doIgnore
  , appName =? "speedcrunch" --> doFloat
  ]


{-
logHook to avoid window layout changes leaving the mouse pointer
in a window that doesn't have focus, which is confusing
-}
moveMouseToFocussedWindow = updatePointer (0.5, 0.5) (0.5, 0.5)


myConfig
  = desktopConfig
      { modMask = myModMask
      , terminal = "termite"
      , focusedBorderColor = "#00ff70"
      , normalBorderColor = "#000000"
      , borderWidth = 2
      , startupHook = startupHook desktopConfig >> myStartupHook
      , layoutHook = lessBorders Screen $ layoutHook desktopConfig
      , manageHook = composeAll myManageHooks <+> manageHook desktopConfig
      , logHook = logHook desktopConfig >> moveMouseToFocussedWindow
      }
    `additionalKeysP` myKeys
