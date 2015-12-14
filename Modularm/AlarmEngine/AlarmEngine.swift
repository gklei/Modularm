//
//  AlarmEngine.swift
//  Modularm
//
//  Created by Alex Hong on 11/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// MARK: - PAlarmEngine implementation
class AlarmEngine
{
   static let sharedInstance:AlarmEngine = AlarmEngine()
   private let application = UIApplication.sharedApplication()
   
   // MARK: - Register User Notification Settings
   func registerAlarmNotificationSettings()
   {
      let snoozeAction = UIMutableUserNotificationAction()
      snoozeAction.identifier = kAlarmNotificationSnoozeActionIdentifier
      snoozeAction.title = kAlarmNotificationSnoozeActionTitle
      snoozeAction.activationMode = .Background
      snoozeAction.authenticationRequired = false
      
      let alarmCategory = UIMutableUserNotificationCategory()
      alarmCategory.identifier = kAlarmNotificationSnoozeCategoryIdentifier
      alarmCategory.setActions([snoozeAction], forContext: .Default)
      
      let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: [alarmCategory])
      application.registerUserNotificationSettings(settings)
   }
   
   // MARK: - AlarmEngine
   func isScheduledAlarm(alarm:PAlarm) -> Bool
   {
      //Check if this is already scheduled alarm, used to update UI.
      let matched = application.scheduledLocalNotifications?.filter{$0 == alarm}
      return (matched?.count ?? 0) > 0
   }
   
   func scheduleAlarm(alarm:PAlarm)
   {
      //first, cancel alarm
      cancelAlarm(alarm)
      
      //Generate notification object and schedule alarm
      let notifications = alarm.buildNotifications()
      for notification in notifications {
         
         print("AlarmEngine -- scheduling alarm at: \(notification.fireDate?.prettyDateString())")
         application.scheduleLocalNotification(notification)
      }
   }
   
   func cancelAlarm(alarm:PAlarm)
   {
      //Cancel alarm if existed. (used when started editing a alarm)
      let matched:[UILocalNotification] = application.scheduledLocalNotifications?.filter{$0 == alarm} ?? []
      for notification in matched
      {
         if let fireDate = notification.fireDate
         {
            print("AlarmEngine -- unscheduling notification with fireDate: \(fireDate.prettyDateString())")
         }
         application.cancelLocalNotification(notification)
      }
   }
   
   func snoozeAlarm(alarm:PAlarm, afterMinutes minutes:Int)  //Snooze alarm after several minutes
   {
      //First check alarm identifier is available.
      guard alarm.alarmIdentifier != "" else { return }
      
      let fireDate = NSDate().dateByAddingTimeInterval((NSTimeInterval)(minutes * 60))
      let notification = alarm.buildTemplateNotification(fireDate)
      application.scheduleLocalNotification(notification)
   }
   
   func alarmForUUID(uuid: String) -> Alarm?
   {
      var targetAlarm: Alarm?
      if let alarms = AlarmManager.alarms
      {
         for alarm in alarms
         {
            if alarm.identifier.characters.elementsEqual(uuid.characters)
            {
               targetAlarm = alarm
               break
            }
         }
      }
      return targetAlarm
   }
}
