//
//  DetailedCryptoInfoViewModel.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import Foundation

final class DetailedCryptoInfoViewModel: DetailedCryptoInfoViewModelProtocol {
    
    // MARK: - Parameters
    
    var detailedData: MainScreenDisplayData
    
    // MARK: - Initialization
    
    init(detailedData: MainScreenDisplayData) {
        self.detailedData = detailedData
    }
}
