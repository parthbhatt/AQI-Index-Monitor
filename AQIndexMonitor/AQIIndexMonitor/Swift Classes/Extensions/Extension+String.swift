//
//  Extension+String.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 12/12/21.
//

import Foundation

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
