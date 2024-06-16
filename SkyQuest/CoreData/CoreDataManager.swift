//
//  CoreDataManager.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 13.06.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    var veiwContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SkyQuest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Определяем метод для сохраения Flights в DataBase
    func saveDataToDB(flightInfo: FlightInfo) {
        let flightInfoDB = FlightsInfoEntity(context: veiwContext)
        flightInfoDB.origin = flightInfo.origin
        flightInfoDB.destination = flightInfo.destination
        flightInfoDB.originAeroport = flightInfo.origin_airport
        flightInfoDB.destinationAeroport = flightInfo.destination_airport
        flightInfoDB.airline = flightInfo.airline
        flightInfoDB.departureAt = flightInfo.departure_at
        flightInfoDB.returnAt = flightInfo.return_at
        flightInfoDB.link = flightInfo.link
        saveContext()
    }
    
    // MARK: Определяем метод для загрузки Flights из DataBase
    func loadDataFromDB() -> [FlightInfo] {
        let flightsFetchRequest = FlightsInfoEntity.fetchRequest()
        let flightInfoDB = try? veiwContext.fetch(flightsFetchRequest)
        guard let recievedFlightInfoDB = flightInfoDB else {
            return []
        }
        var flightInfoSaved: [FlightInfo] = []
        recievedFlightInfoDB.forEach { flightInfoDB in
            let flightInfo = FlightInfo(origin: flightInfoDB.origin ?? "", destination: flightInfoDB.destination ?? "", origin_airport: flightInfoDB.originAeroport ?? "", destination_airport: flightInfoDB.destinationAeroport ?? "", airline: flightInfoDB.airline ?? "", departure_at: flightInfoDB.departureAt ?? "", return_at: flightInfoDB.returnAt ?? "", link: flightInfoDB.link ?? "")
            flightInfoSaved.append(flightInfo)
        }
        return flightInfoSaved
    }

    // MARK: Определяем метод для удаления Flights из DataBase
    func deleteDataFromDB(flightInfo: FlightInfo) {
        let flightsFetchRequest = FlightsInfoEntity.fetchRequest()
        flightsFetchRequest.predicate = NSPredicate(format: "link == %@", "\(flightInfo.link)")
        let flightInfoDB = try? veiwContext.fetch(flightsFetchRequest)
        guard let recievedFlightInfoDB = flightInfoDB else {
            return print("Data didn't delete from DB")
        }
        veiwContext.delete(recievedFlightInfoDB[0])
        saveContext()
    }
    
}
