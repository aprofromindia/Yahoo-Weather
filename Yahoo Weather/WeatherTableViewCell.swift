//
//  WeatherTableViewCell.swift
//  Yahoo Weather
//
//  Created by Choudhury, Apratim (201) on 29/01/2017.
//  Copyright © 2017 Apro. All rights reserved.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(WeatherTableViewCell.self)"
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
}
