//
//  DetailedCryptoInfoViewModelProtocol.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import UIKit
import Combine

protocol DetailedCryptoInfoViewModelProtocol {
    var detailedData: MainScreenDisplayData { get set }
    var anyPeriodButtonTappedPublisher: AnyPublisher<UIButton, Never> { get }
    
    init(detailedData: MainScreenDisplayData)
    
    func periodButtonTapped(by button: UIButton)
}
