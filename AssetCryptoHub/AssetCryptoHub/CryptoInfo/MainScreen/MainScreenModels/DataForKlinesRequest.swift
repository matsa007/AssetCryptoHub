//
//  TradingPairsDailyInfo.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation

struct DataForKlinesRequest {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let lastPrice: String
    let priceChange: String
    let priceChangePercent: String
}
