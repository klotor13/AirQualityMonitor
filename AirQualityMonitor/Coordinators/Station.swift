//
//  Station.swift
//  AirQualityMonitor
//
//  Created by Karol on 09.01.2018.
//  Copyright © 2018 KarolPiatek. All rights reserved.
//

import Foundation

struct Station {
    var id: Int?
    var stationName: String?
    var gegrLat: String?
    var gegrLon: String?
    var city: City?
    var addressStreet: String?
    
    func getDisplayAddress() -> String {
        guard let street = self.addressStreet, let city = self.city?.name else {
            return self.city?.name ?? "NoData".localized
        }
        return street + ", " + city
    }
}

extension Station: Decodable {
    enum StationKeys: String, CodingKey {
        case id
        case stationName
        case gegrLat
        case gegrLon
        case city
        case addressStreet
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        stationName = try? container.decode(String.self, forKey: .stationName)
        gegrLat = try? container.decode(String.self, forKey: .gegrLat)
        gegrLon = try? container.decode(String.self, forKey: .gegrLon)
        city = try? container.decode(City.self, forKey: .city)
        addressStreet = try? container.decode(String.self, forKey: .addressStreet)
    }
}
