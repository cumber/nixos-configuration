module Main
  ( main )
where

import System.Posix.Env ( getEnv
                        , putEnv
                        )

import System.Taffybar.Support.PagerHints ( pagerHints )

import XMonad
import XMonad.Actions.UpdatePointer ( updatePointer )
import XMonad.Actions.Navigation2D ( Navigation2DConfig ( Navigation2DConfig
                                                        , defaultTiledNavigation
                                                        , floatNavigation
                                                        , screenNavigation
                                                        , layoutNavigation
                                                        )
                                   , navigation2D
                                   , centerNavigation

                                   , singleWindowRect
                                   , unmappedWindowRect
                                   , switchLayer

                                   , windowGo
                                   , windowSwap
                                   , screenGo
                                   , windowToScreen
                                   )
import XMonad.Config.Desktop ( desktopConfig, desktopLayoutModifiers )
import XMonad.Hooks.ManageDocks ( ToggleStruts (ToggleStruts) )
import XMonad.Hooks.ManageHelpers ( isDialog )
import XMonad.Hooks.SetWMName ( setWMName )
import XMonad.Layout.Fullscreen ( fullscreenSupport )
import XMonad.Layout.NoBorders ( Ambiguity (Screen)
                               , lessBorders
                               , hasBorder
                               )
import XMonad.Layout.PerScreen ( ifWider )
import XMonad.Layout.ThreeColumns ( ThreeCol ( ThreeCol ) )
import XMonad.Hooks.InsertPosition ( Focus ( Newer )
                                   , Position ( Below )
                                   , insertPosition
                                   )
import XMonad.Hooks.Place ( fixed
                          , inBounds
                          , placeHook
                          )
import XMonad.Util.EZConfig ( additionalKeysP )
import XMonad.Util.Run ( safeSpawn )


main :: IO ()
main = launch . fullscreenSupport . pagerHints . nav2D $ myConfig


myModMask = mod4Mask
myKeys =
  [ ( "M-b"
    , sendMessage ToggleStruts
    )

  , ( "<XF86AudioLowerVolume>"
    , safeSpawn "{{sys-pulseaudio}}/bin/pactl"
                 [ "set-sink-volume", "@DEFAULT_SINK@", "-5%" ]
    )
  , ( "<XF86AudioRaiseVolume>"
    , safeSpawn "{{sys-pulseaudio}}/bin/pactl"
                [ "set-sink-volume", "@DEFAULT_SINK@", "+5%" ]
    )
  , ( "<XF86AudioMute>"
    , safeSpawn "{{sys-pulseaudio}}/bin/pactl"
                [ "set-sink-mute", "@DEFAULT_SINK@", "toggle" ]
    )

    -- Win-z locks screen
  , ( "M-z"
    , safeSpawn "{{lightlocker}}/bin/light-locker-command" ["-l"]
    )

  , ( "M-C-<Tab>"
    , switchLayer
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
  , appName =? "albert" --> hasBorder False
  , not <$> isDialog --> insertPosition Below Newer
  ]


{-
logHook to avoid window layout changes leaving the mouse pointer
in a window that doesn't have focus, which is confusing
-}
moveMouseToFocussedWindow = updatePointer (0.5, 0.5) (0.5, 0.5)


myLayout
  = lessBorders Screen
    . desktopLayoutModifiers
    $ ifWider 2500 large (ifWider 1500 medium small)
  where small = vertical ||| Full
        medium = horizontal ||| Full
        large = three ||| horizontal ||| Full

        three = ThreeCol nmaster delta (1/3)
        horizontal = Tall nmaster delta (1/2)
        vertical = Mirror horizontal

        nmaster = 1
        delta = 3/100


nav2D = navigation2D navConfig
          (xK_Up, xK_Left, xK_Down, xK_Right)
          [ (myModMask, windowGo)
          , (myModMask .|. shiftMask, windowSwap)
          , (myModMask .|. controlMask, screenGo)
          , (myModMask .|. controlMask .|. shiftMask, windowToScreen)
          ]
          False

navConfig
  = Navigation2DConfig
      { defaultTiledNavigation = centerNavigation
      , floatNavigation = centerNavigation
      , screenNavigation = centerNavigation
      , layoutNavigation = [("Full", centerNavigation)]
      , unmappedWindowRect = [("Full", singleWindowRect)]
      }


myConfig
  = desktopConfig
      { modMask = myModMask
      , terminal = "alacritty"
      , focusedBorderColor = "#00ff70"
      , normalBorderColor = "#000000"
      , borderWidth = 2
      , startupHook = startupHook desktopConfig >> myStartupHook
      , layoutHook = myLayout
      , manageHook = composeAll myManageHooks <+> manageHook desktopConfig
      , logHook = logHook desktopConfig >> moveMouseToFocussedWindow
      }
    `additionalKeysP` myKeys
