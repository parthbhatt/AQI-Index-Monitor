//
//  CityAQI.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 10/12/21.
//

import Foundation

struct CityModel: Decodable {
    var city: String
    var aqi: Double
    let time: Date! = Date()
}

extension CityModel: Equatable {
    // Customize Equitable Protociol
    static func ==(lhs: CityModel, rhs: CityModel) -> Bool {
        return lhs.city == rhs.city
    }
}
