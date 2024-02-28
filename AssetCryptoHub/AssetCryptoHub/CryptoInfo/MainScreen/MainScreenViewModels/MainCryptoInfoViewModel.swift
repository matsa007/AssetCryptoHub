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
    private var cancellables: Set<AnyCancellable> = []
    
    private let mainScreenDisplayDataIsReadyForViewPublisher = PassthroughSubject<Void, Never>()
    var anyMainScreenDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> {
        self.mainScreenDisplayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Fetch data
    
    func readyForDisplay() {
        self.fetchExchangeData()
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
