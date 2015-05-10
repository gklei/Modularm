//
//  File.swift
//  Modularm
//
//  Created by Gregory Klein on 4/16/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import UIKit

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
   
   var plusIcon: UIImage {
      var image: UIImage = UIImage()
      var imageName = ""
      
      switch self
      {
      case .Countdown:
         imageName = "icn-plus-countdown"
         break
      case .Date:
         imageName = "icn-plus-date"
         break
      case .Music:
         imageName = "icn-plus-music"
         break
      case .Repeat:
         imageName = "icn-plus-repeat"
         break
      case .Snooze:
         imageName = "icn-plus-snooze"
         break
      case .Sound:
         imageName = "icn-plus-alarm-sound"
         break
      case .Weather:
         imageName = "icn-plus-weather"
         break
      case .Message:
         imageName = "icn-plus-message"
         
      default: // Unknown
         break
      }
      
      if let icon = UIImage(named: imageName)
      {
         image = icon.templateImage
      }
      return image
   }
}
