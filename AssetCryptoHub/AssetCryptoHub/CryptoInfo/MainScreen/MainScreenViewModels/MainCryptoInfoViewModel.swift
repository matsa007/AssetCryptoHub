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
    
    // MARK: - Initialization
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Fetch data
    
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

// MARK: - Private methods

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
}
