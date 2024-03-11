//
//  DetailedCryptoInfoViewModelProtocol.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import UIKit
import Combine

protocol DetailedCryptoInfoViewModelProtocol {
    
    var detailedScreenDisplayData: DetailedScreenDisplayData { get set }
    var anyPeriodButtonTappedPublisher: AnyPublisher<UIButton, Never> { get }
    var anyDetailedChartDataIsReadyPublisher: AnyPublisher<Void, Never> { get }
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> { get }
    
    init(detailedScreenDisplayData: DetailedScreenDisplayData)
    
    func periodButtonTapped(by button: UIButton)
    func fetchDetaikledKlinesData(for tradingPairName: String, interval: ChartIntervals, limit: ChartRanges)
}
