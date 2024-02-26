//
//  MainScreenChartData.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation

struct MainScreenChartData {
    var minPrice: Double
    var maxPrice: Double
    var isRaised: Bool
    var tradingPairChartViewModel: [TradingPairChartData]
}

struct TradingPairChartData: Identifiable {
    let id: UUID
    
    let openTime: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: String
    let closeTime: String

    init(
        id: UUID = UUID(),
        openTime: String,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        volume: String,
        closeTime: String
    ) {
        self.id = id
        self.openTime = openTime
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.closeTime = closeTime
    }
}
