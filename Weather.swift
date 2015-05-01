//
//  Weather.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Weather)
class Weather: NSManagedObject {

    @NSManaged var displayType: Int16
    @NSManaged var backgroundPhoto: Bool
    @NSManaged var autoLocation: Int16
    @NSManaged var alarm: Alarm

}
