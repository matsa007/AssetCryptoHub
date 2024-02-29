//
//  DetailedCryptoInfoViewModelProtocol.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import Foundation

protocol DetailedCryptoInfoViewModelProtocol {
    var detailedData: MainScreenDisplayData { get set }
    
    init(detailedData: MainScreenDisplayData)
}
