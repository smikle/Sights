//
//  Locations.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import Foundation

class Locations {
    
    static let urlString = "https://s3-ap-southeast-2.amazonaws.com/com-cochlear-sabretooth-takehometest/locations.json"
    
    private let session = URLSession(configuration: .default)
    
    func from(urlString: String? = Locations.urlString, completionHandler: ((LocationsModel?) -> Void)?) {
        guard let string = urlString,
            let url = URL(string: string) else {
                dPrint("error url")
                return
        }
        
        let task = session.dataTask(with: url) { (responseData, _, error) in
            if let error = error {
                dPrint(error.localizedDescription)
                completionHandler?(nil)
                return
            }
            
            guard let data = responseData,
                let locations = try? JSONDecoder().decode(LocationsModel.self, from: data) else {
                    dPrint("error")
                    completionHandler?(nil)
                    return
            }
            completionHandler?(locations)
        }
        task.resume()
    }
}

struct LocationsModel: Codable {
    let locations: [LocationModel]
    let updated: String
    
    enum CodingKeys: String, CodingKey {
        case locations
        case updated
    }
    
    struct LocationModel: Codable {
        let name: String
        let lat: Double
        let lng: Double
        
        enum CodingKeys: String, CodingKey {
            case name
            case lat
            case lng
        }
    }
}
