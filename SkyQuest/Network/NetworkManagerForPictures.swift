//
//  NetworkManagerForPictures.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 06.06.2024.
//

import Foundation
import UIKit

class NetworkManagerForPictures {
    let sessionConfig = URLSession(configuration: .default)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func getPicture(airlineLogo: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: "http://pics.avs.io/100/30/\(airlineLogo).png") else {
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                guard let error = error else { return }
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
}
