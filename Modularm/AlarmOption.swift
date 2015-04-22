//
//  File.swift
//  Modularm
//
//  Created by Gregory Klein on 4/16/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

enum AlarmOption
{
   case Snooze
   case Sound
   case Music
   case Message
   case Weather
   case Date
   case Repeat
   case Countdown
   case Unknown
   
   var description: String {
      switch self {
      case Snooze: return "Snooze"
      case Sound: return "Sound"
      case Music: return "Music"
      case Message: return "Message"
      case Weather: return "Weather"
      case Date: return "Date"
      case Repeat: return "Repeat"
      case Countdown: return "Countdown"
      case Unknown: return "Unknown"
      }
   }
}
