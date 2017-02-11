//
//  WeatherViewModel.swift
//  Yahoo Weather
//
//  Created by Choudhury, Apratim (201) on 09/02/2017.
//  Copyright © 2017 Apro. All rights reserved.
//

import UIKit
import RxSwift

final class WeatherListViewModel {
    var weatherList = Variable([Weather]())
    private let _repository: WeatherRepository
    var networkReqOngoing = Variable(true)
    
    init(repository: WeatherRepository) {
        _repository = repository
    }
    
    func fetchWeatherList() {
        networkReqOngoing.value = true
        _repository.getWeatherList { [weak self] weatherList in
            self?.weatherList.value = weatherList
            self?.networkReqOngoing.value = false
        }
    }
}
