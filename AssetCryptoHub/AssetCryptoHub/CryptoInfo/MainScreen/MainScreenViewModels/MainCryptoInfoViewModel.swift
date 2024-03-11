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
    
    private let selectedCellDataIsReadyPublisher = PassthroughSubject<MainScreenDisplayData, Never>()
    var anySelectedCellDataIsReadyPublisher: AnyPublisher<MainScreenDisplayData, Never> {
        self.selectedCellDataIsReadyPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorAlertPublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> {
        self.networkErrorAlertPublisher.eraseToAnyPublisher()
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
        self.handleSearchButtonTapped()
    }
    
    func searchBarCancelButtonTapped() {
        self.handleSearchBarCancelButtonTapped()
    }
    
    func tableViewRowSelected(index: Int) {
        self.handleTableViewRowSelected(for: index)
    }

    // MARK: - Filtered display data updating
    
    func filteredDisplayDataUpdating(searchedText: String) {
        self.handleDisplayDataUpdating(with: searchedText)
    }
}

// MARK: - Fetch exchange data

private extension MainCryptoInfoViewModel {
    func fetchExchangeData() {
        let dataLoader = CryptoInfoDataLoader()
        dataLoader.anyDisplayDataIsReadyForViewPublisher
            .sink { [weak self] data in
                guard let self else { return }
                self.handleDisplayData(for: data)
            }
            .store(in: &self.cancellables)
        
        dataLoader.anyNetworkErrorMessagePublisher
            .sink { [weak self] error in
                guard let self else { return }
                self.handleAlertForNetworkError(for: error)
            }
            .store(in: &self.cancellables)

        dataLoader.requestExchangeInfoData()
    }
    
    
}

// MARK: - Handlers and actions

private extension MainCryptoInfoViewModel {
    func handleDisplayData(for data: [MainScreenDisplayData]) {
        self.mainScreenDisplayData = data
        self.mainScreenDisplayDataIsReadyForViewPublisher.send()
    }
    
    func handleSearchButtonTapped() {
        self.searchButtonTappedPublisher.send()
    }
    
    func handleDisplayDataUpdating(with searchedText: String) {
        self.mainScreenDisplayData.forEach { tradingPair in
            if tradingPair.tradingPairName.uppercased().starts(with: searchedText.uppercased()) {
                self.filteredMainScreenDisplayData.append(tradingPair)
            }
        }
        self.filteredMainScreenDisplayDataIsUpdatedPublisher.send()
    }
    
    func handleSearchBarCancelButtonTapped() {
        self.searchBarCancelButtonTappedPublisher.send()
    }
    
    func handleTableViewRowSelected(for index: Int) {
        let selectedMainScreenDisplayData = self.filteredMainScreenDisplayData.isEmpty
        ? self.mainScreenDisplayData[index]
        : self.filteredMainScreenDisplayData[index]
        
        self.selectedCellDataIsReadyPublisher.send(selectedMainScreenDisplayData)
    }
    
    func handleAlertForNetworkError(for error: Error) {
        self.networkErrorAlertPublisher.send(error)
    }
}
