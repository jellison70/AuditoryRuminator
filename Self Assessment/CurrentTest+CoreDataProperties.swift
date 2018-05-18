//
//  CurrentTest+CoreDataProperties.swift
//  
//
//  Created by John Ellison on 4/27/18.
//
//

import Foundation
import CoreData


extension CurrentTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentTest> {
        return NSFetchRequest<CurrentTest>(entityName: "CurrentTest")
    }

    @NSManaged public var date: String?
    @NSManaged public var thresholdL_1k: Double
    @NSManaged public var thresholdR_1k: Double
    @NSManaged public var thresholdL_2k: Double
    @NSManaged public var thresholdR_2k: Double
    @NSManaged public var thresholdL_3k: Double
    @NSManaged public var thresholdR_3k: Double
    @NSManaged public var thresholdL_4k: Double
    @NSManaged public var thresholdR_4k: Double

}
