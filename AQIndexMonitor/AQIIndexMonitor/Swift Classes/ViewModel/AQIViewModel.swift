//
//  AQIViewModel.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 10/12/21.
//

import UIKit

class AQIViewModel: NSObject {
    
   private var webSocketDelegate: WebSocket!
    
    weak var aqitableViewProtocol: AQIHomeViewControllerDelegate?
    var arrCityAQIModels : [CityModel] = []
    var arrCityHistoryAQIModels: [CityModel] = []
    
    override init() {
        super.init()
        self.webSocketDelegate = WebSocket()
        let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        webSocketDelegate.start(session: session)
        
        self.webSocketDelegate.passDataToViewModelCompletionBlock = { [weak self] in
            
             var updatedAQIData = self?.webSocketDelegate.arrCityAQI ?? []
            updatedAQIData.mergeElements(newElements:self?.arrCityAQIModels ?? [])
            self?.arrCityAQIModels =  updatedAQIData.sorted(by: {$0.city < $1.city})
            
            if let data = self?.arrCityAQIModels {
                
                if self?.arrCityHistoryAQIModels.count ?? 0 >= 10 {
                    self?.arrCityHistoryAQIModels.remove(at: 0)
                }
                
                self?.arrCityHistoryAQIModels.append(contentsOf: data)
            }
            
            self?.aqitableViewProtocol?.notifyViewToRefreshAQITable()
        }
    }
}
