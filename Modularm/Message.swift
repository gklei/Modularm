//
//  Message.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Message)
class Message: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var alarm: Alarm

}
