//
//  DetailedCryptoInfoViewModel.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import UIKit
import Combine

final class DetailedCryptoInfoViewModel: DetailedCryptoInfoViewModelProtocol {
    
    // MARK: - Parameters
    
    var detailedScreenDisplayData: DetailedScreenDisplayData
    private var cancellables: Set<AnyCancellable> = []
    
    private let periodButtonTappedPublisher = PassthroughSubject<UIButton, Never>()
    var anyPeriodButtonTappedPublisher: AnyPublisher<UIButton, Never> {
        self.periodButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    private let detailedChartDataIsReadyPublisher = PassthroughSubject<Void, Never>()
    var anyDetailedChartDataIsReadyPublisher: AnyPublisher<Void, Never> {
        self.detailedChartDataIsReadyPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorAlertPublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> {
        self.networkErrorAlertPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(detailedScreenDisplayData: DetailedScreenDisplayData) {
        self.detailedScreenDisplayData = detailedScreenDisplayData
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Fetch selected trading pair data

    func fetchDetaikledKlinesData(for tradingPairName: String, interval: ChartIntervals, limit: ChartRanges) {
        let dataLoader = DetailedCryptoInfoDataLoader()
        let helper = CryptoInfoHelper()
        
        dataLoader.anyDetailedKlinesDataIsReadyForViewPublisher
            .sink { [weak self] detailedKlinesData in
                guard let self else { return }
                self.handleDetailedKlinesData(
                    for: detailedKlinesData
                )
            }
            .store(in: &self.cancellables)
        
        dataLoader.anyNetworkErrorMessagePublisher
            .sink { [weak self] error in
                guard let self else { return }
                self.handleAlertForNetworkError(for: error)
            }
            .store(in: &self.cancellables)
        
        dataLoader.requestDetailedKlinesData(
            interval: interval.rawValue,
            limit: limit.rawValue,
            tradePairName: helper.createTradePairNameForDetailedKlinesRequest(
                for: tradingPairName
            )
        )
    }
    
    // MARK: - User interaction
    
    func periodButtonTapped(by button: UIButton) {
        self.handlePeriodButtonTapped(for: button)
    }
}

// MARK: - Actions and handlers

private extension DetailedCryptoInfoViewModel {
    func handlePeriodButtonTapped(for button: UIButton) {
        self.periodButtonTappedPublisher.send(button)
    }
    
    func handleDetailedKlinesData(for detailedKlinesData: [KlinesModel]) {
        let services = MainCryptoInfoServices()
        
        dump("Open = \(detailedKlinesData.first)")
        dump("Close = \(detailedKlinesData.last)")
        
        self.detailedChartDataIsReadyPublisher.send()
    }
    
    func handleAlertForNetworkError(for error: Error) {
        self.networkErrorAlertPublisher.send(error)
    }
}
