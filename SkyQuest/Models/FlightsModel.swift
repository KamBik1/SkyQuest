//
//  Model.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 04.06.2024.
//
import Foundation

struct Flight: Decodable {
    let success: Bool
    let data: [FlightInfo]
    let currency: String
}

struct FlightInfo: Decodable {
    var origin: String
    var destination: String
    let origin_airport: String
    let destination_airport: String
    let airline: String
    let departure_at: String
    let return_at: String
    let link: String
    
    // MARK: Определяем метод, который преобразует дату и время в структуру типа DateTime
    private func transformDateTime(dateTime: String) -> DateTime {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateTime) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let day = components.day
            let month = components.month
            let year = components.year
            let hour = components.hour
            let minute = components.minute
            guard let day = day, let month = month, let year = year, let hour = hour, let minute = minute else { return DateTime(day: "", month: "", year: "", hour: "", minute: "") }
            let stringDay = String(format: "%02d", day)
            let stringMonth = String(format: "%02d", month)
            let stringYear = String(year)
            let stringHour = String(format: "%02d", hour)
            let stringMinute = String(format: "%02d", minute)
            return DateTime(day: stringDay, month: stringMonth, year: stringYear, hour: stringHour, minute: stringMinute)
        }
        else {
            return DateTime(day: "", month: "", year: "", hour: "", minute: "")
        }
    }
    
    // MARK: Определяем метод, который возвращяет departureDate
    func createDepartureDate() -> String {
        let day = transformDateTime(dateTime: departure_at).day
        let month = transformDateTime(dateTime: departure_at).month
        let year = transformDateTime(dateTime: departure_at).year
        return "\(day)/\(month)/\(year)"
    }
    
    // MARK: Определяем метод, который возвращяет returnDate
    func createReturnDate() -> String {
        let day = transformDateTime(dateTime: return_at).day
        let month = transformDateTime(dateTime: return_at).month
        let year = transformDateTime(dateTime: return_at).year
        return "\(day)/\(month)/\(year)"
    }
    
    // MARK: Определяем метод, который возвращяет departureTime
    func createDepartureTime() -> String {
        let hour = transformDateTime(dateTime: departure_at).hour
        let minute = transformDateTime(dateTime: departure_at).minute
        return "\(hour):\(minute)"
    }
    
    // MARK: Определяем метод, который возвращяет returnTime
    func createReturnTime() -> String {
        let hour = transformDateTime(dateTime: return_at).hour
        let minute = transformDateTime(dateTime: return_at).minute
        return "\(hour):\(minute)"
    }
}
