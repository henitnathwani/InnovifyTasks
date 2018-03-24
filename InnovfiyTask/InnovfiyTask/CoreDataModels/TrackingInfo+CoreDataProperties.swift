//
//  TrackingInfo+CoreDataProperties.swift
//  Innovfiy Task
//
//  Created by Henit Nathwani on 24/03/18.
//  Copyright © 2018 Henit Nathwani. All rights reserved.
//
//

import Foundation
import CoreData


extension TrackingInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackingInfo> {
        return NSFetchRequest<TrackingInfo>(entityName: "TrackingInfo")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var currentTimeInterval: Double
    @NSManaged public var nextTimeInterval: Double
    @NSManaged public var time: NSDate?

}
