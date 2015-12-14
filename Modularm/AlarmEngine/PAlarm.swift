//
//  PAlarm.swift
//  Modularm
//
//  Created by Alex Hong on 11/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// protocol for representing alarm
protocol PAlarm
{
   var alarmIdentifier: String { get }    //Unique identifier of alarm
   var alarmBody: String { get }
   var alarmHour: Int { get }             //Hour to be fired.
   var alarmMinute: Int { get }           //Minute to be fired.
   var alarmWeekDays: [Int]? { get }
   var alarmSound: String { get }
   var snoozeMinute: Int { get }          //If bigger than zero this should be snoozed
   var alarmType: AlarmType { get }
}