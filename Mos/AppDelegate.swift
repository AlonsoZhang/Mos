//
//  AppDelegate.swift
//  Mos
//
//  Created by Caldis on 2017/1/10.
//  Copyright © 2017年 Caldis. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var mouseEventTap:CFMachPort?
    let mouseEventMask = CGEventMask(1 << CGEventType.otherMouseDown.rawValue)
    
    // 运行前预处理
    func applicationWillFinishLaunching(_ notification: Notification) {
        // 设置通知中心代理
        NSUserNotificationCenter.default.delegate = self
        // 禁止重复运行
        Utils.preventMultiRunning(killExist: true)
        // 读取用户设置
        Options.shared.readOptions()
        // 提示用户状态栏图标已隐藏
        Utils.notificateUserStatusBarIconIsHidden()
        // 监听用户切换, 在切换用户 session 时停止运行
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(AppDelegate.sessionDidActive), name: NSWorkspace.sessionDidBecomeActiveNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(AppDelegate.sessionDidResign), name: NSWorkspace.sessionDidResignActiveNotification, object: nil)
    }
    // 运行后启动处理
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ScrollCore.shared.startHandlingScroll()
        mouseEventTap = Interception.start(event: mouseEventMask, to: mouseEventCallback, at: .cghidEventTap, where: .headInsertEventTap, for: .defaultTap)
    }
    
    let mouseEventCallback: CGEventTapCallBack = { (proxy, type, event, refcon) in
        let flag = event.getIntegerValueField(.mouseEventButtonNumber)
        if flag == 4 {
            
            //NSDictionary *error = [NSDictionary new];
            let script = NSAppleScript.init(source: "tell application \"System Events\" to key code 123 using command down")
            script?.executeAndReturnError(nil)
//            var event = CGEvent(keyboardEventSource: nil, virtualKey: 43, keyDown: true)
//            event?.flags = CGEventFlags.maskControl
//            event?.post(tap: .cgSessionEventTap)
//            event = CGEvent(keyboardEventSource: nil, virtualKey: 43, keyDown: false)
//            event?.flags = CGEventFlags.maskControl
//            event?.post(tap: .cgSessionEventTap)
        }else if flag == 3{
            let script = NSAppleScript.init(source: "tell application \"System Events\" to key code 124 using command down")
            script?.executeAndReturnError(nil)
//            var event = CGEvent(keyboardEventSource: nil, virtualKey: 47, keyDown: true)
//            event?.flags = CGEventFlags.maskControl
//            event?.post(tap: .cgSessionEventTap)
//            event = CGEvent(keyboardEventSource: nil, virtualKey: 47, keyDown: false)
//            event?.flags = CGEventFlags.maskControl
//            event?.post(tap: .cgSessionEventTap)
        }else if flag == 2{
            
        }
        return nil
    }
    // 关闭前停止处理
    func applicationWillTerminate(_ aNotification: Notification) {
        ScrollCore.shared.endHandlingScroll()
    }
    
    // 在切换用户时停止处理
    @objc func sessionDidActive(notification:NSNotification){
         ScrollCore.shared.startHandlingScroll()
    }
    @objc func sessionDidResign(notification:NSNotification){
         ScrollCore.shared.endHandlingScroll()
    }
    
    // 收到通知后显示图标
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        Options.shared.others.hideStatusItem = false
    }
    
}
