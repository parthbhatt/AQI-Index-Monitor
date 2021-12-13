//
//  ViewController.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 10/12/21.
//

import UIKit

protocol AQIHomeViewControllerDelegate: AnyObject {
    func notifyViewToRefreshAQITable()
}

class AQIHomeViewController: UIViewController, URLSessionWebSocketDelegate, UITableViewDataSource, UITableViewDelegate, AQIHomeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var aqiViewModelObject : AQIViewModel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "AQI Index Monitor"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.standardAppearance = appearance;
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        
        self.aqiViewModelObject = AQIViewModel()
        self.aqiViewModelObject.aqitableViewProtocol = self
    }
    
    //MARK: - TableView Data Source & Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aqiViewModelObject.arrCityAQIModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQITableIdentifier", for: indexPath) as! AQITableViewCell
        let cityModel = aqiViewModelObject.arrCityAQIModels[indexPath.row]
        cell.vwBackground.backgroundColor = ColorUtility.setColor(aqiValue: cityModel.aqi)
        if let unwrapTime =  cityModel.time
        {
            cell.configureCellWithValues(cityName: cityModel.city, airQualityIndex: cityModel.aqi, timestamp: unwrapTime)
        }
        else
        {
            cell.configureCellWithValues(cityName: cityModel.city, airQualityIndex: cityModel.aqi, timestamp: Date())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cityName = aqiViewModelObject.arrCityAQIModels[indexPath.row].city
        
        var arrSelectedCityHistory : [CityModel] = []
        arrSelectedCityHistory = aqiViewModelObject.arrCityHistoryAQIModels.filter({$0.city == cityName})
        let selectedCityHistory =  arrSelectedCityHistory.sorted(by: { $0.time ?? Date() < $1.time ?? Date() })
        let aqiValues = selectedCityHistory.map({$0.aqi})
        let timestampValues = selectedCityHistory.map({$0.time ?? Date()})
        let chartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityHistoryViewController") as! CityHistoryViewController
        chartViewController.cityName = cityName
        chartViewController.arrCityAQI = aqiValues
        chartViewController.arrTimeStamp = timestampValues
        self.navigationController?.pushViewController(chartViewController, animated: true)
    }
    
    //MARK: - AQIHomeViewController Delegate
    
    func notifyViewToRefreshAQITable()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

