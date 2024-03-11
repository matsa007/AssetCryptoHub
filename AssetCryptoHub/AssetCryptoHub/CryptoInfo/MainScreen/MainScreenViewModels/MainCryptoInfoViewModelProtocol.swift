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
    var filteredMainScreenDisplayData: [MainScreenDisplayData] { get set }
    
    var anySpinnerStartViewPublisher: AnyPublisher<Void, Never> { get }
    var anySpinnerStopViewPublisher: AnyPublisher<Void, Never> { get }
    var anyMainScreenDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> { get }
    var anyFilteredMainScreenDisplayDataIsUpdatedPublisher: AnyPublisher<Void, Never> { get }
    var anySearchButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    var anySearchBarCancelButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    var anyRefreshControlActivatedPublisher: AnyPublisher<Void, Never> { get }
    var anySelectedCellDataIsReadyPublisher: AnyPublisher<MainScreenDisplayData, Never> { get }
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> { get }

    func readyForDisplay()
    func searchButtonTapped()
    func searchBarCancelButtonTapped()
    func refreshControlActivated()
    func tableViewRowSelected(index: Int)
    func filteredDisplayDataUpdating(searchedText: String)
}

extension MainCryptoInfoViewModelProtocol {
    func clearFilteredDisplayData() {
        self.filteredMainScreenDisplayData.removeAll()
    }
}
