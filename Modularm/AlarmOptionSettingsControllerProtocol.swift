//
//  AlarmOptionSettingsControllerProtocol.swift
//  Modularm
//
//  Created by Gregory Klein on 4/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol AlarmOptionSettingsControllerProtocol
{
   func configureWithAlarm(alarm: Alarm?, option: AlarmOption)
   func cancelButtonPressed()
   func deleteSettingsButtonPressedWithOption(option: AlarmOption)
   func updateSetOptionButtonClosure(closure: (() -> ())?)
   func updateSetOptionButtonTitle(title: String)
   func resetSetOptionButtonTitle()
}
