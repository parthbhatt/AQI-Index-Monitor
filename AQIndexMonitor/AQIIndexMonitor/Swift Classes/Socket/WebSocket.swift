//
//  WebSocket.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 12/12/21.
//

import Foundation

internal var refreshInterval = 10

class WebSocket: NSObject, URLSessionWebSocketDelegate {
    
    var webSocketTask: URLSessionWebSocketTask!
    var arrCityAQI : [CityModel] = []
    {
        didSet {
            self.passDataToViewModelCompletionBlock()
        }
    }
    var passDataToViewModelCompletionBlock : (() -> ()) = {}
    
    //MARK: - Websocket Connnection Methods
    
    func start(session: URLSession)
    {
        if let unwrapURL = URL(string: "ws://city-ws.herokuapp.com")
        {
            webSocketTask = session.webSocketTask(with: unwrapURL)
            webSocketTask.resume()
        }
    }
    
    func stop()
    {
        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)
    }
    
    func sendPingToWebSocket()
    {
        webSocketTask.sendPing { error in
            if let error = error
            {
                print("Error in Ping: \(error)")
            }
            else
            {
                print("Web Socket connection is alive")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [self] in
                    sendPingToWebSocket()
                }
            }
        }
    }
    
    func receiveDataWithStatus()
    {
        webSocketTask.receive { [self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("data: \(data)")
                case .string(let text):
                    print("text: \(text)")
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:  text.toJSON() as Any, options: [])
                        arrCityAQI = try JSONDecoder().decode([CityModel].self, from: jsonData)
                    } catch {
                        print("Invalid JSON")
                    }
                @unknown default:
                    print("unknown value")
                }
            case .failure(let error):
                print("Error when receiving \(error)")
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(refreshInterval)) { [self] in
                receiveDataWithStatus()
            }
        }
    }
    
    //MARK: - URLSession WebSocket Delegate
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?)
    {
        print("WebSocketSession didOpenWithProtocol")
        sendPingToWebSocket()
        receiveDataWithStatus()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
    {
        print("WebSocketSession didCloseWith: \(closeCode)")
    }
}

