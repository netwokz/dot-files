{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified GI.Gtk as Gtk
import Data.GI.Base
import System.Directory
import System.Process
import System.Posix.User

main :: IO ()
main = do
    Gtk.init Nothing

    window <- Gtk.windowNew Gtk.WindowTypeToplevel
    Gtk.setContainerBorderWidth window 10
    Gtk.setWindowTitle window "ByeBye"
    Gtk.setWindowResizable window False
    Gtk.setWindowDefaultWidth window 750
    Gtk.setWindowDefaultHeight window 225
    Gtk.setWindowWindowPosition window Gtk.WindowPositionCenter
    Gtk.setWindowDecorated window False

    home <- getHomeDirectory
    user <- getEffectiveUserName

    img_cancel <- Gtk.imageNewFromFile $ home ++ "/logout-app/byebye/img/cancel.png"
    img_logout <- Gtk.imageNewFromFile $ home ++ "/logout-app/byebye/img/logout.png"
    img_reboot <- Gtk.imageNewFromFile $ home ++ "/logout-app/byebye/img/reboot.png"
    img_shutdown <- Gtk.imageNewFromFile $ home ++ "/logout-app/byebye/img/shutdown.png"
    img_lock <- Gtk.imageNewFromFile $ home ++ "/logout-app/byebye/img/lock.png"

    label_cancel <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label_cancel "<b>Cancel</b>"

    label_logout <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label_logout "<b>Logout</b>"
    
    label_reboot <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label_reboot "<b>Reboot</b>"

    label_shutdown <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label_shutdown "<b>Shutdown</b>"

    label_lock <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label_lock "<b>Lock</b>"

    btn_cancel <- Gtk.buttonNew
    Gtk.buttonSetRelief btn_cancel Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn_cancel $ Just img_cancel
    Gtk.widgetSetHexpand btn_cancel False
    on btn_cancel #clicked $ do
        putStrLn "User chose: Cancel"
        Gtk.widgetDestroy window

    btn_logout <- Gtk.buttonNew
    Gtk.buttonSetRelief btn_logout Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn_logout $ Just img_logout
    Gtk.widgetSetHexpand btn_logout False
    on btn_logout #clicked $ do
        putStrLn "User chose: Logout"
        callCommand $ "pkill -9 -u " ++ user

    btn_reboot <- Gtk.buttonNew
    Gtk.buttonSetRelief btn_reboot Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn_reboot $ Just img_reboot
    Gtk.widgetSetHexpand btn_reboot False
    on btn_reboot #clicked $ do
        putStrLn "User chose: Reboot"
        callCommand "reboot"

    btn_shutdown <- Gtk.buttonNew
    Gtk.buttonSetRelief btn_shutdown Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn_shutdown $ Just img_shutdown
    Gtk.widgetSetHexpand btn_shutdown False
    on btn_shutdown #clicked $ do
        putStrLn "User chose: Shutdown"
        callCommand "shutdown -h now"

    btn_lock <- Gtk.buttonNew
    Gtk.buttonSetRelief btn_lock Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn_lock $ Just img_lock
    Gtk.widgetSetHexpand btn_lock False
    on btn_lock #clicked $ do
        putStrLn "User chose: Lock"
        callCommand "xflock4"
        Gtk.widgetDestroy window

    grid <- Gtk.gridNew
    Gtk.gridSetColumnSpacing grid 10
    Gtk.gridSetRowSpacing grid 10
    Gtk.gridSetColumnHomogeneous grid True

    #attach grid btn_cancel     0 0 1 1
    #attach grid label_cancel   0 1 1 1

    #attach grid btn_logout     1 0 1 1
    #attach grid label_logout   1 1 1 1

    #attach grid btn_reboot     2 0 1 1
    #attach grid label_reboot   2 1 1 1

    #attach grid btn_shutdown   3 0 1 1
    #attach grid label_shutdown 3 1 1 1

    #attach grid btn_lock       4 0 1 1
    #attach grid label_lock     4 1 1 1

    #add window grid

    Gtk.onWidgetDestroy window Gtk.mainQuit
    #showAll window
    Gtk.main
