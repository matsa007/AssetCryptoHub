//
//  CryptoInfoDataLoadable.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation
import Combine

protocol CryptoInfoDataLoadable: AnyObject {
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<[MainScreenDisplayData], Never> { get }
    var anyNetworkErrorMessagePublisher: AnyPublisher<Error, Never> { get }
    
    func requestExchangeInfoData()
    func requestTraidingPairsDailyInfoData(_ traidingPairsList: [ExhangeInfo]) async
    func requestKlinesData(dataForKlinesRequest: [DataForKlinesRequest], interval: ChartIntervals, limit: ChartRanges) async
}
