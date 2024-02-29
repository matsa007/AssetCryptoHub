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
    
    var detailedData: MainScreenDisplayData
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let periodButtonTappedPublisher = PassthroughSubject<UIButton, Never>()
    var anyPeriodButtonTappedPublisher: AnyPublisher<UIButton, Never> {
        self.periodButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(detailedData: MainScreenDisplayData) {
        self.detailedData = detailedData
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
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
}
