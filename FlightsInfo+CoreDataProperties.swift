//
//  FlightsInfo+CoreDataProperties.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 13.06.2024.
//
//

import Foundation
import CoreData


extension FlightsInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightsInfo> {
        return NSFetchRequest<FlightsInfo>(entityName: "FlightsInfo")
    }

    @NSManaged public var origin: String?
    @NSManaged public var destination: String?
    @NSManaged public var originAeroport: String?
    @NSManaged public var destinationAeroport: String?
    @NSManaged public var airline: String?
    @NSManaged public var departureAt: String?
    @NSManaged public var returnAt: String?
    @NSManaged public var link: String?

}

extension FlightsInfo : Identifiable {

}
