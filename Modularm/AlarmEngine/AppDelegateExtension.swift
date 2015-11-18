//
//  AppDelegateExtension.swift
//  Modularm
//
//  Created by Alex Hong on 11/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// MARK: - AppDelegate extension for snooze action
extension AppDelegate {
   func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
      if identifier == kAlarmNotificationSnoozeActionIdentifier && notification.isSnoozeEnabled {
         AlarmEngine.sharedInstance.snoozeAlarm(notification, afterMinutes: notification.snoozeMinute)
      }
      completionHandler()
   }
}

// MARK: - UILocalNotification's extension can be only used here.
extension UILocalNotification:PAlarm {
   internal var alarmIdentifier:String {
      return (userInfo?[kAlarmNotificationUserInfoAlarmUUIDKey] as? String) ?? ""
   }
   
   internal var alarmBody:String {return alertBody ?? ""}
   internal var alarmSound:String {return soundName ?? UILocalNotificationDefaultSoundName }
   
   // Will implement in future.
   internal var alarmHour:Int {return 0}
   internal var alarmMinute:Int {return 0}
   internal var alarmWeekDays:[Int]? {return nil}
   
   var snoozeMinute:Int {
      return userInfo?[kAlarmNotificationUserInfoSnoozeMinute] as? Int ?? 0
   }
}
