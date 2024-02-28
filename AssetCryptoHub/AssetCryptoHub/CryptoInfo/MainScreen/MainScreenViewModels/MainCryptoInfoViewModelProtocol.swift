//
//  MainCryptoInfoViewModelProtocol.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import Foundation
import Combine

protocol MainCryptoInfoViewModelProtocol: AnyObject {
    var mainScreenDisplayData: [MainScreenDisplayData] { get set }
    var anyMainScreenDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> { get }

    func readyForDisplay()
}
