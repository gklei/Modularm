//
//  AlarmMusicPickerFactory.swift
//  Modularm
//
//  Created by Alex Hong on 8/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import MediaPlayer

//Internal Enum for picking
enum PickedAlarmMusic{
   case Spotify(name:String, url:NSURL)
   case iPodLibrary(name:String, url:NSURL)
}

extension PickedAlarmMusic : PAlarmMusic
{
   var name:String {
      switch(self){
      case .Spotify(let name, _):
         return name
      case .iPodLibrary(let name, _):
         return name
      }
   }
   
   var musicType:AlarmMusicType {
      switch(self) {
      case .Spotify(_, _):
         return .Spotify
      case .iPodLibrary(_, _):
         return .iPodLibrary
      }
   }
   
   var url:NSURL {
      switch(self) {
      case .Spotify(_, let url):
         return url
      case .iPodLibrary(_, let url):
         return url
      }
   }
}
