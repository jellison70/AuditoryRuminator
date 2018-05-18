//
//  Previous+CoreDataProperties.swift
//  
//
//  Created by John Ellison on 4/26/18.
//
//

import Foundation
import CoreData


extension Previous {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Previous> {
        return NSFetchRequest<Previous>(entityName: "Previous")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var thresholdR: Double
    @NSManaged public var thresholdL: Double

}
