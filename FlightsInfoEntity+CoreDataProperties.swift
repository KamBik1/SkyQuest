//
//  FlightsInfoEntity+CoreDataProperties.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 13.06.2024.
//
//

import Foundation
import CoreData


extension FlightsInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightsInfoEntity> {
        return NSFetchRequest<FlightsInfoEntity>(entityName: "FlightsInfoEntity")
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

extension FlightsInfoEntity : Identifiable {

}
