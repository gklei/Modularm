//
//  Countdown.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Countdown)
class Countdown: NSManagedObject
{
    @NSManaged var shouldDisplay: Bool
    @NSManaged var alarm: Alarm
}
