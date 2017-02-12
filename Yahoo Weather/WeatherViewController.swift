//
//  ViewController.swift
//  Yahoo Weather
//
//  Created by Choudhury, Apratim (201) on 29/01/2017.
//  Copyright © 2017 Apro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WeatherViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: WeatherListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = WeatherListViewModel(repository: WeatherRepository.instance)
        viewModel.fetchWeatherList()
        
        setupNetworkActivityIndicator()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        setupTableView(dateFormatter: dateFormatter)
        setupRefreshControl()
    }
    
    // MARK: - Network Activity Indicator setup
    
    private func setupNetworkActivityIndicator() {
        let networkDriver = viewModel.networkReqOngoing.asDriver()
        
        networkDriver.drive(onNext: { ongoing in
            UIApplication.shared.isNetworkActivityIndicatorVisible = ongoing
        })
        .addDisposableTo(disposeBag)
        
        networkDriver.filter { !$0 }
            .drive(onNext: { [unowned self] _ in
                self.refreshControl?.endRefreshing()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.blue
        refreshControl?.rx
            .controlEvent(.primaryActionTriggered)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.fetchWeatherList()
            })
            .addDisposableTo(disposeBag)
    }
    
    
    // MARK: - TableView setup
    
    private func setupTableView(dateFormatter: DateFormatter) {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        viewModel.weatherList.asDriver()
            .drive(tableView.rx.items(cellIdentifier: WeatherTableViewCell.reuseIdentifier,
                                      cellType: WeatherTableViewCell.self)) { _, weather, cell in
                                        cell.tempLabel.text = "\(weather.temp)"
                                        cell.dateLabel.text = dateFormatter.string(from: weather.date)
                                        cell.conditionLabel.text = weather.text
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .addDisposableTo(disposeBag)
    }
}

