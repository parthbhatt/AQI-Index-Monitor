//
//  AQICustomTableViewCell.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 10/12/21.
//

import UIKit
import ABGaugeViewKit

class AQITableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblAQIValue: UILabel!
    @IBOutlet weak var lblLastUpdated: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var vwBgShadow: UIView!
    @IBOutlet weak var vwGauge: ABGaugeView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.vwBackground.layer.cornerRadius = 5
        self.vwBackground.layer.borderColor = UIColor.lightGray.cgColor
        self.vwBackground.layer.borderWidth = 0.5
    }
    
    func configureCellWithValues(cityName: String , airQualityIndex: Double, timestamp: Date)
    {
        lblCityName.text = cityName
        lblAQIValue.text = String(format: "%.2f", airQualityIndex)
        vwGauge.needleValue = (airQualityIndex * 100.0) / 501.0
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: timestamp, relativeTo: Date())
        if relativeDate.contains("in 0 seconds") {
            lblLastUpdated.text = "updated just now"
        } else {
            lblLastUpdated.text = "updated " + relativeDate
        }
    }
}
