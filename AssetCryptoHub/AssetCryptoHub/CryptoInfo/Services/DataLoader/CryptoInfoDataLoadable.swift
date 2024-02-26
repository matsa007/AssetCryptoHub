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
    var anyDetailedKlinesDataIsReadyForViewPublisher: AnyPublisher<[KlinesModel], Never> { get }
    
    func requestExchangeInfoData()
    func requestTraidingPairsDailyInfoData(_ traidingPairsList: [ExhangeInfo]) async
    func requestKlinesData(tradingPairsDailyInfo: [TradingPairsDailyInfo], interval: String, limit: Int) async
    func requestDetailedKlinesData(interval: String, limit: Int, tradePairName: String)
}
