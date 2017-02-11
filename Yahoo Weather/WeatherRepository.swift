//
//  WeatherRepository.swift
//  Yahoo Weather
//
//  Created by Choudhury, Apratim (201) on 09/02/2017.
//  Copyright © 2017 Apro. All rights reserved.
//

import UIKit
import SwiftyJSON

final class WeatherRepository {
    
    private let _urlString = "https://query.yahooapis.com/v1/public/yql"
    private let _json = "json"
    private let _weatherYQL = "select item.condition from weather.forecast where woeid in (select woeid from geo.places(1) where text in (\"tokyo\", \"new york\", \"sao paulo\", \"seoul\", \"mumbai\", \"delhi\", \"jakarta\", \"cairo\", \"los angeles\", \"buenos aires\", \"moscow\", \"shanghai\", \"paris\", \"istanbul\", \"beijing\", \"london\", \"singapore\", \"hong kong\", \"sydney\", \"madrid\", \"rio\"))"
    
    static let instance = WeatherRepository()
    let restClient = RESTClient.shared
    var weatherList: [Weather]!
    
    private init(){}
    
    func getWeatherList(completion: @escaping ([Weather]) -> Void) {
        let queryParams = ["q" : _weatherYQL, "format" : _json]
        restClient.getRequest(url: _urlString, query: queryParams) { [weak self] data in
            
            DispatchQueue.global(qos: .userInitiated).async {
                let results = JSON(data: data)["query"]["results"]
                let channels = results["channel"].arrayValue
                
                self?.weatherList = [Weather]()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm a z"
                
                for c in channels {
                    let condition = c["item"]["condition"]
                    
                    guard let date = dateFormatter.date(from: condition["date"].stringValue)
                        else { continue }
                    
                    let weather = Weather(temp: condition["temp"].intValue,
                                          date: date, text: condition["text"].stringValue)
                    self?.weatherList.append(weather)
                }
                
                DispatchQueue.main.async {
                    completion((self?.weatherList)!)
                }
            }
        }
    }
}
