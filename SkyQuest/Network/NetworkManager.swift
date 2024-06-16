//
//  NetworkManager.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 05.06.2024.
//
import Foundation

class NetworkManager {
    let sessionConfig = URLSession(configuration: .default)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func getFlight(textFieldFrom: String?, textFieldTo: String?, textFieldDepartingDate: String?, textFieldReturningDate: String?, completion: @escaping ([FlightInfo]) -> Void) {
        guard let textFieldFrom = textFieldFrom, let textFieldTo = textFieldTo, let textFieldDepartingDate = textFieldDepartingDate, let textFieldReturningDate = textFieldReturningDate else {
            completion([])
            return
        }
        guard let url = URL(string: "https://api.travelpayouts.com/aviasales/v3/prices_for_dates?origin=\(textFieldFrom)&destination=\(textFieldTo)&departure_at=\(textFieldDepartingDate)&return_at=\(textFieldReturningDate)&unique=false&sorting=price&direct=true&currency=rub&limit=30&page=1&one_way=false&token=47d5d1dd683ba0b9514d2c88fe9e1cfe") else {
            completion([])
            return
        }
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                completion([])
                return
            }
            if error == nil, let data = data {
                guard let recievedFlights = try? strongSelf.decoder.decode(Flight.self, from: data) else { 
                    completion([])
                    return }
                DispatchQueue.main.async {
                    completion(recievedFlights.data)
                }
            } else {
                guard let error = error else { return }
                completion([])
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
