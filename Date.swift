//
//  Date.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Date)
class Date: NSManagedObject {

    @NSManaged var displayType: Int16
    @NSManaged var alarm: Alarm

}
