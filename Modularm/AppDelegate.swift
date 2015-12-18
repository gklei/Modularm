//
//  AppDelegate.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import CoreData
import CoreLocation
import FBSDKCoreKit

let kModularmMinuteChangedNotification = "ModularmMinuteChangedNotification"
let kModularmWillEnterForegroundNotification = "ModularmEnteredForegroundNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   var window: UIWindow?
   var minuteChangedNotificationTimer: NSTimer?
   private var _locationManager = CLLocationManager() {
      didSet {
         _locationManager.delegate = self
      }
   }

   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      Fabric.with([Crashlytics.self])
      
      _removeInitialKeyboardLag()
      startTimerForMinuteChangedNotification()
      
      // TODO: Onboarding
      AlarmEngine.sharedInstance.registerAlarmNotificationSettings()
      if CLLocationManager.authorizationStatus() == .NotDetermined {
         _locationManager.requestWhenInUseAuthorization()
      }
      if CLLocationManager.locationServicesEnabled() {
         _locationManager.startUpdatingLocation()
      }
      
      if let options = launchOptions {
         if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            if let userInfo = notification.userInfo, let alarmUUID = userInfo["UUID"] as? String {
               showFiredAlarmWithUUID(alarmUUID)
            }
         }
      }
      
      FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
      
      return true
   }
   
   func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
   {
      if let userInfo = notification.userInfo, let alarmUUID = userInfo["UUID"] as? String
      {
         showFiredAlarmWithUUID(alarmUUID)
      }
   }

   func applicationWillResignActive(application: UIApplication)
   {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
      self.stopTimerForMinuteChangedNotification()
   }

   func applicationDidEnterBackground(application: UIApplication)
   {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      self.stopTimerForMinuteChangedNotification()
   }

   func applicationWillEnterForeground(application: UIApplication)
   {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      self.startTimerForMinuteChangedNotification()
      NSNotificationCenter.defaultCenter().postNotificationName(kModularmWillEnterForegroundNotification, object: nil);
   }

   func applicationDidBecomeActive(application: UIApplication)
   {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      self.startTimerForMinuteChangedNotification()
      FBSDKAppEvents.activateApp()
   }

   func applicationWillTerminate(application: UIApplication)
   {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      // Saves changes in the application's managed object context before the application terminates.

      let defaultStack = CoreDataStack.defaultStack
      defaultStack.saveContext()
   }
   
   private func _removeInitialKeyboardLag()
   {
      let dummyTextField = UITextField()
      window?.addSubview(dummyTextField)
      dummyTextField.becomeFirstResponder()
      dummyTextField.resignFirstResponder()
      window?.removeFromSuperview()
   }
   
   private func startTimerForMinuteChangedNotification()
   {
      if self.minuteChangedNotificationTimer == nil
      {
         let calendar = NSCalendar.autoupdatingCurrentCalendar()
         let components = calendar.components(.Second, fromDate: NSDate())
         let currentSecond = components.second
         
         let fireDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(60 - currentSecond + 1))
         self.minuteChangedNotificationTimer = NSTimer(fireDate: fireDate, interval: 60, target: self, selector: Selector("minuteChanged:"), userInfo: nil, repeats: true)
         
         NSRunLoop.mainRunLoop().addTimer(self.minuteChangedNotificationTimer!, forMode: NSDefaultRunLoopMode)
      }
   }
   
   private func showFiredAlarmWithUUID(uuid: String)
   {
      let alarmDetailViewController = UIStoryboard.controllerWithIdentifier("AlarmDetailViewController") as! AlarmDetailViewController
      if let navController = self.window?.rootViewController as? UINavigationController
      {
         if let alarm = AlarmEngine.sharedInstance.alarmForUUID(uuid)
         {
            let shouldPlaySound = UIApplication.sharedApplication().applicationState == .Active
            alarmDetailViewController.configureWithAlarm(alarm, isFiring: true, displayMode: AppSettingsManager.displayMode, shouldPlaySound: shouldPlaySound)
            
            var eventName = FBEventAlarmFired
            if let sound = alarm.sound?.alarmSound {
               eventName += "-\(sound.name)"
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
               FBSDKAppEvents.logEvent(eventName)
            })
         }
         navController.pushViewController(alarmDetailViewController, animated: false)
      }
   }
   
   private func stopTimerForMinuteChangedNotification()
   {
      self.minuteChangedNotificationTimer?.invalidate()
      self.minuteChangedNotificationTimer = nil
   }
   
   func minuteChanged(timer: NSTimer)
   {
      NSNotificationCenter.defaultCenter().postNotificationName(kModularmMinuteChangedNotification, object: nil);
   }
}

extension AppDelegate: CLLocationManagerDelegate
{
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
   {
      if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
         _locationManager.startUpdatingLocation()
      }
   }
}

