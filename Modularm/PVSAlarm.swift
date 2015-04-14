//
//  PVSAlarm.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(PVSAlarm)
class PVSAlarm: NSManagedObject
{
    @NSManaged var date: NSTimeInterval
    @NSManaged var message: String
}
