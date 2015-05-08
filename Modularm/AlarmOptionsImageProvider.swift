//
//  AlarmOptionsImageProvider.swift
//  Modularm
//
//  Created by Klein, Greg on 5/8/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

struct AlarmOptionImageProvider
{
   //      if let button = self.optionButton
   //      {
   //         self.iconImageView.image = button.deactivatedImage?.templateImage
   //
   //         let option = button.option
   //         let title = self.buttonTitleForOption(option)
   //         self.setOptionButton.setTitle(title, forState: .Normal)
   //         self.delegateDataSource = self.delegateDataSourceForOption(option)
   //      }
   
   static func iconForOption(option: AlarmOption) -> UIImage
   {
      var image: UIImage = UIImage()
      var imageName = ""
      
      switch (option)
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
