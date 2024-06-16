//
//  AeroportsCodes.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 10.06.2024.
//

import Foundation

struct AeroportsCodes {
    let IATAcodes: [String: String] = [
        "moscow" : "MOW",
        "dubai" : "DXB",
        "istanbul" : "IST",
        "astana" : "NQZ",
        "sochi" : "AER"
        ]
    
    // MARK: Определяем метод, который преобразует города в IATA-коды
    func searchIATAcode(forCity: String) -> String {
        return IATAcodes[forCity.lowercased()] ?? ""
    }
}
