//
//  CalibrationData+CoreDataProperties.swift
//  
//
//  Created by John Ellison on 5/14/18.
//
//

import Foundation
import CoreData


extension CalibrationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalibrationData> {
        return NSFetchRequest<CalibrationData>(entityName: "CalibrationData")
    }
    @NSManaged public var date: String?
    @NSManaged public var calL_1k: Double
    @NSManaged public var calL_3k: Double
    @NSManaged public var calL_4k: Double
    @NSManaged public var calR_1k: Double
    @NSManaged public var calR_2k: Double
    @NSManaged public var calR_3k: Double
    @NSManaged public var calR_4k: Double
    @NSManaged public var calL_2k: Double

}
