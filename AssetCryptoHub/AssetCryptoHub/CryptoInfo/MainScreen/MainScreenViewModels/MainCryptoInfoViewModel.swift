//
//  MainCryptoInfoViewModel.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import Foundation
import Combine

final class MainCryptoInfoViewModel: MainCryptoInfoViewModelProtocol {
    
    // MARK: - Parameters
    
    var mainScreenDisplayData = [MainScreenDisplayData]()
    var filteredMainScreenDisplayData = [MainScreenDisplayData]()

    private var cancellables: Set<AnyCancellable> = []
    
    private let mainScreenDisplayDataIsReadyForViewPublisher = PassthroughSubject<Void, Never>()
    var anyMainScreenDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> {
        self.mainScreenDisplayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let filteredMainScreenDisplayDataIsUpdatedPublisher = PassthroughSubject<Void, Never>()
    var anyFilteredMainScreenDisplayDataIsUpdatedPublisher: AnyPublisher<Void, Never> {
        self.filteredMainScreenDisplayDataIsUpdatedPublisher.eraseToAnyPublisher()
    }
    
    private let searchButtonTappedPublisher = PassthroughSubject<Void, Never>()
    var anySearchButtonTappedPublisher: AnyPublisher<Void, Never> {
        self.searchButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    private let searchBarCancelButtonTappedPublisher = PassthroughSubject<Void, Never>()
    var anySearchBarCancelButtonTappedPublisher: AnyPublisher<Void, Never> {
        self.searchBarCancelButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    private let selectedCellDetailedDataIsReadyPublisher = PassthroughSubject<MainScreenDisplayData, Never>()
    var anySelectedCellDetailedDataIsReadyPublisher: AnyPublisher<MainScreenDisplayData, Never> {
        self.selectedCellDetailedDataIsReadyPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Data loading
    
    func readyForDisplay() {
        self.fetchExchangeData()
    }
    
    // MARK: - User interaction
    
    func searchButtonTapped() {
        self.searchButtonTappedPublisher.send()
    }
    
    func searchBarCancelButtonTapped() {
        self.searchBarCancelButtonTappedPublisher.send()
    }
    
    func tableViewRowSelected(index: Int) {
        switch self.filteredMainScreenDisplayData.isEmpty {
        case true:
            let tradingPairName = self.mainScreenDisplayData[index].tradingPairName
            self.fetchDetaikledKlinesData(for: tradingPairName, index: index)
        case false:
            let tradingPairName = self.filteredMainScreenDisplayData[index].tradingPairName
            self.fetchDetaikledKlinesData(for: tradingPairName, index: index)
        }
    }

    // MARK: - Filtered display data updating
    
    func filteredDisplayDataUpdating(searchedText: String) {
        self.mainScreenDisplayData.forEach { tradingPair in
            if tradingPair.tradingPairName.uppercased().starts(with: searchedText.uppercased()) {
                self.filteredMainScreenDisplayData.append(tradingPair)
            }
        }
        self.filteredMainScreenDisplayDataIsUpdatedPublisher.send()
    }
}

// MARK: - Fetch exchange data

private extension MainCryptoInfoViewModel {
    func fetchExchangeData() {
        let dataLoader = CryptoInfoDataLoader()
        dataLoader.anyDisplayDataIsReadyForViewPublisher
            .sink { [weak self] data in
                guard let self else { return }
                self.mainScreenDisplayData = data
                self.mainScreenDisplayDataIsReadyForViewPublisher.send()
            }
            .store(in: &self.cancellables)
        
        dataLoader.requestExchangeInfoData()
    }
    
    func fetchDetaikledKlinesData(for tradingPairName: String, index: Int) {
        let dataLoader = CryptoInfoDataLoader()
        let helper = CryptoInfoHelper()
        
        dataLoader.anyDetailedKlinesDataIsReadyForViewPublisher
            .sink { [weak self] detailedKlinesData in
                guard let self else { return }
                self.handleDetailedKlinesData(
                    for: detailedKlinesData,
                    index: index
                )
            }
            .store(in: &self.cancellables)
        
        dataLoader.requestDetailedKlinesData(
            interval: ChartIntervals.oneHour,
            limit: ChartRanges.oneWeekForOneHourLimit,
            tradePairName: helper.createTradePairNameForDetailedKlinesRequest(
                for: tradingPairName
            )
        )
    }
}

// MARK: - Handlers

private extension MainCryptoInfoViewModel {
    func handleDetailedKlinesData(for detailedKlinesData: [KlinesModel], index: Int) {
        let services = Services()

        switch self.filteredMainScreenDisplayData.isEmpty {
        case true:
            let tradingPairPriceDailyChangeInPercents = self.mainScreenDisplayData[index].tradingPairPriceDailyChangeInPercents
            let detailedChartData = services.createChartData(
                for: detailedKlinesData,
                with: tradingPairPriceDailyChangeInPercents
            )
            let detailedDisplayData = services.createDetailedDisplayData(
                for: self.mainScreenDisplayData[index],
                and: detailedChartData
            )
            
            self.selectedCellDetailedDataIsReadyPublisher.send(detailedDisplayData)
        case false:
            let tradingPairPriceDailyChangeInPercents = self.filteredMainScreenDisplayData[index].tradingPairPriceDailyChangeInPercents
            let detailedChartData = services.createChartData(
                for: detailedKlinesData,
                with: tradingPairPriceDailyChangeInPercents
            )
            let detailedDisplayData = services.createDetailedDisplayData(
                for: self.filteredMainScreenDisplayData[index],
                and: detailedChartData
            )
            
            self.selectedCellDetailedDataIsReadyPublisher.send(detailedDisplayData)
        }
    }
}
