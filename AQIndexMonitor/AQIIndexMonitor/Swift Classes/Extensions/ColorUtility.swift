//
//  Color.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 12/12/21.
//

import Foundation
import UIKit
import Charts

class ColorUtility: NSObject
{
    class func setColor(aqiValue: Double) -> UIColor {
        switch aqiValue {
        case 0..<51:
            return NSUIColor(red: 106.0/255.0, green: 165.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        case 51..<101:
            return NSUIColor(red: 171.0/255.0, green: 198.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        case 101..<201:
            return NSUIColor(red: 254.0/255.0, green: 247.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case 201..<301:
            return NSUIColor(red: 230.0/255.0, green: 159.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        case 301..<401:
            return NSUIColor(red: 215.0/255.0, green: 77.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        case 401...501:
            return NSUIColor(red: 161.0/255.0, green: 56.0/255.0, blue: 44.0/255.0, alpha: 1.0)
        default:
            return NSUIColor(red: 161.0/255.0, green: 56.0/255.0, blue: 44.0/255.0, alpha: 1.0)
        }
    }
}
